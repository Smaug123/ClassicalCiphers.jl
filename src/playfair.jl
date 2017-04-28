"""
Converts the given key-string to a Playfair key square.

Parameter `replacement` is a pair, such as ('I', 'J'), containing
the two letters which are combined. Only the first of these letters will
be present in the keysquare.
"""
function playfair_key_to_square(key::AbstractString, replacement)
	# make the key replacement
	key = encrypt_monoalphabetic(key, Dict(replacement[2] => replacement[1]))
	# delete duplicates etc from key
	key_sanitised = union(uppercase(letters_only(key)))
	# construct key square
	remaining = collect(filter(x -> (x != replacement[2] && findfirst(key_sanitised, x) == 0), 'A':'Z'))
	keysquare = reshape([key_sanitised; remaining], 5, 5)
    return permutedims(keysquare, (2, 1)) # transpose() is deprecated
end

function encrypt_playfair(plaintext, key::AbstractString; combined=('I','J'))
	keysquare = playfair_key_to_square(key, combined)

	# make combinations in plaintext
	plaintext_sanitised = encrypt_monoalphabetic(plaintext, Dict(combined[2] => combined[1]))

	encrypt_playfair(plaintext_sanitised, keysquare, combined=combined)
end

"""
Encrypts the given plaintext according to the Playfair cipher.
Throws an error if the second entry in the `combined` tuple is present in the key.

Optional parameters:

stripped=false. When set to true, encrypt_playfair skips
  converting the plaintext to uppercase, removing punctuation, and
  combining characters which are to be combined in the key.
combined=('I', 'J'), marks the characters which are to be combined in the text.
  Only the first of these two may be present in the output of encrypt_playfair.
"""
function encrypt_playfair(plaintext, key::Array{Char, 2}; stripped=false, combined=('I', 'J'))
	if !stripped
		if findfirst(key, combined[2]) != 0
			error("Key must not contain symbol $(combined[2]), as it was specified to be combined.")
		end
		plaintext_sanitised = uppercase(letters_only(plaintext))
		plaintext_sanitised = encrypt_monoalphabetic(plaintext_sanitised, Dict(combined[2] => combined[1]))
	else
		plaintext_sanitised = plaintext
	end

	# add X's as necessary to break up double letters
	if combined[2] != 'X'
		padding_char = 'X'
	else
		padding_char = combined[1]
	end
	if combined[2] != 'Z'
		backup_padding_char = 'Z'
	else
		backup_padding_char = combined[1]
	end

	i = 1
	while i < length(plaintext_sanitised)
      if plaintext_sanitised[i] == plaintext_sanitised[i+1]
      	if plaintext_sanitised[i] != padding_char
      		plaintext_sanitised = plaintext_sanitised[1:i] * string(padding_char) * plaintext_sanitised[i+1:end]
      	else
      		plaintext_sanitised = plaintext_sanitised[1:i] * string(backup_padding_char) * plaintext_sanitised[i+1:end]
      	end
      end
      i += 2
    end

    if length(plaintext_sanitised) % 2 == 1
    	if plaintext_sanitised[end] != padding_char
    		plaintext_sanitised = plaintext_sanitised * string(padding_char)
    	else
    		plaintext_sanitised = plaintext_sanitised * string(backup_padding_char)
    	end
    end

    # start encrypting!
    ans = IOBuffer()

    i = 1
    while i < length(plaintext_sanitised)
    	l1 = plaintext_sanitised[i]
    	l2 = plaintext_sanitised[i+1]

    	l1pos = ind2sub((5, 5), findfirst(key, l1))
    	l2pos = ind2sub((5, 5), findfirst(key, l2))

    	@assert l1pos != l2pos

    	if l1pos[1] == l2pos[1]
    		print(ans, key[l1pos[1], (((l1pos[2]+1 - 1) % 5) + 1)])
    		print(ans, key[l2pos[1], (((l2pos[2]+1 - 1) % 5) + 1)])
    	elseif l1pos[2] == l2pos[2]
    		print(ans, key[((l1pos[1]+1 - 1) % 5)+1, l1pos[2]])
    		print(ans, key[((l2pos[1]+1 - 1) % 5)+1, l2pos[2]])
    	else

    		print(ans, key[l1pos[1], l2pos[2]])
    		print(ans, key[l2pos[1], l1pos[2]])
    	end

    	i += 2
    end

    String(take!(ans))
end


function decrypt_playfair(ciphertext, key::AbstractString; combined=('I', 'J'))
	keysquare = playfair_key_to_square(key, combined)
	decrypt_playfair(ciphertext, keysquare, combined=combined)
end

"""
Decrypts the given ciphertext according to the Playfair cipher.

Does not attempt to delete X's inserted as padding for double letters.
"""
function decrypt_playfair(ciphertext, key::Array{Char, 2}; combined=('I', 'J'))
	# to obtain the decrypting keysquare, reverse every row and every column
	keysquare =	mapslices(reverse, key, 2)
	keysquare = permutedims(mapslices(reverse, permutedims(keysquare, (2, 1)), 2), (2, 1))
	lowercase(encrypt_playfair(ciphertext, keysquare, combined=combined))
end
