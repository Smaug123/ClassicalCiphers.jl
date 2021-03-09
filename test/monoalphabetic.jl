# Patrick's tests:

@test encrypt_monoalphabetic("aBcbD", Dict{Char, Char}('a' => '5', 'B' => '@', 'b' => 'o', 'D' => 'D')) == "5@coD"

# when given a string second argument, it lowercases everything
@test encrypt_monoalphabetic("THIS CODE WAS INVENTED BY JULIUS CAESAR", "DEFGHIJKLMNOPQRSTUVWXYZABC") == "WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU"

@test decrypt_monoalphabetic("5@coD", Dict{Char, Char}('a' => '5', 'B' => '@', 'b' => 'o', 'D' => 'D')) == "aBcbD"

@test decrypt_monoalphabetic("WKLV FRGH ZDV LQYHQWHG EB MXOLXV FDHVDU", "DEFGHIJKLMNOPQRSTUVWXYZABC") == lowercase("THIS CODE WAS INVENTED BY JULIUS CAESAR")
    
    
# Jake's tests:
    
@test encrypt_monoalphabetic("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz") == "HELLO THIS IS PLAINTEXT"
@test encrypt_monoalphabetic("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz") == "HELLO THIS IS PLAINTEXT"
@test encrypt_monoalphabetic("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm") == "ITSSG ZIOL OL HSQOFZTBZ"
@test encrypt_monoalphabetic("hello this is plaintext", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") == "PCSSI EPHL HL JSKHYECUE"
@test encrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") == "HELLO THIS IS PLAINTEXT"
@test encrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") != encrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm")
@test encrypt_monoalphabetic("hello this is plaintext", Dict('n' => 'y','f' => 'n','w' => 'b','d' => 'm','e' => 'c','o' => 'i','h' => 'p','y' => 'f','i' => 'h','r' => 'd','t' => 'e','s' => 'l','j' => 'q','q' => 'a','k' => 'r','a' => 'k','c' => 'v','p' => 'j','m' => 'z','z' => 't','g' => 'o','x' => 'u','u' => 'g','l' => 's','v' => 'w','b' => 'x')) == "pcssi ephl hl jskhyecue"
@test encrypt_monoalphabetic("hello this is plaintext", Dict('n' => 'f','f' => 'y','w' => 'v','d' => 'r','e' => 't','o' => 'g','h' => 'i','j' => 'p','i' => 'o','k' => 'a','r' => 'k','s' => 'l','t' => 'z','q' => 'j','y' => 'n','a' => 'q','c' => 'e','p' => 'h','m' => 'd','z' => 'm','g' => 'u','v' => 'c','l' => 's','u' => 'x','x' => 'b','b' => 'w')) == "itssg ziol ol hsqofztbz"

@test decrypt_monoalphabetic("hello this is ciphertext", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz") == "hello this is ciphertext"
@test decrypt_monoalphabetic("hello this is ciphertext", "abcdefghijklmnopqrstuvwxyz") == "hello this is ciphertext"
@test decrypt_monoalphabetic("hello this is ciphertext", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = true) == "hello this is ciphertext"
@test decrypt_monoalphabetic("hello this is ciphertext", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") == "itssg ziol ol eohitkztbz"
@test decrypt_monoalphabetic("hello this is ciphertext", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = false) == "pcssi ephl hl vhjpcdecue"
@test decrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = false) == "ozllu mogs gs iljgymzwm"
@test decrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = true) == "hello this is plaintext"
@test decrypt_monoalphabetic("PCSSI EPHL HL JSKHYECUE", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = false) == "jvllh cjps ps qlrpfcvgc"
@test decrypt_monoalphabetic("PCSSI EPHL HL JSKHYECUE", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = true) == "hello this is plaintext"
@test decrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = false) != decrypt_monoalphabetic("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = true)

@test (
	RID = encrypt_monoalphabetic("hello there", "mnbvcxzlkjhgfdsapoiuytrewq");
	crack_monoalphabetic(RID) == ("gessi ngere", "INZYCDLPSFVKAUMJHOGRBTEQXW")
	crack_monoalphabetic("93ee90299") == ("93ee90299", "XQJFEPHRBLTNKDCWVGAZMSIYOU")
	)
