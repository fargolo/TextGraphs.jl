module TextGraphs

using Graphs , MetaGraphs
using Snowball , WordTokenizers
using RCall

export 
	naive_graph,
	phrases_graph,
	stem_graph,
	lemma_graph,
	pos_graph

include("basic_tools.jl")
include("raw_graphs.jl")
include("nlp_graphs_stem_pos_lemma.jl")

end
