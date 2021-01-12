"""
```julia
encrypt_caesar(plaintext, key::Integer)
encrypt_caesar(plaintext)
```

Encrypts the given plaintext according to the Caesar cipher.
The key is given as an integer, being the offset of each character;
so `encrypt_caesar("abc", 1) == "BCD"`.

Converts the input to uppercase, but retains symbols.

Traditionally, the Caesar cipher was used with a shift of 3, so this is the method it will
fall back to if only given plaintext.

---

### Examples

```julia
julia> encrypt_caesar("Hello, World!", 3)
"KHOOR, ZRUOG!"
```
"""
function encrypt_caesar(plaintext, key::Integer)
    # plaintext: string; key: integer offset, so k=1 sends "a" to "b"
    key = ((key - 1) % 26) + 1
    keystr = join(vcat(collect(Char(97 + key):'z'), collect('a':Char(97 + key - 1))))
    return encrypt_monoalphabetic(plaintext, keystr)
end
encrypt_caesar(plaintext) = encrypt_caesar(plaintext, 3)

"""
```julia
decrypt_caesar(ciphertext, key::Integer)
decrypt_caesar(ciphertext)
```

Decrypts the given ciphertext according to the Caesar cipher.
The key is given as an integer, being the offset of each character;
so `decrypt_caesar("abcd", 1) == "zabc"`.

Converts the input to lowercase, but retains symbols.

Traditionally, the Caesar cipher was used with a shift of 3, so this is the method it will
fall back to if only given plaintext.
    
---

### Examples

```julia
julia> decrypt_caesar("Khoor, Zruog!", 3)
"hello, world!"
```
"""
function decrypt_caesar(ciphertext, key::Integer)
    # ciphertext: string; key: integer offset, so k=1 decrypts "B" as "a"
    key = ((key - 1) % 26) + 1
    return lowercase(encrypt_caesar(ciphertext, 26 - key))
end
decrypt_caesar(plaintext) = decrypt_caesar(plaintext, 3)

"""
```julia
crack_caesar(ciphertext; cleverness::Integer = 1)
```

Cracks the given ciphertext according to the Caesar cipher.
Returns `(plaintext, key::Integer)`, such that `encrypt_caesar(plaintext, key)`
would return ciphertext.

With `cleverness=0`, simply does the shift that maximises e's frequency.
With `cleverness=1`, maximises the string's total fitness.

Converts the input to lowercase.

---

### Examples

```julia
julia> crack_caesar("Khoor, Zruog!")
("hello, world!", 3)
```
"""
function crack_caesar(ciphertext; cleverness::Integer = 1)
    texts = Tuple{String, Int}[(decrypt_caesar(ciphertext,key), key) for key in 0:25]
    
    if cleverness == 1
        texts = sort(texts, by = (x -> string_fitness(first(x))))
    else
        texts = sort(texts, by = (x -> length(collect(filter(i -> (i == 'e'), first(x))))))
    end
    
    return last(texts)
end
