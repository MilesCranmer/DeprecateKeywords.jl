<div align="center">

# DeprecateKeywords.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://astroautomata.com/DeprecateKeywords.jl/dev/)
[![Build Status](https://github.com/MilesCranmer/DeprecateKeywords.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/MilesCranmer/DeprecateKeywords.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://coveralls.io/repos/github/MilesCranmer/DeprecateKeywords.jl/badge.svg?branch=master)](https://coveralls.io/github/MilesCranmer/DeprecateKeywords.jl?branch=master)

</div>
  
[DeprecateKeywords.jl](https://github.com/MilesCranmer/DeprecateKeywords.jl) is a tiny package (77 lines) which defines a macro for keyword deprecation. 

While normally you can use `Base.@deprecate` for deprecating functions and *arguments*, because multiple dispatch does not apply to keywords, you actually need a separate macro for using at the original function signature.

For example, let's say we wish to deprecate the keyword `old_kw1` in favor of `new_kw1`, and
and `old_kw2` in favor of `new_kw2`:
```julia
using DeprecateKeywords

@depkws function foo(; new_kw1=2, new_kw2=3,
                       @deprecate(old_kw1, new_kw1),
                       @deprecate(old_kw2, new_kw2))
    return new_kw1 + new_kw2
end
```
The use of normal `@deprecate` in here is syntactic sugar to help make the signature more intuitive. The `@depkws` will simply consume the `@deprecate`s and and interpret their contents.

With this, we can use both the old and new keywords. If using the old keyword, it will automatically be passed to the new keyword, but with a deprecation warning.

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

Here's what this actually gets expanded to:

```julia
function foo(; old_kw2 = DeprecatedDefault, old_kw1 = DeprecatedDefault, new_kw1 = begin
                  if old_kw1 !== DeprecatedDefault
                      Base.depwarn("Keyword argument `old_kw1` is deprecated. Use `new_kw1` instead.", :foo)
                      old_kw1
                  else
                      2
                  end
              end, new_kw2 = begin
                  if old_kw2 !== DeprecatedDefault
                      Base.depwarn("Keyword argument `old_kw2` is deprecated. Use `new_kw2` instead.", :foo)
                      old_kw2
                  else
                      3
                  end
              end)
      new_kw1 + new_kw2
  end
```

### Other notes/warnings

- I'm not 100% sure if/when this might prevent Julia from specializing to types, or if it is different from how you would set this up manually. So just be wary of major type inference issues when passing the deprecated keywords.
- This does not check whether the user passes both keyword arguments. (It might be better to use `kws...` and then pass through the old keywords within the function body. I didn't do this in my current approach so that the user could still use `kws...` in the signature if they wish.)
- This uses the very nice [MacroTools.jl](https://github.com/FluxML/MacroTools.jl) package to help make the macro generic.

Contributions very much appreciated. I'm also open to better syntax suggestions!
