using ClassicalCiphers
using Base.Test

# docs examples

@test encrypt_affine("Hello, World!", 3, 4) == "ZQLLU, SUDLN!"
@test decrypt_affine("ZQLLU, SUDLN!", 3, 4) == "hello, world!" 
@test crack_affine("zqllu, sudln!") == ((3, 4), "hello, world!")

# Wikipedia examples

@test encrypt_affine("affine cipher", 5, 8) == "IHHWVC SWFRCP"
@test decrypt_affine("IHHWVC SWFRCP", 5, 8) == "affine cipher"

# Practical Cryptography

@test encrypt_affine("defend the east wall of the castle", 5, 7) == uppercase("wbgbuw yqb bhty nhkk zg yqb rhtykb")
@test decrypt_affine("wbgbuwyqbbhtynhkkzgyqbrhtykb", 5, 7) == "defendtheeastwallofthecastle"
@test crack_affine("wbgbuwyqbbhtynhkkzgyqbrhtykb") == ((5, 7), "defendtheeastwallofthecastle")

@test crack_affine("wbgbuwyqbbhtynhkkzgyqbrhtykb", mult=5) == ((5, 7), "defendtheeastwallofthecastle")
@test crack_affine("wbgbuwyqbbhtynhkkzgyqbrhtykb", add=7) == ((5, 7), "defendtheeastwallofthecastle")