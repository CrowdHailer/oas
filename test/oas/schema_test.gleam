import gleam/dynamic
import gleam/dynamic/decode
import non_empty_list
import oas
import oas/generator/utils

pub fn enum_test() {
  let raw =
    dynamic.properties([
      #(
        dynamic.string("enum"),
        dynamic.list([
          dynamic.string("red"),
          dynamic.string("amber"),
          dynamic.string("green"),
        ]),
      ),
    ])
  assert Ok(
      oas.Enum(
        non_empty_list.new(utils.String("red"), [
          utils.String("amber"),
          utils.String("green"),
        ]),
      ),
    )
    == decode.run(raw, oas.schema_decoder())
}

pub fn const_test() {
  let raw =
    dynamic.properties([
      #(dynamic.string("const"), dynamic.string("Highlander")),
    ])
  assert Ok(oas.Enum(non_empty_list.single(utils.String("Highlander"))))
    == decode.run(raw, oas.schema_decoder())
}
