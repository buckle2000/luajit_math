vec2 = require "vector2"
a=vec2(1,1)
b=vec2(1,1)
c={}
c[a:hash()]='sth'
print(c[b:hash()])
