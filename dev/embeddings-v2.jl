using Embeddings , Distances
using Statistics
using DataFrames, CSV
using Graphs,MetaGraphs, TextGraphs

# Apply embeddings to an array of words
function get_embedding_array(word_array)
    map(x->get_embedding(x),word_array)
end

# Get embeddings form corpus in embtable
function get_embedding(word,embtable=ft_embtable)
    
    try
        ind = get_word_index[word]
        emb = embtable.embeddings[:,ind]
        return emb
    catch y
        if isa(y, KeyError)
            return missing
        end
    end
end


#Load texts
transcricoes_df = CSV.read("../media-to-text/outputs/Banco_Transcricoes.csv",DataFrame) 

const ft_embtable = load_embeddings(FastText_Text{:pt}; max_vocab_size=30000) 
const get_word_index = Dict(word => ii for (ii,word) in enumerate(ft_embtable.vocab))

sentences = transcricoes_df[15,"Sonho_Recente"]
a = TextGraphs.WordTokenizers.punctuation_space_tokenize(sentences)
transc_naive_graph_props = map(naive_graph,transcricoes_df[!,"Sonho_Recente"])

sample_graph = transc_naive_graph_props[15]
labels = TextGraphs.get_graph_labels(sample_graph)
latent_space_reps = get_embedding_array(labels)
latent_space_reps_full = collect(skipmissing(latent_space_reps))

latent_space_repsZ = map(latent_space_reps) do vec
    if ismissing(vec)
      return zeros(300)
    end
    return vec
  end

vector_reps = permutedims(hcat(latent_space_repsZ...))
vector_reps_full = permutedims(hcat(latent_space_reps_full...))

word_dists = pairwise(cosine_dist, vector_reps, dims=1)
word_dists_full = pairwise(cosine_dist, vector_reps_full, dims=1)

word_dists_df = DataFrame(hcat(labels,word_dists),:auto)
labels_full = labels[.!(ismissing.(vec(latent_space_reps)))]
word_dists_full_df = DataFrame(hcat(labels_full,word_dists_full),:auto)
CSV.write("corpora/distances.csv",word_dists_full_df)

mg = MetaGraph(complete_graph(nv(sample_graph)),NaN)
for i=1:nv(mg)
    set_prop!(mg,i,:token, get_prop(sample_graph,i,:token))
    for j=1:nv(mg)
        set_prop!(mg, Edge(i, j), :weight, word_dists[i,j])
    end
end   
naive_g = mg

# julia> using Arpack
# Centrality for each entry based on 1st eigenvector weights
eigenvect_centr = abs.(vec(eigs(word_dists_full, which=:LM, nev=1)[2]))
# All eigenvalues
eigenvals_all = (vec(eigs(word_dists_full, which=:LM, nev=size(word_dists_full)[1])[1]))

# Mean, median, min, max
# Median are important: https://www.mathsci.udel.edu/content-sub-site/Documents/AEGT%20Presentations/1Ye.pdf
[f(eigenvals_all) for f in [mean, median, minimum, maximum]]
[f(eigenvect_centr) for f in [mean, median, minimum, maximum]]

# Normalized mean, med., min. max. 
[f(eigenvals_all) for f in [mean, median, minimum, maximum]] ./ sum(eigenvals_all)
#[f(eigenvect_centr) for f in [mean, median, minimum, maximum]] ./ sum(eigenvect_centr)

# Chromatic number - https://web.cs.elte.hu/~lovasz/eigenvals-x.pdf
minimum(eigenvals_all)/maximum(eigenvals_all)
#minimum(eigenvect_centr)/maximum(eigenvect_centr)

plot(eigenvals_all)
histogram(eigenvect_centr)
Plots.density(eigenvect_centr)