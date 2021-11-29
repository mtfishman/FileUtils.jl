using FileUtils
using Documenter

DocMeta.setdocmeta!(FileUtils, :DocTestSetup, :(using FileUtils); recursive=true)

makedocs(;
    modules=[FileUtils],
    authors="Matthew Fishman <mfishman@flatironinstitute.org> and contributors",
    repo="https://github.com/mtfishman/FileUtils.jl/blob/{commit}{path}#{line}",
    sitename="FileUtils.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mtfishman.github.io/FileUtils.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mtfishman/FileUtils.jl",
    devbranch="main",
)
