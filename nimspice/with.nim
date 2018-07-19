
import macros
#TODO when compiles(`=with_open`(var))
#TODO when compiles(`=with_close`(var))
macro `with`*(xpr: untyped, exe: untyped): untyped {.discardable.} =
  result = newStmtList()
  var alias = "_".ident
  var val = xpr
  # hint xpr.astGenRepr
  if xpr.kind==nnkInfix:
    assert $xpr[0] == "as"
    alias = xpr[2]
    val = xpr[1]
  var 
    innerProc = genSym(nskProc,"inner_proc")
    r = "result".ident

  result.add quote do:
    var val = `val`
    template `alias` : untyped {.inject.} = val
    # block:
    block:
      `exe`
    val
    
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
  with 5:
    assert _ == 5
    echo "5 ",_