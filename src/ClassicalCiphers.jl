module ClassicalCiphers

# Monoalphabetic

include("common.jl")
include("monoalphabetic.jl")
include("caesar.jl")
include("vigenere.jl")
include("solitaire.jl")
include("portas.jl")
include("affine.jl")
include("hill.jl")
include("playfair.jl")

export encrypt_monoalphabetic, decrypt_monoalphabetic, crack_monoalphabetic,
       encrypt_caesar, decrypt_caesar, crack_caesar,
       encrypt_affine, decrypt_affine, crack_affine,
       encrypt_vigenere, decrypt_vigenere, crack_vigenere,
       encrypt_portas, decrypt_portas,
       encrypt_solitaire, decrypt_solitaire,
       encrypt_hill, decrypt_hill,
       encrypt_playfair, decrypt_playfair,
       string_fitness, index_of_coincidence

end # module
