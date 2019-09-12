"""
Encrypts the given plaintext according to the Caesar cipher.
The key is given as an integer, being the offset of each character;
so encrypt_caesar("abc", 1) == "BCD".

Converts the input to uppercase.
"""
function encrypt_caesar(plaintext, key::T) where {T<:Integer}
  # plaintext: string; key: integer offset, so k=1 sends "a" to "b"
  key = ((key-1) % 26) + 1
  keystr = join([collect(Char(97+key):'z'); collect('a':Char(97+key-1))])
  encrypt_monoalphabetic(plaintext, keystr)
end

"""
Decrypts the given ciphertext according to the Caesar cipher.
The key is given as an integer, being the offset of each character;
so decrypt_caesar("abcd", 1) == "zabc".

Converts the input to lowercase.
"""
function decrypt_caesar(ciphertext, key::Integer)
  # ciphertext: string; key: integer offset, so k=1 decrypts "B" as "a"
  key = ((key-1) % 26) + 1
  lowercase(encrypt_caesar(ciphertext, 26-key))
end

"""
Cracks the given ciphertext according to the Caesar cipher.
Returns (plaintext, key::Integer), such that encrypt_caesar(plaintext, key)
would return ciphertext.

With cleverness=0, simply does the shift that maximises e's frequency.
With cleverness=1, maximises the string's total fitness.

Converts the input to lowercase.
"""
function crack_caesar(ciphertext; cleverness=1)
  texts = [(decrypt_caesar(ciphertext,key), key) for key in 0:25]
  if cleverness == 1
    texts = sort(texts, by=(x -> string_fitness(first(x))))
  else
    texts = sort(texts, by=(x -> length(collect(filter(i -> (i == 'e'), first(x))))))
  end
  texts[end]
end
