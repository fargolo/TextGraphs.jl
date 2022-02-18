using Graphs , MetaGraphs , SimpleWeightedGraphs
using Snowball , WordTokenizers

# Creates graph with edges between tokens which are consecutive in the original sequence
# If they appear twice or more, a loop is created.
function link_consecutive(tokens_list)
    unique_tokens = unique(tokens_list)
    g_lenght = length(unique_tokens) #g total size (nodes)
    g = DiGraph(g_lenght) # initialize
    
    for (cur_token,next_token) in zip(tokens_list[1:end-1],tokens_list[2:end])
    ind1 , ind2 = findfirst(x->x==cur_token,unique_tokens) ,
                        findfirst(x->x==next_token,unique_tokens)
    add_edge!(g, ind1, ind2)
    end
    return g
end   

# Takes a MetaGraph graph and unique tokens with length equal to the number of vertices
# Adds tokens as properties of vertices 
function add_prop_label_tokens(mg,unique_tokens)
    for (token_index,unique_token) in zip(collect(1:length(unique_tokens)),unique_tokens)
        set_prop!(mg,token_index,:token,unique_token)
    end
    return mg
end    

# Future: Edges weighted on cosien similarity
#function add_prop_edge_distance(mg)
#    for i in 1:nv(mg)
#        for j in 1:nv(mg) 
#            token_a , token_b = get_prop(mg,i,:token) , get_prop(mg,j,:token)
#            set_prop!(mg, i,j, :distance , cos_similarity(token_a,token_b))
#    end
#end

# Text to naive graphs 
function naive_graph(raw_text)
    tokenized_words = WordTokenizers.tokenize(raw_text)
    unique_tokens = unique(tokenized_words)    
    g = link_consecutive(tokenized_words)
    mg = MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end

# Texto to stem graphs
function stem_graph(raw_text)
    pt_stemmer = Snowball.Stemmer("portuguese") # Snowball.stemmer_types()
    tokenized_words = WordTokenizers.tokenize(raw_text)
    tokenized_words_stem = map(x -> Snowball.stem(pt_stemmer,x),tokenized_words)
    unique_tokens = unique(tokenized_words_stem)
    g = link_consecutive(tokenized_words_stem)
    mg = MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end   

# Future: Text to POS Graphs
#function pos_graph()
   # POS_TAGGING
#end

# New: Phrases graph
function phrases_graph(raw_text)
    tokenized_sentences = [x for x in WordTokenizers.split_sentences(raw_text)]
    # Tokenize words within sentences
    # tokenized_sentences = [WordTokenizers.tokenize(x) for x in WordTokenizers.split_sentences(raw_text)]
    unique_tokens = unique(tokenized_sentences) # Identical sentences are rare
    g = link_consecutive(tokenized_sentences)
    mg = MetaDiGraph(g)
    mg = add_prop_label_tokens(mg,unique_tokens)
    return mg
end
 