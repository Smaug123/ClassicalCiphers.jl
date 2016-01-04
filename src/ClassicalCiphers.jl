module ClassicalCiphers

# Monoalphabetic

include("common.jl")
include("monoalphabetic.jl")
include("caesar.jl")
include("vigenere.jl")
include("solitaire.jl")

export encrypt_monoalphabetic, decrypt_monoalphabetic,
       encrypt_caesar, decrypt_caesar,
       encrypt_vigenere, decrypt_vigenere,
       encrypt_solitaire, decrypt_solitaire,
       string_fitness

end # module
