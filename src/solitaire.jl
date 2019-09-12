function next_solitaire(deckIn::AbstractVector{T}) :: AbstractVector{Integer} where {T<:Integer}
  # performs one round of Solitaire on the given deck
# first joker
  deck = deckIn
  jokerPos = findfirst(i -> i == 53, deck)
  if jokerPos != length(deck)
    inter = deck[jokerPos+1]
    deck[jokerPos+1] = deck[jokerPos]
    deck[jokerPos] = inter
  else
    inter = deck[end]
    deck[end] = deck[1]
    deck[1] = inter
    deck = rotateRight(deck)
  end
# second joker
  jokerPos = findfirst(i -> i == 54, deck)
  if jokerPos <= length(deck) - 2
    inter = deck[jokerPos]
    deck[jokerPos] = deck[jokerPos+1]
    deck[jokerPos + 1] = deck[jokerPos + 2]
    deck[jokerPos + 2] = inter
  elseif jokerPos == length(deck) - 1
    inter = deck[length(deck)-1]
    inter1 = deck[length(deck)]
    deck[end] = deck[1]
    deck[length(deck)-1] = inter1
    deck[1] = inter
    deck = rotateRight(deck, 1)
  elseif jokerPos == length(deck)
    inter = deck[1]
    inter1 = deck[end]
    deck[1] = deck[2]
    deck[2] = inter1
    deck[end] = inter
    deck = rotateRight(deck,1)
  end
# triple-cut
  split_deck = splitBy(deck, x -> x > 52)
  if deck[1] > 52 && deck[end] > 52
    1
    # do nothing
  elseif deck[1] > 52
    split_deck = rotateRight(split_deck, 1)
  elseif deck[end] > 52
    split_deck = rotateLeft(split_deck, 1)
  else
    inter = split_deck[1]
    split_deck[1] = split_deck[end]
    split_deck[end] = inter
  end
  deck = collect(Iterators.flatten(split_deck))
# take bottom of deck and put it just above last card
  cardsToTake = (deck[end] > 52) ? 0 : deck[end]

  intermediate = rotateLeft(deck[1:length(deck)-1], cardsToTake)
  append!(intermediate, [deck[end]])
  deck = intermediate

  return collect(deck)
end

function keychar_from_deck(deck::AbstractVector{T}) :: Integer where {T<:Integer}
  # given a deck, returns an integer which is the Solitaire key value
  # output by that deck
  deck[((deck[1]==54 ? 53 : deck[1]) % length(deck)) + 1]
end

struct SolitaireKeyStreamStruct
  deck::AbstractVector{Integer}
end

function Base.iterate(b::SolitaireKeyStreamStruct)
  (0, next_solitaire(b.deck))
end

function Base.iterate(b::SolitaireKeyStreamStruct, state)
  curState = state::AbstractVector{Integer}
  while keychar_from_deck(curState) > 52
    curState = next_solitaire(curState)
  end
  (keychar_from_deck(curState)::Integer, next_solitaire(curState))
end

function SolitaireKeyStream(initialDeck::AbstractVector{T}) where {T<:Integer}
  Iterators.filter(i -> i <= 52, Iterators.drop(SolitaireKeyStreamStruct(initialDeck), 1))
end

"""
Encrypts the given plaintext according to the Solitaire cipher.
The key may be given either as a vector initial deck, where the cards are
1 through 54 (the two jokers being 53, 54), or as a string.
Schneier's keying algorithm is used to key the deck if the key is a string.
"""
function encrypt_solitaire(string, initialDeck::AbstractVector{T}) :: AbstractString where {T<:Integer}
  inp = uppercase(letters_only(string))
  ans = ""
  for (keyval::Integer, input::Char) in zip(SolitaireKeyStream(initialDeck), collect(inp))
    ans *= encrypt_caesar(input, keyval)
  end
  return ans
end

"""
Decrypts the given ciphertext according to the Solitaire cipher.
The key may be given either as a vector initial deck, where the cards are
1 through 54 (the two jokers being 53, 54), or as a string.
Schneier's keying algorithm is used to key the deck if the key is a string.
"""
function decrypt_solitaire(string, initialDeck::Vector)
  inp = uppercase(letters_only(string))
  ans = ""
  i = 0
  for (keyval, input) in zip(SolitaireKeyStream(initialDeck), collect(inp))
    ans *= decrypt_caesar(input, keyval)
  end
  return ans
end

function key_deck(key::AbstractString) :: AbstractVector{Integer}
  # returns the Solitaire deck after it has been keyed with the given string
  deck = collect(1:54)
  for keyval in uppercase(letters_only(key))
    deck = next_solitaire(deck)
    cardsToTake = Int(keyval)-64
    intermediate = rotateLeft(deck[1:length(deck)-1], cardsToTake)
    append!(intermediate, [deck[end]])
    deck = intermediate
  end
  deck
end

function encrypt_solitaire(string::AbstractString, key::AbstractString) :: AbstractString
  key = key_deck(key)
  encrypt_solitaire(string, key)
end

function decrypt_solitaire(string, key::AbstractString)
  decrypt_solitaire(string, key_deck(key))
end
