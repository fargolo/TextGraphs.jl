using Graphs 
# Random Graph (Erdos-Renyi) 
random_g = Graphs.erdos_renyi(nv(g),ne(g)) 

# Centrality Measures
Graphs.betweenness_centrality(g)
Graphs.closeness_centrality(g)
Graphs.eigenvector_centrality(g)
# Other measures
Graphs.prim_mst(random_g) # Minimum spanning tree requires undirected graph
Graphs.density(g) # Actual edges / Possible Edges
Graphs.num_self_loops(g) # Repetition: from word to itself, as in add_edge!(g,1,1) 

# Connected components
SCC = Graphs.strongly_connected_components(g)
nSCC = length(SCC) # Number of SCC
maximum(map(length,SCC)) # Size of Largest connected component
Graphs.strongly_connected_components_kosaraju(g)
Graphs.weakly_connected_components(g)
