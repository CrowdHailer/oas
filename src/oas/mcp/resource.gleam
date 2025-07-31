import gleam/json
import gleam/option.{type Option}

pub type Resource {
  Resource(
    uri: String,
    name: String,
    title: Option(String),
    description: Option(String),
    mime_type: Option(String),
    size: Option(Int),
  )
}

pub fn encode(resource) {
  let Resource(uri:, name:, title:, description:, mime_type:, size:) = resource
  json.object([
    #("uri", json.string(uri)),
    #("name", json.string(name)),
    #("title", json.nullable(title, json.string)),
    #("description", json.nullable(description, json.string)),
    #("mimeType", json.nullable(mime_type, json.string)),
    #("size", json.nullable(size, json.int)),
  ])
}
