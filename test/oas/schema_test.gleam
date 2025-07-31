import gleam/dynamic/decode
import gleam/json
import gleam/option.{None}
import oas

pub fn boolean_test() {
  oas.Boolean(False, None, None, False)
  |> oas.encode_schema
  |> echo
  |> json.to_string
  |> json.parse(oas.schema_decoder())
  |> echo
  todo
}
