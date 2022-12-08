"""
get_embeddings(word,embtable)

Get real vector embedding of a word in an Embeddings.jl embtable. 
"""
# Get embeddings form corpus in embtable
function get_embedding(word,embtable)
    
    word_inds = Dict(word => ii for (ii,word) in enumerate(embtable.vocab))
    try
        ind = word_inds[word]
        emb = embtable.embeddings[:,ind]
        return emb
    catch y
        if isa(y, KeyError)
            return missing
        end
    end
end


"""
latent_space_dists(raw_text, embtable, graph_function=naive_graph,complete_embed=true)

Obtain a distance matrix of words in a graph using an Embeddings.jl embedding table. 

Inputs are the raw text, an embedding table, a graph_function (e.g. TextGraphs.naive_graph). 
complete_embed =false will return NaN for words without space embeddings.  
"""
# Get graph embedding from text, Embeddings.jl embedding table and TextGraphs graph function
# Return matrix without missingembeddings when complete_embed is true    
function latent_space_dists(raw_text,embtable,graph_function=naive_graph,complete_embed=true)

    unweighted_graph = graph_function(raw_text)
    labels = TextGraphs.get_graph_labels(unweighted_graph)

    latent_space_reps = map(x -> get_embedding(x,embtable),labels)
    latent_space_reps_full = collect(skipmissing(latent_space_reps)) 
    labels_full = labels[.!(ismissing.(vec(latent_space_reps)))]

    # Add 0s to missing values befode cosine dist.
    latent_space_repsZ = map(latent_space_reps) do vec
        if ismissing(vec)
            return zeros(300)
        end
        return vec
    end

    # Cosine distance
    vector_reps = permutedims(hcat(latent_space_repsZ...))
    vector_reps_full = permutedims(hcat(latent_space_reps_full...))        
    word_dists = pairwise(cosine_dist, vector_reps, dims=1)
    word_dists_full = pairwise(cosine_dist, vector_reps_full, dims=1)
   
    word_dists_df = DataFrame(hcat(labels,word_dists),:auto)
    word_dists_full_df = DataFrame(hcat(labels_full,word_dists_full),:auto)
    rename!(word_dists_full_df, ["HEADER",labels_full...])
    rename!(word_dists_df, ["HEADER",labels...])
 
    ifelse(complete_embed==true,word_dists_full_df,word_dists_df)

end


"""
latent_space_graph(raw_text,embtable,graph_function=naive_graph)

Obtain a complete weighted graph using an Embeddings.jl embedding table.  
"""
function latent_space_graph(raw_text,embtable,graph_function=naive_graph)

    unweighted_graph = graph_function(raw_text)
    labels = TextGraphs.get_graph_labels(unweighted_graph)

    latent_space_reps = map(x -> get_embedding(x,embtable),labels)
    latent_space_reps_full = collect(skipmissing(latent_space_reps)) 

    # Add 0s to missing values befode cosine dist.
    latent_space_repsZ = map(latent_space_reps) do vec
        if ismissing(vec)
            return zeros(300)
        end
        return vec
    end

    # Cosine distance
    vector_reps = permutedims(hcat(latent_space_repsZ...))
    vector_reps_full = permutedims(hcat(latent_space_reps_full...))        
    word_dists = pairwise(cosine_dist, vector_reps, dims=1)   
    
    weighted_graph = MetaGraph(complete_graph(nv(unweighted_graph)),NaN)
    for i=1:nv(weighted_graph)
        set_prop!(weighted_graph,i,:token, get_prop(unweighted_graph,i,:token))
        for j=1:nv(weighted_graph)
            set_prop!(weighted_graph, Edge(i, j), :weight, word_dists[i,j])
        end
    end   
 

    return weighted_graph

end

