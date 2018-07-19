
iterator zip*[T](iters: varargs[Slice[T]]):T=
  for iter in iters:
    for val in iter:
      yield val