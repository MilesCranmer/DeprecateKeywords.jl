module DeprecateKeywords

export @deprecate_kws

using MacroTools

macro deprecate_kws(deprecations, def)
    return esc(_deprecate_kws(deprecations, def))
end

function _deprecate_kws(deprecations, def)
    @assert(
        deprecations.head == :tuple,
        "First argument to `deprecate_kws` must be passed as a tuple, like `(new_kw1=old_kw1, new_kw2=old_kw2)`"
    )
    sdef = splitdef(def)
    func_symbol = Expr(:quote, sdef[:name])  # Double quote for expansion

    new_symbols = [_get_symbol(k.args[1]) for k in deprecations.args]
    deprecated_symbols = [_get_symbol(k.args[2]) for k in deprecations.args]
    symbol_mapping = Dict(new_symbols .=> deprecated_symbols)

    # Add deprecated kws:
    for deprecated_symbol in deprecated_symbols
        pushfirst!(sdef[:kwargs], Expr(:kw, deprecated_symbol, :nothing))
    end

    # Update new symbols to use deprecated kws if passed:
    for (i, kw) in enumerate(sdef[:kwargs])
        new_kw = kw.args[1]
        default = kw.args[2]
        _get_symbol(new_kw) in deprecated_symbols && continue
        !(_get_symbol(new_kw) in new_symbols) && continue
        deprecated_symbol = symbol_mapping[_get_symbol(new_kw)]
        depwarn_string = "Keyword argument `$(deprecated_symbol)` is deprecated. Use `$(_get_symbol(new_kw))` instead."
        new_kwcall = quote
            if $deprecated_symbol !== nothing
                Base.depwarn($depwarn_string, $func_symbol)
                $deprecated_symbol
            else
                $default
            end
        end
        sdef[:kwargs][i] = Expr(:kw, new_kw, new_kwcall)
    end

    return combinedef(sdef)
end

# This is used to go from a::Int to a
_get_symbol(e::Expr) = first(map(_get_symbol, e.args))
_get_symbol(e::Symbol) = e

end
