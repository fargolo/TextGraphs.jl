using Embeddings , Distances
using Statistics
using DataFrames, CSV
using Graphs,MetaGraphs, TextGraphs

include("embeddings_utils.jl")

# Loads embedding table
const ft_embtable = load_embeddings(FastText_Text{:pt}; max_vocab_size=30000) 

const word_indexes = get_word_indexes(ft_embtable)

#Load texts
transcricoes_df = CSV.read("../media-to-text/outputs/Banco_Transcricoes.csv",DataFrame) 
sentences = transcricoes_df[15,"Sonho_Recente"]
word_dists_full_df = latent_space_graph(sentences,ft_embtable,naive_graph,true)
CSV.write("corpora/distances.csv",word_dists_full_df)
# Check igraphs.R in the same folder for further analysis