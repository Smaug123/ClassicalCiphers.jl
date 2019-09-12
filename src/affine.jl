"""
Encrypts the given plaintext according to the Affine cipher.
The key is given as a pair of integers: first the multiplier, then
the additive constant.

The multiplier must be coprime to 26. If it is not, an error is thrown.

Converts the input to uppercase, but retains symbols.

Optional argument: offset=0, which specifies what number 'a' should be
considered as.
"""
function encrypt_affine(plaintext, mult::Integer, add::Integer; offset=0)
	if mult % 2 == 0 || mult % 13 == 0
		error("Multiplier must be coprime to 26.")
	end

	keystr = join([Char(((mult*i + add) % 26) + 97 - offset) for i in offset:25+offset], "")
    encrypt_monoalphabetic(plaintext, keystr)
end

"""
Decrypts the given ciphertext according to the Affine cipher.
The key is given as a pair of integers: first the multiplier, then
the additive constant.

The multiplier must be coprime to 26. If it is not, an error is thrown.

Converts the input to lowercase, but retains symbols.

Optional argument: offset=0, which specifies what number 'a' should be
considered as.
"""
function decrypt_affine(ciphertext, mult::Integer, add::Integer; offset=0)
	if mult % 2 == 0 || mult % 13 == 0
		error("Multiplier must be coprime to 26.")
	end

	keystr = join([Char(((mult*i + add) % 26) + 97 - offset) for i in offset:25+offset], "")
	decrypt_monoalphabetic(ciphertext, keystr)
end

function max_by(arr, f)
	currMax = undef
	currAns = undef
	set = false
	for i in arr
		if set == false
			set = true
			currMax = f(i)
			currAns = i
		else
			t = f(i)
			if currMax < t
				currMax = t
				currAns = i
			end
		end
	end
	currAns
end

"""
Cracks the given ciphertext according to the Affine cipher.
Returns ((multiplier, additive constant), decrypted string).

Converts the input to lowercase, but retains symbols.

Optional arguments: mult=0, which specifies the multiplier if known;
add=-1, which specifies the additive constant if known.
"""
function crack_affine(ciphertext::AbstractString; mult=0, add=-1)
	mults = mult != 0 ? [mult] : [i for i in filter(x -> (x % 2 != 0 && x % 13 != 0), 1:25)]
	adds = add != -1 ? [add] : (0:25)

	possible_keys = Iterators.product(mults, adds)

	reverse(max_by([(i, decrypt_affine(ciphertext, i[1], i[2])) for i in possible_keys], x -> string_fitness(x[2])))
end