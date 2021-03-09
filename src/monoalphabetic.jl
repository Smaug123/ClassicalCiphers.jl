_keystr_to_dict(keystr::AbstractString) =
    Dict{Char, Char}(Char(i + 64) => c for (i, c) in enumerate(uppercase(keystr)))
_keystr_to_dict(A::AbstractString, B::AbstractString) =
    Dict{eltype(A), eltype(B)}(a => b for (a, b) in zip(uppercase(A), uppercase(B))) # policy decision: all dictionaries are uppercase

Base.reverse(D::Dict{T, S}) where {T, S} =
    Dict{S, T}(reverse(p) for p in D)
_monoalphabetic_substitution(text, sub_dict::Dict{T, S}) where {T, S} =
    S[get(sub_dict, c, c) for c in text]

# if using sub_dict directly, do not convert case
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

*All characters undefined in the dictionary are preserved by default; this includes punctionation, spaces, and cases.*  This means that, when using a dictionary, strings are not automatically converted into uppercase.

As per convention, the output will always be uppercase.

For more information, see [`https://en.wikipedia.org/wiki/Substitution_cipher`](https://en.wikipedia.org/wiki/Substitution_cipher).

---

### Examples

```julia
julia> encrypt_monoalphabetic("Hello, World!", "DEFGHIJKLMNOPQRSTUVWXYZABC")
"KHOOR, ZRUOG!"

julia> encrypt_monoalphabetic("aBcbDd", Dict{Char, Char}('a' => '5', 'B' => '@', 'b' => 'o'))
"5@coDd"

julia> encrypt_monoalphabetic("Hello, this is plaintext", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm")
"ITSSG, ZIOL OL HSQOFZTBZ"

julia> encrypt_monoalphabetic("Hello, this is plaintext", "qwertyuiopasdfghjklzxcvbnm")
"ITSSG, ZIOL OL HSQOFZTBZ"

julia> encrypt_monoalphabetic("xyz", Dict('x' => 'd', 'y' => 'e', 'z' => 't'))
"det"
```
"""
encrypt_monoalphabetic(plaintext, sub_dict::Dict{T, S}) where {T, S} =
    join(_monoalphabetic_substitution(plaintext, sub_dict))
encrypt_monoalphabetic(plaintext, A, B::AbstractString) =
    encrypt_monoalphabetic(uppercase(plaintext), _keystr_to_dict(A, B))
# Fall back on using english alphabet as keys
encrypt_monoalphabetic(plaintext, B::AbstractString) =
    encrypt_monoalphabetic(uppercase(plaintext), _keystr_to_dict(B))

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

*All characters undefined in the dictionary are preserved by default; this includes punctionation, spaces, and cases.*  This means that, when using a dictionary, strings are not automatically converted into lowercase.

*If `reverse_dict` is set to true (as it is by default), the input dictionary is assumed to be the same used to _en_crypt, meaning it is reversed in order to _decrypt_ the ciphertext.*

As per convention, the output will always be lowercase.

For more information, see [`https://en.wikipedia.org/wiki/Substitution_cipher`](https://en.wikipedia.org/wiki/Substitution_cipher).

---

### Examples

```julia
julia> decrypt_monoalphabetic("ITSSG, ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm", reverse_dict = true)
"hello, this is plaintext"

julia> decrypt_monoalphabetic("Khoor, Zruog!", "DEFGHIJKLMNOPQRSTUVWXYZABC")
"hello, world!"
```
"""
function decrypt_monoalphabetic(ciphertext, sub_dict::Dict{T, S}; reverse_dict::Bool = true) where {T, S}
    sub_dict = reverse_dict ? reverse(sub_dict) : sub_dict
    return join(_monoalphabetic_substitution(ciphertext, sub_dict))
end
decrypt_monoalphabetic(ciphertext, A, B; reverse_dict::Bool = true) =
    lowercase(decrypt_monoalphabetic(uppercase(ciphertext), _keystr_to_dict(A, B); reverse_dict = reverse_dict))
decrypt_monoalphabetic(ciphertext, B; reverse_dict::Bool = true) =
    lowercase(decrypt_monoalphabetic(uppercase(ciphertext), _keystr_to_dict(B); reverse_dict = reverse_dict))

# Cracking

# The method we use for cracking is simulated annealing.

"""
```julia
swap_two(str)
```

swap_two(string) swaps two of the characters of the input string, at random.
The characters are guaranteed to be at different positions, though "aa" would be
'swapped' to "aa".
"""
function swap_two(str)
    indices = rand(1:length(str), 2)
    while indices[1] == indices[2]
        indices = rand(1:length(str), 2)
    end

    return join(Char[i == indices[1] ? str[indices[2]] : (i == indices[2] ? str[indices[1]] : str[i]) for i in 1:length(str)])
end

"""
```julia
crack_monoalphabetic(
    ciphertext;
    starting_key::AbstractString = "",
    min_temp::AbstractFloat = 0.0001,
    temp_factor::AbstractFloat = 0.97,
    acceptance_prob::AbstractFloat = ((e,ep,t) -> ep > e ? 1. : exp(-(e-ep)/t)),
    chatty::Integer = 0,
    rounds::Integer = 1
)
```

crack_monoalphabetic cracks the given ciphertext which was encrypted by the monoalphabetic
substitution cipher.

Returns `(the derived key, decrypted plaintext)`.

The various optional arguments to `crack_monoalphabetic` are:
* `starting_key=""`, which when specified (for example, as "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
  starts the simulation at the given key. The default causes it to start with the most
  common characters being decrypted to the most common English characters.
* `min_temp=0.0001`, which is the temperature at which we stop the simulation.
* `temp_factor=0.97`, which is the factor by which the temperature decreases each step.
* `chatty=0`, which can be set to 1 to print whenever the key is updated, or 2 to print
  whenever any new key is considered.
* `rounds=1`, which sets the number of repetitions we perform. Each round starts with the
  best key we've found so far.
* `acceptance_prob=((e, ep, t) -> ep>e ? 1 : exp(-(e-ep)/t))`, which is the probability
  with which we accept new key of fitness ep, given that the current key has fitness e,
  at temperature t.

---

### Examples

```julia
julia> crack_monoalphabetic(str, chatty=0, rounds=10)
(decrypted_string, key)
```
"""
function crack_monoalphabetic(
    ciphertext;
    starting_key::AbstractString = string(),
    min_temp::Union{AbstractFloat, Integer} = 0.0001,
    temp_factor::Union{AbstractFloat, Integer} = 0.97,
    acceptance_prob::Function = ((e,ep,t) -> ep > e ? 1. : exp(-(e-ep)/t)),
    chatty::Integer = 0,
    rounds::Integer = 1
)

    if isempty(starting_key)
        # most common letters
        commonest = "ETAOINSHRDLUMCYWFGBPVKZJXQ"
        freqs = frequencies(uppercase(letters_only(ciphertext)))
        for c in 'A':'Z'
            if !haskey(freqs, c)
                freqs[c] = 0
            end
        end

        freqs_input = sort(collect(freqs), by = tuple -> last(tuple), rev = true)
        start_key = fill('a', 26)
        for i in 1:26
            start_key[Int(commonest[i]) - 64] = first(freqs_input[i])
        end

        key = join(start_key)
    else
        key = starting_key
    end
    
    if chatty > 1
        println("Starting key: $(key)")
    end

    stripped_ciphertext = letters_only(ciphertext)
    fitness = string_fitness(decrypt_monoalphabetic(stripped_ciphertext, key))
    total_best_fitness, total_best_key = fitness, key
    total_best_decrypt = decrypt_monoalphabetic(ciphertext, key)

    for roundcount in 1:rounds
        temp = 10^((roundcount - 1) / rounds)
        while temp > min_temp
            for i in 1:round(Int, min(ceil(1 / temp), 10))
                neighbour = swap_two(key)
                new_fitness = string_fitness(decrypt_monoalphabetic(stripped_ciphertext, neighbour), alreadystripped = true)
                if new_fitness > total_best_fitness
                    total_best_fitness = new_fitness
                    total_best_key = neighbour
                    total_best_decrypt = decrypt_monoalphabetic(ciphertext, total_best_key)
                end
                
                threshold = rand()

                if chatty >= 2
                    println("Current fitness: $(fitness)")
                    println("New fitness: $(new_fitness)")
                    println("Acceptance probability: $(acceptance_prob(fitness, new_fitness, temp))")
                    println("Threshold: $(threshold)")
                end

                if acceptance_prob(fitness, new_fitness, temp) >= threshold
                    if chatty >= 1
                        println("$(key) -> $(neighbour), threshold $(threshold), temperature $(temp), fitness $(new_fitness), prob $(acceptance_prob(fitness, new_fitness, temp))")
                    end
                    fitness = new_fitness
                    key = neighbour
                end
            end

            temp = temp * temp_factor

            if chatty >= 2
                println("----")
            end
        end

        key, fitness = total_best_key, total_best_fitness
        temp = 1
    end

    if chatty >= 1
        println("Best was $(total_best_key) at $(total_best_fitness)")
        println(total_best_decrypt)
    end
    
    return decrypt_monoalphabetic(ciphertext, key), key
end

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

---

### Examples

```julia
julia> encrypt_atbash("some text", "abcdefghijklmnopqrstuvwxyz")
"HLNV GVCG"

julia> decrypt_atbash("HLNV GVCG", "abcdefghijklmnopqrstuvwxyz")
"some text"
```
"""
decrypt_atbash(ciphertext, alphabet) =
    decrypt_substitution(ciphertext, reverse(alphabet), alphabet)
decrypt_atbash(ciphertext) =
    decrypt_atbash(ciphertext, "abcdefghijklmnopqrstuvwxyz")
