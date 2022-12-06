"""
bypass_eigenvector_centrality(g::Union{MetaDiGraph,SimpleGraph})

Calculate eigenvector centrality for each node in g. 

This function returns an Array with either the eigenvector centrality values or missing.
It is needed because LinAlg.jl.eigs seems to bear erratic behavior, somethings returning vector bound error.  
"""
function bypass_eigenvector_centrality(g::Union{MetaDiGraph,SimpleDiGraph})
    try 
        eig_centr = Graphs.eigenvector_centrality(g)
        return eig_centr
    catch e
        println("Eigenvector vector bounds error")
        eig_centr = Array{Missing}(missing, nv(g), 1)
        return eig_centr
    end    
end

"""
node_props(g::Union{MetaDiGraph,SimpleGraph})

Calculate betweeness, closeness and eigenvector centralities for each node. 

This function returns a Dict with vectors of values for each centrality method.  
"""
function node_props(g::Union{MetaDiGraph,SimpleDiGraph})
    node_dict = Dict(
    "betweenness_centrality" => Graphs.betweenness_centrality(g),
    "closeness_centrality" => Graphs.closeness_centrality(g),
    "eigenvector_centrality" => bypass_eigenvector_centrality(g),
    )
    return node_dict
end

"""
mean_graph_centrs(g::Union{MetaDiGraph,SimpleGraph})

Calculate mean values for centrality (betweeness, closeness and eigenvector methods). 

This function returns a Dict with numeric values for each centrality method.  
"""
function mean_graph_centrs(g::Union{MetaDiGraph,SimpleDiGraph})
    node_dict = node_props(g)
    mean_graph_centrs = Dict(
        "mean_between_centr" => Statistics.mean(node_dict["betweenness_centrality"]),
        "mean_close_centr" => Statistics.mean(node_dict["closeness_centrality"]),
        "mean_eig_centr" => Statistics.mean(node_dict["eigenvector_centrality"]) 
    )
    return mean_graph_centrs
end

"""
graph_props(g::MetaDiGraph)

Calculate several properties for a MetaDiGraph.

This function returns a Dict with numeric values for
density, # of self loops, # of SCCs, size of largest SCC, 
and mean centrality (betweeness, closeness and eigenvector methods) 
"""
function graph_props(g::Union{MetaDiGraph,SimpleDiGraph})
    SCC = Graphs.strongly_connected_components(g)
    centrs_dict = mean_graph_centrs(g)
    graph_dict = Dict(
    "density" => Graphs.density(g),
    "num_self_loops" => Graphs.num_self_loops(g),
    "num_strong_connect_comp" => length(SCC),
    "size_largest_scc" => maximum(map(length,SCC)),
    "graph_size" => nv(g)
    )
    
    out_dict = merge(centrs_dict,graph_dict)
    return out_dict
end


"""
window_props(nwindow, graph_function, raw_text)

Calculate average properties from subsets of text.

User must privde window length (1st argument), graph building function (e.g. naive_graph) and source text.
"""
function window_props(nwindow,graph_function,raw_text)

    tokenized_words = WordTokenizers.punctuation_space_tokenize(lowercase(raw_text))
    text_arrays = [tokenized_words[i:(i+nwindow-1)] for i in 1:(length(tokenized_words) - nwindow+1)]
    text_array = map(x->join(x," "),text_arrays)
    graph_array = map(graph_function,text_array)   
    prop_array = map(graph_props,graph_array)
    
    prop_df = vcat(DataFrame.(prop_array)...)
    averages_df = mapcols(mean,prop_df)
 
    return Dict(names(averages_df) .=> values(averages_df[1,:]))
    
end


"""
rand_erdos_ratio_props(g::MetaDiGraph)

Calculate ratios between a given MetaDiGraph and a corresponding random Erdős–Rényi graph.

This function returns a Dict with numeric values for density and 
mean centralities (betweeness, closeness and eigenvector methods) 
"""
function rand_erdos_ratio_props(g::MetaDiGraph;rnd_seed=123)
    
    random_erdos_g = Graphs.erdos_renyi(nv(g),ne(g),seed=rnd_seed,is_directed=true)
    #random_tourn_g = Graphs.random_tournament_digraph(nv(g))
    rand_props = graph_props(random_erdos_g)
    g_props = graph_props(g) 
    
    g_keys = keys(g_props)
    ratio_values = values(rand_props) ./ values(g_props)

    ratio_dict = Dict(zip(g_keys,ratio_values))
    return ratio_dict
end


"""
erdos_graph_short(g::MetaDiGraph)

Generate random Erdős–Rényi graph from MetaDiGraph.

Short version of erdos_renyi function that takes a MetaDiGraph instead of numebr of vertices and nodes.
"""
erdos_graph_short(g::MetaDiGraph) = Graphs.erdos_renyi(nv(g),ne(g),is_directed=true)


"""
rand_erdos_ratio_props(g::MetaDiGraph;n_samples=1000,n_boot=1000)

Calculate ratios between a given MetaDiGraph and corresponding random Erdős–Rényi graphs via bootstrapping.

This function returns a Dict with numeric values for density, connected components and 
mean centralities (betweeness, closeness and eigenvector methods). Currently
returning error for some samples.
"""
function rand_erdos_ratio_sampled(g::MetaDiGraph;n_samples=1000,n_boot=1000)
    

    random_graphs = [erdos_graph_short(g) for _ in 1:n_samples]
    rand_graph_properties = map(graph_props,random_graphs)
    rand_g_props_df = vcat(DataFrame.(rand_graph_properties)...)
    
    rand_bias = mapcols(x -> bootstrap(mean, x, BasicSampling(n_boot)) |> x -> original(x,1), rand_g_props_df)

    #random_tourn_g = Graphs.random_tournament_digraph(nv(g))
    rand_props = values(rand_bias[1,:])
    g_props = graph_props(g) 
    
    g_keys = keys(g_props)
    ratio_values = rand_props ./ values(g_props)

    ratio_dict = Dict(zip(g_keys,ratio_values))
    return ratio_dict
end

