using Dices
using Test

@testset "Basic tests - making sure basic things don't throw errors" begin
    @test 1 ≤ roll(d20) ≤ 20
    @test 1 ≤ roll(Roll(d20)) ≤ 20
    @test 2 ≤ roll(2d20) ≤ 40
    @test 4 ≤ roll(2d20 + 2) ≤ 42
    @test 2 ≤ roll(d8 + d6) ≤ 14
    @test 5 ≤ roll(3d4 + 2d6) ≤ 24
    @test 4 ≤ roll(3d4 + d6) ≤ 18
    @test 3 ≤ roll(drop(4d6)) ≤ 18
end

@testset "Histogram" begin
    @test histogram(d4) == (1:4, ones(Int, 4))
    @test histogram(d20) == (1:20, ones(Int, 20))
    @test histogram(2d4) == (2:8, [1, 2, 3, 4, 3, 2, 1])
    @test histogram(2d4 + 2) == (4:10, [1, 2, 3, 4, 3, 2, 1])
    @test histogram(2d4 + d4) == (3:12, [1, 3, 6, 10, 12, 12, 10, 6, 3, 1])
    @test histogram(drop(2d4)) == (1:4, [1, 3, 5, 7])
end