function keystr_to_dict(keystr::AbstractString)
  Dict{Char, Char}(map(x -> (Char(x[1]+64), x[2]), enumerate(uppercase(keystr))))
end

"""
Encrypts the given plaintext according to the monoalphabetic substitution cipher.
The key may be given as a Dict of replacements {'a' => 'b', 'c' => 'd'}, etc,
or as a 26-length string "keystringbcdfhjlmopqruvwxz", which is shorthand for
{'a' => 'k', 'e' => 'b', …}

If the key is given as a string, it is assumed that each character occurs only
once, and the string is converted to lowercase.
If the key is given as a Dict, the only substitutions made are those in the Dict;
in particular, the string is not converted to lowercase automatically.
"""
function encrypt_monoalphabetic(plaintext, key::Dict)
  # plaintext: string; key: dictionary of {'a' => 'b'}, etc, for replacing 'a' with 'b'
  join([(i in keys(key) ? key[i] : i) for i in plaintext], "")
end

"""
Decrypts the given ciphertext according to the monoalphabetic substitution cipher.
The key may be given as a Dict of replacements {'a' => 'b', 'c' => 'd'}, etc,
or as a 26-length string "keystringbcdfhjlmopqruvwxz", which is shorthand for
{'a' => 'k', 'e' => 'b', …}

If the key is given as a string, it is assumed that each character occurs only
once, and the string is converted to lowercase.
If the key is given as a Dict, the only substitutions made are those in the Dict;
in particular, the string is not converted to lowercase automatically.
"""
function decrypt_monoalphabetic(ciphertext, key::Dict)
  # ciphertext: string; key: dictionary of {'a' => 'b'}, etc, where the plaintext 'a' was
  # replaced by ciphertext 'b'. No character should appear more than once
  # as a value in {key}.
  encrypt_monoalphabetic(ciphertext, Dict{Char, Char}([reverse(a) for a in key]))
end

function encrypt_monoalphabetic(plaintext, key::AbstractString)
  # plaintext: string; key: string of length 26, first character is the image of 'a', etc
  # working in lowercase; key is assumed only to have each element appearing once
  encrypt_monoalphabetic(uppercase(plaintext), keystr_to_dict(key))
end

function decrypt_monoalphabetic(ciphertext, key::AbstractString)
  # ciphertext: string; key: string of length 26, first character is the image of 'a', etc
  # working in lowercase; key is assumed only to have each element appearing once
  # and to be in lowercase
  # so decrypt_monoalphabetic("cb", "cbade…") is "ab"
  dict = Dict(a => Char(96 + search(lowercase(key), a)) for a in lowercase(key))
  encrypt_monoalphabetic(lowercase(ciphertext), dict)
end

# Cracking

# The method we use for cracking is simulated annealing.

"""
swap_two(string) swaps two of the characters of the input string, at random.
The characters are guaranteed to be at different positions, though "aa" would be
'swapped' to "aa".
"""
function swap_two(str)
  indices = rand(1:length(str), 2)
  while indices[1] == indices[2]
    indices = rand(1:length(str), 2)
  end

  join([i == indices[1] ? str[indices[2]] : (i == indices[2] ? str[indices[1]] : str[i]) for i in 1:length(str)], "")
end

"""
crack_monoalphabetic cracks the given ciphertext which was encrypted by the monoalphabetic
substitution cipher.

Returns (the derived key, decrypted plaintext).

Possible arguments include:
starting_key="", which when specified (for example, as "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
  starts the simulation at the given key. The default causes it to start with the most
  common characters being decrypted to the most common English characters.
min_temp=0.0001, which is the temperature at which we stop the simulation.
temp_factor=0.97, which is the factor by which the temperature decreases each step.
chatty=0, which can be set to 1 to print whenever the key is updated, or 2 to print
  whenever any new key is considered.
rounds=1, which sets the number of repetitions we perform. Each round starts with the
  best key we've found so far.
acceptance_prob=((e, ep, t) -> ep>e ? 1 : exp(-(e-ep)/t)), which is the probability
  with which we accept new key of fitness ep, given that the current key has fitness e,
  at temperature t.
"""
function crack_monoalphabetic(ciphertext; starting_key="",
                              min_temp=0.0001, temp_factor=0.97,
                              acceptance_prob=((e,ep,t) -> ep > e ? 1. : exp(-(e-ep)/t)),
                              chatty=0,
                              rounds=1)

  if starting_key == ""
  # most common letters
    commonest = "ETAOINSHRDLUMCYWFGBPVKZJXQ"
    freqs = frequencies(uppercase(letters_only(ciphertext)))
    for c in 'A':'Z'
      if !haskey(freqs, c)
        freqs[c] = 0
      end
    end

    freqs_input = sort(collect(freqs), by = tuple -> last(tuple), rev=true)
    start_key = fill('a', 26)
    for i in 1:26
      start_key[Int(commonest[i])-64] = freqs_input[i][1]
    end

    key = join(start_key, "")
  else
    key = starting_key
  end

  if chatty > 1
    println("Starting key: $(key)")
  end

  stripped_ciphertext = letters_only(ciphertext)
  fitness = string_fitness(decrypt_monoalphabetic(stripped_ciphertext, key))
  total_best_fitness = fitness
  total_best_key = key
  total_best_decrypt = decrypt_monoalphabetic(ciphertext, key)

  for roundcount in 1:rounds
    temp = 10^((roundcount-1)/rounds)
    while temp > min_temp
      for i in 1:round(Int, min(ceil(1/temp), 10))
        neighbour = swap_two(key)
        new_fitness = string_fitness(decrypt_monoalphabetic(stripped_ciphertext, neighbour), alreadystripped=true)
        if new_fitness > total_best_fitness
          total_best_fitness = new_fitness
          total_best_key = neighbour
          total_best_decrypt = decrypt_monoalphabetic(ciphertext, total_best_key)
        end

        threshold = rand()

        if chatty >= 2
          println("Current fitness: $(fitness)")
          println("New fitness: $(new_fitness)")
          println("Acceptance probability: $(acceptance_prob(fitness, new_fitness, temp))")
          println("Threshold: $(threshold)")
        end

        if acceptance_prob(fitness, new_fitness, temp) >= threshold
          if chatty >= 1
            println("$(key) -> $(neighbour), threshold $(threshold), temperature $(temp), fitness $(new_fitness), prob $(acceptance_prob(fitness, new_fitness, temp))")
          end
          fitness = new_fitness
          key = neighbour
        end
      end

      temp = temp * temp_factor

      if chatty >= 2
        println("----")
      end
    end

    key = total_best_key
    fitness = total_best_fitness
    temp = 1
  end

  if chatty >= 1
    println("Best was $(total_best_key) at $(total_best_fitness)")
    println(total_best_decrypt)
  end
  (decrypt_monoalphabetic(ciphertext, key), key)
end
