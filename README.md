[![Build Status](https://travis-ci.org/Smaug123/ClassicalCiphers.jl.svg?branch=master)](https://travis-ci.org/Smaug123/ClassicalCiphers.jl)

[![Coverage Status](https://coveralls.io/repos/Smaug123/ClassicalCiphers.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/Smaug123/ClassicalCiphers.jl?branch=master)

# ClassicalCiphers

## Main Features

Provides access to encryption and decryption of strings according to a variety of classical algorithms.
The Solitaire cipher is included for completeness, though it is perhaps not strictly classical.

## Currently Implemented

* [Caesar]
* [Affine]
* [Monoalphabetic substitution]
* [Vigenère]
* [Portas]
* [Hill]
* [Playfair]
* [Enigma (M3 Army)][Enigma]
* [Solitaire]

## Gotchas

In general, `encrypt` functions turn text upper-case, while `decrypt` functions
turn text lower-case.
This is consistent with convention, but may not be expected.

## Code samples

This is the last section of the readme. Nothing appears after this section.

### Caesar cipher

Encrypt the text "Hello, World!" with a Caesar offset of 3 (that is, sending
  'a' to 'd'):
```julia
encrypt_caesar("Hello, World!", 3)
# outputs "KHOOR, ZRUOG!"
```

Notice that `encrypt_caesar` turns everything upper-case, but retains symbols.

Decrypt the same text:
```julia
decrypt_caesar("Khoor, Zruog!", 3)
# outputs "hello, world!"
```

Likewise, `decrypt_caesar` turns everything lower-case, but retains symbols.

Automatically crack the same text:
```julia
crack_caesar("Khoor, Zruog!")
# outputs ("hello, world!", 3)
```

### Affine cipher

Encrypt the text "Hello, World!" with the function `x -> 3x+4`:

```julia
encrypt_affine("Hello, World!", 3, 4)
# outputs "ZQLLU, SUDLN!"
```

Notice that `encrypt_affine` turns everything upper-case, but retains symbols.
The multiplier is the second argument, and the additive constant is the third.

The multiplier must be coprime to 26, or an error is thrown.

Decrypt the same text:

```julia
decrypt_affine("ZQLLU, SUDLN!", 3, 4)
# outputs "hello, world!"
```

Crack the same text:

```julia
crack_affine("ZQLLU, SUDLN!")
# outputs ("hello, world!", (3, 4))
```

You can provide `mult=` or `add=` options to `crack_affine`, if they are known,
to help it out.

### Monoalphabetic cipher

Encrypt the text "Hello, World!" with the same Caesar cipher, but
viewed as a monoalphabetic substitution:

```julia
encrypt_monoalphabetic("Hello, World!", "DEFGHIJKLMNOPQRSTUVWXYZABC")
# outputs "KHOOR, ZRUOG!"
```

Decrypt the same text:

```julia
decrypt_monoalphabetic("Khoor, Zruog!", "DEFGHIJKLMNOPQRSTUVWXYZABC")
# outputs "hello, world!"
```

Encrypt using a Dict:

```julia
encrypt_monoalphabetic("aBcbDd", Dict{Char, Char}('a' => '5', 'B' => '@', 'b' => 'o'))
# outputs "5@coDd"
```

Notice that `encrypt_monoalphabetic` *does not* convert its input to uppercase
when a Dict key is supplied.
It simply makes all specified changes, and leaves the rest of the string unchanged.

Cracking a cipher:
```julia
crack_monoalphabetic(str, chatty=0, rounds=10)
# outputs (decrypted_string, key)
```

The various optional arguments to `crack_monoalphabetic` are:

* `starting_key=""`, which when specified (for example, as "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
  starts the simulation at the given key. The default causes it to start with the most
  common characters being decrypted to the most common English characters.
* `min_temp=0.0001`, which is the temperature at which we stop the simulation.
* `temp_factor=0.97`, which is the factor by which the temperature decreases each step.
* `chatty=0`, which can be set to 1 to print whenever the key is updated, or 2 to print
  whenever any new key is considered.
* `rounds=1`, which sets the number of repetitions we perform. Each round starts with the
  best key we've found so far.
* `acceptance_prob=((e, ep, t) -> ep>e ? 1 : exp(-(e-ep)/t))`, which is the probability
  with which we accept new key of fitness ep, given that the current key has fitness e,
  at temperature t.

The simulation is set up to start each round off at a successively lower temperature.

### Vigenère cipher

Encrypt the text "Hello, World!" with a Vigenère cipher of key "ab":

```julia
encrypt_vigenere("Hello, World!", "ab")
# outputs "HFLMOXOSLE"
```

Decrypt the same text with the offsets given as an array:

```julia
decrypt_vigenere("HFLMOXOSLE", [0, 1])
# outputs "helloworld"
```

Notice that the offset `0` corresponds to the key `a`.

Crack a text:

```julia
crack_vigenere(str)
```

This attempts to use the index of coincidence to find the keylength,
and then performs frequency analysis to derive the key.
It returns (key, decrypted text).

If the keylength is known, specifying it as `crack_vigenere(str, keylength=6)`
may aid decryption.

### Portas cipher

Encrypt the text "Hello, World!" with a Portas cipher of key "ab":

```julia
encrypt_portas("Hello, World!", "ab")
# outputs "URYYB, JBEYQ!"
```

Note that the input has been made uppercase, but symbols have been preserved.
The key is expected to be letters only; it is converted to uppercase and symbols
are stripped out before use.

Decrypt the same text:

```julia
decrypt_portas("URYYB, JBEYQ!", "ab") 
# outputs "hello, world!"
```

Notice that the input has been made lowercase.

### Hill cipher

Encrypt the text "Hello, World!" with a Hill key of matrix `[1 2; 5 7]`:

```julia
encrypt_hill("Hello, World!", [1 2; 5 7])
# outputs "PHHRGUWQRV"
```

Notice that the input has been made uppercase and symbols have been stripped out.

The key matrix must be invertible mod 26. That is, its determinant must be
coprime to 26.

Encrypt the same text with the same key, this time represented as a string:

```julia
encrypt_hill("Hello, World!", "bcfh")
# outputs "PLHCGQWHRY"
```

If the plaintext-length is not a multiple of the dimension of the key matrix,
it is padded with X:

```julia
encrypt_hill("Hello", "bcfh")
# outputs "PLHCIX"

decrypt_hill("PLHCIX", "bcfh")
# outputs "hellox"
```

Decrypt the text "PLHCGQWHRY" with key of `[1 2; 5 7]`:

```julia
decrypt_hill("PLHCGQWHRY", [1 2; 5 7])
# outputs "helloworld"
```

Do the same, but using the string representation of the key:

```julia
decrypt_hill("PLHCGQWHRY", "bcfh")
# outputs "helloworld"
```

### Playfair cipher

Encrypt the text "Hello, World!" with the Playfair cipher, key "playfair example":
```julia
encrypt_playfair("Hello, World!", "playfair example")
# outputs "DMYRANVQCRGE"
```

The key is converted to "PLAYFIREXM", removing duplicate letters and punctuation.
The padding character used to separate double letters, and to ensure the final
plaintext is of even length, is 'X'; the backup character is 'Z' (used for separating
consecutive 'X's).

Encrypt the same text using an explicitly specified keysquare:

```julia
arr = ['P' 'L' 'A' 'Y' 'F'; 'I' 'R' 'E' 'X' 'M'; 'B' 'C' 'D' 'G' 'H'; 'K' 'N' 'O' 'Q' 'S'; 'T' 'U' 'V' 'W' 'Z']
encrypt_playfair("Hello, World!", arr)
# outputs "DMYRANVQCRGE"
```

Note that the keysquare must be 25 letters, in a 5x5 array.

Optionally specify the two letters which are to be combined (default 'I','J'):

```julia
encrypt_playfair("IJXYZA", "PLAYFIREXM", combined=('I', 'J'))
# outputs "RMRMFWYE"
encrypt_playfair("IJXYZA", "PLAYFIREXM", combined=('X', 'Z'))
# outputs "BSGXEY"
```

In this case, the letters are combined in the plaintext, and then treated as one throughout.

Decrypt the same text:

```julia
decrypt_playfair("RMRMFWYE", "playfair example")
# outputs "ixixyzax"
```

The decrypting function does not attempt to delete padding letters.
Note that in the above example, the text originally encrypted was "IJXYZA";
the 'J' was transcribed as 'I', as specified by the default `combined=('I', 'J')`,
and then padding 'X's were introduced to ensure no digraph was a double letter.
Finally, an 'X' was appended to the string, to ensure that the string was not of odd
length.

### Enigma

The variant of Enigma implemented is the M3 Army version.
This has five possible rotors, of which three are chosen in some distinct order.

The plugboard may be specified either as a `Array{Tuple{Char, Char}}` or a string.
For example, both the following plugboards have the same effect:

```julia
"ABCDEF"
[('A', 'B'), ('C', 'D'), ('E', 'F')]
```

For no plugboard, use `Tuple{Char, Char}[]` or `""`.

The rotor order may be specified as `[5, 1, 2]` indicating that the leftmost rotor should be rotor 5, the middle should be rotor 1, and the rightmost should be rotor 2.
That is, when a letter goes into Enigma, it passes first through rotor 2, then rotor 1, then rotor 5.
(That is, letters move through the machine from right to left, before being reflected.)

The ring settings may be specified as a three-character string.
For example, `"AAA"` indicates no adjustment to the rings.
TODO: expand this.

The initial key may be specified as a three-character string.
For example, `"AQY"` indicates that the leftmost rotor should start at position `'A'`, the middle rotor at position `'Q'`, and the rightmost at position `'Y'`.

Three reflectors are given; they may be specified with `reflector_id='A'` or `'B'` or `'C'`.
Alternatively, specify `reflector_id="YRUHQSLDPXNGOKMIEBFZCWVJAT"` to use a custom reflector; this particular example happens to be reflector `'B'`, so is equivalent to `reflector_id='B'`.

For example, the following encrypts `"AAA"` with rotors 1, 2, 3, with key `"ABC"`, an empty plugboard, the default `'B'` reflector, and ring `"AAA"`:

```julia
encrypt_enigma("AAA", [1,2,3], "ABC")
# outputs "CXT"
```

This is synonymous with:

```julia
encrypt_enigma("AAA", [1,2,3], "ABC", ring="AAA", reflector_id='B', stecker="")
```

And also with:

```julia
encrypt_enigma("AAA", [1,2,3], "ABC", ring="AAA", reflector_id="YRUHQSLDPXNGOKMIEBFZCWVJAT", stecker="")
```

And also with:

```julia
encrypt_enigma("AAA", [1,2,3], "ABC", ring="AAA", reflector_id='B', stecker=Tuple{Char, Char}[])
```

The arguments to `decrypt_enigma` are identical.
(In fact, `decrypt_enigma` and `encrypt_enigma` are essentially the same function, because Enigma is reversible.)
As ever, `encrypt_enigma` uppercases its input, and `decrypt_enigma` lowercases it.


### Solitaire cipher

Encrypt the text "Hello, World!" with the Solitaire cipher, key "crypto":

```julia
encrypt_solitaire("Hello, World!", "crypto")
# outputs "GRNNQISRYA"
```

Decrypt text with an initial deck specified:

```julia
decrypt_solitaire("EXKYI ZSGEH UNTIQ", collect(1:54))
# outputs "aaaaaaaaaaaaaaa", as per https://www.schneier.com/code/sol-test.txt
```

[Caesar]: https://en.wikipedia.org/wiki/Caesar_cipher
[Affine]: https://en.wikipedia.org/wiki/Affine_cipher
[Vigenère]: https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
[Monoalphabetic substitution]: https://en.wikipedia.org/wiki/Substitution_cipher
[Solitaire]: https://en.wikipedia.org/wiki/Solitaire_(cipher)
[Portas]: http://practicalcryptography.com/ciphers/porta-cipher/
[Hill]: https://en.wikipedia.org/wiki/Hill_cipher
[Playfair]: https://en.wikipedia.org/wiki/Playfair_cipher
[Enigma]: https://en.wikipedia.org/wiki/Enigma_machine
