type
  OpCode* = enum
    ocReturn

  Chunk* = object
    code: seq[byte]

proc initChunk*: Chunk =
  Chunk(code: newSeq[byte]())

proc add*(chunk: var Chunk, byte: byte) =
  chunk.code.add(byte)


