import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/string
import oas
import oas/generator
import simplifile

pub fn main() {
  let decoder =
    decode.field(
      "definitions",
      decode.dict(decode.string, oas.schema_decoder()),
      decode.success,
    )
  let assert Ok(content) = simplifile.read("./priv/2025-06-18/schema.json")
  // TODO update oas_generator to handle a self module. 
  // This already exists but assumes components/schemas is getting written directly to schema.gleam

  // TODO extract the constant value for each request type
  let content = string.replace(content, "#/definitions", "#/components/schemas")
  let assert Ok(definitions) = json.parse(content, decoder)
  let definitions =
    dict.map_values(definitions, fn(key, value) {
      case is_request(key) || is_notification(key) {
        True -> lift_params(value)
        False -> value
      }
    })

  let contents = generator.gen_schema_file(definitions, "oas/mcp")
  let assert Ok(Nil) =
    simplifile.write("../src/oas/mcp/messages.gleam", contents)
}

fn is_request(key) {
  case string.ends_with(key, "Request"), key {
    _, "ClientRequest" | _, "ServerRequest" | _, "JSONRPCRequest" -> False
    True, _ -> True
    False, _ -> False
  }
}

fn is_notification(key) {
  case string.ends_with(key, "Notification"), key {
    _, "ClientNotification" | _, "ServerNotification" | _, "JSONRPCNotification"
    -> False
    True, _ -> True
    False, _ -> False
  }
}

fn lift_params(value) {
  case value {
    oas.Object(properties: p, ..) ->
      case dict.size(p), dict.get(p, "method"), dict.get(p, "params") {
        2, Ok(oas.Inline(oas.String(..))), Ok(oas.Inline(params)) -> params
        _, _, _ -> panic as "method and params should be string and object"
      }
    _ -> panic as "Request should be an object"
  }
}
