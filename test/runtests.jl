include(joinpath(dirname(@__DIR__), "src", "ClassicalCiphers.jl")); using .ClassicalCiphers
using Test

tests = [
         "common",
         "playfair",
         "vigenere",
         "monoalphabetic",
         "caesar",
         "portas",
         "affine",
         "enigma",
         "hill",
         "solitaire",
         "railfence",
        ]

println("Running tests:")

for t in tests
    test_fn = "$t.jl"
    println(" * $test_fn")
    include(test_fn)
end
