function next_solitaire(deckIn)
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

function keychar_from_deck(deck::Vector)
  # given a deck, returns an integer which is the Solitaire key value
  # output by that deck
  deck[((deck[1]==54 ? 53 : deck[1]) % length(deck)) + 1]
end

struct SolitaireKeyStream
  deck::Vector
end

function Base.iterate(b::SolitaireKeyStream)
  (next_solitaire(b.deck))
end

function Base.iterate(b::SolitaireKeyStream, state)
  print("hi2")
  curState = state
  print("hi")
  print(curState)
  while keychar_from_deck(curState) > 52
    print(curState)
    print("\n")
    curState = next_solitaire(curState)
  end
  (keychar_from_deck(curState), next_solitaire(curState))
end

"""
Encrypts the given plaintext according to the Solitaire cipher.
The key may be given either as a vector initial deck, where the cards are
1 through 54 (the two jokers being 53, 54), or as a string.
Schneier's keying algorithm is used to key the deck if the key is a string.
"""
function encrypt_solitaire(string, initialDeck::Vector)
  inp = uppercase(letters_only(string))
  ans = ""
  i = 0
  for keyval in SolitaireKeyStream(initialDeck)
    print(keyval)
    i += 1
    if i > length(inp)
      break
    end
    ans *= encrypt_caesar(inp[i], keyval)
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
  for keyval in SolitaireKeyStream(initialDeck)
    i += 1
    if i > length(inp)
      break
    end
    ans *= decrypt_caesar(inp[i], keyval)
  end
  return ans
end

function key_deck(key::AbstractString)
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

function encrypt_solitaire(string, key::AbstractString)
  encrypt_solitaire(string, key_deck(key))
end

function decrypt_solitaire(string, key::AbstractString)
  decrypt_solitaire(string, key_deck(key))
end
