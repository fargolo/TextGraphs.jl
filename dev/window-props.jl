"""
window_props(nwindow, graph_function, raw_text)

Calculate average properties from subsets of text.
"""
function window_props(nwindow,graph_function,raw_text)

    tokenized_words = WordTokenizers.punctuation_space_tokenize(lowercase(raw_text))
    text_arrays = [tokenized_words[i:(i+nwindow-1)] for i in 1:(length(tokenized_words) - nwindow+1)]
    text_array = map(x->join(x," "),text_arrays)
    graph_array = map(graph_function,text_array)
    
    prop_array = map(graph_props,graph_array)

    # Get average values from array of dicts.

end