## https://forum.nim-lang.org/t/1188#7366
## https://forum.nim-lang.org/t/1188#7374
## https://forum.nim-lang.org/t/1188#17709
template ptrMath*(body: untyped) =
  template `+`[T](p: ptr T, off: SomeInteger): ptr T =
    # cast[ptr type(p[])](cast[ByteAddress](p) +% off * sizeof(p[]))
    cast[ptr T](cast[ByteAddress](p) +% off * sizeof(T))
  
  template `+=`[T](p: ptr T, off: SomeInteger) =
    p = p + off
  
  template `-`[T](p: ptr T, off: SomeInteger): ptr T =
    # cast[ptr type(p[])](cast[ByteAddress](p) -% off * sizeof(p[]))
    cast[ptr T](cast[ByteAddress](p) -% off * sizeof(T))
  
  template `-=`[T](p: ptr T, off: SomeInteger) =
    p = p - off
  
  template `[]`[T](p: ptr T, off: SomeInteger): T =
    (p + off)[]
  
  template `[]=`[T](p: ptr T, off: SomeInteger, val: T) =
    (p + off)[] = val
  
  body

when isMainModule:
  ptrMath:
    var a: array[0..3, int]
    for i in a.low..a.high:
      a[i] += i
    var p = addr(a[0])
    p += 1
    p[0] -= 2
    echo p[0], " ", p[1]