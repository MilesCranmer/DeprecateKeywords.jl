using Test
using DeprecateKeywords

@testset "Basic" begin
    @depkws function f(; a=2, @deprecate b a)
        a
    end

    @test f(a=1) === 1
    VERSION >= v"1.8" && @test_warn "Keyword argument `b` is deprecated. Use `a` instead." (@test f(b=1) == 1)

    @test f(b=nothing) === nothing
end

@testset "Multi-param" begin
    @depkws function g(; α=2, γ=4, @deprecate(β, α), @deprecate(δ, γ))
        α + γ
    end

    @test g() === 6
    @test g(α=1, γ=3) === 4
    if VERSION >= v"1.8"
        @test_warn "Keyword argument" (@test g(β=1, γ=3) === 4)
        @test_warn "Keyword argument" (@test g(α=1, δ=3) === 4)
        @test_warn "Keyword argument `β`" (@test g(β=1, δ=3) === 4)
    end
end

@testset "With types" begin
    @depkws h(; (@deprecate old_kw new_kw), new_kw::Int=3) = new_kw
    @test h() === 3
    @test h(new_kw=1) === 1
    VERSION >= v"1.8" && @test_warn "Keyword argument" (@test h(old_kw=1) === 1)
end

@testset "Error catching" begin
    VERSION >= v"1.8" && @test_throws LoadError (@eval @depkws k(; @deprecate a b, b = 10) = b)
end
