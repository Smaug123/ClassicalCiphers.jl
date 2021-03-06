"""
```julia
encrypt_portas(plaintext, key_in::AbstractString)
```

Encrypts the given plaintext with the Portas cipher.

The key must be given as a string, whose characters are letters.

Converts the text to uppercase.

---

### Examples

```julia
julia> encrypt_portas("Hello, World!", "ab")
"URYYB, JBEYQ!"
```
"""
function encrypt_portas(plaintext, key_in::AbstractString)
	key = uppercase(letters_only(key_in))
	plaintext = uppercase(plaintext)
	keyarr = Int[div(Int(ch) - 65, 2) for ch in key]

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

	return String(take!(ans))
end

"""
```julia
decrypt_portas(ciphertext, key::AbstractString)
```

Decrypts the given ciphertext with the Portas cipher.

The key must be given as a string, whose characters are letters.

Converts the text to lowercase.

---

### Examples

```julia
julia> decrypt_portas("URYYB, JBEYQ!", "ab")
"hello, world!"
```
"""
function decrypt_portas(ciphertext, key::AbstractString)
	return lowercase(encrypt_portas(ciphertext, key))
end
