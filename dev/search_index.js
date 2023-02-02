var documenterSearchIndex = {"docs":
[{"location":"README/#TextGraphs","page":"Instructions","title":"TextGraphs","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"<!–- (Image: Stable) –>   (Image: Dev) (Image: Build Status) (Image: Coverage)","category":"page"},{"location":"README/#Introduction","page":"Instructions","title":"Introduction","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"TextGraphs.jl offers Graphs representations of Text, along with natural language proccessing (NLP) functionalities.  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"It is inspired by SpeechGraphs(https://repositorio.ufrn.br/jspui/handle/123456789/23273), which transform text into graphs. TextGraphs.jl novel features include graph properties (e.g. centrality) and latent space embeddings (adding latent semantic information to graphs). ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Julia uses multiple dispatching, focusing on modular functions and high-performance computing. There's a previous object-oriented Python implementation by github/facuzeta.  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"(Image: No meio do caminho tinha uma pedra. Tinha uma pedra no meio do caminho.)","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"","category":"page"},{"location":"README/#Quick-introduction","page":"Instructions","title":"Quick introduction","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Check the documentation for further information.   ","category":"page"},{"location":"README/#Install","page":"Instructions","title":"Install","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Install with Pkg.  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"pkg>add TextGraphs","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"You should also have R and package udpipe available.","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"$sudo apt install r-base\n$sudo Rscript -e 'install.packages(\"udpipe\")'","category":"page"},{"location":"README/#Features","page":"Instructions","title":"Features","text":"","category":"section"},{"location":"README/#Graph-types","page":"Instructions","title":"Graph types","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"You can build the following graphs from text (AbstractString):  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Raw  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Naive (naive_graph) uses the original sequence of words.  \nPhrases Graph(phrases_graph): Uses the original sequence of phrases.  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"POS, Stems and Lemmas  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Stem (stem_graph) uses stemmed words.    \nLemma (lemma_graph): Uses lemmatized words.  \nPart of Speech Graph (POS, pos_graph) uses syntactical functions. ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Latent space embeddings","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Latent space embedding (LSE, latent_space_graph) graphs.  ","category":"page"},{"location":"README/#Properties","page":"Instructions","title":"Properties","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"You can obtain several properties of the graphs:  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Direct measures   graph_props returns values of density, # of self loops, # of SCCs, size of largest SCC, and mean centrality (betweeness, closeness and eigenvector methods).  ","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Erdős–Rényi ratios   rand_erdos_ratio_props returns values of density and mean centrality ratios between the graph and a random Erdõs-Rényi graph with identical number of vertices and edges.  ","category":"page"},{"location":"README/#Usage","page":"Instructions","title":"Usage","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"julia>using TextGraphs  \njulia>naive_graph(\"Sample for graph\")  \n{3, 2} directed Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)  \njulia>stem_graph(\"Sample for graph\";snowball_language=\"english\") # Optional keyword argument  \n{3, 2} directed Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)  \njulia> graph_props(naive_graph(\"Sample for graph\"))\nDict{String, Real} with 7 entries:\n  \"mean_close_centr\"        => 0.388889\n  \"size_largest_scc\"        => 1\n  \"num_strong_connect_comp\" => 3\n  \"density\"                 => 0.333333\n  \"num_self_loops\"          => 0\n  \"mean_between_centr\"      => 0.166667\n  \"mean_eig_centr\"          => 0.333335","category":"page"},{"location":"README/#Plot","page":"Instructions","title":"Plot","text":"","category":"section"},{"location":"README/","page":"Instructions","title":"Instructions","text":"using GraphMakie , GLMakie\n\ng = naive_graph(\"Colorless green ideas sleep furiously\")\nstem_g = stem_graph(\"No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho\")\n\ng_labels = map(x -> get_prop(naive_g,x,:token), collect(1:nv(naive_g)))\nstem_g_labels = map(x -> get_prop(stem_g,x,:token), collect(1:nv(stem_g)))\ngraphplot(naive_g,nlabels=g_labels)\ngraphplot(stem_g,nlabels=stem_g_labels)\n\nspec3_layout = Spectral(dim=3)\ngraphplot(naive_g,node_size=30,nlabels=g_labels,layout=spec3_layout)","category":"page"},{"location":"README/","page":"Instructions","title":"Instructions","text":"Modules = [TextGraphs]","category":"page"},{"location":"README/#TextGraphs.add_prop_label_tokens-Tuple{MetaGraphs.AbstractMetaGraph, Any}","page":"Instructions","title":"TextGraphs.add_prop_label_tokens","text":"add_prop_label_tokens(metagraph,metagraph_unique_tokens)\n\nAdd tokens as properties of nodes in a MetaGraph.\n\nThis function is used internally to attach word labels to each node. Unique tokens must have length equal to the number of vertices\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.build_labelled_graph-Tuple{AbstractArray}","page":"Instructions","title":"TextGraphs.build_labelled_graph","text":"build_labelled_graph(x::AbstractArray)\n\nThis function is used internally to build graph lebelled with unique tokens.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.bypass_eigenvector_centrality-Tuple{Union{MetaGraphs.MetaDiGraph, Graphs.SimpleGraphs.SimpleDiGraph}}","page":"Instructions","title":"TextGraphs.bypass_eigenvector_centrality","text":"bypass_eigenvector_centrality(g::Union{MetaDiGraph,SimpleGraph})\n\nCalculate eigenvector centrality for each node in g. \n\nThis function returns an Array with either the eigenvector centrality values or missing. It is needed because LinAlg.jl.eigs seems to bear erratic behavior, sometimes returning vector bound error.  \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.erdos_graph_short-Tuple{MetaGraphs.MetaDiGraph}","page":"Instructions","title":"TextGraphs.erdos_graph_short","text":"erdos_graph_short(g::MetaDiGraph)\n\nGenerate random Erdős–Rényi graph from MetaDiGraph.\n\nShort version of erdos_renyi function that takes a MetaDiGraph instead of numebr of vertices and nodes.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.get_graph_labels-Tuple{MetaGraphs.MetaDiGraph}","page":"Instructions","title":"TextGraphs.get_graph_labels","text":"get_graph_labels(g::MetaDiGraph)\n\nReturn graph labels.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.graph_props-Tuple{Union{MetaGraphs.MetaDiGraph, Graphs.SimpleGraphs.SimpleDiGraph}}","page":"Instructions","title":"TextGraphs.graph_props","text":"graph_props(g::MetaDiGraph)\n\nCalculate several properties for a MetaDiGraph.\n\nThis function returns a Dict with numeric values for density, # of self loops, # of SCCs, size of largest SCC,  and mean centrality (betweeness, closeness and eigenvector methods) \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.lemma_graph-Tuple{AbstractString}","page":"Instructions","title":"TextGraphs.lemma_graph","text":"lemma_graph(my_text)\n\nBuild lemmatized graph from text (AbstractString) using R package udpipe. \n\nCurrently, supports portuguese and english corpora. \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.link_consecutive-Tuple{AbstractArray}","page":"Instructions","title":"TextGraphs.link_consecutive","text":"link_consecutive(array_with_tokens)\n\nTransform serialized tokens into a directed graph. \n\nThis function is used internally to build graphs from text. Each token has an unique node in the graph.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.mean_graph_centrs-Tuple{Union{MetaGraphs.MetaDiGraph, Graphs.SimpleGraphs.SimpleDiGraph}}","page":"Instructions","title":"TextGraphs.mean_graph_centrs","text":"mean_graph_centrs(g::Union{MetaDiGraph,SimpleGraph})\n\nCalculate mean values for centrality (betweeness, closeness and eigenvector methods). \n\nThis function returns a Dict with numeric values for each centrality method.  \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.naive_graph-Tuple{AbstractString}","page":"Instructions","title":"TextGraphs.naive_graph","text":"naive_graph(raw_text::AbstractString)\n\nBuild graph from text (AbstractString) with unprocessed words.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.node_props-Tuple{Union{MetaGraphs.MetaDiGraph, Graphs.SimpleGraphs.SimpleDiGraph}}","page":"Instructions","title":"TextGraphs.node_props","text":"node_props(g::Union{MetaDiGraph,SimpleGraph})\n\nCalculate betweeness, closeness and eigenvector centralities for each node. \n\nThis function returns a Dict with vectors of values for each centrality method.  \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.phrases_graph-Tuple{AbstractString}","page":"Instructions","title":"TextGraphs.phrases_graph","text":"phrases_graph(my_text)\n\nBuild graph from text (AbstractString) using sentences as unique tokens. \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.pos_graph-Tuple{AbstractString}","page":"Instructions","title":"TextGraphs.pos_graph","text":"pos_graph(my_text)\n\nBuild POS Tagging from text (AbstractString) using R package udpipe. \n\nCurrently, supports portuguese and english corpora. \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.rand_erdos_ratio_props-Tuple{MetaGraphs.MetaDiGraph}","page":"Instructions","title":"TextGraphs.rand_erdos_ratio_props","text":"rand_erdos_ratio_props(g::MetaDiGraph)\n\nCalculate ratios between a given MetaDiGraph and a corresponding random Erdős–Rényi graph.\n\nThis function returns a Dict with numeric values for density and  mean centralities (betweeness, closeness and eigenvector methods) \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.rand_erdos_ratio_sampled-Tuple{MetaGraphs.MetaDiGraph}","page":"Instructions","title":"TextGraphs.rand_erdos_ratio_sampled","text":"rand_erdos_ratio_props(g::MetaDiGraph;n_samples=1000,n_boot=1000)\n\nCalculate ratios between a given MetaDiGraph and corresponding random Erdős–Rényi graphs via bootstrapping.\n\nThis function returns a Dict with numeric values for density, connected components and  mean centralities (betweeness, closeness and eigenvector methods). Currently returning error for some samples.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.stem_graph-Tuple{AbstractString}","page":"Instructions","title":"TextGraphs.stem_graph","text":"stem_graph(my_text)\n\nBuild graph from text (AbstractString) using lemmatized words. \n\nStemming is performed with Snowball.jl stemmer. Default language is \"english\". \n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.udp_import_annotations-Tuple{AbstractString}","page":"Instructions","title":"TextGraphs.udp_import_annotations","text":"udp_import_annotations(raw_text)\n\nGet anonnotated DataFrame by importing R::udpipe object created with udpipe::annonate. \n\nThis function is used internally.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.window_props-Tuple{Any, Any, Any}","page":"Instructions","title":"TextGraphs.window_props","text":"window_props(nwindow, graph_function, raw_text)\n\nCalculate average properties from subsets of text.\n\nUser must privde window length (1st argument), graph building function (e.g. naive_graph) and source text.\n\n\n\n\n\n","category":"method"},{"location":"README/#TextGraphs.window_props_lemma","page":"Instructions","title":"TextGraphs.window_props_lemma","text":"windowpropslemma(rawtext,nwindow=5,txtstepsize=1,text_language=\"english\")\n\nCalculate average properties from subsets of text.\n\nUser must privde window length (1st argument), graph building function (e.g. naive_graph) and source text.\n\n\n\n\n\n","category":"function"},{"location":"","page":"Functions","title":"Functions","text":"CurrentModule = TextGraphs","category":"page"},{"location":"#TextGraphs","page":"Functions","title":"TextGraphs","text":"","category":"section"},{"location":"","page":"Functions","title":"Functions","text":"Documentation for TextGraphs.","category":"page"},{"location":"#Functionalities","page":"Functions","title":"Functionalities","text":"","category":"section"},{"location":"","page":"Functions","title":"Functions","text":"List of package utilities.  ","category":"page"},{"location":"","page":"Functions","title":"Functions","text":"Modules = [TextGraphs]","category":"page"},{"location":"","page":"Functions","title":"Functions","text":"","category":"page"}]
}
