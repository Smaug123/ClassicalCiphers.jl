"""
Encrypts the given string using the Vigenere cipher according to the given vector of offsets.
For example, encrypt_vigenere("ab", [0, 1]) returns "AC".
"""
function encrypt_vigenere(plaintext, key::Array)
  # plaintext: string; key: vector of integer offsets, so [0, 1] encrypts "ab" as "ac"
  ans = [encrypt_caesar(chr, key[(i-1) % length(key)+1]) for (i, chr) in enumerate(letters_only(plaintext))]
  join(ans, "")
end

"""
Decrypts the given string using the Vigenere cipher according to the given vector of offsets.
For example, decrypt_vigenere("ac", [0, 1]) returns "ab".
"""
function decrypt_vigenere(ciphertext, key::Array)
  # ciphertext: string; key: vector of integer offsets, so [0, 1] decrypts "ac" as "ab"
  lowercase(encrypt_vigenere(ciphertext, 26-key))
end

"""
Encrypts the given string using the Vigenere cipher according to the given keystring.
For example, encrypt_vigenere("ab", "ab") returns "AC".
"""
function encrypt_vigenere(ciphertext, key::AbstractString)
  # ciphertext: string; key: string, so "ab" encrypts "ab" as "AC"
  encrypt_vigenere(ciphertext, [Int(i)-97 for i in lowercase(letters_only(key))])
end

"""
Decrypts the given string using the Vigenere cipher according to the given keystring.
For example, decrypt_vigenere("ab", "ac") returns "ab".
"""
function decrypt_vigenere(plaintext, key::AbstractString)
  # plaintext: string; key: string, so "ab" decrypts "ac" as "ab"
  decrypt_vigenere(plaintext, [Int(i)-97 for i in lowercase(letters_only(key))])
end

"""
Cracks the given text encrypted with the Vigenere cipher.

Returns (derived key, decrypted plaintext).

Optional parameters:
keylength=0: if the key length is known, specifying it may help the solver.
  If 0, the solver will attempt to derive the key length using the index
  of coincidence.
"""
function crack_vigenere(plaintext; keylength=0)
  stripped_text = letters_only(lowercase(plaintext))
  if keylength == 0
  	lens = sort(collect(2:15), by= len -> mean([index_of_coincidence(stripped_text[i:len:end]) for i in 1:len]))
    keylength = lens[end]
  end

  everyother = [stripped_text[i:keylength:end] for i in 1:keylength]
  decr = [crack_caesar(st)[1] for st in everyother]

  ans = IOBuffer()
  for column in 1:length(decr[1])
  	for j in 1:keylength
  	  if column <= length(decr[j])
  		  print(ans, decr[j][column])
  	  end
  	end
  end

  derived_key = join([Char(65+crack_caesar(st)[2]) for st in everyother], "")
  (derived_key, String(take!(ans)))

end
