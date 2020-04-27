bits_sizeof(::Type{T}) where {T} = 8 * sizeof(T)
log2_bits_sizeof(::Type{T}) where {T} = intlog2(bits_sizeof(T))

"""
LD = log2.(size(::BitBlockArray))
"""
struct BitBlockArray{N, T, LD} <: AbstractArray{Bool, N}
    x::T
end

function BitBlockArray(x::T, dims::Vararg{Int,N}) where {T<:Unsigned, N}
    log2_dims = intlog2.(dims)
    sum(log2_dims) == log2_bits_sizeof(T) || throw(ArgumentError("dims: $(dims) not compatible with $(T)"))
    BitBlockArray{N, T, Tuple{log2_dims...}}(x)
end

log2_Size(::Type{BitBlockArray{N, T, LD}}) where {N, T, LD} = Tuple(LD.parameters) # TODO how to Tuple{1,2} -> (1, 2)

# thought I might use the StaticArrays type trait, but so far no
Base.size(A::Type{<:BitBlockArray}) = 2 .^ log2_Size(A)
Base.size(::A) where {A <: BitBlockArray} = 2 .^ log2_Size(A)

Base.getindex(A::BitBlockArray, i) = Bool((A.x >>> (i-1)) & 1)
Base.IndexStyle(::BitBlockArray) = IndexLinear()

function intlog2(x::Signed)
    x > 0 || throw(ArgumentError("x must be positive, got $x"))
    intlog2(unsigned(x))
end

# TODO use `bsr` https://stackoverflow.com/a/994709/415404
function intlog2(x::Unsigned)
    count_ones(x) == 1 || throw(ArgumentError("x must be a positive power of 2, got $x"))
    i = 0
    while true
        (x & 1 == 1) && return i
        x = x >>> 1
        i += 1
    end
end


"""
Hacker's Delight, 2ed
Henry S. Warren, Jr.
Section 7–3 Transposing a Bit Matrix
Figure 7.6 (tranpose8)
"""
function transpose_8x8bit(a::UInt64)
    x = a

    x =  x & (0xAA55AA55AA55AA55)       |
        (x & 0x00AA00AA00AA00AA) << 7   |
        (x >> 7) & 0x00AA00AA00AA00AA
    x =  x & 0xCCCC3333CCCC3333         |
        (x & 0x0000CCCC0000CCCC) << 14  |
        (x >> 14) & 0x0000CCCC0000CCCC
    x =  x & 0xF0F0F0F00F0F0F0F         |
        (x & 0x00000000F0F0F0F0) << 28  |
        (x >> 28) & 0x00000000F0F0F0F0

    return x
end


# https://discourse.julialang.org/t/covert-bitarray-to-int64/9193/6
# This was stated to be better than the LLVM intrinsic!
function revbits(z::UInt64)
   z = (((z & 0xaaaaaaaaaaaaaaaa) >>  1) | ((z & 0x5555555555555555) <<  1))
   z = (((z & 0xcccccccccccccccc) >>  2) | ((z & 0x3333333333333333) <<  2))
   z = (((z & 0xf0f0f0f0f0f0f0f0) >>  4) | ((z & 0x0f0f0f0f0f0f0f0f) <<  4))
   z = (((z & 0xff00ff00ff00ff00) >>  8) | ((z & 0x00ff00ff00ff00ff) <<  8))
   z = (((z & 0xffff0000ffff0000) >> 16) | ((z & 0x0000ffff0000ffff) << 16))
   z = (((z & 0xffffffff00000000) >> 32) | ((z & 0x00000000ffffffff) << 32))
   return z
end


function Base.permutedims(A::BitBlockArray{2, UInt64, Tuple{3,3}})
    BitBlockArray{2, UInt64, Tuple{3,3}}(transpose_8x8bit(A.x))
end


function Base.rot180(A::BitBlockArray{2, UInt64, Tuple{3,3}})
    # TODO would work for other sizes, too
    BitBlockArray{2, UInt64, Tuple{3,3}}(revbits(A.x))
end
