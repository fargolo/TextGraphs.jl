using DataFrames , CSV 

# Read data
poems_df = CSV.read("dev/fernando_pessoa.csv",DataFrame) 
# Filter poems 4 most common pseudonyms
autor_list = ["Ricardo Reis","Alberto Caeiro","Álvaro de Campos","Bernardo Soares"]
poems_filt_df = filter(x -> x.autor in autor_list && x.tipo == "poesia",poems_df)
