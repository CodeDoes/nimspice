## https://forum.nim-lang.org/t/4044#25189

template `on`(xpr: typed, cond: untyped, onvalid: untyped): untyped =
  var value = xpr
  block:
    template _ : untyped {.inject.} = value
    if cond:
      onvalid
  value
template onError(xpr: typed, errBody: untyped): untyped =
  xpr.on _!=0:
    errBody
var 
  val = 
    1.on _ > 0:
      echo "valid value"
      _ = 22222

doAssert:
  val == 22222
doAssert:
  (;1.onError:
    echo "caught the error"
    )==1


