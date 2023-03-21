"""
    bypass_eigenvector_centrality(g::Union{MetaDiGraph,SimpleGraph})

Calculate eigenvector centrality for each node in g. 

This function returns an Array with either the eigenvector centrality values or missing.
It is needed because LinAlg.jl.eigs seems to bear erratic behavior, sometimes returning vector bound error.  
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
    window_props(raw_text,nwindow=5,txt_stepsize=1,graph_function=naive_graph;prop_type="raw",rnd_eval_method="ratio")

Calculate average properties from windowed subsets of text.

User must provide source text, window length, step size, 
graph building function (e.g. naive_graph). Set `prop_type` to 'random'
to obtain properties from Erdos-Renye graphs. If `prop_type` is random,
set `rnd_eval_method` to either 'ratio' (default) or 'z_score'. 
""" 
function window_props(raw_text::AbstractString,nwindow::Integer=5,txt_stepsize::Integer=1,graph_function::Function=naive_graph;
    prop_type::AbstractString="raw",rnd_eval_method::AbstractString="ratio")

    tokenized_words = WordTokenizers.punctuation_space_tokenize(lowercase(raw_text))
    text_arrays = [tokenized_words[i:(i+nwindow-1)] for i in 1:txt_stepsize:(length(tokenized_words) - nwindow+1)]
    text_array = map(x->join(x," "),text_arrays)
    graph_array = map(graph_function,text_array)   

    if prop_type == "raw"
        prop_array = map(graph_props,graph_array)
    elseif prop_type == "random"
        prop_array = map(x -> rand_erdos_props(x;eval_method=rnd_eval_method,n_samples=1000),graph_array)
    else
        throw(DomainError(prop_type,"prop_type must be either 'raw' or 'random'"))
    end
    
    prop_df = vcat(DataFrame.(prop_array)...)
    averages_df = mapcols(mean,prop_df)
 
    return Dict(names(averages_df) .=> values(averages_df[1,:]))
    
end

"""
    window_props_lemma(raw_text,nwindow=5,txt_stepsize=1,text_language="english")

Calculate average properties from windowed subsets of lemmatized text. 

User must provide source text, window length, step size and text language.
This function is faster than using `window_props` with `graph_function=lemma_graph`.
"""
function window_props_lemma(raw_text::AbstractString,nwindow::Integer=5,
    txt_stepsize::Integer=1,text_language::AbstractString="english")

    tokenized_words = WordTokenizers.punctuation_space_tokenize(lowercase(raw_text))
    udp_lemma_df = udp_import_annotations(join(tokenized_words," ");udpipe_lang=text_language)
    tokenized_lemmas = udp_lemma_df.lemma
    text_arrays = [tokenized_lemmas[i:(i+nwindow-1)] for i in 1:txt_stepsize:(length(tokenized_words) - nwindow+1)]
    text_array = map(x->join(x," "),text_arrays)

    graph_array = map(naive_graph,text_array)   
    prop_array = map(graph_props,graph_array)
    
    prop_df = vcat(DataFrame.(prop_array)...)
    averages_df = mapcols(mean,prop_df)
 
    return Dict(names(averages_df) .=> values(averages_df[1,:]))
    
end

"""
    erdos_graph_short(g::MetaDiGraph)

Generate random Erdős–Rényi graph from MetaDiGraph.

Short version of erdos_renyi function that takes a MetaDiGraph instead of numebr of vertices and nodes.
"""
erdos_graph_short(g::MetaDiGraph) = Graphs.erdos_renyi(nv(g),ne(g),is_directed=true)

"""
    rand_erdos_props(g::MetaDiGraph;eval_method="z_score",n_samples=1000)

Calculate ratios between a given MetaDiGraph and corresponding random Erdős–Rényi graphs.

This function returns a Dict with numeric values for density, connected components and 9
mean centralities (betweeness, closeness and eigenvector methods). Currently
returning error for some samples. `eval_method` must can be either 'z_score' or 'ratio'.  
"""
function rand_erdos_props(g::MetaDiGraph; eval_method::AbstractString="ratio", n_samples::Integer=1000)

    random_graphs = [erdos_graph_short(g) for _ in 1:n_samples]
    rand_graph_properties = map(graph_props,random_graphs)
    rand_g_props_df = vcat(DataFrame.(rand_graph_properties)...)
    
    rand_mean = mapcols(mean,rand_g_props_df)
    rand_std = mapcols(std, rand_g_props_df)

    #random_tourn_g = Graphs.random_tournament_digraph(nv(g))
    rand_props = values(rand_mean[1,:])
    g_props = graph_props(g) 
    
    g_keys = keys(g_props)
    if eval_method=="z_score"
        output_values = (values(g_props) .- rand_props) ./ values(rand_std[1,:])
    elseif eval_method=="ratio"
        output_values = values(g_props) ./ rand_props 
    else   
        throw(DomainError(eval_method,"eval_method must be either 'z_score' or 'ratio'"))
    end

    ratio_dict = Dict(zip(g_keys,output_values))
    return ratio_dict
end
