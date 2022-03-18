"""
     f(x::MetaGraph;embeddings=FastText_Text{:pt})
     #
# Return an identical graph, with vector embeddings from Embeddings.jl as properties.  


## To do ()
# Trajectory in which states are defined by the proximity in the embeddings (clustering algorithms on the distance matrix).
# Compare observed trajectory with random diffusion. Use complete graphs and minimum spanning tree.
"""

# using Embeddings , MetaGraphs , Distances, Clustering
# function lse_graph(mg::MetaGraph;EmbeddingSystem=FastText_Text{:pt})


# Using the Embeddings.jl function:
## Currently crashing on my PC

const embtable = load_embeddings(FastText_Text{:pt}; max_vocab_size=20000) 

const get_word_index = Dict(word=>ii for (ii,word) in enumerate(embtable.vocab))

function get_embedding(word)
    ind = get_word_index[word]
    emb = embtable.embeddings[:,ind]
    return emb
end

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

