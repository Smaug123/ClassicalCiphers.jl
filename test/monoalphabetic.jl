using ClassicalCiphers
using Base.Test

@test encrypt_monoalphabetic("aBcbD", Dict{Char, Char}('a' => '5', 'B' => '@', 'b' => 'o', 'D' => 'D')) == "5@coD"

# when given a string second argument, it lowercases everything
@test encrypt_monoalphabetic("THIS CODE WAS INVENTED BY JULIUS CAESAR", "DEFGHIJKLMNOPQRSTUVWXYZABC") == "WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU"

@test decrypt_monoalphabetic("5@coD", Dict{Char, Char}('a' => '5', 'B' => '@', 'b' => 'o', 'D' => 'D')) == "aBcbD"

@test decrypt_monoalphabetic("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU", "DEFGHIJKLMNOPQRSTUVWXYZABC") == lowercase("THIS CODE WAS INVENTED BY JULIUS CAESAR")

@test encrypt_caesar("THIS CODE WAS INVENTED BY JULIUS CAESAR", 3) == "WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU"

@test decrypt_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU", 3) == lowercase("THIS CODE WAS INVENTED BY JULIUS CAESAR")
