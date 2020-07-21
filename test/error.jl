@testset "Throw error" begin
  @test_throws ErrorException drop(4d6, kind=:bad)
  @test_throws ErrorException keep(4d6, kind=:bad)
  @test_throws ErrorException drop(4d6, n = 4)
  @test_throws ErrorException keep(4d6, n = 5)
end