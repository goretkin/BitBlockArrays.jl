"""
Arrays of arrays, where the inner arrays are "statically sized" i.e. size is encoded in the type via the Size trait.
The inner arrays must all share the same type signature.
"""
struct UniformBlockArray{T, N, X} <: AbstractArray{T, N}
    A::X
end

function UniformBlockArray(A::X) where {X}
    @assert ndims(eltype(X)) == ndims(X)
    UniformBlockArray{eltype(eltype(X)), ndims(X), X}(A)
end

function index_parts(l, i)
    i0 = i - 1
    inner = i0 & (2^l - 1)
    outer = i0 >> l
    return (outer + 1, inner +1)
end

function outerinner(Tblock, idxs)
    ls = log2_Size(Tblock)
    ps = index_parts.(ls, idxs)
end

blocktype(::Type{UniformBlockArray{T, N, X}}) where {T, N, X} = eltype(X)

Base.size(uba::UniformBlockArray) = size(uba.A) .* size(blocktype(typeof(uba)))
Base.length(uba::UniformBlockArray) = prod(size(uba))

function Base.getindex(uba::UniformBlockArray{T, N, X}, idxs::Vararg{Int, N}) where {T, N, X}
    ps = outerinner(blocktype(typeof(uba)), idxs)
    outer = first.(ps)
    inner = last.(ps)
    (uba.A[outer...])[inner...]
end
