
"""
node_props(g::Union{MetaDiGraph,SimpleGraph})

Calculate betweeness, closeness and eigenvector centralities for each node. 

This function returns a Dict with vectors of values for each centrality method.  
"""
function node_props(g::Union{MetaDiGraph,SimpleGraph})
    node_dict = Dict(
    "betweenness_centrality" => Graphs.betweenness_centrality(g),
    "closeness_centrality" => Graphs.closeness_centrality(g),
    "eigenvector_centrality" => Graphs.eigenvector_centrality(g),
    )
    return node_dict
end

"""
mean_graph_centrs(g::Union{MetaDiGraph,SimpleGraph})

Calculate mean values for centrality (betweeness, closeness and eigenvector methods). 

This function returns a Dict with numeric values for each centrality method.  
"""
function mean_graph_centrs(g::Union{MetaDiGraph,SimpleGraph})
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
function graph_props(g::MetaDiGraph)
    SCC = Graphs.strongly_connected_components(g)
    centrs_dict = mean_graph_centrs(g)
    graph_dict = Dict(
    "density" => Graphs.density(g),
    "num_self_loops" => Graphs.num_self_loops(g),
    "num_strong_connect_comp" => length(SCC),
    "size_largest_scc" => maximum(map(length,SCC))
    )
    
    out_dict = merge(centrs_dict,graph_dict)
    return out_dict
end

"""
rand_erdos_ratio_props(g::MetaDiGraph)

Calculate ratios between a given MetaDiGraph and a corresponding random Erdős–Rényi graph.

This function returns a Dict with numeric values for density and 
mean centralities (betweeness, closeness and eigenvector methods) 
"""
function rand_erdos_ratio_props(g::MetaDiGraph;rnd_seed=123)
    
    random_erdos_g = Graphs.erdos_renyi(nv(g),ne(g),seed=rnd_seed)
    #random_tourn_g = Graphs.random_tournament_digraph(nv(g))
    rand_props = node_props(random_erdos_g)
    g_props = node_props(g) 
    g_centrs , rand_centrs = map(mean_graph_centrs,(g,random_erdos_g))
    ratio_centrs = values(g_centrs) ./ values(rand_centrs)
    ratio_density = Graphs.density(g) / Graphs.density(random_erdos_g)
    
    ratio_dict = Dict(zip(["closeness","betweeness","eigenvector","density"],
                                [ratio_centrs;ratio_density]))
    return ratio_dict
end