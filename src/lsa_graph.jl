# rastros_term_doc = CSV.read("corpora/RastrOS/RastrOS_term_doc.csv",DataFrame)
# rastros_svd = LinearAlgebra.svd(Matrix(rastros_term_doc[:,2:end]))
# U, S, V = F;


"""
    lsa_cosine_matrix(raw_text)

Return square matrix with cosine distances between words in text. Currently, uses RastrOS corpus. 

This function is used internally.
"""


# Future: Edges weighted on cosien similarity
#function add_prop_edge_distance(mg)
#    for i in 1:nv(mg)
#        for j in 1:nv(mg) 
#            token_a , token_b = get_prop(mg,i,:token) , get_prop(mg,j,:token)
#            set_prop!(mg, i,j, :distance , cos_similarity(token_a,token_b))
#    end
#end
