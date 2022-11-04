using Embeddings , Distances
using Statistics
using DataFrames, CSV
using Graphs,MetaGraphs, TextGraphs

include("embeddings_utils.jl")

# Load embedding table
const ft_embtable = load_embeddings(FastText_Text{:pt}; max_vocab_size=30000) 

# Load texts
poems_df = CSV.read("dev/fernando_pessoa.csv",DataFrame) 
sentences = poems_df[4,"texto"]

# Latent space graph
word_dists_full_df = latent_space_graph(sentences,ft_embtable,naive_graph,true)
CSV.write("corpora/distances.csv",word_dists_full_df)
# Check igraphs.R or embeddings.jl in the same folder for further analysis
