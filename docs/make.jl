include(joinpath(dirname(@__DIR__), "src", "ClassicalCiphers.jl"))
using Documenter, .ClassicalCiphers

Documenter.makedocs(
    clean = true,
    doctest = true,
    modules = Module[ClassicalCiphers],
    repo = "",
    highlightsig = true,
    sitename = "ClassicalCiphers Documentation",
    expandfirst = [],
    pages = [
        "Home" => "index.md",
        "Usage" => "usage.md"
    ]
)

deploydocs(;
    repo  =  "github.com/Smaug123/ClassicalCiphers.jl.git",
)
