
# Further analysis
## To do: integrate the following procedures with current functions in embeddings_utils.jl

#Adds distances from word_dists to sample_graph
## mg = MetaGraph(complete_graph(nv(sample_graph)),NaN)
## for i=1:nv(mg)
##     set_prop!(mg,i,:token, get_prop(sample_graph,i,:token))
##     for j=1:nv(mg)
##         set_prop!(mg, Edge(i, j), :weight, word_dists[i,j])
##     end
## end   
## naive_g = mg
##  
## # julia> using Arpack
## # Centrality for each entry based on 1st eigenvector weights
## eigenvect_centr = abs.(vec(eigs(word_dists_full, which=:LM, nev=1)[2]))
## # All eigenvalues
## eigenvals_all = (vec(eigs(word_dists_full, which=:LM, nev=size(word_dists_full)[1])[1]))
##  
## # Mean, median, min, max
## # Median are important: https://www.mathsci.udel.edu/content-sub-site/Documents/AEGT%20Presentations/1Ye.pdf
## [f(eigenvals_all) for f in [mean, median, minimum, maximum]]
## [f(eigenvect_centr) for f in [mean, median, minimum, maximum]]
##  
## # Normalized mean, med., min. max. 
## [f(eigenvals_all) for f in [mean, median, minimum, maximum]] ./ sum(eigenvals_all)
## #[f(eigenvect_centr) for f in [mean, median, minimum, maximum]] ./ sum(eigenvect_centr)
##  
## # Chromatic number - https://web.cs.elte.hu/~lovasz/eigenvals-x.pdf
## minimum(eigenvals_all)/maximum(eigenvals_all)
## #minimum(eigenvect_centr)/maximum(eigenvect_centr)
##  
## plot(eigenvals_all)
## histogram(eigenvect_centr)
## Plots.density(eigenvect_centr) 

# By-passing Embeddings.jl package. 
## Download PT embeddings from  
## https://fasttext.cc/docs/en/crawl-vectors.html  
## https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.pt.300.vec.gz  
## Directly write the load_embeddings function


fast_text_embeddings , vocab = load_embeddings("data/cc.pt.300.vec") 


function load_embeddings(embedding_file)
    local LL, indexed_words, index
    indexed_words = Vector{String}()
    LL = Vector{Vector{Float32}}()
    open(embedding_file) do f
        index = 1
        for line in eachline(f)
            xs = split(line)
            word = xs[1]
            push!(indexed_words, word)
            push!(LL, parse.(Float32, xs[2:end]))
            index += 1
        end
    end

    return reduce(hcat, LL), indexed_words
end

# Pseudo-code to build LSE graph 
## Or calculate locally based on 
## embeddings = map(get_embedding,unique_tokens) 
## Build distance matrix D with cosine_dist() for every tuple in (embeddings x embeddings)
 # 
##   set_prop!(word_node,get_cluster(word))   
##       
##   Loop over sequence of cluster_ids:
##       add_edge!(g,current_cluster_id,next_cluster_id)
##       Enumerate edges to store original sequence. 

# gist for Clustering.jl
## const clustered_embeddings = kmeans(embtable.embeddings,10) 
## 
## function get_cluster(word)   
##   ind = get_word_index[word]
##   clust_id = assignments(clustered_embeddings)[ind]
##   return cluster_id
## end



