using ClassicalCiphers
using Base.Test

@test encrypt_caesar("THIS CODE WAS INVENTED BY JULIUS CAESAR", 3) == "WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU"

@test decrypt_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU", 3) == "this code was invented by julius caesar"

@test crack_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU") == ("this code was invented by julius caesar", 3)
