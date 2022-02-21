using GraphMakie , GLMakie

# g = naive_graph("Colorless green ideas sleep furiously")
# stem_g = stem_graph("No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho")
g_labels = map(x -> get_prop(naive_g,x,:token), collect(1:nv(naive_g)))
stem_g_labels = map(x -> get_prop(stem_g,x,:token), collect(1:nv(stem_g)))
graphplot(naive_g,nlabels=g_labels)
graphplot(stem_g,nlabels=stem_g_labels)

layout = Spectral(dim=3)
graphplot(naive_g,node_size=30,nlabels=g_labels,layout=layout)