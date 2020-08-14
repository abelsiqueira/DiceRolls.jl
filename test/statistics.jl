@testset "Statistics" begin
  dices = [d4, d10, 2d6, 2d4+d6, 2d4+2d6, (1d4 - 1) * (1d4 - 1), drop(3d4), keep(3d4)]
  foos = [mean, median, std, var]
  for foo in foos
    @testset "$foo" begin
      for dice in dices
        D = DiscreteNonParametric(histogram(dice, normalize=true)...)
        @test foo(dice) ≈ foo(D)
      end
    end
  end
end