module TextGraphs

using Graphs , MetaGraphs
using Snowball , WordTokenizers

export 
	naive_graph,
	stem_graph,
	phrases_graph

include("text_to_graphs.jl")

end
