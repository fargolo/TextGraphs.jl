# TextGraphs

[![Build Status](https://github.com/fargolo/TextGraphs.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/fargolo/TextGraphs.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/fargolo/TextGraphs.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/fargolo/TextGraphs.jl)


# Introduction
This package offers Graphs representations of Text. It builds on SpeechGraphs, while adding extra features.   

## To do

[ ] Tokenizers must remove punctuation.  
[ ] Distance based on Embeddings.  
[ ] Compare current measures with SpeechGraph.  
---  

## Supported graphs

**Support for**:  
[X] Naive Graph: Uses original sequence of words.  
[X] Stem Graph: Uses lemmatized words.  
[ ] Part of Speech Graph.  
[X] Sentences Graph: Uses original sequence of phrases.  

Preprocessing  
[X] 1 . Tokenize text by sentences.  
[X] 2 . Tokenize sentences by words.  
[X] 3 . Stemming  

Text to Graph  
[X] 1 . Generate Graphs from sequence of tokenized words  
[X] 2 . Generate Graphs from sequence of tokenized sentences  

Graph Measures  
[X] Centrality measures  
[X] Density  
[X] Strongly and Weakly connected components  
