import gleam/dynamic
import gleam/dynamic/decode.{DecodeError}
import gleeunit/should
import oas/decodex

pub type Thing {
  Foo(String)
  Bar(Int)
}

fn decoder() {
  use type_ <- decodex.discriminate("type", decode.string, Bar(0))
  case type_ {
    "foo" ->
      Ok({
        use foo <- decode.field("foo", decode.string)
        decode.success(Foo(foo))
      })
    "bar" ->
      Ok({
        use bar <- decode.field("bar", decode.int)
        decode.success(Bar(bar))
      })
    _ -> Error("Unknown type")
  }
}

pub fn no_discriminator_test() {
  dynamic.properties([])
  |> decode.run(decoder())
  |> should.be_error
  |> should.equal([
    DecodeError(expected: "Discriminator", found: "Dict", path: []),
  ])
}

pub fn invalid_discriminator_type_test() {
  dynamic.properties([#(dynamic.string("type"), dynamic.int(0))])
  |> decode.run(decoder())
  |> should.be_error
  |> should.equal([
    DecodeError(expected: "String", found: "Int", path: ["type"]),
    // don't think this decode error should be there.
    DecodeError(expected: "Unknown type", found: "Dict", path: []),
  ])
}

pub fn unknown_discriminator_test() {
  dynamic.properties([#(dynamic.string("type"), dynamic.string("baz"))])
  |> decode.run(decoder())
  |> should.be_error
  |> should.equal([
    DecodeError(expected: "Unknown type", found: "Dict", path: []),
  ])
}

pub fn invalid_content_test() {
  dynamic.properties([
    #(dynamic.string("type"), dynamic.string("foo")),
    #(dynamic.string("baz"), dynamic.string("Orange")),
  ])
  |> decode.run(decoder())
  |> should.be_error
  |> should.equal([
    DecodeError(expected: "Field", found: "Nothing", path: ["foo"]),
  ])
}

pub fn valid_content_test() {
  dynamic.properties([
    #(dynamic.string("type"), dynamic.string("foo")),
    #(dynamic.string("foo"), dynamic.string("Orange")),
  ])
  |> decode.run(decoder())
  |> should.be_ok
  |> should.equal(Foo("Orange"))
}
