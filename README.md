# adventofcode2023
My solutions for advent of code 2023

## day 01 - learning about graphemes

Thanks to gleam, which uses graphemes natively in the stdlib, I have a better understanding of the concept of graphemes. It is pretty cool that gleam has them as the default tool for processing "perceived" characters in the stdlib.

Languages I am used to (Python, Nim) can access graphemes as relatively unknown third party libraries:
- https://github.com/alvinlindstam/grapheme
- https://github.com/nitely/nim-graphemes

I see Rust has theme in a crate:
- https://crates.io/crates/unicode-segmentation

And Elm also has a nice 3rd party library:
- https://package.elm-lang.org/packages/BrianHicks/elm-string-graphemes/latest/

The standard reference for implementation is this Unicode annex: http://www.unicode.org/reports/tr29/

Gleam seems to indeed get this from Erlang: https://www.erlang.org/doc/man/string
(I see no mention of Unicode Annex 29 but it seems the implementation is the same).
In gleam source code:
- there is only mention of the js implementation that I can find:
https://github.com/gleam-lang/stdlib/blob/82559e94597d85da6064e11e6f3d8d776dbcbebc/src/gleam/string.gleam#L676
- I assuming erlang implementation is not needed since it will use the erlang function with the same name and it will be handled by the compiler directly
- js implementation uses Intl.segmenter from javascript: https://github.com/gleam-lang/stdlib/blob/82559e94597d85da6064e11e6f3d8d776dbcbebc/src/gleam_stdlib.mjs#L155
- and the relevant MDN does not seem to mention the unicode annex too: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Segmenter/Segmenter

See also `gl/src/graphemes.gleam` for a few examples in gleam.