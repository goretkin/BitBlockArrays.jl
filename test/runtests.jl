using BitBlockArrays
using BitBlockArrays: BitBlockArray, UniformBlockArray, transpose_8x8bit
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

@testset "8-by-8 transpose" begin
    # test zero matrix and all matrices with exactly one `1` element.
    # `transpose_8x8bit` uses only linear operations, so this should result in completely testing the behavior
    for i = 0:64
        x = UInt64(0x1) << i
        a = BitBlockArray(x, 8, 8)

        xt = transpose_8x8bit(x)
        at = BitBlockArray(xt, 8, 8)

        @test collect(at) == collect(a)'
    end
end

@testset "8-by-8 rot180" begin
    for i = 0:64
        x = UInt64(0x1) << i
        a = BitBlockArray(x, 8, 8)

        @test collect(rot180(a)) == rot180(collect(a))
    end
end
