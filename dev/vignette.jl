using TextGraphs
using DataFrames, CSV
using StatsPlots
using Statistics , HypothesisTests

poems_df = CSV.read("dev/fernando_pessoa.csv",DataFrame) 
sentences = poems_df[4,"texto"]

autor_list = ["Ricardo Reis","Alberto Caeiro","Álvaro de Campos","Bernardo Soares"]
poems_filt_df = filter(row -> row.autor in autor_list,poems_df)

# To do:
## Problem in text 794.
## eigenvector_centrality randomly returns an error
## probably problem with LinAlg.jl "eigs"
## that uses partialschur and partial
##  graph_props(naive_graph(poems_filt_df[794,"texto"]))

a = naive_graph(poems_filt_df[794,"texto"])

function bypass_eigenvector_centrality(g::Union{MetaDiGraph,SimpleDiGraph})
    try 
        eig_centr = Graphs.eigenvector_centrality(g)
        return eig_centr
    catch e
        println("Eigenvector vector bounds error")
        eig_centr = Array{Missing}(missing, nv(g), 1)
        return eig_centr
    end    
end

b = bypass_eigenvector_centrality(a)

poems_naive_graph_props = map(x->graph_props(naive_graph(x)),poems_filt_df[!,"texto"])
poems_naive_props_df = vcat(DataFrame.(poems_naive_graph_props)...)

fernando_df = hcat(poems_filt_df,poems_naive_props_df)
fernando_df.betweeness_corr =  fernando_df.mean_between_centr ./ fernando_df.graph_size .* 100
fernando_df.density_corr =  fernando_df.density ./ fernando_df.graph_size .* 100
fernando_df.size_lcc_corr =  fernando_df.size_largest_scc ./ fernando_df.graph_size

fernando_df = filter(row -> row.graph_size < 400,fernando_df)
histogram(fernando_df.graph_size)

@df fernando_df violin(:autor, :mean_between_centr)
@df fernando_df violin(:autor, :betweeness_corr)
@df fernando_df violin(:autor, :size_lcc_corr)
@df fernando_df violin(:autor, :size_largest_scc)
@df fernando_df violin(:autor, :density)
@df fernando_df violin(:autor, :density_corr)

combine(groupby(fernando_df, :autor), :betweeness_corr .=> Statistics.mean)
combine(groupby(fernando_df, :autor), :density_corr .=> Statistics.median)
combine(groupby(fernando_df, :autor), :size_lcc_corr .=> Statistics.mean)

fernando_authors = groupby(fernando_df,:autor)

ricardo , caieiro , bernardo, alvaro =  fernando_authors[1].betweeness_corr, fernando_authors[2].betweeness_corr, fernando_authors[3].betweeness_corr,fernando_authors[4].betweeness_corr

KruskalWallisTest(ricardo, caieiro, bernardo, alvaro)
OneWayANOVATest(ricardo, caieiro, bernardo, alvaro)
