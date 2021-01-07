# using ClassicalCiphers
# using Test

@test encrypt_railfence("WE ARE DISCOVERED. FLEE AT ONCE", 3) == "WECRFACERDSOEE.LETNEAIVDEO"
@test decrypt_railfence("WECRFACERDSOEE.LETNEAIVDEO", 3) == "wearediscovered.fleeatonce"
@test encrypt_railfence("Julia is strong", 10) == "JULIAISGSNTOR"
@test decrypt_railfence("JULIAISGSNTOR", 10) == "juliaisstrong"
@test encrypt_railfence("This is not a very strong cipher, but indeed it is classical", 2) == "TIINTVRSRNCPE,UIDEIICASCLHSSOAEYTOGIHRBTNEDTSLSIA"
@test decrypt_railfence("TIINTVRSRNCPE,UIDEIICASCLHSSOAEYTOGIHRBTNEDTSLSIA", 2) == "thisisnotaverystrongcipher,butindeeditisclassical"
@test construct_railfence("WE ARE DISCOVERED. FLEE AT ONCE", 3) == ['W' '□' '□' '□' 'E' '□' '□' '□' 'C' '□' '□' '□' 'R' '□' '□' '□' 'F' '□' '□' '□' 'A' '□' '□' '□' 'C' '□'; '□' 'E' '□' 'R' '□' 'D' '□' 'S' '□' 'O' '□' 'E' '□' 'E' '□' '.' '□' 'L' '□' 'E' '□' 'T' '□' 'N' '□' 'E'; '□' '□' 'A' '□' '□' '□' 'I' '□' '□' '□' 'V' '□' '□' '□' 'D' '□' '□' '□' 'E' '□' '□' '□' 'O' '□' '□' '□']
