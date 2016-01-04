using ClassicalCiphers
using Base.Test

# doc examples
@test encrypt_vigenere("ab", [0, 1]) == "AC"
@test decrypt_vigenere("ac", [0, 1]) == "ab"
@test encrypt_vigenere("ab", "ab") == "AC"
@test decrypt_vigenere("ac", "ab") == "ab"

# others

@test decrypt_vigenere("DYIMXMESTEZDPNFVVAMJ", [11, 18, 5, 13, 12, 9, 14]-1) == "theamericanshaverobb"

@test decrypt_vigenere("DYIMXMESTEZDPNFVVAMJ", "kremlin") == "theamericanshaverobb"

@test encrypt_vigenere("THEAMERICANSHAVEROBB", "kremlin") == "DYIMXMESTEZDPNFVVAMJ"
