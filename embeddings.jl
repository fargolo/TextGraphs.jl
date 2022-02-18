using Embeddings

const embtable = load_embeddings(FastText_Text{:pt}) 

const get_word_index = Dict(word=>ii for (ii,word) in enumerate(embtable.vocab))

function get_embedding(word)
    ind = get_word_index[word]
    emb = embtable.embeddings[:,ind]
    return emb
end

#get_embedding("teste")