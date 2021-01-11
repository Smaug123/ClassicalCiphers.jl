using ClassicalCiphers
using Test

@test encrypt_substitution("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz") == "HELLO THIS IS PLAINTEXT"
@test encrypt_substitution("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz") == "HELLO THIS IS PLAINTEXT"
@test encrypt_substitution("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm") == "ITSSG ZIOL OL HSQOFZTBZ"
@test encrypt_substitution("hello this is plaintext", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") == "PCSSI EPHL HL JSKHYECUE"
@test encrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") == "HELLO THIS IS PLAINTEXT"
@test encrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") != encrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm")
@test encrypt_substitution("hello this is plaintext", Dict('n' => 'y','f' => 'n','w' => 'b','d' => 'm','e' => 'c','o' => 'i','h' => 'p','y' => 'f','i' => 'h','r' => 'd','t' => 'e','s' => 'l','j' => 'q','q' => 'a','k' => 'r','a' => 'k','c' => 'v','p' => 'j','m' => 'z','z' => 't','g' => 'o','x' => 'u','u' => 'g','l' => 's','v' => 'w','b' => 'x')) == "PCSSI EPHL HL JSKHYECUE"
@test encrypt_substitution("hello this is plaintext", Dict('n' => 'f','f' => 'y','w' => 'v','d' => 'r','e' => 't','o' => 'g','h' => 'i','j' => 'p','i' => 'o','k' => 'a','r' => 'k','s' => 'l','t' => 'z','q' => 'j','y' => 'n','a' => 'q','c' => 'e','p' => 'h','m' => 'd','z' => 'm','g' => 'u','v' => 'c','l' => 's','u' => 'x','x' => 'b','b' => 'w')) == "ITSSG ZIOL OL HSQOFZTBZ"

@test decrypt_substitution("hello this is ciphertext", "abcdefghijklmnopqrstuvwxyz", "abcdefghijklmnopqrstuvwxyz") == "hello this is ciphertext"
@test decrypt_substitution("hello this is ciphertext", "abcdefghijklmnopqrstuvwxyz") == "hello this is ciphertext"
@test decrypt_substitution("hello this is ciphertext", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = true) == "hello this is ciphertext"
@test decrypt_substitution("hello this is ciphertext", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz") == "pcssi ephl hl vhjpcdecue"
@test decrypt_substitution("hello this is ciphertext", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = false) == "itssg ziol ol eohitkztbz"
@test decrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = true) == "ozllu mogs gs iljgymzwm"
@test decrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = false) == "hello this is plaintext"
@test decrypt_substitution("PCSSI EPHL HL JSKHYECUE", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = true) == "jvllh cjps ps qlrpfcvgc"
@test decrypt_substitution("PCSSI EPHL HL JSKHYECUE", "qwertyuiopasdfghjklzxcvbnm", "abcdefghijklmnopqrstuvwxyz"; reverse_dict = false) == "hello this is plaintext"
@test decrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = false) != decrypt_substitution("ITSSG ZIOL OL HSQOFZTBZ", "abcdefghijklmnopqrstuvwxyz", "qwertyuiopasdfghjklzxcvbnm"; reverse_dict = true)




@test encrypt_atbash("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz") == "SVOOL GSRH RH KOZRMGVCG"
@test encrypt_atbash("hello this is plaintext") == "SVOOL GSRH RH KOZRMGVCG"
@test decrypt_atbash("SVOOL GSRH RH KOZRMGVCG", "abcdefghijklmnopqrstuvwxyz") == "hello this is plaintext"
@test decrypt_atbash("SVOOL GSRH RH KOZRMGVCG") == "hello this is plaintext"
@test encrypt_atbash("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz") == encrypt_substitution("hello this is plaintext", "abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba")
@test decrypt_atbash("SVOOL GSRH RH XRKSVIGVCG", "abcdefghijklmnopqrstuvwxyz") == decrypt_substitution("SVOOL GSRH RH XRKSVIGVCG", "zyxwvutsrqponmlkjihgfedcba", "abcdefghijklmnopqrstuvwxyz")
@test decrypt_atbash("SVOOL GSRH RH XRKSVIGVCG", "abcdefghijklmnopqrstuvwxyz") == decrypt_substitution("SVOOL GSRH RH XRKSVIGVCG", "zyxwvutsrqponmlkjihgfedcba"; reverse_dict = true)
