"""
    stem_graph(my_text)

Build graph from text (`AbstractString`) using lemmatized words. 

Stemming is performed with `Snowball.jl` stemmer. Default language is "english". 
"""
function stem_graph(raw_text::AbstractString; snowball_language::AbstractString = "english")
    snb_stemmer = Snowball.Stemmer(snowball_language) # Snowball.stemmer_types()
    tokenized_words = WordTokenizers.tokenize(raw_text)
    tokenized_words_stem = map(x -> Snowball.stem(snb_stemmer,x),tokenized_words)
    build_labelled_graph(tokenized_words_stem)
end   


"""
    udp_import_annotations(raw_text)

Get anonnotated DataFrame by importing R::udpipe object created with udpipe::annonate. 

This function is used internally.
"""
function udp_import_annotations(raw_text::AbstractString)
 
    cur_path = @__DIR__
    @rput raw_text cur_path
    
    udp_ann_robj = reval("""
    require(udpipe)
    file_path <-"/../corpora/udpipe/portuguese-ud-2.1-20180111.udpipe"
    udp_model_pt <- udpipe::udpipe_load_model(file = paste(cur_path,file_path,sep=""))
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

