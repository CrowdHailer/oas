import castor as json_schema
import castor/decodex
import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/list
import gleam/option.{type Option, None}
import gleam/pair
import non_empty_list.{type NonEmptyList, NonEmptyList}
import oas/path_template

/// This is the root object of the OpenAPI document.
pub type Document {
  Document(
    openapi: String,
    info: Info,
    json_schema_dialect: Option(String),
    servers: List(Server),
    paths: Dict(String, PathItem),
    // webhooks:
    components: Components,
    // security:
    // tags:
    // externalDocs:
  )
}

pub fn decoder() -> decode.Decoder(Document) {
  use openapi <- decode.field("openapi", decode.string)
  use info <- decode.field("info", info_decoder())
  use json_schema_dialect <- decodex.optional_field(
    "jsonSchemaDialect",
    decode.string,
  )
  use servers <- decodex.default_field(
    "servers",
    decode.list(server_decoder()),
    [],
  )
  use paths <- decodex.default_field("paths", paths_decoder(), dict.new())
  use components <- decodex.default_field(
    "components",
    components_decoder(),
    Components(dict.new(), dict.new(), dict.new(), dict.new()),
  )
  decode.success(Document(
    openapi,
    info,
    json_schema_dialect,
    servers,
    paths,
    components,
  ))
}

/// The object provides metadata about the API. The metadata MAY be used by the clients if needed, and MAY be presented in editing or documentation generation tools for convenience.
pub type Info {
  Info(
    title: String,
    summary: Option(String),
    description: Option(String),
    terms_of_service: Option(String),
    contact: Option(Contact),
    license: Option(Licence),
    version: String,
  )
}

fn info_decoder() {
  use title <- decode.field("title", decode.string)
  use summary <- decodex.optional_field("summary", decode.string)
  use description <- decodex.optional_field("description", decode.string)
  use terms_of_service <- decodex.optional_field(
    "termsOfService",
    decode.string,
  )
  use contact <- decodex.optional_field("contact", contact_decoder())
  use license <- decodex.optional_field("license", license_decoder())
  use version <- decode.field("version", decode.string)
  decode.success(Info(
    title,
    summary,
    description,
    terms_of_service,
    contact,
    license,
    version,
  ))
}

/// Contact information for the exposed API.
pub type Contact {
  Contact(name: Option(String), url: Option(String), email: Option(String))
}

fn contact_decoder() {
  use name <- decodex.optional_field("name", decode.string)
  use url <- decodex.optional_field("url", decode.string)
  use email <- decodex.optional_field("email", decode.string)
  decode.success(Contact(name, url, email))
}

/// License information for the exposed API.
pub type Licence {
  Licence(name: String, identifier: Option(String), url: Option(String))
}

fn license_decoder() {
  use name <- decode.field("name", decode.string)
  use identifier <- decodex.optional_field("identifier", decode.string)
  use url <- decodex.optional_field("url", decode.string)
  decode.success(Licence(name, identifier, url))
}

/// An object representing a Server.
pub type Server {
  Server(
    url: String,
    description: Option(String),
    variables: Dict(String, ServerVariable),
  )
}

fn server_decoder() {
  use url <- decode.field("url", decode.string)
  use description <- decodex.optional_field("description", decode.string)
  use variables <- decodex.default_field(
    "variables",
    decode.dict(decode.string, server_variable_decoder()),
    dict.new(),
  )
  decode.success(Server(url, description, variables))
}

/// An object representing a Server Variable for server URL template substitution.
pub type ServerVariable {
  ServerVariable(
    enum: Option(NonEmptyList(String)),
    default: String,
    description: Option(String),
  )
}

fn server_variable_decoder() {
  use enum <- decodex.optional_field("enum", non_empty_list_of_string_decoder())
  use default <- decode.field("default", decode.string)
  use description <- decodex.optional_field("description", decode.string)
  decode.success(ServerVariable(enum, default, description))
}

// Is it possible to get the zero value from a decoder
fn non_empty_list_of_string_decoder() {
  use list <- decode.then(decode.list(decode.string))
  case list {
    [] -> decode.failure(NonEmptyList("", []), "")
    [a, ..rest] -> decode.success(NonEmptyList(a, rest))
  }
}

/// Describes the operations available on a single path.
pub type PathItem {
  PathItem(
    summary: Option(String),
    description: Option(String),
    parameters: List(json_schema.Ref(Parameter)),
    operations: List(#(http.Method, Operation)),
  )
}

fn paths_decoder() {
  decode.dict(decode.string, path_decoder())
}

fn path_decoder() {
  use summary <- decodex.optional_field("summary", decode.string)
  use description <- decodex.optional_field("description", decode.string)
  use parameters <- decodex.default_field(
    "parameters",
    decode.list(json_schema.ref_decoder(parameter_decoder())),
    [],
  )
  use get <- decodex.optional_field(
    "get",
    operation_decoder() |> decode.map(pair.new(http.Get, _)),
  )
  use put <- decodex.optional_field(
    "put",
    operation_decoder() |> decode.map(pair.new(http.Put, _)),
  )
  use post <- decodex.optional_field(
    "post",
    operation_decoder() |> decode.map(pair.new(http.Post, _)),
  )
  use delete <- decodex.optional_field(
    "delete",
    operation_decoder() |> decode.map(pair.new(http.Delete, _)),
  )
  use options <- decodex.optional_field(
    "options",
    operation_decoder() |> decode.map(pair.new(http.Options, _)),
  )
  use head <- decodex.optional_field(
    "head",
    operation_decoder() |> decode.map(pair.new(http.Head, _)),
  )
  use patch <- decodex.optional_field(
    "patch",
    operation_decoder() |> decode.map(pair.new(http.Patch, _)),
  )
  use trace <- decodex.optional_field(
    "trace",
    operation_decoder() |> decode.map(pair.new(http.Trace, _)),
  )
  decode.success(PathItem(
    summary,
    description,
    parameters,
    [get, put, post, delete, options, head, patch, trace]
      |> list.filter_map(option.to_result(_, Nil)),
  ))
}

/// Holds a set of reusable objects for different aspects of the OAS.
/// All objects defined within the components object will have no effect on the API unless they are explicitly referenced from properties outside the components object.
pub type Components {
  Components(
    schemas: Dict(String, json_schema.Schema),
    responses: Dict(String, json_schema.Ref(Response)),
    parameters: Dict(String, json_schema.Ref(Parameter)),
    request_bodies: Dict(String, json_schema.Ref(RequestBody)),
  )
}

@internal
pub fn components_decoder() {
  use schemas <- decodex.default_field(
    "schemas",
    decode.dict(decode.string, json_schema.decoder()),
    dict.new(),
  )
  use responses <- decodex.default_field(
    "responses",
    decode.dict(decode.string, json_schema.ref_decoder(response_decoder())),
    dict.new(),
  )
  use parameters <- decodex.default_field(
    "parameters",
    decode.dict(decode.string, json_schema.ref_decoder(parameter_decoder())),
    dict.new(),
  )
  use request_bodies <- decodex.default_field(
    "requestBodies",
    decode.dict(decode.string, json_schema.ref_decoder(request_body_decoder())),
    dict.new(),
  )
  decode.success(Components(schemas, responses, parameters, request_bodies))
}

/// Describes a single operation parameter.
///
/// There are four possible parameter locations specified by the `in` field:
/// `path`, `query`, `header` and `cookie`.
/// A unique parameter is defined by a combination of a name and location.
pub type Parameter {
  QueryParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: json_schema.Ref(json_schema.Schema),
  )
  PathParameter(name: String, schema: json_schema.Ref(json_schema.Schema))
  HeaderParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: json_schema.Ref(json_schema.Schema),
  )
  CookieParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: json_schema.Ref(json_schema.Schema),
  )
}

fn parameter_decoder() {
  use in <- decode.field("in", decode.string)
  case in {
    "query" -> {
      use name <- decode.field("name", decode.string)
      use description <- decodex.optional_field("description", decode.string)
      use required <- decodex.default_field("required", decode.bool, False)
      use schema <- decode.field(
        "schema",
        json_schema.ref_decoder(json_schema.decoder()),
      )
      decode.success(QueryParameter(name, description, required, schema))
    }
    "header" -> {
      use name <- decode.field("name", decode.string)
      use description <- decodex.optional_field("description", decode.string)
      use required <- decodex.default_field("required", decode.bool, False)
      use schema <- decode.field(
        "schema",
        json_schema.ref_decoder(json_schema.decoder()),
      )
      decode.success(HeaderParameter(name, description, required, schema))
    }
    "path" -> {
      use name <- decode.field("name", decode.string)
      use schema <- decode.field(
        "schema",
        json_schema.ref_decoder(json_schema.decoder()),
      )
      decode.success(PathParameter(name, schema))
    }

    "cookie" -> {
      use name <- decode.field("name", decode.string)
      use description <- decodex.optional_field("description", decode.string)
      use required <- decodex.default_field("required", decode.bool, False)
      use schema <- decode.field(
        "schema",
        json_schema.ref_decoder(json_schema.decoder()),
      )
      decode.success(CookieParameter(name, description, required, schema))
    }
    _ ->
      decode.failure(
        PathParameter(
          "",
          json_schema.Inline(json_schema.Null(None, None, False)),
        ),
        "expected valid \"in\" field",
      )
  }
}

/// Describes a single API operation on a path.
pub type Operation {
  Operation(
    tags: List(String),
    summary: Option(String),
    description: Option(String),
    operation_id: String,
    parameters: List(json_schema.Ref(Parameter)),
    request_body: Option(json_schema.Ref(RequestBody)),
    responses: Dict(Status, json_schema.Ref(Response)),
  )
}

fn operation_decoder() {
  use tags <- decodex.default_field("tags", decode.list(decode.string), [])
  use summary <- decodex.optional_field("summary", decode.string)
  use description <- decodex.optional_field("description", decode.string)
  use operation_id <- decode.field("operationId", decode.string)
  use parameters <- decodex.default_field(
    "parameters",
    decode.list(json_schema.ref_decoder(parameter_decoder())),
    [],
  )
  use request_body <- decodex.optional_field(
    "requestBody",
    json_schema.ref_decoder(request_body_decoder()),
  )
  use responses <- decode.field(
    "responses",
    decode.dict(status_decoder(), json_schema.ref_decoder(response_decoder())),
  )
  decode.success(Operation(
    tags,
    summary,
    description,
    operation_id,
    parameters,
    request_body,
    responses,
  ))
}

/// Describes a single request body.
pub type RequestBody {
  RequestBody(
    description: Option(String),
    content: Dict(String, MediaType),
    required: Bool,
  )
}

fn request_body_decoder() {
  use description <- decodex.optional_field("description", decode.string)
  use content <- decode.field("content", content_decoder())
  use required <- decodex.default_field("required", decode.bool, False)
  decode.success(RequestBody(description, content, required))
}

fn content_decoder() {
  decode.dict(decode.string, media_type_decoder())
}

pub type Status {
  Default
  Status(Int)
}

fn status_decoder() {
  decode.new_primitive_decoder("default", fn(key) {
    case decode.run(key, decode.string) {
      Ok("default") -> Ok(Default)
      Ok(key) ->
        case int.parse(key) {
          Ok(i) -> Ok(Status(i))
          Error(Nil) -> Error(Default)
        }
      Error(_reason) -> Error(Default)
    }
  })
}

/// Describes a single response from an API Operation
pub type Response {
  Response(
    description: Option(String),
    headers: Dict(String, json_schema.Ref(Header)),
    content: Dict(String, MediaType),
  )
}

fn response_decoder() {
  use description <- decodex.optional_field("description", decode.string)
  use headers <- decodex.default_field(
    "headers",
    decode.dict(decode.string, json_schema.ref_decoder(header_decoder())),
    dict.new(),
  )
  use content <- decodex.default_field("content", content_decoder(), dict.new())
  decode.success(Response(description, headers, content))
}

pub type Header {
  Header(
    description: Option(String),
    required: Bool,
    schema: json_schema.Schema,
  )
}

fn header_decoder() {
  use description <- decodex.optional_field("description", decode.string)
  use required <- decodex.default_field("required", decode.bool, False)
  use schema <- decode.field("schema", json_schema.decoder())
  decode.success(Header(description, required, schema))
}

/// Each Media Type Object provides schema and examples for the media type identified by its key.
pub type MediaType {
  MediaType(schema: Option(json_schema.Ref(json_schema.Schema)))
}

fn media_type_decoder() {
  use schema <- decodex.optional_field(
    "schema",
    json_schema.ref_decoder(json_schema.decoder()),
  )
  decode.success(MediaType(schema))
}

// --------------------------------------------------------------------
// UTILS

pub type Segment {
  FixedSegment(content: String)
  MatchSegment(name: String, schema: json_schema.Schema)
}

fn get_parameter(parameters, key) {
  list.find(parameters, fn(p) {
    case p {
      PathParameter(name: name, ..) if name == key -> True
      _ -> False
    }
  })
}

pub fn query_parameters(parameters) {
  list.filter_map(parameters, fn(p) {
    case p {
      QueryParameter(name: n, required: r, schema: s, ..) -> Ok(#(n, r, s))
      _ -> Error(Nil)
    }
  })
}

pub fn gather_match(pattern, parameters, components: Components) {
  case path_template.parse(pattern) {
    Ok(segments) -> {
      list.try_map(segments, fn(segment) {
        case segment {
          path_template.Variable(label) -> {
            case get_parameter(parameters, label) {
              Ok(PathParameter(schema: schema, ..)) -> {
                let schema = fetch_schema(schema, components.schemas)
                Ok(MatchSegment(label, schema))
              }
              _ -> Error("Don't have a matching parameter for: " <> label)
            }
          }
          path_template.Fixed(name) -> Ok(FixedSegment(name))
        }
      })
    }
    _ -> Error("pattern must start with '/' and be valid url")
  }
}

pub fn fetch_schema(ref, schemas) {
  case ref {
    json_schema.Inline(schema) -> schema
    json_schema.Ref(ref: "#/components/schemas/" <> name, ..) -> {
      let assert Ok(schema) = dict.get(schemas, name)
      schema
    }
    json_schema.Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}

pub fn fetch_parameter(ref, parameters) {
  case ref {
    json_schema.Inline(parameter) -> parameter
    json_schema.Ref(ref: "#/components/parameters/" <> name, ..) -> {
      let assert Ok(json_schema.Inline(parameter)) = dict.get(parameters, name)
      parameter
    }
    json_schema.Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}

pub fn fetch_request_body(ref, request_bodies) {
  case ref {
    json_schema.Inline(request_body) -> request_body
    json_schema.Ref(ref: "#/components/requestBodies/" <> name, ..) -> {
      let assert Ok(json_schema.Inline(request_body)) =
        dict.get(request_bodies, name)
      request_body
    }
    json_schema.Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}

pub fn fetch_response(ref, responses) {
  case ref {
    json_schema.Inline(response) -> response
    json_schema.Ref(ref: "#/components/responses/" <> name, ..) -> {
      let assert Ok(json_schema.Inline(response)) = dict.get(responses, name)
      response
    }
    json_schema.Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}
