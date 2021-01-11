using ClassicalCiphers
using Test

@test encrypt_caesar("This code was not strictly invented by Julius Caesar, but it was reported by Roman historian Suetonius that Caesar used it, and hence the cipher was named.", 3) == "WKLV FRGH ZDV QRW VWULFWOB LQYHQWHG EB MXOLXV FDHVDU, EXW LW ZDV UHSRUWHG EB URPDQ KLVWRULDQ VXHWRQLXV WKDW FDHVDU XVHG LW, DQG KHQFH WKH FLSKHU ZDV QDPHG."
@test encrypt_caesar("The Caesar cipher was traditionally used by shifting each letter exactly three positions down.") == "WKH FDHVDU FLSKHU ZDV WUDGLWLRQDOOB XVHG EB VKLIWLQJ HDFK OHWWHU HADFWOB WKUHH SRVLWLRQV GRZQ."

@test decrypt_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU", 3) == "this code was invented by julius caesar"
@test decrypt_caesar("wkh fdhvdu flskhu zdv wudglwlrqdoob xvhg eb vkliwlqj hdfk ohwwhu hadfwob wkuhh srvlwlrqv grzq.") == "the caesar cipher was traditionally used by shifting each letter exactly three positions down."

@test crack_caesar("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU") == ("this code was invented by julius caesar", 3)

@test crack_caesar("there is nothing to fear") == ("there is nothing to fear", 0)

# Simon Singh's Cipher Challenge

@test (
	singh = "MHILY LZA ZBHL XBPZXBL MVYABUHL HWWPBZ JSHBKPBZ JHLJBZ KPJABT HYJHUBT LZA ULBAYVU";
	singh_ans = lowercase("FABER EST SUAE QUISQUE FORTUNAE APPIUS CLAUDIUS CAECUS DICTUM ARCANUM EST NEUTRON");
	crack_caesar(singh) == (singh_ans, 7))
