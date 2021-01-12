function construct_railfence(input, fence::AbstractArray, n_rails::Integer)
	rails = vcat(1:n_rails, (n_rails - 1):-1:2)

	for (i, letter) in enumerate(input)
		fence[rails[mod1(i, length(rails))], i] = letter
	end
	
	return fence
end

@doc raw"""
```julia
construct_railfence(input::AbstractString, n_rails::Integer)
construct_railfence(input::AbstractArray{T}, n_rails::Integer) where {T <: Number}
```

See [`https://en.wikipedia.org/wiki/Rail_fence_cipher`](https://en.wikipedia.org/wiki/Rail_fence_cipher).

---

### Examples

```julia
julia> construct_railfence("WE ARE DISCOVERED. FLEE AT ONCE", 3)
3×26 Array{Char,2}:
 'W'  '□'  '□'  '□'  'E'  '□'  '□'  '□'  'C'  '□'  '□'  '□'  'R'  …  '□'  '□'  'F'  '□'  '□'  '□'  'A'  '□'  '□'  '□'  'C'  '□'
 '□'  'E'  '□'  'R'  '□'  'D'  '□'  'S'  '□'  'O'  '□'  'E'  '□'     '□'  '.'  '□'  'L'  '□'  'E'  '□'  'T'  '□'  'N'  '□'  'E'
 '□'  '□'  'A'  '□'  '□'  '□'  'I'  '□'  '□'  '□'  'V'  '□'  '□'     'D'  '□'  '□'  '□'  'E'  '□'  '□'  '□'  'O'  '□'  '□'  '□'
```
"""
function construct_railfence(input::AbstractString, n_rails::Integer)
	input = uppercase(replace(input, " " => ""))
	# the square is my `UndefInitializer()` for `Char`.
	return construct_railfence(input, fill('□', n_rails, length(input)), n_rails)
end
function construct_railfence(input::AbstractArray{T}, n_rails::Integer) where {T <: Number}
	return construct_railfence(input, zeros(T, n_rails, length(input)), n_rails)
end

@doc raw"""
```julia
encrypt_railfence(input::AbstractString, n_rails::Integer)
```

See [`https://en.wikipedia.org/wiki/Rail_fence_cipher`](https://en.wikipedia.org/wiki/Rail_fence_cipher).

---

### Examples

```julia
julia> encrypt_railfence("WE ARE DISCOVERED. FLEE AT ONCE", 3) # this reads the above matrix row by row
"WECRFACERDSOEE.LETNEAIVDEO"
```
"""
function encrypt_railfence(input::AbstractString, n_rails::Integer)
	return join(Char[c for rail in eachrow(construct_railfence(input, n_rails)) for c in rail if c != '□'])
end

@doc raw"""
```julia
encrypt_railfence(input::AbstractString, n_rails::Integer)
```

See [`https://en.wikipedia.org/wiki/Rail_fence_cipher`](https://en.wikipedia.org/wiki/Rail_fence_cipher).

---

### Examples

```julia
julia> decrypt_railfence("WECRFACERDSOEE.LETNEAIVDEO", 3)
"wearediscovered.fleeatonce"
```
"""
function decrypt_railfence(input::AbstractString, n_rails::Integer)
	char_positions = Int[n for row in eachrow(construct_railfence(1:length(input), n_rails)) for n in row if n != 0]
	return lowercase(join(Char[input[findfirst(==(i), char_positions)] for i in 1:length(input)]))
end
