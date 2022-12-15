shannon = function(p) {
  x = p * log2(p)
  x = replace(x, is.nan(x), 0)
  return(-sum(x))
}

simpson = function(p) {
  x = 1 - sum(p * p)
  return(x)
}

rao = function(p, D) {
  x = diag(p) %*% D %*% diag(p)
  return(sum(c(x)))
}


heterogeneity = function(g, D, mode = "col") {
  A = as_adjacency_matrix(g, attr = "weight", sparse = FALSE)
  print(A)
  if (mode == "col") {
    A = A %*% diag(1/colSums(A))
    dim = 2
    print(colSums(A)) 
  } else {
    A = diag(1/rowSums(A)) %*% A
    dim = 1 
    print(rowSums(A))
  }
  return(list(shannon = apply(A, dim, shannon), 
              simpson = apply(A, dim, simpson), 
              rao = apply(A, dim, rao, D)))
}

library(igraph)

mat_dim = 5
full_adj = matrix(data=rep(1,mat_dim**2),nrow=mat_dim,ncol=mat_dim)
adj_mat = matrix(data=rbinom(n = mat_dim**2,size = 1,prob=.5),nrow=mat_dim,ncol=mat_dim)
rnd_mat = matrix(data=rnorm(n = mat_dim**2,sd = 15),nrow=mat_dim,ncol=mat_dim)

random_g <- graph_from_adjacency_matrix(full_adj)
g_attr <- set_edge_attr(random_g,"weight", value = sum(adj_mat))

heterogeneity(g_attr,D=rnd_mat,mode="col")
det(rnd_mat)
#Inspecting Rao's objects
#AB = as_adjacency_matrix(g_attr, attr = "weight", sparse = FALSE)
#Proportion of total edges ("evenness") for each node: AC = diag(1/rowSums(AB)) %*% AB 
#Weighted sum by distances: AD = diag(AC[,1]) %*% rnd_mat %*% diag(AC[,1])
#Sum for each node: AE = sum(AD)
  
diag(adj_mat)
