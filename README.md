<div align="center">

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://astroautomata.com/DeprecateKeywords.jl/dev/)
[![Build Status](https://github.com/MilesCranmer/DeprecateKeywords.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MilesCranmer/DeprecateKeywords.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://coveralls.io/repos/github/MilesCranmer/DeprecateKeywords.jl/badge.svg?branch=main)](https://coveralls.io/github/MilesCranmer/DeprecateKeywords.jl?branch=main)

</div>
  
DeprecateKeywords defines a macro for keyword deprecation:

```julia
using DeprecateKeywords

@deprecate_kws (a=b, c=d) function f(;a=2, c=3)
    a + c
end
```

With this, we can use both the old and new keywords (making sure to start with `--depwarn=yes`)

```julia
julia> f(a=1, c=2)
3

julia> f(b=1, d=2)
3
```
