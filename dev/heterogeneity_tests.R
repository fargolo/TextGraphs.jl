library(igraph)
library(extraDistr)
library(purrr)

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


mat_dim = 5
full_adj = matrix(data=rep(1,mat_dim**2),nrow=mat_dim,ncol=mat_dim)
adj_mat = matrix(data=rbinom(n = mat_dim**2,size = 1,prob=.5),nrow=mat_dim,ncol=mat_dim)
diag(adj_mat) <- rep(1,nrow(adj_mat))
rnd_mat = matrix(data=rnorm(n = mat_dim**2,sd = 15),nrow=mat_dim,ncol=mat_dim)
rnd_mat_array = purrr::map(.f = function(x) matrix(data=extraDistr::rhnorm(n = x**2),nrow=x,ncol=x),.x=c(1:30))
rnd_mat_array = purrr::map(.f = function(x) matrix(data=rnorm(n = x**2),nrow=x,ncol=x),.x=c(1:30))

random_g <- graph_from_adjacency_matrix(adj_mat)
g_attr <- set_edge_attr(random_g, "weight", value=1)


# Found a transformation for det(x) that scales linearly with length(x)
## Log-det uhhraay :) 
## f(det(x)) = log(abs(det(x))) / length(x)
heterogeneity(g_attr,D=rnd_mat,mode="col")
scaled_determs <- purrr::map(rnd_mat_array,.f=function(x) log(abs(det(x))) / length(x))
abs_determs <- purrr::map(scaled_determs,abs)
plot(c(1:length(scaled_determs)),scaled_determs)
#Inspecting Rao's objects
#AB = as_adjacency_matrix(g_attr, attr = "weight", sparse = FALSE)
#Proportion of total edges ("evenness") for each node: AC = diag(1/rowSums(AB)) %*% AB 
#Weighted sum by distances: AD = diag(AC[1,])  %*% rnd_mat %*% diag(AC[1,])
#Sum for each node: AE = sum(AD)
  
diag(adj_mat)
