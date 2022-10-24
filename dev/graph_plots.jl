using GraphMakie , GLMakie
using MetaGraphs

# g = naive_graph("Colorless green ideas sleep furiously")
# stem_g = stem_graph("No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho")

function print_tokens(graph::MetaDiGraph)
    g_labels = map(x -> get_prop(graph,x,:token), collect(1:nv(graph)))
    graphplot(graph,nlabels=g_labels)
end    

g_labels = map(x -> get_prop(naive_g,x,:token), collect(1:nv(naive_g)))

graphplot(naive_g,nlabels=g_labels, edgelinewidth=ew,edge_width=0.5)
graphplot(stem_g,nlabels=stem_g_labels,edgelinewidth=ew)

layout = Spectral(dim=3)
graphplot(naive_g,node_size=30,nlabels=g_labels,layout=layout)