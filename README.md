# BitBlockArrays

[![Build Status](https://gitlab.com/goretkin/BitBlockArrays.jl/badges/master/build.svg)](https://gitlab.com/goretkin/BitBlockArrays.jl/pipelines)
[![Coverage](https://gitlab.com/goretkin/BitBlockArrays.jl/badges/master/coverage.svg)](https://gitlab.com/goretkin/BitBlockArrays.jl/commits/master)
[![Build Status](https://travis-ci.com/goretkin/BitBlockArrays.jl.svg?branch=master)](https://travis-ci.com/goretkin/BitBlockArrays.jl)
[![Coverage](https://codecov.io/gh/goretkin/BitBlockArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/goretkin/BitBlockArrays.jl)
[![Coverage](https://coveralls.io/repos/github/goretkin/BitBlockArrays.jl/badge.svg?branch=master)](https://coveralls.io/github/goretkin/BitBlockArrays.jl?branch=master)


This package is completely undeveloped.


Extend `Base.BitArray` to include other bit-packing layouts. More "square" layouts gives me flexibility in choosing alignment, so that bitwise operations may be used.


```julia
julia> b = BitBlockArray(UInt64(0xF0F0F0FF0000FF00), 8, 8)
8×8 BitBlockArray{2,UInt64,(3, 3)}:
 0  1  0  0  1  0  0  0
 0  1  0  0  1  0  0  0
 0  1  0  0  1  0  0  0
 0  1  0  0  1  0  0  0
 0  1  0  0  1  1  1  1
 0  1  0  0  1  1  1  1
 0  1  0  0  1  1  1  1
 0  1  0  0  1  1  1  1

julia> bz = BitBlockArray(UInt64(0), 8, 8)
8×8 BitBlockArray{2,UInt64,(3, 3)}:
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0

julia> uba = UniformBlockArray(fill(bz, 2, 2))
16×16 UniformBlockArray{Bool,2,Array{BitBlockArray{2,UInt64,(3, 3)},2}}:
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0

julia> uba
16×16 UniformBlockArray{Bool,2,Array{BitBlockArray{2,UInt64,(3, 3)},2}}:
 0  1  0  0  1  0  0  0  0  0  0  0  0  0  0  0
 0  1  0  0  1  0  0  0  0  0  0  0  0  0  0  0
 0  1  0  0  1  0  0  0  0  0  0  0  0  0  0  0
 0  1  0  0  1  0  0  0  0  0  0  0  0  0  0  0
 0  1  0  0  1  1  1  1  0  0  0  0  0  0  0  0
 0  1  0  0  1  1  1  1  0  0  0  0  0  0  0  0
 0  1  0  0  1  1  1  1  0  0  0  0  0  0  0  0
 0  1  0  0  1  1  1  1  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
```

related:
https://github.com/JuliaLang/julia/blob/098ef24c7acb989cae2516ac18bff498e9a69554/base/bitarray.jl#L1692-L1717
https://github.com/JuliaLang/julia/blob/098ef24c7acb989cae2516ac18bff498e9a69554/base/multidimensional.jl#L1145-L1150
