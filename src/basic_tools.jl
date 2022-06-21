"""
    link_consecutive(array_with_tokens)

Transform serialized tokens into a directed graph. 

This function is used internally to build graphs from text. Each token has an unique node in the graph.
"""
function link_consecutive(tokens_list::AbstractArray)
    unique_tokens = unique(tokens_list)
    g_lenght = length(unique_tokens) #g total size (nodes)
    g = Graphs.DiGraph(g_lenght) # initialize
   
    inds = indexin(tokens_list, unique_tokens)
        for i in 2:length(inds)
        add_edge!(g, inds[i-1], inds[i])
    end
    return g
end   


"""
    add_prop_label_tokens(metagraph,metagraph_unique_tokens)

Add tokens as properties of nodes in a `MetaGraph`.

This function is used internally to attach word labels to each node. Unique tokens must have length equal to the number of vertices
"""
function add_prop_label_tokens(mg::AbstractMetaGraph,unique_tokens)
    for (token_index,unique_token) in zip(collect(1:length(unique_tokens)),unique_tokens)
        set_prop!(mg,token_index,:token,unique_token)
    end
    return mg
end    


"""
    build_labelled_graph(x::AbstractArray)

This function is used internally to build graph lebelled with unique tokens.
"""
function build_labelled_graph(x::AbstractArray)
    unique_tokens = unique(x)    
    g = link_consecutive(x)
    mg = MetaGraphs.MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end
