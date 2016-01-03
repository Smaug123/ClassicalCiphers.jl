function encrypt_monoalphabetic(plaintext, key::Dict)
  # plaintext: string; key: dictionary of {'a' => 'b'}, etc, for replacing 'a' with 'b'
  join([(i in keys(key) ? key[i] : i) for i in plaintext], "")
end

function decrypt_monoalphabetic(ciphertext, key::Dict)
  # ciphertext: string; key: dictionary of {'a' => 'b'}, etc, where the plaintext 'a' was
  # replaced by ciphertext 'b'. No character should appear more than once
  # as a value in {key}.
  encrypt_monoalphabetic(ciphertext, Dict{Char, Char}([reverse(a) for a in key]))
end

function encrypt_monoalphabetic(plaintext, key::AbstractString)
  # plaintext: string; key: string of length 26, first character is the image of 'a', etc
  # working in lowercase; key is assumed only to have each element appearing once
  # and to be in lowercase.
  dict = Dict{Char, Char}(map(x -> (x[1]+96, x[2]), enumerate(key)))
  encrypt_monoalphabetic(lowercase(plaintext), dict)
end

function decrypt_monoalphabetic(ciphertext, key::AbstractString)
  # ciphertext: string; key: string of length 26, first character is the image of 'a', etc
  # working in lowercase; key is assumed only to have each element appearing once
  # and to be in lowercase
  # so decrypt_monoalphabetic("cb", "cbade…") is "ab"
  dict = [(a => Char(96 + search(lowercase(key), a))) for a in lowercase(key)]
  encrypt_monoalphabetic(lowercase(ciphertext), dict)
end