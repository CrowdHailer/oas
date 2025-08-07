import gleam/dynamic
import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option}
import oas
import oas/decodex

const jsonrpc = "2.0"

// Notifications have no id
pub type Request(t) {
  Request(version: String, id: Option(Id), of: t)
}

pub type ParamsDecoder(t) {
  FromParams(decode.Decoder(t))
  OptionalParams(decode.Decoder(t))
  NoParams(t)
}

pub fn request_decoder(decoders, zero) {
  use version <- decode.field("jsonrpc", decode.string)
  use id <- oas.optional_field("id", id_decoder())
  use method <- decode.field("method", decode.string)
  use of <- decode.then(case list.key_find(decoders, method) {
    Ok(FromParams(decoder)) -> decode.field("params", decoder, decode.success)
    Ok(OptionalParams(decoder)) -> {
      use maybe <- oas.optional_field("params", decodex.any())
      let params = option.unwrap(maybe, dynamic.properties([]))
      case decode.run(params, decoder) {
        Ok(v) -> decode.success(v)
        Error(_reason) -> decode.failure(todo, "params")
      }
    }
    Ok(NoParams(unit)) -> decode.success(unit)
    Error(Nil) -> decode.failure(zero, "missing decoder")
  })

  decode.success(Request(version, id, of))
}

pub type Id {
  StringId(String)
  NumberId(Int)
}

fn id_decoder() {
  decode.one_of(decode.string |> decode.map(StringId), [
    decode.int |> decode.map(NumberId),
  ])
}

fn encode_id(id) {
  case id {
    StringId(string) -> json.string(string)
    NumberId(number) -> json.int(number)
  }
}

pub type Response {
  Response(version: String, id: Id, return: Result(Json, Json))
}

pub fn encode_response(response) {
  let Response(version:, id:, return:) = response

  json.object([
    #("jsonrpc", json.string(version)),
    #("id", encode_id(id)),
    case return {
      Ok(value) -> #("result", value)
      Error(error) -> #("error", error)
    },
  ])
}

pub fn response(id, return) {
  Response(jsonrpc, id, return)
}
// MCP
