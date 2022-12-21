using GraphMakie , GLMakie
using MetaGraphs

california_txt = "Someone told me there's a girl out there
With love in her eyes and flowers in her hair"

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

naive_g = naive_graph(california_txt)
lemma_g = lemma_graph(california_txt)
g_labels = TextGraphs.get_graph_labels(naive_g)
lemma_g_labels = TextGraphs.get_graph_labels(lemma_g)

graphplot(naive_g,nlabels=g_labels, edge_width=0.5)
graphplot(lemma_g,nlabels=lemma_g_labels)

layout = Spectral(dim=3)
graphplot(naive_g,node_size=30,nlabels=g_labels,layout=layout)