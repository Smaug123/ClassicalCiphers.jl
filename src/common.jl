function letters_only(text)
  # text: string; removes all non-alphabetic characters
  filter(x -> ('A' <= x <= 'Z' || 'a' <= x <= 'z'), text)
end

function rotateRight(arr, n)
  # implementation of the Mathematica function RotateRight
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

flatten{T}(a::Array{T,1}) = any(map(x->isa(x,Array),a))? flatten(vcat(map(flatten,a)...)): a
flatten{T}(a::Array{T}) = reshape(a,prod(size(a)))
flatten(a)=a

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