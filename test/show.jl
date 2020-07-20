@testset "Show" begin
  @testset "Dices" begin
    @test string(d4) == "d₄"
    @test string(d6) == "d₆"
    @test string(d8) == "d₈"
    @test string(d12) == "d₁₂"
    @test string(d20) == "d₂₀"
  end

  @testset "DiceRoll" begin
    @test string(d4+d6) == "1d₄+1d₆"
    @test string(2d6+2) == "2d₆+2"
    @test string(4d4+2d6-10) == "4d₄+2d₆-10"
    @test string(d4 * d4) == "d₄×d₄"
    @test string(DiceRoll([d4, d4], 0, v -> log(sum(exp.(v))))) == "d₄?d₄"
  end

  @testset "CompositeRoll" begin
    @test string(d4*d4+d6) == "(d₄×d₄)+(1d₆)"
    @test string((2d4)*(1d6)+2) == "(2d₄)×(1d₆)+2"
    @test string((1d4-1)*(1d4-1)-1) == "(1d₄-1)×(1d₄-1)-1"
    @test string(CompositeRoll([d4, d4], 0, v -> log(sum(exp.(v))))) == "(d₄)?(d₄)"
  end

  @testset "DropRoll" begin
    @test string(drop(4d6)) == "4d₆ drop lowest 1"
    @test string(drop(4d6, kind=:highest)) == "4d₆ drop highest 1"
    @test string(drop(4d6, n=2)) == "4d₆ drop lowest 2"
  end

  @testset "KeepRoll" begin
    @test string(keep(4d6)) == "4d₆ keep highest 1"
    @test string(keep(4d6, kind=:lowest)) == "4d₆ keep lowest 1"
    @test string(keep(4d6, n=2)) == "4d₆ keep highest 2"
  end
end