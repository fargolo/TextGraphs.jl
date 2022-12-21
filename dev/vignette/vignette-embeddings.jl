using Embeddings , Distances
using Statistics
using DataFrames, CSV
using Graphs,MetaGraphs, TextGraphs
using GraphMakie , GLMakie
using LinearAlgebra
using Plots 
using DynamicalSystems

# Functions for LSE
include("embeddings_utils.jl")
# Loads data to poems_filt_df
include("vignette-load-data.jl")


# Load embedding table
const ft_embtable = load_embeddings(FastText_Text{:en}; max_vocab_size=30000) 

sentences = poems_filt_df[90,"texto"]

colors_txt = "Colors are the central theme of this text .
Blue , green and yellow are the colors of Brazil .
Red and white are from Japan and Canada .
Does violet exist in any flags ?
Jamaica is yellow, black and green . Orange is another color ."
colors_txt = "red green yellow blue"

random_txt = "This text looks like a Haiku .
Frog can be pink, rocket is bigger than hat .
Every night there's ice in some bakery .
Even the Jew can run and fish ,
but socialism remains seated"

# Latent space dists and graph
weighted_graph_rnd = latent_space_graph(random_txt,ft_embtable,naive_graph)
weighted_graph = latent_space_graph(colors_txt,ft_embtable,naive_graph)

txt_distances = Matrix{Float64}(weighted_graph["skipmiss_distances"][:,2:end])
txt_distances_rnd = Matrix{Float64}(weighted_graph_rnd["skipmiss_distances"][:,2:end])
plt_labs = weighted_graph["skipmiss_distances"][:,1]
plt_labs_rnd = weighted_graph_rnd["skipmiss_distances"][:,1]

gr(size=(1200,500))
Plots.plot(Plots.heatmap(txt_distances,xticks=(1:length(plt_labs),plt_labs),
                                        yticks=(1:length(plt_labs),plt_labs)),
            Plots.heatmap(txt_distances_rnd,xticks=(1:length(plt_labs_rnd),plt_labs_rnd),
                                        yticks=(1:length(plt_labs_rnd),plt_labs_rnd)),
layout=(1,2),xrotation=90)

# Generalized variance: det(txt_colors) < det(randn_text)
log(abs(det(txt_distances)))/ foldr(*,size(txt_distances))
log(abs(det(txt_distances_rnd)))/ foldr(*,size(txt_distances_rnd))


#RQA
rqa(txt_distances)

# Get labels and weights
g_labels = map(x -> get_prop(weighted_graph["weighted_graph"],x,:token), collect(1:nv(weighted_graph["weighted_graph"])))
graphweights = round.(map(x->get_prop(weighted_graph["weighted_graph"],x,:weight),collect(edges(weighted_graph["weighted_graph"]))),digits=3)

# Plot
graphplot(weighted_graph["weighted_graph"], elabels=string.(graphweights),
nlabels=g_labels, edge_width= 0.4,edge_color="gray")
    

CSV.write("corpora/distances.csv",word_dists_full_df)
# Check igraphs.R or embeddings.jl in the same folder for further analysis
