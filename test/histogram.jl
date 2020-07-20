@testset "Histogram" begin
    @test histogram(d4) == (1:4, ones(Int, 4))
    @test histogram(d20) == (1:20, ones(Int, 20))
    @test histogram(2d4) == (2:8, [1, 2, 3, 4, 3, 2, 1])
    @test histogram(2d4 + 2) == (4:10, [1, 2, 3, 4, 3, 2, 1])
    @test histogram(2d4 + d4) == (3:12, [1, 3, 6, 10, 12, 12, 10, 6, 3, 1])
    @test histogram(drop(2d4)) == (1:4, [1, 3, 5, 7])
end