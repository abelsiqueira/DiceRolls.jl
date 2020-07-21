@testset "Histogram" begin
  @test histogram(coin) == ([0, 1], [1, 1])
  @test histogram(coin, normalize=true) == ([0, 1], [0.5; 0.5])
  @test histogram(coin * coin, normalize=true) == ([0, 1], [0.75; 0.25])
  @test histogram(d4) == (1:4, ones(Int, 4))
  @test histogram(d4, normalize=true) == (1:4, 0.25 * ones(4))
  @test histogram(d20) == (1:20, ones(Int, 20))
  @test histogram(2d4) == (2:8, [1, 2, 3, 4, 3, 2, 1])
  @test histogram(2d4 + 2) == (4:10, [1, 2, 3, 4, 3, 2, 1])
  @test histogram(2d4 + d4) == (3:12, [1, 3, 6, 10, 12, 12, 10, 6, 3, 1])
  @test histogram((1d4 - 1) * (1d4 - 1)) == ([0, 1, 2, 3, 4, 6, 9], [7, 1, 2, 2, 1, 2, 1])
  @test histogram(drop(2d4)) == (1:4, [1, 3, 5, 7])
  @test histogram(keep(2d4)) == (1:4, [1, 3, 5, 7])
end