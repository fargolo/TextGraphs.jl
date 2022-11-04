# Get word indexes from embtable 
function get_word_indexes(embtable)
    return Dict(word => ii for (ii,word) in enumerate(embtable.vocab))
end


# Get embeddings form corpus in embtable
function get_embedding(word,embtable, word_indexes)
    
    try
        ind = word_indexes[word]
        emb = embtable.embeddings[:,ind]
        return emb
    catch y
        if isa(y, KeyError)
            return missing
        end
    end
end


# Apply embeddings to an array of words
function get_embedding_array(word_array,embtable,word_indexes)
    map(x->get_embedding(x,embtable,word_indexes),word_array)
end

# Get graph embedding from text, Embeddings.jl embedding table and TextGraphs graph function
# Return matrix without missingembeddings when complete_embed is true    
function latent_space_graph(raw_text,embtable,graph_function=naive_graph,complete_embed=true)

    word_indexes = get_word_indexes(embtable)
    unweighted_graph = graph_function(raw_text)
    labels = TextGraphs.get_graph_labels(unweighted_graph)

    latent_space_reps = get_embedding_array(labels,embtable,word_indexes)
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
    ## weightwed_graph = MetaGraph(complete_graph(nv(unweighted_graph)),NaN)
    ## for i=1:nv(weightwed_graph)
    ##     set_prop!(weightwed_graph,i,:token, get_prop(unweighted_graph,i,:token))
    ##     for j=1:nv(weightwed_graph)
    ##         set_prop!(weightwed_graph, Edge(i, j), :weight, word_dists[i,j])
    ##     end
    ## end   
    ## 
    ifelse(complete_embed==true,word_dists_full_df,word_dists_df)

end