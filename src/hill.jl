using LinearAlgebra

"""
Encrypts the given plaintext according to the Hill cipher.
The key may be given as a matrix (that is, two-dimensional Array{Int}) or as a string.

If the key is given as a string, the string is converted to uppercase before use, and
symbols are removed. It is assumed to be of square integer length, and the matrix entries
are filled top-left to top-right, then next-top left to next-top right, and so on down
to bottom-left to bottom-right. If the string is not of square integer length, an error
is thrown.

The matrix must be invertible modulo 26. If it is not, an error is thrown.
"""
function encrypt_hill(plaintext::AbstractString, key::AbstractArray{T, 2}) where {T<:Integer}
	if round(Integer, det(key)) % 26 == 0
		error("Key must be invertible mod 26.")
	end

	keysize = size(key, 1)
    text = uppercase(letters_only(plaintext))

	# split the plaintext up into that-size chunks

	# pad if necessary
    if length(text) % keysize != 0
    	text = text * ("X"^(keysize - (length(text) % keysize)))
    end
    chars = [Int(ch[1]) - 65 for ch in split(text, "")]
    # split
    split_text = reshape(chars, (keysize, div(length(text), keysize)))

    encrypted = mapslices(group -> 65 .+ ((key * group) .% 26), split_text, dims = [1])

    ans = IOBuffer()
    for group in encrypted
    	for x in group
    		print(ans, Char(x))
    	end
    end
    String(take!(ans))
end


function encrypt_hill(plaintext::AbstractString, key::AbstractString)

    if round(Integer, sqrt(length(key))) != sqrt(length(key))
    	error("Hill key must be of square integer size.")
    end

	matrix_dim = round(Integer, sqrt(length(key)))
	keys = map(x -> Int(x) - 65, collect(uppercase(letters_only(key))))

	key_matrix = reshape(keys, matrix_dim, matrix_dim)

	encrypt_hill(plaintext, transpose(key_matrix))
end

function minor(mat::AbstractArray{T, 2}, i, j) where {T<:Integer}
	d = det(mat[[1:i-1; i+1:end], [1:j-1; j+1:end]])
	round(Integer, d)
end

"""
Computes the adjugate matrix for given matrix.
"""
function adjugate(mat::AbstractArray{T, 2}) where {T<:Integer}
	arr = [(-1)^(i+j) * minor(mat, i, j) for (i, j) in Iterators.product(1:size(mat, 1), 1:size(mat, 2))]
	ans = reshape(arr, size(mat))
	Array{Integer, 2}(transpose(ans))
end

function decrypt_hill(ciphertext, key::AbstractArray{T, 2}) where {T<:Integer}
	if ndims(key) != 2
		error("Key must be a two-dimensional matrix.")
	end
	if round(Integer, det(key)) % 26 == 0
		error("Key must be invertible mod 26.")
	end

	# invert the input array mod 26
    inverse_mat = (adjugate(key) .% 26)
    inverse_mat = invmod(round(Integer, det(key)), 26) .* inverse_mat
    inverse_mat = inverse_mat .% 26
    inverse_mat = (inverse_mat .+ (26 * 26)) .% 26

    lowercase(encrypt_hill(ciphertext, inverse_mat))
end

function decrypt_hill(ciphertext, key::AbstractString)

	if round(Integer, sqrt(length(key))) != sqrt(length(key))
    	error("Hill key must be of square integer size.")
    end

	matrix_dim = round(Integer, sqrt(length(key)))
	keys = map(x -> Int(x) - 65, collect(uppercase(letters_only(key))))

	key_matrix = reshape(keys, matrix_dim, matrix_dim)

	decrypt_hill(ciphertext, transpose(key_matrix))
end