function letters_only(text::AbstractString)
    # text: string; removes all non-alphabetic characters
    return filter(x -> ('A' <= x <= 'Z' || 'a' <= x <= 'z'), text)
end

rotate_left(arr::AbstractVector, n::Integer) = circshift(arr, -n)
rotate_right(arr::AbstractVector, n::Integer) = circshift(arr, n)

function rotate_string(str::AbstractString, n::Integer)
    i = mod(n, length(str))
    return str[i+1:end] * str[1:i]
end

rotate_left(str::AbstractString, n::Integer) =
    rotate_string(str, n)
rotate_right(str::AbstractString, n::Integer) =
    rotate_string(str, -n)

function split_by(arr::AbstractVector, func::Function)
    # implementation of the Mathematica function split_by
    # splits the array into sublists so that each list has the same value of func
    # on its elements
    arrinternal = map(func, arr)
    currans = Vector{Integer}[[arr[1]]]
    for i in 2:length(arr)
        if arrinternal[i] != arrinternal[i - 1]
            append!(currans, Vector{Integer}[[arr[i]]])
        else
            append!(currans[end], [arr[i]])
        end
    end
    
    return currans
end

function get_trigram_fitnesses(datafile::AbstractString)
    # The quadgrams file we use is licensed MIT, as per
    # http://practicalcryptography.com/cryptanalysis/text-characterisation/quadgrams/#comment-2007984751
    dict = Dict{AbstractString, Int32}()
    
    open(datafile) do io
        while ! eof(io)
            (ngram, fitness) = split(readline(io))
            dict[ngram] = parse(Int32, fitness)
        end
    end
    
    return dict
end

trigram_fitnesses = get_trigram_fitnesses(joinpath(dirname(Base.source_path()), "english_trigrams.txt"))

"""
Performs a trigram analysis on the input string, to determine how close it
is to English. That is, splits the input string into groups of three letters,
and assigns a score based on the frequency of the trigrams in true English.
"""
function string_fitness(input::AbstractString; alreadystripped::Bool = false)
    if alreadystripped
        str = input
    else
        str = letters_only(input)
    end

    str = uppercase(str)

    ans = 0
    for i in 1:(length(str) - 2)
        ans += get(trigram_fitnesses, str[i:(i + 2)], 0)
    end

    return log(ans / length(str))
end

function _frequencies_internal(input::AbstractString)
    ans = Dict{Char, Int}()
    for c in input
        index = Base.ht_keyindex2!(ans, c)
        if index > 0
            @inbounds ans.vals[index] += 1
        else
            @inbounds Base._setindex!(ans, 0, c, -index)
        end
    end
    return ans
end

"""
```julia
frequencies(input::AbstractString)
```

Finds the frequencies of all characters in the input string, returning a `Dict`
of `'a' => 4`, for instance. Uppercase characters are considered distinct from lowercase.
"""
function frequencies(input::AbstractString)
    ans = Dict{Char, Int}()
    for c in input
        index = Base.ht_keyindex2!(ans, c)
        if index > 1
            @inbounds ans.vals[index] += 1
        else
            @inbounds Base._setindex!(ans, 1, c, -index)
        end
    end
    return ans
end

"""
```julia
index_of_coincidence(input::AbstractString)
```

Finds the index of coincidence of the input string. Uppercase characters are considered to be
equal to their lowercase counterparts.

See [issue 32](https://github.com/Smaug123/ClassicalCiphers.jl/issues/32) for an important note on this.
"""
function index_of_coincidence(input::AbstractString)
    freqs = _frequencies_internal(lowercase(letters_only(input)))
    len = length(lowercase(letters_only(input)))

    ans = 0
    for i in 'a':'z'
        ans += map(x -> x * (x - 1), get(freqs, i, 0))
    end

    return ans /= (len * (len - 1) / 26)
end
