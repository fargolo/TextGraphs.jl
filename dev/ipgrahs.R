# https://neo4j.com/docs/graph-data-science/current/algorithms/
# http://users.dimi.uniud.it/~massimo.franceschet/teaching/datascience/network/heterogeneity.html
# To do: remover stopwords 
#dist_matrix[colSums(!is.na(dist_matrix)) > 0]
## Load package
library(igraph)

full_matrix <- read.csv("corpora/distances.csv")
dist_matrix <- full_matrix[,2:ncol(full_matrix)] 
colnames(dist_matrix) <- full_matrix[,1]

g3 =  graph_from_adjacency_matrix(as.matrix(dist_matrix), 
                                  weighted=TRUE, mode="undirected",
                                  add.colnames = T)
E(g3)$width <- 1/(E(g3)$weight + min(E(g3)$weight,na.rm = T))
plot(g3,edge.label=round(E(g3)$weight,3),
     vertex.label=full_matrix[,1],
     edge.width=E(g3)$width)
distances(g3)
eigen_centrality(g3)
# raw harmonic centrality(node) = sum(1 / distance from node to every other node excluding itself)
harmonic_centrality(g3)
igraph::closeness(g3)

igraph::page_rank(g3)

#install.packages("janitor")
#df <- janitor::remove_empty(dist_matrix, 
#                            which = "cols")
