using TextGraphs
using Documenter

DocMeta.setdocmeta!(TextGraphs, :DocTestSetup, :(using TextGraphs); recursive=true)

makedocs(;
    modules=[TextGraphs],
    authors="fargolo <felipe.c.argolo@protonmail.com> and contributors",
    repo="https://github.com/fargolo/TextGraphs.jl/blob/{commit}{path}#{line}",
    sitename="TextGraphs.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://fargolo.github.io/TextGraphs.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Functions" => "intro.md",
	    "Readme" => "README.md"
    ],
)

deploydocs(;
    repo="github.com/fargolo/TextGraphs.jl",
    devbranch="main",
)
