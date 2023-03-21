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
    stem_g_labels = get_graph_labels(stem_g)

    @test naive_g_labels[4:5] == ["sleep","furiously"]
    @test stem_g_labels[4:5] == ["caminh","tinh"]

    naive_props = TextGraphs.graph_props(naive_g)
    map(x->round(x;digits=5),collect(values(naive_props)))
    @test isequal(map(x->round(x;digits=3),
            collect(values(naive_props))), [0.272, 1.0, 5.0, 0.2, 5.0, 0.0, 0.167,0.2])
    
    naive_erdos_props = TextGraphs.rand_erdos_props(naive_g;eval_method="ratio")
    
    @test isequal(round(naive_erdos_props["mean_between_centr"];digits=2), 0.04)
    
    pos_g = TextGraphs.pos_graph(pt_sentence;text_language="portuguese")
    pos_g_labels = get_graph_labels(pos_g)
    @test pos_g_labels[2:5] == ["ADP","DET","NOUN","VERB"] 

    lemma_g = TextGraphs.lemma_graph(pt_sentence;text_language="portuguese")
    lemma_g_labels = get_graph_labels(lemma_g)
    @test lemma_g_labels[2:9] == ["em","o","meio","de","caminho","ter","um","pedra"] 


    naive_window_props = TextGraphs.window_props(pt_sentence,5,1,naive_graph)
    @test isequal(map(x->round(x;digits=5),
    collect(values(naive_window_props))), [0.38842, 1.8, 3.6, 0.28667, 4.4, 0.0, 0.25,0.32883])

    lemma_window_props = TextGraphs.window_props_lemma(pt_sentence,5,1,"portuguese")
    @test isequal(map(x->round(x;digits=3),
    collect(values(naive_window_props))), [0.388, 1.8, 3.6, 0.287, 4.4, 0.0, 0.25,0.329])


end
