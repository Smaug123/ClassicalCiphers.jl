function letters_only(text)
  # text: string; removes all non-alphabetic characters
  filter(x -> ('A' <= x <= 'Z' || 'a' <= x <= 'z'), text)
end

function rotateRight(arr, n)
  # implementation of the Mathematica function RotateRight - or you could try circshift()?
  ans = copy(arr)
  for i in 1:length(arr)
    ans[i] = arr[((2*length(ans)+i-n-1) % length(ans)) + 1]
  end
  ans
end

function rotateLeft(arr, n)
  # implementation of the Mathematica function RotateLeft
  ans = copy(arr)
  for i in 1:length(arr)
    ans[i] = arr[((i+n-1) % length(ans)) + 1]
  end
  ans
end

function rotateLeftStr(st::AbstractString, n)
  join(rotateLeft(split(st, ""), n), "")
end

function rotateRightStr(st::AbstractString, n)
  join(rotateRight(split(st, ""), n), "")
end

function splitBy(arr, func)
  # implementation of the Mathematica function SplitBy
  # splits the array into sublists so that each list has the same value of func
  # on its elements
  arrinternal = map(func, arr)
  currans = Vector{Integer}[[arr[1]]]
  for i in 2:length(arr)
    if arrinternal[i] != arrinternal[i-1]
      append!(currans, Vector{Integer}[[arr[i]]])
    else
      append!(currans[end], [arr[i]])
    end
  end
  currans
end

function get_trigram_fitnesses()
  # The quadgrams file we use is licensed MIT, as per
  # http://practicalcryptography.com/cryptanalysis/text-characterisation/quadgrams/#comment-2007984751
  f = open(joinpath(dirname(Base.source_path()), "english_trigrams.txt"))
  lines = readlines(f)
  dict = Dict{AbstractString, Integer}()

  for l in lines
    (ngram, fitness) = split(l)
    dict[ngram] = parse(Int32, fitness)
  end

  close(f)
  dict
end

trigram_fitnesses = get_trigram_fitnesses()

"""
Performs a trigram analysis on the input string, to determine how close it
is to English. That is, splits the input string into groups of three letters,
and assigns a score based on the frequency of the trigrams in true English.
"""
function string_fitness(input::AbstractString; alreadystripped=false)
  if !alreadystripped
    str = letters_only(input)
  else
    str = input
  end

  str = uppercase(str)

  ans = 0
  for i in 1:(length(str)-2)
    ans += get(trigram_fitnesses, str[i:i+2], 0)
  end

  log(ans/length(str))
end

"""
Finds the frequencies of all characters in the input string, returning a Dict
of 'a' => 4, for instance. Uppercase characters are considered distinct from lowercase.
"""
function frequencies(input)
  ans = Dict{Char, Integer}()
  for i in input
    if haskey(ans, i)
      ans[i] += 1
    else
      ans[i] = 0
    end
  end
  ans
end

"""
Finds the index of coincidence of the input string. Uppercase characters are considered to be
equal to their lowercase counterparts.
"""
function index_of_coincidence(input)
  freqs = frequencies(lowercase(letters_only(input)))
  len = length(lowercase(letters_only(input)))

  ans = 0
  for i in 'a':'z'
    ans += (x -> x*(x-1))(get(freqs, i, 0))
  end

  ans /= (len * (len-1) / 26)
end
