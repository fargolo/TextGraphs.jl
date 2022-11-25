using Embeddings , Distances
using Statistics
using DataFrames, CSV
using Graphs,MetaGraphs, TextGraphs
using GraphMakie , GLMakie

# Functions for LSE
include("embeddings_utils.jl")
# Loads data to poems_filt_df
include("vignette-load-data.jl")


# Load embedding table
const ft_embtable = load_embeddings(FastText_Text{:pt}; max_vocab_size=30000) 

sentences = poems_filt_df[1,"texto"]

# Latent space dists and graph
word_dists_full_df = latent_space_dists(sentences,ft_embtable,naive_graph,true)
weighted_graph = latent_space_graph(sentences,ft_embtable,naive_graph,true)

# Get labels and weights
g_labels = map(x -> get_prop(weighted_graph,x,:token), collect(1:nv(weighted_graph)))
graphweights = round.(map(x->get_prop(weighted_graph,x,:weight),collect(edges(weighted_graph))),digits=3)

# Plot
graphplot(weighted_graph, elabels=string.(graphweights),
nlabels=g_labels, edge_width= exp.(graphweights),edge_color="gray")

CSV.write("corpora/distances.csv",word_dists_full_df)
# Check igraphs.R or embeddings.jl in the same folder for further analysis
