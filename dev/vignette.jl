using TextGraphs
using DataFrames, CSV


poems_df = CSV.read("dev/fernando_pessoa.csv",DataFrame) 
sentences = poems_df[4,"texto"]

autor_list = ["Ricardo Reis","Alberto Caeiro","Álvaro de Campos","Bernardo Soares"]
poems_filt_df = filter(row -> row.autor in autor_list,poems_df)

# To do:
## write for loop with print statement to check which text is returning an error
## fix de TextGraphs.jl function to verify input in order to avoid this
transc_lemma_graph_props = map(x->graph_props(naive_graph(x)),poems_df[!,"texto"])
lemma_props_df = vcat(DataFrame.(transc_lemma_graph_props)...)

