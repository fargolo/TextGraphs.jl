using GraphMakie , GLMakie
using MetaGraphs


drummond_poem = "no meio do caminho tinha uma pedra
tinha uma pedra no meio do caminho
tinha uma pedra
no meio do caminho tinha uma pedra
nunca me esquecerei desse acontecimento
na vida de minhas retinas t o fatigadas
nunca me esquecerei que no meio do caminho
tinha uma pedra
tinha uma pedra no meio do caminho
no meio do caminho tinha uma pedra
no meio do caminho tinha uma pedra tinha uma pedra no meio do caminho"

naive_g = naive_graph(drummond_poem)
g_labels = TextGraphs.get_graph_labels(naive_g)

graphplot(naive_g,nlabels=g_labels, edge_width=0.5)
graphplot(stem_g,nlabels=stem_g_labels,edgelinewidth=ew)

layout = Spectral(dim=3)
graphplot(naive_g,node_size=30,nlabels=g_labels,layout=layout)