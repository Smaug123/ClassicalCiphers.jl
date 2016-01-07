using ClassicalCiphers

tests = ["vigenere", "monoalphabetic", "solitaire",
		 "caesar", "portas", "affine", "hill"]

println("Running tests:")

for t in tests
    test_fn = "$t.jl"
    println(" * $test_fn")
    include(test_fn)
end
