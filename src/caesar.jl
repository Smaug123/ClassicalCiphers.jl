"""
Encrypts the given plaintext according to the Caesar cipher.
The key is given as an integer, being the offset of each character;
so encrypt_caesar("abc", 1) == "BCD".

Converts the input to uppercase.

Traditionally, the Caesar cipher was used with a shift of 3, so this is the method it will
fall back to if only given plaintext.
"""
function encrypt_caesar(plaintext, key::T) where {T <: Integer}
    # plaintext: string; key: integer offset, so k=1 sends "a" to "b"
    key = ((key - 1) % 26) + 1
    keystr = join(vcat(collect(Char(97 + key):'z'), collect('a':Char(97 + key - 1))))
    return encrypt_monoalphabetic(plaintext, keystr)
end
encrypt_caesar(plaintext) = encrypt_caesar(plaintext, 3)

"""
Decrypts the given ciphertext according to the Caesar cipher.
The key is given as an integer, being the offset of each character;
so decrypt_caesar("abcd", 1) == "zabc".

Converts the input to lowercase.

Traditionally, the Caesar cipher was used with a shift of 3, so this is the method it will
fall back to if only given plaintext.
"""
function decrypt_caesar(ciphertext, key::T) where {T <: Integer}
    # ciphertext: string; key: integer offset, so k=1 decrypts "B" as "a"
    key = ((key - 1) % 26) + 1
    return lowercase(encrypt_caesar(ciphertext, 26 - key))
end
decrypt_caesar(plaintext) = decrypt_caesar(plaintext, 3)

"""
Cracks the given ciphertext according to the Caesar cipher.
Returns (plaintext, key::Integer), such that encrypt_caesar(plaintext, key)
would return ciphertext.

With cleverness=0, simply does the shift that maximises e's frequency.
With cleverness=1, maximises the string's total fitness.

Converts the input to lowercase.
"""
function crack_caesar(ciphertext; cleverness::T = 1) where {T <: Integer}
    texts = Tuple{String, Int}[(decrypt_caesar(ciphertext,key), key) for key in 0:25]
    if cleverness == 1
        texts = sort(texts, by = (x -> string_fitness(first(x))))
    else
        texts = sort(texts, by = (x -> length(collect(filter(i -> (i == 'e'), first(x))))))
    end
    
    return texts[end]
end
