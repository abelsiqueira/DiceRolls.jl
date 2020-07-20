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