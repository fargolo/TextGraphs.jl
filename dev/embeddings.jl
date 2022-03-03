using Embeddings

# Trajectory in which states are defined by the proximity in the embeddings (clustering algorithms on the distance matrix).
# Compare observed trajectory with random diffusion. Use complete graphs and minimum spanning tree.

const embtable = load_embeddings(FastText_Text{:pt}) 

const get_word_index = Dict(word=>ii for (ii,word) in enumerate(embtable.vocab))

function get_embedding(word)
    ind = get_word_index[word]
    emb = embtable.embeddings[:,ind]
    return emb
end

#get_embedding("teste")
