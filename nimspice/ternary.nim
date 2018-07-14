
template `?`*(condition: typed, on_valid: untyped, otherwise:untyped) {.dirty.} =
  if condition:
    on_valid
  else:
    otherwise
template `?`*(condition: typed, on_valid: untyped) {.dirty.} =
  condition?on_valid:discard