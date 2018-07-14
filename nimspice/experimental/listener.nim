import macros
template makeListener(T: typed): untyped=
  # doAssert(T.type is RootObj.type)
  type 
    Listener=object
  # proc test(Listener: Listener, value: any): bool =
  #   debugEcho("value is not a object instance", repr value)
  #   return false
  # proc test(Listener: Listener, value: typedesc): bool {.compiletime.} =
  #   debugEcho("value is type and not a object instance", value.getType())
  #   return false
  method test(listener: Listener, value: ref RootObj): bool {.base.} =
    debugEcho "type is T ", value of T
    return false
  method test(listener: Listener, value: T): bool #[{.base.}]# =
    return true
  Listener()

type Foo = ref object of RootObj

var foo_listener = makeListener(Foo)
# var o:object

# echo foo_listener.test(typedesc[object])
echo foo_listener.test(new(RootObj))
echo foo_listener.test(new(Foo))

var o= newseq[ref RootObj]()
var a = new(Foo)
# o.add(a)
o.add(new(RootObj))
o.add(new(Foo))
o.add(a)
for i in o:
  echo foo_listener.test(i)



