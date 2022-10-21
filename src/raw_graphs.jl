"""
    naive_graph(raw_text::AbstractString)

Build graph from text (`AbstractString`) with unprocessed words.
"""
function naive_graph(raw_text::AbstractString)
    tokenized_words = WordTokenizers.tokenize.(WordTokenizers.split_sentences(sentences))...)
    build_labelled_graph(tokenized_words)
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
 
