using Bootstrap
using GraphMakie , GLMakie
using DataFrames

english_sentence = "Colorless green ideas sleep furiously"
naive_g = naive_graph(english_sentence)
g_labels = map(x -> get_prop(naive_g,x,:token), collect(1:nv(naive_g)))


graphplot(naive_g,nlabels=g_labels)

erdos_graph(g::MetaDiGraph) = Graphs.erdos_renyi(nv(g),ne(g),is_directed=true)

random_graphs = [erdos_graph(naive_g) for _ in 1:100]

b = map(graph_props,random_graphs)
c = vcat(DataFrame.(b)...)

bs1 = mapcols(x -> bootstrap(mean, x, BasicSampling(100)) |> bias ,c)

values(bs1[1,:]) ./ values(graph_props(naive_g))

for i in 1:100
    print(i)
    graph_props(random_graphs[i])
end

graph_props(random_graphs[56])