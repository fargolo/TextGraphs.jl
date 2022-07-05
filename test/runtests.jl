using TextGraphs
using Test
using Graphs , MetaGraphs 

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

    naive_g_labels = get_graph_labels(naive_g)
    stem_g_labels = get_graph_labels(stem_g_labels)

    @test naive_g_labels[4:5] == ["sleep","furiously"]
    @test stem_g_labels[4:5] == ["caminh","tinh"] 

    stem_props = TextGraphs.graph_props(stem_g)
    @test isequal(map(x->round(x;digits=5),
            collect(values(stem_props))), [0.27158, 7.0, 2.0, 0.16071, 0, 0.33929,0.33713])
    
    stem_erdos_props = TextGraphs.rand_erdos_ratio_props(stem_g;rnd_seed=123)
    @test isequal(map(x->round(x;digits=5),
        collect(values(stem_erdos_props))),[0.73644,0.42857,2.5,1.0,NaN,0.07018,0.62623])
    
    pos_g = TextGraphs.pos_graph(pt_sentence;text_language="portuguese")
    pos_g_labels = get_graph_labels(pos_g)
    @test pos_g_labels[2:5] == ["ADP","DET","NOUN","VERB"] 

    lemma_g = TextGraphs.lemma_graph(pt_sentence;text_language="portuguese")
    lemma_g_labels = get_graph_labels(lemma_g)
    @test lemma_g_labels[2:9] == ["em","o","meio","de","caminho","ter","um","pedra"] 

end
