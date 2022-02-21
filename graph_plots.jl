using GraphMakie , GLMakie

# g = naive_graph("Colorless green ideas sleep furiously")
# stem_g = stem_graph("No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho")
g_labels = map(x -> get_prop(g,x,:token), collect(1:nv(g)))
stem_g_labels = map(x -> get_prop(stem_g,x,:token), collect(1:nv(stem_g)))
graphplot(g,nlabels=g_labels)
graphplot(stem_g,nlabels=stem_g_labels)