construct_sub_dict(A, B) =
    Dict{eltype(A), eltype(B)}(a => b for (a, b) in zip(lowercase(A), lowercase(B))) # policy decision: all dictionaries are lowercase
Base.reverse(D::Dict{T, S}) where {T, S} =
    Dict{S, T}(reverse(p) for p in D)
something_crypt_substitution(text, sub_dict::Dict{T, S}) where {T, S} =
    S[get(sub_dict, c, c) for c in text]

@doc raw"""
Arguably the most simple of the classical ciphers, the substitution cipher works by creating an arbitrary substitution dictionary; e.g.,
```julia
'a' => 'x'
'b' => 'g'
'c' => 'l'
...
```
This dictionary then replaces every corresponding letter in the plaintext input with a different letter (as specified by the dictionary input.)

The function `encrypt_substitution` will either take this dictionary as its second parameter, _or_ it can construct the dictionary itself:
```julia
encrypt_substitution(plaintext, Dict(...))
encrypt_substitution(plaintext, "abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba") # this will create the dictionary 'a' => 'z', 'b' => 'y', ..., 'z' => 'a'
encrypt_substitution(plaintext, "zyxwvutsrqponmlkjihgfedcba") # this will create the dictionary 'a' => 'z', 'b' => 'y', ..., 'z' => 'a' by assuming the keys in the substitution dictionary
```

*All characters undefined in the dictionary are preserved by default; this includes punctionation and spaces.*

As per convention, the output will always be uppercase.

For more information, see https://en.wikipedia.org/wiki/Substitution_cipher.
"""
encrypt_substitution(plaintext, sub_dict::Dict{T, S}) where {T, S} =
    uppercase(join(something_crypt_substitution(lowercase(plaintext), sub_dict)))
encrypt_substitution(plaintext, A, B) =
    encrypt_substitution(plaintext, construct_sub_dict(A, B))
encrypt_substitution(plaintext, B) =
    encrypt_substitution(plaintext, "abcdefghijklmnopqrstuvwxyz", B)

@doc raw"""
Arguably the most simple of the classical ciphers, the substitution cipher works by creating an arbitrary substitution dictionary; e.g.,
```julia
'a' => 'x'
'b' => 'g'
'c' => 'l'
...
```
This dictionary then replaces every corresponding letter in the plaintext input with a different letter (as specified by the dictionary input.)

The function `decrypt_substitution` will either take this dictionary as its second parameter, _or_ it can construct the dictionary itself:
```julia
decrypt_substitution(ciphertext, Dict(...); reverse_dict = true)
decrypt_substitution(ciphertext, "abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba"; reverse_dict = true) # this will create the dictionary 'a' => 'z', 'b' => 'y', ..., 'z' => 'a'
decrypt_substitution(ciphertext, "zyxwvutsrqponmlkjihgfedcba"; reverse_dict = true) # this will create the dictionary 'a' => 'z', 'b' => 'y', ..., 'z' => 'a' by assuming the keys in the substitution dictionary
```

*All characters undefined in the dictionary are preserved by default; this includes punctionation and spaces.*

*If `reverse_dict` is set to true (as it is by default), the input dictionary is assumed to be the same used to _en_crypt, meaning it is reversed in order to _decrypt_ the ciphertext.*

As per convention, the output will always be lowercase.

For more information, see https://en.wikipedia.org/wiki/Substitution_cipher.
"""
function decrypt_substitution(ciphertext, sub_dict::Dict{T, S}; reverse_dict::Bool = true) where {T, S}
    sub_dict = reverse_dict ? reverse(sub_dict) : sub_dict
    return lowercase(join(something_crypt_substitution(lowercase(ciphertext), sub_dict)))
end
decrypt_substitution(ciphertext, A, B; reverse_dict::Bool = true) =
    decrypt_substitution(ciphertext, construct_sub_dict(A, B); reverse_dict = reverse_dict)
decrypt_substitution(ciphertext, B; reverse_dict::Bool = true) =
    decrypt_substitution(ciphertext, "abcdefghijklmnopqrstuvwxyz", B; reverse_dict = reverse_dict)

"""
```julia
encrypt_atbash(plaintext, alphabet)
```

A special case of the substitution cipher, the Atbash cipher substitutes a given alphabet with its reverse:
```julia
encrypt_atbash(plaintext, "abcdefghijklmnopqrstuvwxyz") == encrypt_substitution(plaintext, "abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba")
```

*Omitting the alphabet, it will assume you are using the English alphabet.*
"""
encrypt_atbash(plaintext, alphabet) =
    encrypt_substitution(plaintext, alphabet, reverse(alphabet))
encrypt_atbash(plaintext) =
    encrypt_atbash(plaintext, "abcdefghijklmnopqrstuvwxyz")

"""
```julia
decrypt_atbash(ciphertext, alphabet)
```

A special case of the substitution cipher, the Atbash cipher substitutes a given alphabet with its reverse:
```julia
decrypt_atbash(ciphertext, "abcdefghijklmnopqrstuvwxyz") == decrypt_substitution(ciphertext, "zyxwvutsrqponmlkjihgfedcba", "abcdefghijklmnopqrstuvwxyz")
decrypt_atbash(ciphertext, "abcdefghijklmnopqrstuvwxyz") == decrypt_substitution(ciphertext, "zyxwvutsrqponmlkjihgfedcba"; reverse_dict = true)
```

*Omitting the alphabet, it will assume you are using the English alphabet.*
"""
decrypt_atbash(ciphertext, alphabet) =
    decrypt_substitution(ciphertext, reverse(alphabet), alphabet)
decrypt_atbash(ciphertext) =
    decrypt_atbash(ciphertext, "abcdefghijklmnopqrstuvwxyz")
