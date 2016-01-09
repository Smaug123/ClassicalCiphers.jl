using ClassicalCiphers
using Base.Test

@test encrypt_caesar("THIS CODE WAS INVENTED BY JULIUS CAESAR", 3) == "WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU"

@test decrypt_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU", 3) == "this code was invented by julius caesar"

@test crack_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU") == ("this code was invented by julius caesar", 3)

@test crack_caesar("there is nothing to fear") == ("there is nothing to fear", 0)

# Simon Singh's Cipher Challenge

@test (
	singh = "MHILY LZA ZBHL XBPZXBL MVYABUHL HWWPBZ JSHBKPBZ JHLJBZ KPJABT HYJHUBT LZA ULBAYVU";
	singh_ans = lowercase("FABER EST SUAE QUISQUE FORTUNAE APPIUS CLAUDIUS CAECUS DICTUM ARCANUM EST NEUTRON");
	crack_caesar(singh) == (singh_ans, 7))