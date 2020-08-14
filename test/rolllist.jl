@testset "Roll list" begin
  @test rolllist(1d4) == [[i] for i = 1:4]
  @test rolllist(2d4) == rolllist(2d4 + 2) == [[i, j] for i = 1:4, j = 1:4][:]
  @test rolllist(drop(2d4)) == [[i, j] for i = 1:4, j = 1:4][:]
  @test rolllist((1d4 - 1) * (1d6 - 1)) == [[i, j] for i = 1:4, j = 1:6][:]
  io = IOBuffer()
  show(io, 1d4 > 2)
  @test String(take!(io)) == "Compact (1d₄) > 2 - Use collect for the list"
end

@testset "Comparisons" begin
  r = d4
  @test collect(r > 0)  == collect(0 < r)  == [[i] for i = 1:4]
  @test collect(r > 2)  == collect(2 < r)  == [[i] for i = 3:4]
  @test collect(r > 4)  == collect(4 < r)  == []
  @test collect(r ≥ 2)  == collect(2 ≤ r)  == [[i] for i = 2:4]
  @test collect(r < 3)  == collect(3 > r)  == [[i] for i = 1:2]
  @test collect(r ≤ 3)  == collect(3 ≥ r)  == [[i] for i = 1:3]
  @test collect(r == 3) == collect(3 == r) == [[3]]

  r = 2d4
  @test collect(r > 0)  == collect(0 < r)  == [[i, j] for i = 1:4, j = 1:4][:]
  @test collect(r > 4)  == collect(4 < r)  == [[i, j] for i = 1:4, j = 1:4 if i + j > 4]
  @test collect(r > 8)  == collect(8 < r)  == []
  @test collect(r ≥ 4)  == collect(4 ≤ r)  == [[i, j] for i = 1:4, j = 1:4 if i + j ≥ 4]
  @test collect(r < 5)  == collect(5 > r)  == [[i, j] for i = 1:4, j = 1:4 if i + j < 5]
  @test collect(r ≤ 5)  == collect(5 ≥ r)  == [[i, j] for i = 1:4, j = 1:4 if i + j ≤ 5]
  @test collect(r == 4) == collect(4 == r) == [[3, 1], [2, 2], [1, 3]]

  r = 2d4 + 2
  @test collect(r > 2)   == collect(2 < r)   == [[i, j] for i = 1:4, j = 1:4][:]
  @test collect(r > 6)   == collect(6 < r)   == [[i, j] for i = 1:4, j = 1:4 if i + j > 4]
  @test collect(r > 10)  == collect(10 < r)  == []
  @test collect(r ≥ 6)   == collect(6 ≤ r)   == [[i, j] for i = 1:4, j = 1:4 if i + j ≥ 4]
  @test collect(r < 7)   == collect(7 > r)   == [[i, j] for i = 1:4, j = 1:4 if i + j < 5]
  @test collect(r ≤ 7)   == collect(7 ≥ r)   == [[i, j] for i = 1:4, j = 1:4 if i + j ≤ 5]
  @test collect(r == 6)  == collect(6 == r)  == [[3, 1], [2, 2], [1, 3]]

  r = drop(2d4)
  @test collect(r > 0)  == collect(0 < r)  == [[i, j] for i = 1:4, j = 1:4][:]
  @test collect(r > 2)  == collect(2 < r)  == [[i, j] for i = 1:4, j = 1:4 if max(i, j) > 2]
  @test collect(r > 4)  == collect(4 < r)  == []
  @test collect(r ≥ 2)  == collect(2 ≤ r)  == [[i, j] for i = 1:4, j = 1:4 if max(i, j) ≥ 2]
  @test collect(r < 3)  == collect(3 > r)  == [[i, j] for i = 1:4, j = 1:4 if max(i, j) < 3]
  @test collect(r ≤ 3)  == collect(3 ≥ r)  == [[i, j] for i = 1:4, j = 1:4 if max(i, j) ≤ 3]
  @test collect(r == 3) == collect(3 == r) == [[3, 1], [3, 2], [1, 3], [2, 3], [3, 3]]
end

@testset "Probabilities" begin
  r = d4
  @test prob(r > 0)  == prob(0 < r)  == 1
  @test prob(r > 2)  == prob(2 < r)  == 0.5
  @test prob(r > 4)  == prob(4 < r)  == 0
  @test prob(r ≥ 2)  == prob(2 ≤ r)  == 0.75
  @test prob(r < 3)  == prob(3 > r)  == 0.5
  @test prob(r ≤ 3)  == prob(3 ≥ r)  == 0.75
  @test prob(r == 3) == prob(3 == r) == 0.25

  r = 2d4
  @test prob(r > 0)  == prob(0 < r)  == 1
  @test prob(r > 4)  == prob(4 < r)  == 0.625
  @test prob(r > 8)  == prob(8 < r)  == 0
  @test prob(r ≥ 4)  == prob(4 ≤ r)  == 0.8125
  @test prob(r < 5)  == prob(5 > r)  == 0.375
  @test prob(r ≤ 5)  == prob(5 ≥ r)  == 0.625
  @test prob(r == 4) == prob(4 == r) == 0.1875

  r = 2d4 + 2
  @test prob(r > 2)   == prob(2 < r)   == 1
  @test prob(r > 6)   == prob(6 < r)   == 0.625
  @test prob(r > 10)  == prob(10 < r)  == 0
  @test prob(r ≥ 6)   == prob(6 ≤ r)   == 0.8125
  @test prob(r < 7)   == prob(7 > r)   == 0.375
  @test prob(r ≤ 7)   == prob(7 ≥ r)   == 0.625
  @test prob(r == 6)  == prob(6 == r)  == 0.1875

  r = drop(2d4)
  @test prob(r > 0)  == prob(0 < r)  == 1
  @test prob(r > 2)  == prob(2 < r)  == 0.75
  @test prob(r > 4)  == prob(4 < r)  == 0
  @test prob(r ≥ 2)  == prob(2 ≤ r)  == 0.9375
  @test prob(r < 3)  == prob(3 > r)  == 0.25
  @test prob(r ≤ 3)  == prob(3 ≥ r)  == 0.5625
  @test prob(r == 3) == prob(3 == r) == 0.3125
end