"""
Encrypts the given plaintext according to the monoalphabetic substitution cipher.
The key may be given as a Dict of replacements {'a' => 'b', 'c' => 'd'}, etc,
or as a 26-length string "keystringbcdfhjlmopqruvwxz", which is shorthand for
{'a' => 'k', 'e' => 'b', …}

If the key is given as a string, it is assumed that each character occurs only
once, and the string is converted to lowercase.
If the key is given as a Dict, the only substitutions made are those in the Dict;
in particular, the string is not converted to lowercase automatically.
"""
function encrypt_monoalphabetic(plaintext, key::Dict)
  # plaintext: string; key: dictionary of {'a' => 'b'}, etc, for replacing 'a' with 'b'
  join([(i in keys(key) ? key[i] : i) for i in plaintext], "")
end

"""
Decrypts the given ciphertext according to the monoalphabetic substitution cipher.
The key may be given as a Dict of replacements {'a' => 'b', 'c' => 'd'}, etc,
or as a 26-length string "keystringbcdfhjlmopqruvwxz", which is shorthand for
{'a' => 'k', 'e' => 'b', …}

If the key is given as a string, it is assumed that each character occurs only
once, and the string is converted to lowercase.
If the key is given as a Dict, the only substitutions made are those in the Dict;
in particular, the string is not converted to lowercase automatically.
"""
function decrypt_monoalphabetic(ciphertext, key::Dict)
  # ciphertext: string; key: dictionary of {'a' => 'b'}, etc, where the plaintext 'a' was
  # replaced by ciphertext 'b'. No character should appear more than once
  # as a value in {key}.
  encrypt_monoalphabetic(ciphertext, Dict{Char, Char}([reverse(a) for a in key]))
end

function encrypt_monoalphabetic(plaintext, key::AbstractString)
  # plaintext: string; key: string of length 26, first character is the image of 'a', etc
  # working in lowercase; key is assumed only to have each element appearing once
  dict = Dict{Char, Char}(map(x -> (x[1]+64, x[2]), enumerate(uppercase(key))))
  encrypt_monoalphabetic(uppercase(plaintext), dict)
end

function decrypt_monoalphabetic(ciphertext, key::AbstractString)
  # ciphertext: string; key: string of length 26, first character is the image of 'a', etc
  # working in lowercase; key is assumed only to have each element appearing once
  # and to be in lowercase
  # so decrypt_monoalphabetic("cb", "cbade…") is "ab"
  dict = [(a => Char(96 + search(lowercase(key), a))) for a in lowercase(key)]
  encrypt_monoalphabetic(lowercase(ciphertext), dict)
end
