using TextGraphs
using Test
using Graphs

@testset "TextGraphs.jl" begin
    english_sentence = "Colorless green ideas sleep furiously"
    pt_sentence = "No meio do caminho tinha uma pedra tinha uma pedra no meio do caminho"
    pt_double_sentence = "Aqui, temos duas frases separadas por pontuação. Essa é a frase de número dois."

    naive_g = TextGraphs.naive_graph(english_sentence)
    stem_g = TextGraphs.stem_graph(pt_sentence;snowball_language="portuguese")
    phrases_g = TextGraphs.phrases_graph(pt_double_sentence)

    @test (nv(naive_g),ne(naive_g)) == (5,4)
    @test (nv(stem_g),ne(stem_g)) == (8,9)
    @test (nv(phrases_g),ne(phrases_g)) == (2,1)

end
