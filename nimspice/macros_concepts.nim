import macros except ident
import future


# template simpleConcept(Name,kind):untyped=
#   type Name = concept c
#     c.expectKind kind
type
  Node = concept c
    c is NimNode
    # c[] is NimNode
macro simpleConcepts(body:untyped):untyped=
  result = newStmtList()
  for x in body:
    var 
      a=x[1]
      b=x[2]
    hint repr a
    hint repr b
    assert(macros.ident($x[0]) == macros.ident("as"), "only as infix allowed")
    result.add quote do:
      type `a` = concept c
        # nk in NimNodeKind
        c is NimNode
        macros.expectKind(c, `b`)
        a is Node

simpleConcepts:
  RoutineNode as RoutineNodes
  IdentNode as nnkIdent
  SymNode as nnkSym
  IdentDefsNode as nnkIdentDefs
  TypeSectionNode as nnkTypeSection
  TypeDefNode as nnkTypeDef
  AsgnNode as nnkAsgn
  PostfixNode as nnkPostfix
  InfixNode as nnkInfix
  Prefix as nnkPrefix
type 
  IdentifierNode = concept c
    (c is IdentNode or c is SymNode)
proc mident(s: string): IdentifierNode = macros.ident(s)



type 
  ObjectTypeDefNode = concept c
    c is TypeDefNode
    c[3].kind == nnkObjectTy
  # ValidTypeDefInheritanceNode 
  RefTypeDefNode = concept c
    c is TypeDefNode
    c[3].kind is nnkRefTy
    c[3][0].kind nnkObjectTy
  StarPostfixNode = concept c 
    c[0] == mident("*")
    c.len == 2
    c[0].kind != nnkEmpty
  ExportedProc = concept c
    c[0] is StarPostfixNode
    c[0].len == 1
# proc `[]`(k:auto):auto=
#   var val = macros.`[]`(k)
#   val
proc ident(s: StarPostfixNode): IdentifierNode {.compileTime.} =
  s[0]
proc ident(s: IdentifierNode): IdentifierNode {.compileTime.} = 
  s
type Foo = object
template check(break_on_false:untyped)=
  doassert break_on_false

proc isValid(n:TypeDefNode)=
  #  check_scope
  var i = n[0].ident
  check n.type is Node
  check n is TypeDefNode
  check n[0] is IdentifierNode
  check i is IdentifierNode
  check n.len == Foo.getTypeInst().symbol.getImpl().len
  
import future
macro testTypeDefNode():untyped =
  let t = (quote do:
    type ASDASD = object)[0]

  doAssert(t is TypeDefNode)
  echo("t is TypeDefNode")
  hint astGenRepr t
  hint $(t is TypeDefNode)
  hint $(t is Node)
  hint $(t.len)
  hint astGenRepr Foo.getTypeInst().symbol.getImpl()
  # hint repr Foo.getTypeImpl()[1].symbol.getImpl().len
  # hint $(t is ValidNode)
  t.isValid()
  # doAssert(t is ValidNode)
  # echo("t is ValidNode")

testTypeDefNode()

macro testRoutinesNode():untyped=
  var p = newProc("myroutine".ident)
  doAssert(p is RoutineNode)

testRoutinesNode()
