type
  Vector*[T] = object
    dat: ptr UncheckedArray[T]
    cap: Natural
    len: Natural

proc initVector*[T](): Vector[T] = Vector[T](dat: nil, cap: 0, len: 0)

proc resize[T](x: var Vector[T]) =
  let oldCap = x.cap
  let oldDat = x.dat
  x.cap = if x.cap < 8: 8 else: x.cap * 2
  x.dat = cast[ptr UncheckedArray[T]](alloc(sizeof(T) * x.cap))
  for i in 0..<oldCap:
    x.dat[i] = oldDat[i]


proc `=destroy`*[T](x: var Vector[T]) =
  if x.dat != nil:
    for i in 0 ..< x.len: `=destroy`(x.dat[i])
    dealloc(x.dat)
    x.dat = nil

proc `=`*[T](a: var Vector[T], b: Vector[T]) =
  if a.dat == b.dat: return
  `=destroy`(a)
  a.len = b.len
  a.cap = b.len
  if b.dat != nil:
    a.dat = cast[type(a.dat)](alloc(a.cap * sizeof(T)))
    for i in 0 ..< a.len:
      a.dat[i] = b.dat[i]

proc `=sink`*[T](a: var Vector[T], b: Vector[T]) =
  `=destroy`(a)
  a.len = b.len
  a.cap = b.cap
  a.dat = b.dat

proc add*[T](x: var Vector, elem: sink T) =
  if x.len >= x.cap: resize(x)
  x.dat[x.len] = elem
  x.len.inc


proc `[]`*[T](x: Vector[T], i: Natural): lent T =
  assert i < x.len
  x.dat[i]

proc `[]=`*[T](x: var Vector[T], i: Natural, t: sink T) =
  assert i < x.len
  x.dat[i] = t

proc initVector*[T](elem: T, elems: varargs[T]): Vector[T] =
  result.cap = elems.len + 1
  result.len = elems.len + 1
  result.dat = cast[type(result.dat)](alloc(result.cap * sizeof(T)))
  result.dat[0] = elem
  for i in 1 .. elems.len: result.dat[i] = elems[i - 1]

proc `@@`*[I, T](arr: sink array[I, T]): Vector[T] =
  when arr.len > 0:
    initVector[T](arr[0], arr[1..arr.high])
  else:
    initVector[T]()

proc `$`*[T](vector: Vector[T]): string =
  result = "["
  for i in 0 ..< vector.len - 1:
    result &= $vector[i] & ","
  if vector.len > 0:
    result &= $vector[vector.len-1]
  result &= "]"


type Tree = object
  elem: int
  kids: Vector[Tree]

proc `$`*(tree: Tree): string =
  if tree.kids.len == 0:
    result &= $tree.elem
  else:
    result = "("
    result &= $tree.kids[0] & "<-"
    result &= $tree.elem
    result &= "->" & $tree.kids[1]
    result &= ")"

var t = Tree(elem: 4, kids: @@[Tree(elem: 2, kids: @@[Tree(elem: 1), Tree(elem: 3)]), Tree(elem: 6, kids: @@[Tree(elem: 5), Tree(elem: 7)])])

echo t

t = t.kids[0]

echo t
