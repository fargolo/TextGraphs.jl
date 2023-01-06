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
    latent_space_graph(raw_text, embtable, graph_function=naive_graph)

Obtain a distance matrices and graphs using an Embeddings.jl embedding table. 

Inputs are the raw text, an embedding table and a graph_function (e.g. TextGraphs.naive_graph).
Return Dict with "skipmiss_distances","distances", "unweighted_graph" and "weighted_graph".  
"""

function latent_space_graph(raw_text,embtable,graph_function=naive_graph)

    unweighted_graph = graph_function(raw_text)
    labels = TextGraphs.get_graph_labels(unweighted_graph)

    latent_space_reps = map(x -> get_embedding(x,embtable),labels)
    latent_space_reps_skipmiss = collect(skipmissing(latent_space_reps)) 
    labels_skipmiss = labels[.!(ismissing.(vec(latent_space_reps)))]

    # Add 0s to missing values befode cosine dist.
    latent_space_repsZ = map(latent_space_reps) do vec
        if ismissing(vec)
            return zeros(300)
        end
        return vec
    end

    vector_reps = permutedims(hcat(latent_space_repsZ...))
    vector_reps_skipmiss = permutedims(hcat(latent_space_reps_skipmiss...))        
    word_dists = pairwise(cosine_dist, vector_reps, dims=1)
    word_dists_skipmiss = pairwise(cosine_dist, vector_reps_skipmiss, dims=1)
   
    word_dists_df = DataFrame(hcat(labels,word_dists),:auto)
    word_dists_skipmiss_df = DataFrame(hcat(labels_skipmiss,word_dists_skipmiss),:auto)
    rename!(word_dists_skipmiss_df, ["HEADER",labels_skipmiss...])
    rename!(word_dists_df, ["HEADER",labels...])

    weighted_graph = MetaGraph(complete_graph(nv(unweighted_graph)),NaN)
    for i=1:nv(weighted_graph)
        set_prop!(weighted_graph,i,:token, get_prop(unweighted_graph,i,:token))
        for j=1:nv(weighted_graph)
            set_prop!(weighted_graph, Edge(i, j), :weight, word_dists[i,j])
        end
    end
 
    #ifelse(complete_embed==true,word_dists_full_df,word_dists_df)

    return Dict("skipmiss_distances" => word_dists_skipmiss_df, 
    "distances" => word_dists_df, 
    "unweighted_graph" => unweighted_graph, 
    "weighted_graph" => weighted_graph)

end

"""
    latent_space_graph_target(raw_text, embtable, target_word ,graph_function=naive_graph)

Obtain a distance matrix relative to a target word using an Embeddings.jl embedding table. 

Inputs are the raw text, an embedding table, the target word and a graph_function (e.g. TextGraphs.naive_graph).
Return Dict with "skipmiss_distances","distances", "target" and "unweighted_graph".  
"""

function latent_space_graph_target(raw_text,embtable, target_word, graph_function=naive_graph)

    unweighted_graph = graph_function(raw_text)
    labels = TextGraphs.get_graph_labels(unweighted_graph)
    
    target_rep = get_embedding(target_word,embtable)
    latent_space_reps = map(x -> get_embedding(x,embtable),labels)
    latent_space_reps_skipmiss = collect(skipmissing(latent_space_reps)) 
    labels_skipmiss = labels[.!(ismissing.(vec(latent_space_reps)))]

    # Add 0s to missing values befode cosine dist.
    latent_space_repsZ = map(latent_space_reps) do vec
        if ismissing(vec)
            return zeros(300)
        end
        return vec
    end

    vector_reps = permutedims(hcat(latent_space_repsZ...))
    vector_reps_skipmiss = permutedims(hcat(latent_space_reps_skipmiss...))        
    word_dists = map(x -> cosine_dist(target_rep,x),eachrow(vector_reps))
    word_dists_skipmiss = map(x -> cosine_dist(target_rep,x),eachrow(vector_reps_skipmiss))
    
    word_dists_df = DataFrame(hcat(labels,word_dists),:auto)
    word_dists_skipmiss_df = DataFrame(hcat(labels_skipmiss,word_dists_skipmiss),:auto)
    rename!(word_dists_skipmiss_df, ["Word","Distance"])
    rename!(word_dists_df, ["Word","Distance"])
 
    #ifelse(complete_embed==true,word_dists_full_df,word_dists_df)

    return Dict("skipmiss_distances" => word_dists_skipmiss_df, 
    "distances" => word_dists_df, 
    "unweighted_graph" => unweighted_graph,
    "target" => target_word)

end
