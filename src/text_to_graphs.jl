"""
    link_consecutive(array_with_tokens)

Transform serialized tokens into a directed graph. 

This function is used internally to build graphs from text. Each token has an unique node in the graph.
"""
function link_consecutive(tokens_list::AbstractArray)
    unique_tokens = unique(tokens_list)
    g_lenght = length(unique_tokens) #g total size (nodes)
    g = Graphs.DiGraph(g_lenght) # initialize
    
    for (cur_token,next_token) in zip(tokens_list[1:end-1],tokens_list[2:end])
        ind1 , ind2 = findfirst(x->x==cur_token,unique_tokens) ,
                        findfirst(x->x==next_token,unique_tokens)
        add_edge!(g, ind1, ind2)
    end
    return g
end   

"""
    add_prop_label_tokens(metagraph,metagraph_unique_tokens)

Add tokens as properties of nodes in a `MetaGraph`.

This function is used internally to attach word labels to each node. Unique tokens must have length equal to the number of vertices
"""
function add_prop_label_tokens(mg::AbstractMetaGraph,unique_tokens)
    for (token_index,unique_token) in zip(collect(1:length(unique_tokens)),unique_tokens)
        set_prop!(mg,token_index,:token,unique_token)
    end
    return mg
end    



# Text to naive graphs 

"""
    naive_graph(raw_text::AbstractString)

Build graph from text (`AbstractString`) with unprocessed words.
"""
function naive_graph(raw_text::AbstractString)
    tokenized_words = WordTokenizers.tokenize(raw_text)
    unique_tokens = unique(tokenized_words)    
    g = link_consecutive(tokenized_words)
    mg = MetaGraphs.MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end

"""
    stem_graph(my_text)

Build graph from text (`AbstractString`) using lemmatized words. 

Stemming is performed with `Snowball.jl` stemmer. Default language is "portugese". 
"""
function stem_graph(raw_text::AbstractString, snowball_language::AbstractString = "portuguese")
    pt_stemmer = Snowball.Stemmer(snowball_language) # Snowball.stemmer_types()
    tokenized_words = WordTokenizers.tokenize(raw_text)
    tokenized_words_stem = map(x -> Snowball.stem(pt_stemmer,x),tokenized_words)
    unique_tokens = unique(tokenized_words_stem)
    g = link_consecutive(tokenized_words_stem)
    mg = MetaGraphs.MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end   

"""
    phrases_graph(my_text)

Build graph from text (`AbstractString`) using sentences as unique tokens. 
"""
function phrases_graph(raw_text::AbstractString)
    tokenized_sentences = [x for x in WordTokenizers.split_sentences(raw_text)]
    # Tokenize words within sentences
    # tokenized_sentences = [WordTokenizers.tokenize(x) for x in WordTokenizers.split_sentences(raw_text)]
    unique_tokens = unique(tokenized_sentences) # Identical sentences are rare
    g = link_consecutive(tokenized_sentences)
    mg = MetaGraphs.MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end
 
# Future: Text to POS Graphs
#function pos_graph()
   # POS_TAGGING
#end

# Future: Edges weighted on cosien similarity
#function add_prop_edge_distance(mg)
#    for i in 1:nv(mg)
#        for j in 1:nv(mg) 
#            token_a , token_b = get_prop(mg,i,:token) , get_prop(mg,j,:token)
#            set_prop!(mg, i,j, :distance , cos_similarity(token_a,token_b))
#    end
#end