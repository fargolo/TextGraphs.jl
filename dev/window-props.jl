"""
window_props(nwindow, graph_function, raw_text)

Calculate average properties from subsets of text.
"""
function window_props(nwindow,graph_function,raw_text)

    tokenized_words = WordTokenizers.punctuation_space_tokenize(lowercase(raw_text))
    text_array = [tokenized_words[i:(i+nwindow)] for i in 1:(length(tokenized_words) - nwindow)]
    
    graph_array = map(graph_function,text_array)
    prop_array = map(graph_props,graph_array)

    # Get average values

end