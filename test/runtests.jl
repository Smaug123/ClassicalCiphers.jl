using ClassicalCiphers
using Test

tests = [
         "playfair",
         "vigenere",
         "monoalphabetic",
         "caesar",
         "portas",
         "affine",
         "enigma",
         "hill",
         "solitaire",
        ]

println("Running tests:")

for t in tests
    test_fn = "$t.jl"
    println(" * $test_fn")
    include(test_fn)
end
