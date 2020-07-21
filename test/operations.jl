@testset "Operations" begin
  @test 2 * d6 == d6 * 2 == 2d6
  @test d4 + 2 == 2 + d4
  @test d4 - 2 == -2 + d4
  @test d4 + d6 == d6 + d4
  @test d4 * d6 == d6 * d4
  @test (2d4) + d4 == 3d4
  @test d4 + d6 + d4 == 2d4 + d6
  @test (d4 * d6) * d4 == (d4 * d4) * d6
  @test 2 + (d4*d6) == (d4*d6) + 2
  @test d4 + d4 * d6 == d4 * d6 + d4
  @test drop(4d6, kind=:highest) != drop(4d6, kind=:lowest)
  @test keep(4d6, kind=:highest) != keep(4d6, kind=:lowest)
end