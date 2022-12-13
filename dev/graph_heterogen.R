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
  if (mode == "col") {
    A = A %*% diag(1/colSums(A))
    dim = 2 
  } else {
    A = diag(1/rowSums(A)) %*% A
    dim = 1 
  }
  return(list(shannon = apply(A, dim, shannon), 
              simpson = apply(A, dim, simpson), 
              rao = apply(A, dim, rao, D)))
}

