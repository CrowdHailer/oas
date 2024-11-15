import gleam/dict
import gleam/dynamic
import gleam/json
import gleam/result
import gleeunit
import gleeunit/should
import oas

pub fn main() {
  gleeunit.main()
}

fn parse(data) {
  json.decode(data, oas.decoder)
}

fn decode_components(data) {
  json.decode(data, oas.components_decoder)
}

pub fn minimal_doc_test() {
  let doc =
    "{\"openapi\": \"3.0.0\", \"info\": {\"title\": \"Test\", \"version\": \"0.x.x\" }}"
    |> parse()
    |> should.be_ok
  let oas.Document(openapi: openapi, info: info, ..) = doc
  openapi
  |> should.equal("3.0.0")
  info.title
  |> should.equal("Test")
  info.version
  |> should.equal("0.x.x")
}

pub fn minimal_doc_null_fields_test() {
  let doc =
    "{
      \"openapi\": \"3.0.0\",
      \"info\": {\"title\": \"Test\", \"version\": \"0.x.x\" },
      \"jsonSchemaDialect\": null,
      \"servers\": null,
      \"paths\": null,
      \"webhooks\": null,
      \"components\": null,
      \"security\": null,
      \"tags\": null,
      \"externalDocs\": null
    }"
    |> parse()
    |> should.be_ok
  let oas.Document(openapi: openapi, info: info, ..) = doc
  openapi
  |> should.equal("3.0.0")
  info.title
  |> should.equal("Test")
  info.version
  |> should.equal("0.x.x")
}

fn parse_paths(data) {
  let data = "{
      \"openapi\": \"3.0.0\",
      \"info\": {\"title\": \"Test\", \"version\": \"0.x.x\" },
      \"jsonSchemaDialect\": null,
      \"servers\": null,
      \"paths\": " <> data <> ",
      \"webhooks\": null,
      \"components\": null,
      \"security\": null,
      \"tags\": null,
      \"externalDocs\": null
    }"
  use oas.Document(paths: paths, ..) <- result.try(json.decode(
    data,
    oas.decoder,
  ))
  Ok(paths)
}

pub fn empty_paths_test() {
  let paths =
    "{\"/\": {\"get\":{
      \"operationId\": \"op1\",
      \"responses\": {\"200\": {}}
    }}}"
    |> parse_paths()
    |> should.be_ok
  dict.get(paths, "/")
  |> should.be_ok
}

pub fn valid_object_schema_test() {
  let data =
    "{
      \"schemas\": {
        \"thing\": {
          \"type\": \"object\",
          \"properties\": {
            \"title\": {
              \"type\": \"string\"
            }
          }
        }
      }
    }"

  data
  |> decode_components
  |> should.be_ok
}

pub fn invalid_object_schema_test() {
  let data =
    "{
      \"schemas\": {
        \"thing\": {
          \"properties\": {
            \"title\": {
              \"type\": \"string\"
            }
          }
        }
      }
    }"

  data
  |> decode_components
  |> should.equal(
    Error(
      json.UnexpectedFormat([
        dynamic.DecodeError(expected: "another type", found: "Object", path: [
          "schemas", "thing",
        ]),
      ]),
    ),
  )
}
