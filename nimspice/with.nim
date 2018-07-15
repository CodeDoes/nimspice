
import macros
#TODO when compiles(`=with_open`(var))
#TODO when compiles(`=with_close`(var))
macro `with`*(xpr: untyped, exe: untyped): untyped =
  result = newStmtList()
  var alias = "_".ident
  var val = xpr
  # hint xpr.astGenRepr
  if xpr.kind==nnkInfix:
    assert $xpr[0] == "as"
    alias = xpr[2]
    val = xpr[1]

  result.add quote do:
    var value = `val`
    template `alias` : untyped {.inject.} = value
    # block:
    block:
      `exe`
    value
when isMainModule:
  var
    a = 
      with 1:
        echo "v is ", _
  doAssert:
    a == 1
  doAssert:
    (;with 3:
      echo "checking 3"
      echo "3 is ", _
    ) == 3
  doAssert:
    (;with 5 as n:
      echo "checking 5 as n"
      echo "n is ", n
      echo "changing n"
      n = 2231
    ) == 2231