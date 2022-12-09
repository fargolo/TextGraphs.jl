using TextGraphs
using DataFrames, CSV
using StatsPlots
using Statistics , HypothesisTests
using AlgebraOfGraphics , CairoMakie

include("vignette-load-data.jl")
# Generate graphs and get properties
poems_naive_graph_props = map(x->graph_props(naive_graph(x)),poems_filt_df[!,"texto"])

poems_naive_props_df = vcat(DataFrame.(poems_naive_graph_props)...)
# Bind graph props to data frame
fernando_df = hcat(poems_filt_df,poems_naive_props_df)

# Window
## Remove graphs < 10
fernando_window_df = filter(x -> x.graph_size > 30,fernando_df)

poems_naive_window_props = map(x->window_props(30,naive_graph,x),fernando_window_df[!,"texto"])
poems_naive_window_props_df = vcat(DataFrame.(poems_naive_window_props)...)
fernando_window_df = hcat(fernando_window_df,poems_naive_window_props_df,makeunique=true)

# Verbosity correction
fernando_df.betweeness_corr =  fernando_df.mean_between_centr ./ fernando_df.graph_size .* 100
fernando_df.density_corr =  fernando_df.density ./ fernando_df.graph_size .* 100
fernando_df.size_lcc_corr =  fernando_df.size_largest_scc ./ fernando_df.graph_size
## Filter out outliers by verbosity
fernando_df_filt = filter(x -> x.graph_size < 400,fernando_df)
histogram(fernando_df.graph_size)


# Plots
@df fernando_df StatsPlots.violin(:autor, :mean_between_centr)
@df fernando_window_df StatsPlots.violin(:autor, :mean_between_centr_1)

#@df fernando_df StatsPlots.violin(:autor, :betweeness_corr)
#@df fernando_df StatsPlots.violin(:autor, :size_lcc_corr)
@df fernando_df StatsPlots.violin(:autor, :size_largest_scc)
@df fernando_window_df StatsPlots.violin(:autor, :size_largest_scc_1)


@df fernando_df StatsPlots.violin(:autor, :density)
@df fernando_window_df StatsPlots.violin(:autor, :density_1)

#@df fernando_df StatsPlots.violin(:autor, :density_corr)
@df fernando_df StatsPlots.marginalscatter(:size_largest_scc,
:mean_between_centr,group=:autor,alpha=0.2)
@df fernando_window_df StatsPlots.marginalscatter(:size_largest_scc_1,
:mean_between_centr_1,group=:autor,alpha=0.6)

fernando_df.size_largest_scc_log = log.(fernando_df.size_largest_scc)
fernando_window_df.size_largest_scc_1_log = log.(fernando_window_df.size_largest_scc_1)

@df fernando_df StatsPlots.marginalscatter(:size_largest_scc_log,
:mean_between_centr,group=:autor,alpha=0.5)
@df fernando_window_df StatsPlots.marginalscatter(:size_largest_scc_1_log,
:mean_between_centr_1,group=:autor,alpha=0.5)

# AlgebraOfGraphics
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
combine(groupby(fernando_df, :autor), :betweeness_corr .=> Statistics.mean)
combine(groupby(fernando_df, :autor), :density_corr .=> Statistics.median)
combine(groupby(fernando_df, :autor), :size_lcc_corr .=> Statistics.mean)

# Hypothesis testing
fernando_authors = groupby(fernando_df,:autor)
ricardo , caieiro , bernardo, alvaro =  fernando_authors[1].betweeness_corr, 
    fernando_authors[2].betweeness_corr, fernando_authors[3].betweeness_corr,
    fernando_authors[4].betweeness_corr

KruskalWallisTest(ricardo, caieiro, bernardo, alvaro)
OneWayANOVATest(ricardo, caieiro, bernardo, alvaro)
