using ClassicalCiphers
using Base.Test

@test encrypt_solitaire("aaaaaaaaaaaaaaa", "") == lowercase("EXKYIZSGEHUNTIQ")
@test encrypt_solitaire("aaaaaaaaaaaaaaa", "f") == lowercase("XYIUQBMHKKJBEGY")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "fo") == lowercase("TUJYMBERLGXNDIW")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "foo") == lowercase("ITHZUJIWGRFARMW")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "a") == lowercase("XODALGSCULIQNSC")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "aa") == lowercase("OHGWMXXCAIMCIQP")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "aaa") == lowercase("DCSQYHBQZNGDRUT")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "b") == lowercase("XQEEMOITLZVDSQS")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "bc") == lowercase("QNGRKQIHCLGWSCE")
@test encrypt_solitaire("AAAAAAAAAAAAAAA", "bcd") == lowercase("FMUBYBMAXHNQXCJ")
@test encrypt_solitaire("AAAAAAAAAAAAAAAAAAAAAAAAA", "cryptonomicon") == lowercase("SUGSRSXSWQRMXOHIPBFPXARYQ")
@test encrypt_solitaire("SOLITAIREX", "cryptonomicon") == lowercase("KIRAKSFJAN")

@test decrypt_solitaire("EXKYI ZSGEH UNTIQ", "") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("XYIUQ BMHKK JBEGY ", "f") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("TUJYM BERLG XNDIW", "fo") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("ITHZU JIWGR FARMW ", "foo") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("XODAL GSCUL IQNSC ", "a") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("OHGWM XXCAI MCIQP ", "aa") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("DCSQY HBQZN GDRUT ", "aaa") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("XQEEM OITLZ VDSQS ", "b") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("QNGRK QIHCL GWSCE ", "bc") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("FMUBY BMAXH NQXCJ", "bcd") == "aaaaaaaaaaaaaaa"
@test decrypt_solitaire("SUGSR SXSWQ RMXOH IPBFP XARYQ", "cryptonomicon") == "aaaaaaaaaaaaaaaaaaaaaaaaa"
@test decrypt_solitaire("KIRAK SFJAN", "cryptonomicon") == "solitairex"
