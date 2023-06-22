using Test
using DeprecateKeywords

@deprecate_kws (a=b,) function f(; a=2)
    a
end

@test f(a=1) === 1
@test_warn "Keyword argument `b` is deprecated. Use `a` instead." (@test f(b=1) == 1)

@test_broken f(b=nothing) === nothing

@deprecate_kws (α=β, γ=δ) function g(; α=2, γ=4)
    α + γ
end

@test g() === 6
@test g(α=1, γ=3) === 4
if VERSION >= v"1.8"
    @test_warn "Keyword argument" (@test g(β=1, γ=3) === 4)
    @test_warn "Keyword argument" (@test g(α=1, δ=3) === 4)
    @test_warn "Keyword argument `β`" (@test g(β=1, δ=3) === 4)
end

@deprecate_kws (new_kw=old_kw,) h(; new_kw::Int=3) = new_kw
@test h() === 3
@test h(new_kw=1) === 1
VERSION >= v"1.8" && @test_warn "Keyword argument" (@test h(old_kw=1) === 1)
