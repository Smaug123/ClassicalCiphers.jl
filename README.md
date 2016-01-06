[![Build Status](https://travis-ci.org/Smaug123/ClassicalCiphers.jl.svg?branch=master)](https://travis-ci.org/Smaug123/ClassicalCiphers.jl)

# ClassicalCiphers

## Main Features

Provides access to encryption and decryption of strings according to a variety of classical algorithms.
The Solitaire cipher is included for completeness, though it is perhaps not strictly classical.

## Currently Implemented

* [Caesar]
* [Monoalphabetic substitution]
* [Vigenère]
* [Portas]
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
# outputs "khoor, zruog!"
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

### Monoalphabetic cipher

Encrypt the text "Hello, World!" with the same Caesar cipher, but
viewed as a monoalphabetic substitution:

```julia
encrypt_monoalphabetic("Hello, World!", "DEFGHIJKLMNOPQRSTUVWXYZABC")
# outputs "KHOOR, ZRUOG!"
```

Decrypt the same text, this time demonstrating the dictionary capability:

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
# outputs (key, decrypted_string)
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
[Vigenère]: https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
[Monoalphabetic substitution]: https://en.wikipedia.org/wiki/Substitution_cipher
[Solitaire]: https://en.wikipedia.org/wiki/Solitaire_(cipher)
[Portas]: http://practicalcryptography.com/ciphers/porta-cipher/
