function encrypt_caesar(plaintext, key::Integer)
  # plaintext: string; key: integer offset, so k=1 sends "a" to "b"
  key = ((key-1) % 26) + 1
  encrypt_monoalphabetic(plaintext, join([collect(Char(97+key):'z'); collect('a':Char(97+key-1))]))
end

function decrypt_caesar(ciphertext, key::Integer)
  # ciphertext: string; key: integer offset, so k=1 decrypts "B" as "A"
  key = ((key-1) % 26) + 1
  encrypt_caesar(ciphertext, 26-key)
end