var documenterSearchIndex = {"docs":
[{"location":"api/#Usage","page":"API","title":"Usage","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"@deprecate_kws","category":"page"},{"location":"api/#DeprecateKeywords.@deprecate_kws","page":"API","title":"DeprecateKeywords.@deprecate_kws","text":"@deprecate_kws(deprecations, def)\n\nMacro to deprecate keyword arguments. deprecations should be a tuple of keyword arguments to deprecate, like (new_kw1=old_kw1, new_kw2=old_kw2). def should be the function definition.\n\n\n\n\n\n","category":"macro"},{"location":"#DeprecateKeywords.jl","page":"Home","title":"DeprecateKeywords.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: Dev) (Image: Build Status) (Image: Coverage)","category":"page"},{"location":"","page":"Home","title":"Home","text":"DeprecateKeywords defines a macro for keyword deprecation. For example, let's say we wish to deprecate the keyword old_kw1 in favor of new_kw1, and likewise for old_kw2. `","category":"page"},{"location":"","page":"Home","title":"Home","text":"using DeprecateKeywords\n\n@deprecate_kws (new_kw1=old_kw1, new_kw2=old_kw2) function f(; new_kw1=2, new_kw2=3)\n    new_kw1 + new_kw2\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"With this, we can use both the old and new keywords. If using the old keyword, it will automatically be passed to the new keyword, but with a deprecation warning.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> f(new_kw1=1, new_kw2=2)\n3\n\njulia> f(old_kw1=1, new_kw2=2)\n┌ Warning: Keyword argument `old_kw1` is deprecated. Use `new_kw1` instead.\n│   caller = top-level scope at REPL[5]:1\n└ @ Core REPL[5]:1\n3","category":"page"},{"location":"","page":"Home","title":"Home","text":"(The warning uses depwarn, so is only visible if one starts with --depwarn=yes)","category":"page"},{"location":"#Missing-features","page":"Home","title":"Missing features","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Check for both kwargs being set (right now it silently takes the new kw)","category":"page"}]
}
