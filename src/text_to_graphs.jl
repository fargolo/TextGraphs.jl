"""
    link_consecutive(array_with_tokens)

Transform serialized tokens into a directed graph. 

This function is used internally to build graphs from text. Each token has an unique node in the graph.
"""
function link_consecutive(tokens_list::AbstractArray)
    unique_tokens = unique(tokens_list)
    g_lenght = length(unique_tokens) #g total size (nodes)
    g = Graphs.DiGraph(g_lenght) # initialize
   
    inds = indexin(tokens_list, unique_tokens)
        for i in 2:length(inds)
        add_edge!(g, inds[i-1], inds[i])
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


"""
    build_labelled_graph(x::AbstractArray)

This function is used internally to build graph lebelled with unique tokens.
"""
function build_labelled_graph(x::AbstractArray)
    unique_tokens = unique(x)    
    g = link_consecutive(x)
    mg = MetaGraphs.MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end


"""
    naive_graph(raw_text::AbstractString)

Build graph from text (`AbstractString`) with unprocessed words.
"""
function naive_graph(raw_text::AbstractString)
    tokenized_words = WordTokenizers.tokenize(raw_text)
    build_labelled_graph(tokenized_words)
end


"""
    stem_graph(my_text)

Build graph from text (`AbstractString`) using lemmatized words. 

Stemming is performed with `Snowball.jl` stemmer. Default language is "portugese". 
"""
function stem_graph(raw_text::AbstractString; snowball_language::AbstractString = "portuguese")
    pt_stemmer = Snowball.Stemmer(snowball_language) # Snowball.stemmer_types()
    tokenized_words = WordTokenizers.tokenize(raw_text)
    tokenized_words_stem = map(x -> Snowball.stem(pt_stemmer,x),tokenized_words)
    build_labelled_graph(tokenized_words_stem)
end   


"""
    phrases_graph(my_text)

Build graph from text (`AbstractString`) using sentences as unique tokens. 
"""
function phrases_graph(raw_text::AbstractString)
    tokenized_sentences = [x for x in WordTokenizers.split_sentences(raw_text)]
    # Tokenize words within sentences
    # tokenized_sentences = [WordTokenizers.tokenize(x) for x in WordTokenizers.split_sentences(raw_text)]
    build_labelled_graph(tokenized_sentences)
end
 

"""
    udp_import_annotations(raw_text)

Gets anonnotated DataFrame by importing R::udpipe object created with udpipe::annonate. 

This function is used internally.
"""
function udp_import_annotations(raw_text::AbstractString)
    
    @rput raw_text
    
    udp_ann_robj = reval("""
    require(udpipe)
    udp_model_pt <- udpipe::udpipe_load_model(file = "corpora/portuguese-ud-2.1-20180111.udpipe")
    udp_pt_annotate <- as.data.frame(udpipe::udpipe_annotate(udp_model_pt,raw_text,tagger="default"))
    """)
    
    udp_pos_df = rcopy(udp_ann_robj)

    return udp_pos_df
end 


"""
    pos_graph(my_text)

Build POS Tagging from text (`AbstractString`) using R package udpipe. 

Currently, supports portuguese and english corpora. 
"""
function pos_graph(raw_text::AbstractString)
    
    udp_pos_df = udp_import_annotations(raw_text)
        build_labelled_graph(udp_pos_df.upos)

end


"""
    lemma_graph(my_text)

Build lemmatized graph from text (`AbstractString`) using R package udpipe. 

Currently, supports portuguese and english corpora. 
"""
function lemma_graph(raw_text::AbstractString)
    
    udp_pos_df = udp_import_annotations(raw_text)

    build_labelled_graph(udp_pos_df.lemma)

end


# Future: Edges weighted on cosien similarity
#function add_prop_edge_distance(mg)
#    for i in 1:nv(mg)
#        for j in 1:nv(mg) 
#            token_a , token_b = get_prop(mg,i,:token) , get_prop(mg,j,:token)
#            set_prop!(mg, i,j, :distance , cos_similarity(token_a,token_b))
#    end
#end
