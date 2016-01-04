"""
Encrypts the given string using the Vigenere cipher according to the given vector of offsets.
For example, encrypt_vigenere("ab", [0, 1]) returns "AC".
"""
function encrypt_vigenere(plaintext, key::Array)
  # plaintext: string; key: vector of integer offsets, so [0, 1] encrypts "ab" as "ac"

  ans = [encrypt_caesar(char, key[(i-1) % length(key)+1]) for (i, char) in enumerate(letters_only(plaintext))]
  join(ans, "")

end

"""
Decrypts the given string using the Vigenere cipher according to the given vector of offsets.
For example, decrypt_vigenere("ac", [0, 1]) returns "ab".
"""
function decrypt_vigenere(ciphertext, key::Array)
  # ciphertext: string; key: vector of integer offsets, so [0, 1] decrypts "ac" as "ab"
  lowercase(encrypt_vigenere(ciphertext, 26-key))
end

"""
Encrypts the given string using the Vigenere cipher according to the given keystring.
For example, encrypt_vigenere("ab", "ab") returns "AC".
"""
function encrypt_vigenere(ciphertext, key::AbstractString)
  # ciphertext: string; key: string, so "ab" encrypts "ab" as "AC"
  encrypt_vigenere(ciphertext, [Int(i)-97 for i in lowercase(letters_only(key))])
end

"""
Decrypts the given string using the Vigenere cipher according to the given keystring.
For example, decrypt_vigenere("ab", "ac") returns "ab".
"""
function decrypt_vigenere(plaintext, key::AbstractString)
  # plaintext: string; key: string, so "ab" decrypts "ac" as "ab"
  decrypt_vigenere(plaintext, [Int(i)-97 for i in lowercase(letters_only(key))])
end
