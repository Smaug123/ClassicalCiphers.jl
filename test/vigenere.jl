using ClassicalCiphers
using Base.Test

# doc examples
@test encrypt_vigenere("ab", [0, 1]) == "ac"
@test decrypt_vigenere("ac", [0, 1]) == "ab"
@test encrypt_vigenere("ab", "ab") == "ac"
@test decrypt_vigenere("ac", "ab") == "ab"

# others

@test decrypt_vigenere("DYIMXMESTEZDPNFVVAMJ", [11, 18, 5, 13, 12, 9, 14]-1) == lowercase("THEAMERICANSHAVEROBB")

@test decrypt_vigenere("DYIMXMESTEZDPNFVVAMJ", "kremlin") == lowercase("THEAMERICANSHAVEROBB")

@test encrypt_vigenere("THEAMERICANSHAVEROBB", "kremlin") ==
                      lowercase("DYIMXMESTEZDPNFVVAMJ")