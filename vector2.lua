local ffi = require("ffi")
local ffi_istype = ffi.istype
local ffi_metatype = ffi.metatype
local bit = require("bit")
local bit_xor = bit.bxor
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift
local is_number, is_vector2, index_mt, mt, vector2
is_number = function(n)
  return type(n) == "number"
end
is_vector2 = function(n)
  return ffi_istype(vector2, n)
end
index_mt = {
  clone = function(v)
    return vector2(v.x, v.y)
  end,
  euclidean = function(v)
    return vector2(v:len(), math.atan2(v.x, v.y))
  end,
  ieuclidean = function(v)
    v.x = v:len()
    v.y = math.atan2(v.x, v.y)
  end,
  polar = function(v)
    return vector2(v.x * cos(v.y), v.x * sin(v.y))
  end,
  ipolar = function(v)
    v.x = v.x * cos(v.y)
    v.y = v.x * sin(v.y)
  end,
  set = function(a, b)
    a.x = b.x
    a.y = b.y
  end,
  setxy = function(v, x, y)
    v.x = x
    v.y = y
  end,
  unpack = function(v)
    return v.x, v.y
  end,
  hash = function(v)
    local seed = 2
    seed = bit_xor(2, v.x + 0x9e3779b9 + bit_lshift(seed, 6) + bit_rshift(seed, 2))
    return bit_xor(seed, v.y + 0x9e3779b9 + bit_lshift(seed, 6) + bit_rshift(seed, 2))
  end,
  length = function(v)
    return math.sqrt(v.x ^ 2 + v.y ^ 2)
  end,
  length2 = function(v)
    return v.x ^ 2 + v.y ^ 2
  end,
  dot = function(a, b)
    return a.x * b.x + a.y * b.y
  end,
  cross = function(a, b)
    return a.x * b.y - a.y * b.x
  end,
  distance = function(a, b)
    return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
  end,
  distance2 = function(a, b)
    return (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2
  end,
  normalize = function(v)
    local l = v:length()
    assert(l > 0, "Vec2: trying to normalize (0,0).")
    return vector2(v.x / l, v.y / l)
  end,
  inormalize = function(v)
    local l = v:length()
    assert(l > 0, "Vec2: trying to normalize (0,0).")
    v.x = v.x / l
    v.y = v.y / l
  end,
  add = function(a, b)
    return vector2(a.x + b.x, a.y + b.y)
  end,
  sub = function(a, b)
    return vector2(a.x - b.x, a.y - b.y)
  end,
  mul = function(a, b)
    if is_number(a) then
      return vector2(a * b.x, a * b.y)
    elseif is_number(b) then
      return vector2(a.x * b, a.y * b)
    else
      return error("Vec2: please use 'dot(a,b)'.")
    end
  end,
  div = function(a, b)
    assert(is_number(b), "Vec2: can only divide by number.")
    return vector2(a.x / b, a.y / b)
  end,
  unm = function(v)
    return vector2(-v.x, -v.y)
  end,
  eq = function(a, b)
    return a.x == b.x and a.y == b.y
  end,
  tostring = function(v)
    return "(" .. tostring(v.x) .. "," .. tostring(v.y) .. ")"
  end,
  iadd = function(a, b)
    a.x = a.x + b.x
    a.y = a.y + b.y
  end,
  isub = function(a, b)
    a.x = a.x - b.x
    a.y = a.y - b.y
  end,
  imul = function(a, b)
    a.x = a.x * b
    a.y = a.y * b
  end,
  idiv = function(a, b)
    a.x = a.x / b
    a.y = a.y / b
  end,
  iunm = function(v)
    v.x = -v.x
    v.y = -v.y
  end
}
mt = {
  __add = index_mt.add,
  __sub = index_mt.sub,
  __mul = index_mt.mul,
  __div = index_mt.div,
  __unm = index_mt.unm,
  __eq = index_mt.eq,
  __tostring = index_mt.tostring,
  __index = index_mt
}
vector2 = ffi_metatype("struct { double x, y; }", mt)
return setmetatable({
  ctype = vector2,
  zero = function()
    return vector2(0, 0)
  end,
  identity = function(n)
    if n == nil then
      n = 1
    end
    return vector2(n, n)
  end,
  from_polar = function(d, angle)
    return vector2(d * cos(angle), d * sin(angle))
  end,
  is_a = is_vector2
}, {
  __call = function(_, ...)
    return vector2(...)
  end,
  __index = index_mt
})
