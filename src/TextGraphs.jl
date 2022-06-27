module TextGraphs

using Graphs , MetaGraphs
using Snowball , WordTokenizers
using RCall #External call for udpipe package
using Statistics

export 
	naive_graph, phrases_graph,
	stem_graph, lemma_graph, pos_graph,
	node_props, graph_props, rand_erdos_ratio_props

include("basic_tools.jl")
include("raw_graphs.jl")
include("nlp_graphs_stem_pos_lemma.jl")
include("graph_measures.jl")

end
