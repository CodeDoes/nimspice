
template `:>`(ident_defs_name:untyped,ident_defs_type:typed):untyped {.dirty.} =
  var ident_defs_name {.inject.}: ident_defs_type
  ident_defs_name
template `:=`(ident_defs_name:untyped,ident_defs_type:typed):untyped {.dirty.} =
  var ident_defs_name {.inject.} = ident_defs_type
  ident_defs_name

template `^`(xpr:typed,middle:untyped):untyped=
  {.push.}
  {.this: self.}
  proc exe[T](self: T):T=
    # bind self
    middle
    self
  {.pop.}
  exe(xpr)