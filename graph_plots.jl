using GraphMakie , GLMakie

g_labels = map(x -> get_prop(a,x,:token), collect(1:nv(a)))
graphplot(a,nlabels=g_labels)