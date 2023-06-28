<div align="center">

# DeprecateKeywords.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://astroautomata.com/DeprecateKeywords.jl/dev/)
[![Build Status](https://github.com/MilesCranmer/DeprecateKeywords.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/MilesCranmer/DeprecateKeywords.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://coveralls.io/repos/github/MilesCranmer/DeprecateKeywords.jl/badge.svg?branch=master)](https://coveralls.io/github/MilesCranmer/DeprecateKeywords.jl?branch=master)

</div>
  
DeprecateKeywords defines a macro for keyword deprecation. For example,
let's say we wish to deprecate the keyword `old_kw1` in favor of `new_kw1`, and
likewise for `old_kw2`.

```julia
using DeprecateKeywords

@depkws function foo(;
    new_kw1=2,
    new_kw2=3,
    @deprecate(old_kw1, new_kw1),
    @deprecate(old_kw2, new_kw2)
)
    new_kw1 + new_kw2
end
```

With this, we can use both the old and new keywords.
If using the old keyword, it will automatically be passed to the new keyword, but with a deprecation warning.

```julia
julia> foo(new_kw1=1, new_kw2=2)
3

julia> foo(old_kw1=1, new_kw2=2)
┌ Warning: Keyword argument `old_kw1` is deprecated. Use `new_kw1` instead.
│   caller = top-level scope at REPL[5]:1
└ @ Core REPL[5]:1
3
```

(The warning uses `depwarn`, so is only visible if one starts with `--depwarn=yes`)


## Missing features

- Check for both kwargs being set (right now it silently takes the new kw). Although this might not be possible/robust.
