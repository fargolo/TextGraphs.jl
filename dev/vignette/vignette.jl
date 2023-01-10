using TextGraphs
using DataFrames, CSV
using StatsPlots
using Statistics , HypothesisTests
using AlgebraOfGraphics , CairoMakie
using Embeddings

include("vignette-load-data.jl")
# Generate graphs and get properties
poems_naive_graph_props = map(x->graph_props(naive_graph(x)),poems_filt_df[!,"texto"])

poems_naive_props_df = vcat(DataFrame.(poems_naive_graph_props)...)
# Bind graph props to data frame
fernando_df = hcat(poems_filt_df,poems_naive_props_df)


fernando_df = filter(x -> x.graph_size < 1000,fernando_df)
gr(size=(1200,800))
StatsPlots.histogram(fernando_df.graph_size)
@df fernando_df groupedhist(:graph_size, group = :autor, bar_position = :stack)
minimum(fernando_df.graph_size)
sort(fernando_df.graph_size)[end-15:end]

# Window
## Remove graphs < 30
fernando_window_df = filter(x -> x.graph_size > 30,fernando_df)

poems_naive_window_props = map(x->window_props(30,naive_graph,x),fernando_window_df[!,"texto"])
poems_naive_window_props_df = vcat(DataFrame.(poems_naive_window_props)...)
fernando_window_df = hcat(fernando_window_df,poems_naive_window_props_df,makeunique=true)


# Verbosity correction
fernando_window_df.betweeness_corr =  log.(fernando_window_df.mean_between_centr) ./ fernando_window_df.graph_size.^2
fernando_window_df.density_corr =  log.(fernando_window_df.density) ./ fernando_window_df.graph_size.^2
fernando_window_df.size_lcc_corr =  log.(fernando_window_df.size_largest_scc) ./ fernando_window_df.graph_size.^2


# Plots
a =  @df fernando_window_df StatsPlots.violin(:autor, :mean_between_centr,title="Betweeness centrality",ylabel="Raw",xaxis=nothing)
b = @df fernando_window_df StatsPlots.violin(:autor, :mean_between_centr_1,ylabel="Window",xaxis=nothing)
c = @df fernando_window_df StatsPlots.violin(:autor, :betweeness_corr,ylabel="Transformed",left_margin=8Plots.mm)
bt_pl = Plots.plot(a,b,c,layout=(3,1))

d = @df fernando_window_df StatsPlots.violin(:autor, :size_largest_scc,title = "LCC",xaxis=nothing)
e = @df fernando_window_df StatsPlots.violin(:autor, :size_largest_scc_1,xaxis=nothing)
f = @df fernando_window_df StatsPlots.violin(:autor, :size_lcc_corr)
lcc_pl = Plots.plot(d,e,f,layout=(3,1))

g = @df fernando_window_df StatsPlots.violin(:autor, :density,title="Density",xaxis=nothing)
h = @df fernando_window_df StatsPlots.violin(:autor, :density_1,xaxis=nothing)
i = @df fernando_window_df StatsPlots.violin(:autor, :density_corr)
density_pl = Plots.plot(g,h,i,layout=(3,1))
Plots.plot(bt_pl,lcc_pl,density_pl,layout=(1,3),rotation=90,legend=false)

#@df fernando_df StatsPlots.violin(:autor, :density_corr)
# Raw
@df fernando_window_df StatsPlots.marginalscatter(:size_largest_scc,
:mean_between_centr,group=:autor,alpha=0.2)
#Window
@df fernando_window_df StatsPlots.marginalscatter(:size_largest_scc_1,
:mean_between_centr_1,group=:autor,alpha=0.6)
# Transformed
@df fernando_window_df StatsPlots.marginalscatter(:size_lcc_corr,
:betweeness_corr,group=:autor,alpha=0.6)

# AlgebraOfGraphics
## Windowed LCC vs Windowed between. centr.
axis = (type = Axis3, width = 800, height = 800)
layer = AlgebraOfGraphics.density() * visual(Wireframe, linewidth=0.05)
fernando_mapping = data(fernando_window_df) * mapping(:size_largest_scc_1,:mean_between_centr_1)
plt = fernando_mapping * layer * mapping(color = :autor)
draw(plt; axis)

fernando_mapping = data(fernando_window_df) * mapping(:size_largest_scc_1,:mean_between_centr_1)
axis = (width = 800, height = 800)
layer = AlgebraOfGraphics.density() * visual(Contour) + mapping(color=:graph_size,marker=:autor)
plt = fernando_mapping * layer * mapping(color = :autor)
draw(plt; axis)


# Descriptive of means
combine(groupby(fernando_window_df, :autor), :betweeness_corr .=> Statistics.mean)
combine(groupby(fernando_window_df, :autor), :density_corr .=> Statistics.median)
combine(groupby(fernando_window_df, :autor), :size_lcc_corr .=> Statistics.mean)

# Hypothesis testing
fernando_authors = groupby(fernando_df,:autor)
ricardo , caieiro , bernardo, alvaro =  fernando_authors[1].betweeness_corr, 
    fernando_authors[2].betweeness_corr, fernando_authors[3].betweeness_corr,
    fernando_authors[4].betweeness_corr

KruskalWallisTest(ricardo, caieiro, bernardo, alvaro)
OneWayANOVATest(ricardo, caieiro, bernardo, alvaro)


# Semantics
const pt_embtable = load_embeddings(FastText_Text{:pt}; max_vocab_size=30000) 

weighted_graphs = map(x->latent_space_graph(x,pt_embtable,naive_graph),fernando_window_df[!,"texto"])
txt_distances = map(x -> Matrix{Float64}(x["skipmiss_distances"][:,2:end]),weighted_graphs)
dets = map(det,txt_distances)
norm_dets = map(x -> log(abs(det(x)))/ foldr(*,size(x)),txt_distances)
fernando_window_df = hcat(fernando_window_df,dets,norm_dets,makeunique=true)
rename!(fernando_window_df,[:x1 , :x1_1].=> [:det, :norm_dets])

gr(size=(600,400))
@df fernando_window_df[completecases(fernando_window_df), :] StatsPlots.violin(:autor, :norm_dets, title="Normalized Gcs",legend=false)

## 
fernando_authors = groupby(fernando_window_df,:autor)
ricardo , caieiro , bernardo, alvaro =  fernando_authors[1].norm_dets, 
    fernando_authors[2].norm_dets, fernando_authors[3].norm_dets,
    fernando_authors[4].norm_dets

KruskalWallisTest(ricardo, caieiro, bernardo, alvaro)
OneWayANOVATest(ricardo, caieiro, bernardo, alvaro)
