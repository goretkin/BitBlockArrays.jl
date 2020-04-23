using BitBlockArrays
using BitBlockArrays: BitBlockArray, UniformBlockArray
using Test

@testset "BitBlockArrays.jl" begin
    # Write your tests here.
    bba = BitBlockArray(UInt64(0), 8, 8)
    @test_throws ArgumentError BitBlockArray(UInt64(0), 8, 9)

    A = fill(bba, 2, 2)

    uba = UniformBlockArray(A)
    @test sum(uba) == 0
    uba.A[1] = BitBlockArray(UInt64(0xF), 8, 8)
    @test sum(uba) == 4
    uba.A[2] = BitBlockArray(UInt64(0xFF), 8, 8)
    @test sum(uba) == 12
    uba.A[end] = BitBlockArray(typemax(UInt64), 8, 8)
    @test sum(uba) == 76

end
