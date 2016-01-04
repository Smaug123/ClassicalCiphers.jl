[![Build Status](https://travis-ci.org/Smaug123/ClassicalCiphers.jl.svg?branch=master)](https://travis-ci.org/Smaug123/ClassicalCiphers.jl)

# ClassicalCiphers

## Main Features

Provides access to encryption and decryption of strings according to a variety of classical algorithms.
The Solitaire cipher is included for completeness, though it is perhaps not strictly classical.

## Currently Implemented

* [Caesar]
* [Monoalphabetic substitution]
* [Vigenère]
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
