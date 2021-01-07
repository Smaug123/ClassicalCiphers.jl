AbstractPair{F, S} = Union{Tuple{F, S}, Pair{F, S}}
parse_abstract_pair(P::AbstractPair) =
	P isa Tuple{Char, Char} ? Dict(reverse(Pair(P...))) : Dict(reverse(P))

"""
Converts the given key-string to a Playfair key square.

Parameter `replacement` is a pair, such as ('I', 'J') or 'I' => 'J', containing
the two letters which are combined. Only the first of these letters will
be present in the keysquare.
"""
function playfair_key_to_square(key::AbstractString, replacement::AbstractPair{Char, Char})
	# make the key replacement
	D = parse_abstract_pair(replacement)
	key = encrypt_monoalphabetic(key, D)
	# delete duplicates etc from key
	key_sanitised = union(uppercase(letters_only(key)))
	# construct key square
	remaining = filter(x -> (x != last(replacement) && !(in(x, key_sanitised))), 'A':'Z')
	# keysquare = reshape(collect(Iterators.flatten(vcat(key_sanitised, remaining))), 5, 5)
	keysquare = reshape(vcat(key_sanitised, remaining), 5, 5) # do we need to flatten? ^
    return permutedims(keysquare, (2, 1)) # transpose() is deprecated for higher dimensional arrays
end

function encrypt_playfair(plaintext, key::AbstractString; combined::AbstractPair{Char, Char} = ('I','J'))
	keysquare = playfair_key_to_square(key, combined)
	D = parse_abstract_pair(combined)
	# make combinations in plaintext
	plaintext_sanitised = encrypt_monoalphabetic(plaintext, D)

	return encrypt_playfair(plaintext_sanitised, keysquare, combined = combined)
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
function encrypt_playfair(plaintext, key::Array{Char, 2}; stripped::Bool = false, combined::AbstractPair{Char, Char} = ('I', 'J'))
	if !stripped
		if in(last(combined), key)
			error("Key must not contain symbol $(last(combined)), as it was specified to be combined.")
		end
		D = parse_abstract_pair(combined)
		plaintext_sanitised = uppercase(letters_only(plaintext))
		plaintext_sanitised = encrypt_monoalphabetic(plaintext_sanitised, D)
	else
		plaintext_sanitised = plaintext
	end

	# add X's as necessary to break up double letters
	if last(combined) != 'X'
		padding_char = 'X'
	else
		padding_char = first(combined)
	end
	if last(combined) != 'Z'
		backup_padding_char = 'Z'
	else
		backup_padding_char = first(combined)
	end

	i = 1
	while i < length(plaintext_sanitised)
        if plaintext_sanitised[i] == plaintext_sanitised[i + 1]
	      	if plaintext_sanitised[i] != padding_char
	      		plaintext_sanitised = plaintext_sanitised[1:i] * string(padding_char) * plaintext_sanitised[(i + 1):end]
	      	else
      			plaintext_sanitised = plaintext_sanitised[1:i] * string(backup_padding_char) * plaintext_sanitised[(i + 1):end]
      		end
      	end
      	i += 2
    end

    if isodd(length(plaintext_sanitised))
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
    	l2 = plaintext_sanitised[i + 1]

    	l1pos = CartesianIndices((5, 5))[findfirst(i -> i == l1, key)]
    	l2pos = CartesianIndices((5, 5))[findfirst(i -> i == l2, key)]

    	@assert l1pos != l2pos

    	if l1pos[1] == l2pos[1]
    		print(ans, key[l1pos[1], (((l1pos[2] + 1 - 1) % 5) + 1)])
    		print(ans, key[l2pos[1], (((l2pos[2] + 1 - 1) % 5) + 1)])
    	elseif l1pos[2] == l2pos[2]
    		print(ans, key[((l1pos[1] + 1 - 1) % 5) + 1, l1pos[2]])
    		print(ans, key[((l2pos[1] + 1 - 1) % 5) + 1, l2pos[2]])
    	else

    		print(ans, key[l1pos[1], l2pos[2]])
    		print(ans, key[l2pos[1], l1pos[2]])
    	end

    	i += 2
    end

    return String(take!(ans))
end


function decrypt_playfair(ciphertext, key::AbstractString; combined::AbstractPair{Char, Char} = ('I', 'J'))
	keysquare = playfair_key_to_square(key, combined)
	return decrypt_playfair(ciphertext, keysquare, combined = combined)
end

"""
Decrypts the given ciphertext according to the Playfair cipher.

Does not attempt to delete X's inserted as padding for double letters.
"""
function decrypt_playfair(ciphertext, key::Array{Char, 2}; combined::AbstractPair{Char, Char} = ('I', 'J'))
	# to obtain the decrypting keysquare, reverse every row and every column
	keysquare = rot180(key)
	return lowercase(encrypt_playfair(ciphertext, keysquare, combined = combined))
end
