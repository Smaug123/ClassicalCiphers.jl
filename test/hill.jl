using ClassicalCiphers
using Test

# Wikipedia examples

@test encrypt_hill("help!", [3 3; 2 5]) == "HIAT"
@test decrypt_hill("hiat", [3 3; 2 5]) == "help"

@test encrypt_hill("act", "GYBNQKURP") == "POH"
@test decrypt_hill("POH", "GYBNQKURP") == "act"
@test encrypt_hill("cat", "GYBNQKURP") == "FIN"
@test decrypt_hill("fin", "GYBNQKURP") == "cat"

# doc examples

@test encrypt_hill("Hello, World!", [1 2; 5 7]) == "PLHCGQWHRY"
@test encrypt_hill("Hello, World!", "bcfh") == "PLHCGQWHRY"
@test encrypt_hill("Hello", "bcfh") == "PLHCIX"
@test decrypt_hill("PLHCIX", "bcfh") == "hellox"
@test decrypt_hill("PLHCGQWHRY", [1 2; 5 7]) == "helloworld"
@test decrypt_hill("PLHCGQWHRY", "bcfh") == "helloworld"

# Practical Cryptography examples

@test encrypt_hill("att", [2 4 5; 9 2 1; 3 17 7]) == "PFO"

@test encrypt_hill("the gold is buried in orono", [5 17; 4 15]) == uppercase("gzscxnvcdjzxeovcrclsrc")
@test decrypt_hill("gzscxnvcdjzxeovcrclsrc", [5 17; 4 15]) == "thegoldisburiedinorono"