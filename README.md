# TextGraphs

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://fargolo.github.io/TextGraphs.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://fargolo.github.io/TextGraphs.jl/dev)
[![Build Status](https://github.com/fargolo/TextGraphs.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/fargolo/TextGraphs.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/fargolo/TextGraphs.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/fargolo/TextGraphs.jl)


# Introduction
This package offers Graphs representations of Text. It builds on SpeechGraphs(https://repositorio.ufrn.br/jspui/handle/123456789/23273), while adding extra features.   

![No meio do caminho tinha uma pedra. Tinha uma pedra no meio do caminho.](dev/drummond.png)

---  

# Features  

## Usage  

Install with Pkg.  
```julia
pkg>add TextGraphs
```

## Supported graphs

**Support for**:  
- [X] Naive Graph: Uses original sequence of words.  
- [X] Stem Graph: Uses lemmatized words.  
- [ ] Part of Speech Graph.  
- [X] Sentences Graph: Uses original sequence of phrases.  

Generate graphs from text (`AbstractString`) with `naive_graph`,`stem_graph` (optional `snowball_language` keyword argument),`phrases_graph`.   

```julia
julia>naive_graph("Sample for graph")
{3, 2} directed Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)

julia>stem_graph("Sample for graph";snowball_language="english") # Optional keyword argument
{3, 2} directed Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)
```
Outputs are directed `Graphs.DiGraph`, with properties added through `MetaGraphs`. One may follow standard procedures for ploting and analysis.  

```julia
using GraphMakie , GLMakie

g = naive_graph("Colorless green ideas sleep furiously")
stem_g = stem_graph(raw_text="No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho")

g_labels = map(x -> get_prop(naive_g,x,:token), collect(1:nv(naive_g)))
stem_g_labels = map(x -> get_prop(stem_g,x,:token), collect(1:nv(stem_g)))
graphplot(naive_g,nlabels=g_labels)
graphplot(stem_g,nlabels=stem_g_labels)

spec3_layout = Spectral(dim=3)
graphplot(naive_g,node_size=30,nlabels=g_labels,layout=spec3_layout)

Graphs.eigenvector_centrality(stem_g)
Graphs.density(stem_g)
```

### Development roadmap 

Preprocessing  
- [X] 1 . Tokenize text by sentences.  
- [X] 2 . Tokenize sentences by words.  
- [X] 3 . Stemming  

Text to Graph  
- [X] 1 . Generate Graphs from sequence of tokenized words  
- [X] 2 . Generate Graphs from sequence of tokenized sentences  

Graph Measures  
- [X] Centrality measures  
- [X] Density  
- [X] Strongly and Weakly connected components  

## To do

- [ ] Tokenizers must remove punctuation.  
- [ ] Distance based on Embeddings.  
- [ ] Compare current measures with original SpeechGraph and ![Python implementation](https://github.com/facuzeta/speechgraph/).  


