"""
Encrypts the given plaintext with the Portas cipher.

The key must be given as a string, whose characters are letters.

Converts the text to uppercase.
"""
function encrypt_portas(plaintext, key_in::AbstractString)
  key = uppercase(letters_only(key_in))
  plaintext = uppercase(plaintext)
  keyarr = [div(Int(ch) - 65, 2) for ch in key]

  keycounter = 1
  ans = IOBuffer()

  for i in 1:length(plaintext)
  	if ('A' <= plaintext[i] <= 'Z')
      plainch = Int(plaintext[i]) # 68
      keych = keyarr[keycounter] # 4
      if 'Z' >= plaintext[i] >= 'M'
      	print(ans, Char(((plainch - 65 - keych + 13) % 13) + 65))
      else
      	print(ans, Char(((plainch - 65 + keych) % 13) + 65+13))
      end

      keycounter += 1
      if keycounter == length(key) + 1
      	keycounter = 1
      end
    else
      print(ans, plaintext[i])
    end
  end

  String(take!(ans))
end

"""
Decrypts the given ciphertext with the Portas cipher.

The key must be given as a string, whose characters are letters.

Converts the text to lowercase.
"""
function decrypt_portas(ciphertext, key::AbstractString)
	lowercase(encrypt_portas(ciphertext, key))
end