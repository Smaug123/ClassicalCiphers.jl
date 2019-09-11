using ClassicalCiphers
using Test

@test encrypt_portas("DEFENDTHEEASTWALLOFTHECASTLE", "FORTIFICATION") == uppercase("synnjscvrnrlahutukucvryrlany")
@test decrypt_portas("synnjscvrnrlahutukucvryrlany", "FORTIFICATION") == lowercase("DEFENDTHEEASTWALLOFTHECASTLE")

@test decrypt_portas("synnjs cvr nrla hutu ku cvr yrlany!", "FORTIFICATION") == lowercase("DEFEND THE EAST WALL OF THE CASTLE!")

# doc tests

@test decrypt_portas("URYYB, JBEYQ!", "ab") == "hello, world!"
@test encrypt_portas("Hello, World!", "ab") == "URYYB, JBEYQ!"