var documenterSearchIndex = {"docs":
[{"location":"README/#TextGraphs","page":"Readme","title":"TextGraphs","text":"","category":"section"},{"location":"README/","page":"Readme","title":"Readme","text":"<!–- (Image: Stable) –>   (Image: Dev) (Image: Build Status) (Image: Coverage)","category":"page"},{"location":"README/#Introduction","page":"Readme","title":"Introduction","text":"","category":"section"},{"location":"README/","page":"Readme","title":"Readme","text":"This package offers Graphs representations of Text. It builds on SpeechGraphs(https://repositorio.ufrn.br/jspui/handle/123456789/23273), while adding extra features.  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"(Image: No meio do caminho tinha uma pedra. Tinha uma pedra no meio do caminho.)","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"","category":"page"},{"location":"README/#Features","page":"Readme","title":"Features","text":"","category":"section"},{"location":"README/#Usage","page":"Readme","title":"Usage","text":"","category":"section"},{"location":"README/","page":"Readme","title":"Readme","text":"Install with Pkg.  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"pkg>add TextGraphs","category":"page"},{"location":"README/#Supported-graphs","page":"Readme","title":"Supported graphs","text":"","category":"section"},{"location":"README/","page":"Readme","title":"Readme","text":"Support for:  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"[X] Naive Graph: Uses original sequence of words.  \n[X] Stem Graph: Uses lemmatized words.  \n[ ] Part of Speech Graph.  \n[X] Sentences Graph: Uses original sequence of phrases.  \n[ ] Latent space embedding (LSE) graphs. ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"Generate graphs from text (AbstractString) with naive_graph,stem_graph (optional snowball_language keyword argument),phrases_graph.   ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"julia>naive_graph(\"Sample for graph\")\n{3, 2} directed Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)\n\njulia>stem_graph(\"Sample for graph\";snowball_language=\"english\") # Optional keyword argument\n{3, 2} directed Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"Outputs are directed Graphs.DiGraph, with properties added through MetaGraphs. One may follow standard procedures for ploting and analysis.  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"using GraphMakie , GLMakie\n\ng = naive_graph(\"Colorless green ideas sleep furiously\")\nstem_g = stem_graph(raw_text=\"No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho\")\n\ng_labels = map(x -> get_prop(naive_g,x,:token), collect(1:nv(naive_g)))\nstem_g_labels = map(x -> get_prop(stem_g,x,:token), collect(1:nv(stem_g)))\ngraphplot(naive_g,nlabels=g_labels)\ngraphplot(stem_g,nlabels=stem_g_labels)\n\nspec3_layout = Spectral(dim=3)\ngraphplot(naive_g,node_size=30,nlabels=g_labels,layout=spec3_layout)\n\nGraphs.eigenvector_centrality(stem_g)\nGraphs.density(stem_g)","category":"page"},{"location":"README/#Development-roadmap","page":"Readme","title":"Development roadmap","text":"","category":"section"},{"location":"README/","page":"Readme","title":"Readme","text":"Preprocessing  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"[X] 1 . Tokenize text by sentences.  \n[X] 2 . Tokenize sentences by words.  \n[X] 3 . Stemming  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"Text to Graph  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"[X] 1 . Generate Graphs from sequence of tokenized words  \n[X] 2 . Generate Graphs from sequence of tokenized sentences  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"Graph Measures  ","category":"page"},{"location":"README/","page":"Readme","title":"Readme","text":"[X] Centrality measures  \n[X] Density  \n[X] Strongly and Weakly connected components  ","category":"page"},{"location":"README/#To-do","page":"Readme","title":"To do","text":"","category":"section"},{"location":"README/","page":"Readme","title":"Readme","text":"[ ] Tokenizers must remove punctuation.  \n[ ] Distance based on Embeddings.  \n[ ] Compare current measures with original SpeechGraph and (Image: Python implementation).  ","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = TextGraphs","category":"page"},{"location":"#TextGraphs","page":"Home","title":"TextGraphs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for TextGraphs.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [TextGraphs]","category":"page"},{"location":"#TextGraphs.add_prop_label_tokens-Tuple{MetaGraphs.AbstractMetaGraph, Any}","page":"Home","title":"TextGraphs.add_prop_label_tokens","text":"add_prop_label_tokens(metagraph,metagraph_unique_tokens)\n\nAdd tokens as properties of nodes in a MetaGraph.\n\nThis function is used internally to attach word labels to each node. Unique tokens must have length equal to the number of vertices\n\n\n\n\n\n","category":"method"},{"location":"#TextGraphs.link_consecutive-Tuple{AbstractArray}","page":"Home","title":"TextGraphs.link_consecutive","text":"link_consecutive(array_with_tokens)\n\nTransform serialized tokens into a directed graph. \n\nThis function is used internally to build graphs from text. Each token has an unique node in the graph.\n\n\n\n\n\n","category":"method"},{"location":"#TextGraphs.naive_graph-Tuple{AbstractString}","page":"Home","title":"TextGraphs.naive_graph","text":"naive_graph(raw_text::AbstractString)\n\nBuild graph from text (AbstractString) with unprocessed words.\n\n\n\n\n\n","category":"method"},{"location":"#TextGraphs.phrases_graph-Tuple{AbstractString}","page":"Home","title":"TextGraphs.phrases_graph","text":"phrases_graph(my_text)\n\nBuild graph from text (AbstractString) using sentences as unique tokens. \n\n\n\n\n\n","category":"method"},{"location":"#TextGraphs.stem_graph-Tuple{AbstractString}","page":"Home","title":"TextGraphs.stem_graph","text":"stem_graph(my_text)\n\nBuild graph from text (AbstractString) using lemmatized words. \n\nStemming is performed with Snowball.jl stemmer. Default language is \"portugese\". \n\n\n\n\n\n","category":"method"}]
}
