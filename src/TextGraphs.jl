module TextGraphs

using Graphs , MetaGraphs
using Snowball , WordTokenizers
using RCall

export 
	naive_graph,
	stem_graph,
	phrases_graph,
	pos_graph,
	lemma_graph

include("text_to_graphs.jl")

end
