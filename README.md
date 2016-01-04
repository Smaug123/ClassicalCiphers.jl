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


[Caesar]: https://en.wikipedia.org/wiki/Caesar_cipher
[Vigenère]: https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
[Monoalphabetic substitution]: https://en.wikipedia.org/wiki/Substitution_cipher
[Solitaire]: https://en.wikipedia.org/wiki/Solitaire_(cipher)
