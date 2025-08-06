import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option}
import oas
import oas/json_schema

pub type Tool {
  Tool(
    name: String,
    title: Option(String),
    description: Option(String),
    input_schema: Dict(String, oas.Schema),
  )
}

pub fn decoder() {
  use name <- decode.field("name", decode.string)
  use title <- oas.optional_field("title", decode.string)
  use description <- oas.optional_field("description", decode.string)
  use input_schema <- decode.field(
    "inputSchema",
    decode.dict(decode.string, oas.schema_decoder()),
  )
  decode.success(Tool(name, title, description, input_schema))
}

pub fn encode(tool) {
  let Tool(name:, title:, description:, input_schema:) = tool
  json.object([
    #("name", json.string(name)),
    #("title", json.nullable(title, json.string)),
    #("description", json.nullable(description, json.string)),
    #(
      "inputSchema",
      json.object([
        #("type", json.string("object")),
        #(
          "properties",
          json.dict(input_schema, fn(x) { x }, json_schema.encode),
        ),
      ]),
    ),
  ])
}
