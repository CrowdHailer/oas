import gleam/dynamic
import gleam/dynamic/decode
import non_empty_list
import oas/generator/utils
import oas/json_schema

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
      json_schema.Enum(
        non_empty_list.new(utils.String("red"), [
          utils.String("amber"),
          utils.String("green"),
        ]),
      ),
    )
    == decode.run(raw, json_schema.decoder())
}

pub fn const_test() {
  let raw =
    dynamic.properties([
      #(dynamic.string("const"), dynamic.string("Highlander")),
    ])
  assert Ok(json_schema.Enum(non_empty_list.single(utils.String("Highlander"))))
    == decode.run(raw, json_schema.decoder())
}
