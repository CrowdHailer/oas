import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/list
import gleam/option.{type Option, None}
import gleam/pair
import gleam/string
import gleam/uri.{Uri}

fn default_field(key, decoder, default, k) {
  decode.optional_field(
    key,
    default,
    decode.optional(decoder) |> decode.map(option.unwrap(_, or: default)),
    k,
  )
}

fn optional_field(key, decoder, k) {
  decode.optional_field(key, None, decode.optional(decoder), k)
}

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
  use json_schema_dialect <- optional_field("jsonSchemaDialect", decode.string)
  use servers <- default_field("servers", decode.list(server_decoder()), [])
  use paths <- default_field("paths", paths_decoder(), dict.new())
  use components <- default_field(
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

/// Node in the Specification that might be represented by a reference.
pub type Ref(t) {
  Ref(ref: String, summary: Option(String), description: Option(String))
  Inline(value: t)
}

fn ref_decoder(of: decode.Decoder(t)) -> decode.Decoder(Ref(t)) {
  decode.one_of(
    {
      use ref <- decode.field("$ref", decode.string)
      use summary <- optional_field("summary", decode.string)
      use description <- optional_field("description", decode.string)
      decode.success(Ref(ref, summary, description))
    },
    [decode.map(of, Inline)],
  )
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
  use summary <- optional_field("summary", decode.string)
  use description <- optional_field("description", decode.string)
  use terms_of_service <- optional_field("termsOfService", decode.string)
  use contact <- optional_field("contact", contact_decoder())
  use license <- optional_field("license", license_decoder())
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
  use name <- optional_field("name", decode.string)
  use url <- optional_field("url", decode.string)
  use email <- optional_field("email", decode.string)
  decode.success(Contact(name, url, email))
}

/// License information for the exposed API.
pub type Licence {
  Licence(name: String, identifier: Option(String), url: Option(String))
}

fn license_decoder() {
  use name <- decode.field("name", decode.string)
  use identifier <- optional_field("identifier", decode.string)
  use url <- optional_field("url", decode.string)
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
  use description <- optional_field("description", decode.string)
  use variables <- default_field(
    "variables",
    decode.dict(decode.string, server_variable_decoder()),
    dict.new(),
  )
  decode.success(Server(url, description, variables))
}

/// An object representing a Server Variable for server URL template substitution.
pub type ServerVariable {
  ServerVariable(
    enum: List(String),
    default: String,
    description: Option(String),
  )
}

fn server_variable_decoder() {
  use enum <- decode.field("enum", decode.list(decode.string))
  use default <- decode.field("default", decode.string)
  use description <- optional_field("description", decode.string)
  decode.success(ServerVariable(enum, default, description))
}

/// Describes the operations available on a single path.
pub type PathItem {
  PathItem(
    summary: Option(String),
    description: Option(String),
    parameters: List(Ref(Parameter)),
    operations: List(#(http.Method, Operation)),
  )
}

fn paths_decoder() {
  decode.dict(decode.string, path_decoder())
}

fn path_decoder() {
  use summary <- optional_field("summary", decode.string)
  use description <- optional_field("description", decode.string)
  use parameters <- default_field(
    "parameters",
    decode.list(ref_decoder(parameter_decoder())),
    [],
  )
  use get <- optional_field(
    "get",
    operation_decoder() |> decode.map(pair.new(http.Get, _)),
  )
  use put <- optional_field(
    "put",
    operation_decoder() |> decode.map(pair.new(http.Put, _)),
  )
  use post <- optional_field(
    "post",
    operation_decoder() |> decode.map(pair.new(http.Post, _)),
  )
  use delete <- optional_field(
    "delete",
    operation_decoder() |> decode.map(pair.new(http.Delete, _)),
  )
  use options <- optional_field(
    "options",
    operation_decoder() |> decode.map(pair.new(http.Options, _)),
  )
  use head <- optional_field(
    "head",
    operation_decoder() |> decode.map(pair.new(http.Head, _)),
  )
  use patch <- optional_field(
    "patch",
    operation_decoder() |> decode.map(pair.new(http.Patch, _)),
  )
  use trace <- optional_field(
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
    schemas: Dict(String, Schema),
    responses: Dict(String, Ref(Response)),
    parameters: Dict(String, Ref(Parameter)),
    request_bodies: Dict(String, Ref(RequestBody)),
  )
}

@internal
pub fn components_decoder() {
  use schemas <- default_field(
    "schemas",
    decode.dict(decode.string, schema_decoder()),
    dict.new(),
  )
  use responses <- default_field(
    "responses",
    decode.dict(decode.string, ref_decoder(response_decoder())),
    dict.new(),
  )
  use parameters <- default_field(
    "parameters",
    decode.dict(decode.string, ref_decoder(parameter_decoder())),
    dict.new(),
  )
  use request_bodies <- default_field(
    "requestBodies",
    decode.dict(decode.string, ref_decoder(request_body_decoder())),
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
    schema: Ref(Schema),
  )
  PathParameter(name: String, schema: Ref(Schema))
  HeaderParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: Ref(Schema),
  )
  CookieParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: Ref(Schema),
  )
}

fn parameter_decoder() {
  use in <- decode.field("in", decode.string)
  case in {
    "query" -> {
      use name <- decode.field("name", decode.string)
      use description <- optional_field("description", decode.string)
      use required <- default_field("required", decode.bool, False)
      use schema <- decode.field("schema", ref_decoder(schema_decoder()))
      decode.success(QueryParameter(name, description, required, schema))
    }
    "header" -> {
      use name <- decode.field("name", decode.string)
      use description <- optional_field("description", decode.string)
      use required <- default_field("required", decode.bool, False)
      use schema <- decode.field("schema", ref_decoder(schema_decoder()))
      decode.success(HeaderParameter(name, description, required, schema))
    }
    "path" -> {
      use name <- decode.field("name", decode.string)
      use schema <- decode.field("schema", ref_decoder(schema_decoder()))
      decode.success(PathParameter(name, schema))
    }

    "cookie" -> {
      use name <- decode.field("name", decode.string)
      use description <- optional_field("description", decode.string)
      use required <- default_field("required", decode.bool, False)
      use schema <- decode.field("schema", ref_decoder(schema_decoder()))
      decode.success(CookieParameter(name, description, required, schema))
    }
    _ ->
      decode.failure(
        PathParameter("", Inline(Null(None, None, False))),
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
    parameters: List(Ref(Parameter)),
    request_body: Option(Ref(RequestBody)),
    responses: Dict(Status, Ref(Response)),
  )
}

fn operation_decoder() {
  use tags <- default_field("tags", decode.list(decode.string), [])
  use summary <- optional_field("summary", decode.string)
  use description <- optional_field("description", decode.string)
  use operation_id <- decode.field("operationId", decode.string)
  use parameters <- default_field(
    "parameters",
    decode.list(ref_decoder(parameter_decoder())),
    [],
  )
  use request_body <- optional_field(
    "requestBody",
    ref_decoder(request_body_decoder()),
  )
  use responses <- decode.field(
    "responses",
    decode.dict(status_decoder(), ref_decoder(response_decoder())),
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
  use description <- optional_field("description", decode.string)
  use content <- decode.field("content", content_decoder())
  use required <- default_field("required", decode.bool, False)
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
    headers: Dict(String, Ref(Header)),
    content: Dict(String, MediaType),
  )
}

fn response_decoder() {
  use description <- optional_field("description", decode.string)
  use headers <- default_field(
    "headers",
    decode.dict(decode.string, ref_decoder(header_decoder())),
    dict.new(),
  )
  use content <- default_field("content", content_decoder(), dict.new())
  decode.success(Response(description, headers, content))
}

pub type Header {
  Header(description: Option(String), required: Bool, schema: Schema)
}

fn header_decoder() {
  use description <- optional_field("description", decode.string)
  use required <- default_field("required", decode.bool, False)
  use schema <- decode.field("schema", schema_decoder())
  decode.success(Header(description, required, schema))
}

/// Each Media Type Object provides schema and examples for the media type identified by its key.
pub type MediaType {
  MediaType(schema: Ref(Schema))
}

fn media_type_decoder() {
  use schema <- decode.field("schema", ref_decoder(schema_decoder()))
  decode.success(MediaType(schema))
}

/// Represents a decoded JSON schema.
/// 
/// Chosen not to support additional properties
/// Chosen to add metadata inline as it doesn't belong on ref object
/// https://json-schema.org/draft/2020-12/json-schema-validation#name-a-vocabulary-for-basic-meta
pub type Schema {
  Boolean(
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  Integer(
    multiple_of: Option(Int),
    maximum: Option(Int),
    exclusive_maximum: Option(Int),
    minimum: Option(Int),
    exclusive_minimum: Option(Int),
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  Number(
    multiple_of: Option(Int),
    maximum: Option(Int),
    exclusive_maximum: Option(Int),
    minimum: Option(Int),
    exclusive_minimum: Option(Int),
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  String(
    max_length: Option(Int),
    min_length: Option(Int),
    pattern: Option(String),
    // There is an enum of accepted formats but it is extended by OAS spec.
    format: Option(String),
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  Null(title: Option(String), description: Option(String), deprecated: Bool)
  Array(
    max_items: Option(Int),
    min_items: Option(Int),
    unique_items: Bool,
    items: Ref(Schema),
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  Object(
    properties: Dict(String, Ref(Schema)),
    required: List(String),
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  AllOf(List(Ref(Dict(String, Ref(Schema)))))
  AnyOf(List(Ref(Schema)))
  OneOf(List(Ref(Schema)))
  AlwaysPasses
  AlwaysFails
}

fn properties_decoder() {
  default_field(
    "properties",
    decode.dict(decode.string, ref_decoder(schema_decoder())),
    dict.new(),
    decode.success,
  )
}

fn schema_decoder() {
  use <- decode.recursive()
  decode.one_of(
    {
      use #(type_, nullable_decoder) <- decode.field(
        "type",
        decode.one_of(
          decode.string
            |> decode.map(fn(type_) { #(type_, nullable_decoder()) }),
          [
            decode.list(decode.string)
            |> decode.then(fn(types) {
              case types {
                [type_] -> decode.success(#(type_, nullable_decoder()))
                ["null", type_] | [type_, "null"] ->
                  decode.success(#(type_, decode.success(True)))
                _ -> decode.failure(#("null", nullable_decoder()), "Type")
              }
            }),
          ],
        ),
      )
      case type_ {
        "boolean" -> {
          use nullable <- decode.then(nullable_decoder)
          use title <- decode.then(title_decoder())
          use description <- decode.then(description_decoder())
          use deprecated <- decode.then(deprecated_decoder())
          decode.success(Boolean(nullable, title, description, deprecated))
        }
        "integer" -> {
          use multiple_of <- optional_field("multipleOf", decode.int)
          use maximum <- optional_field("maximum", decode.int)
          use exclusive_maximum <- optional_field(
            "exclusiveMaximum",
            decode.int,
          )
          use minimum <- optional_field("minimum", decode.int)
          use exclusive_minimum <- optional_field(
            "exclusiveMinimum",
            decode.int,
          )
          use nullable <- decode.then(nullable_decoder)
          use title <- decode.then(title_decoder())
          use description <- decode.then(description_decoder())
          use deprecated <- decode.then(deprecated_decoder())
          decode.success(Integer(
            multiple_of,
            maximum,
            exclusive_maximum,
            minimum,
            exclusive_minimum,
            nullable,
            title,
            description,
            deprecated,
          ))
        }
        "number" -> {
          use multiple_of <- optional_field("multipleOf", decode.int)
          use maximum <- optional_field("maximum", decode.int)
          use exclusive_maximum <- optional_field(
            "exclusiveMaximum",
            decode.int,
          )
          use minimum <- optional_field("minimum", decode.int)
          use exclusive_minimum <- optional_field(
            "exclusiveMinimum",
            decode.int,
          )
          use nullable <- decode.then(nullable_decoder)
          use title <- decode.then(title_decoder())
          use description <- decode.then(description_decoder())
          use deprecated <- decode.then(deprecated_decoder())
          decode.success(Number(
            multiple_of,
            maximum,
            exclusive_maximum,
            minimum,
            exclusive_minimum,
            nullable,
            title,
            description,
            deprecated,
          ))
        }

        "string" -> {
          use max_length <- optional_field("maxLength", decode.int)
          use min_length <- optional_field("minLength", decode.int)
          use pattern <- optional_field("pattern", decode.string)
          use format <- optional_field("format", decode.string)
          use nullable <- decode.then(nullable_decoder)
          use title <- decode.then(title_decoder())
          use description <- decode.then(description_decoder())
          use deprecated <- decode.then(deprecated_decoder())
          decode.success(String(
            max_length,
            min_length,
            pattern,
            format,
            nullable,
            title,
            description,
            deprecated,
          ))
        }

        "null" -> {
          use title <- decode.then(title_decoder())
          use description <- decode.then(description_decoder())
          use deprecated <- decode.then(deprecated_decoder())
          decode.success(Null(title, description, deprecated))
        }
        "array" -> {
          {
            use max_items <- optional_field("maxItems", decode.int)
            use min_items <- optional_field("minItems", decode.int)
            use unique_items <- default_field("uniqueItems", decode.bool, False)
            use items <- decode.field("items", ref_decoder(schema_decoder()))
            use nullable <- decode.then(nullable_decoder)
            use title <- decode.then(title_decoder())
            use description <- decode.then(description_decoder())
            use deprecated <- decode.then(deprecated_decoder())
            decode.success(Array(
              max_items,
              min_items,
              unique_items,
              items,
              nullable,
              title,
              description,
              deprecated,
            ))
          }
        }
        "object" -> {
          use properties <- decode.then(properties_decoder())
          use required <- decode.then(required_decoder())
          use nullable <- decode.then(nullable_decoder)
          use title <- decode.then(title_decoder())
          use description <- decode.then(description_decoder())
          use deprecated <- decode.then(deprecated_decoder())
          decode.success(Object(
            properties,
            required,
            nullable,
            title,
            description,
            deprecated,
          ))
        }
        _ -> decode.failure(Null(None, None, False), "Json data type")
      }
    },
    [
      decode.field(
        "allOf",
        decode.list(ref_decoder(properties_decoder())) |> decode.map(AllOf),
        decode.success,
      ),
      decode.field(
        "anyOf",
        decode.list(ref_decoder(schema_decoder())) |> decode.map(AnyOf),
        decode.success,
      ),
      decode.field(
        "oneOf",
        decode.list(ref_decoder(schema_decoder())) |> decode.map(OneOf),
        decode.success,
      ),
      decode.bool
        |> decode.map(fn(b) {
          case b {
            True -> AlwaysPasses
            False -> AlwaysFails
          }
        }),
      decode.dict(decode.string, decode.string)
        |> decode.map(fn(d) {
          case d == dict.new() {
            True -> AlwaysPasses
            False -> AlwaysFails
          }
        }),
    ],
  )
}

fn required_decoder() {
  default_field("required", decode.list(decode.string), [], decode.success)
}

fn nullable_decoder() {
  default_field("nullable", decode.bool, False, decode.success)
}

fn title_decoder() {
  optional_field("title", decode.string, decode.success)
}

fn description_decoder() {
  optional_field("description", decode.string, decode.success)
}

fn deprecated_decoder() {
  default_field("deprecated", decode.bool, False, decode.success)
}

// --------------------------------------------------------------------
// UTILS

pub type Segment {
  FixedSegment(content: String)
  MatchSegment(name: String, schema: Schema)
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
  case uri.parse(pattern) {
    Ok(Uri(path: "/" <> pattern, ..)) -> {
      string.split(pattern, "/")
      |> list.try_map(fn(segment) {
        case segment {
          "{" <> rest -> {
            let label = string.drop_end(rest, 1)
            case get_parameter(parameters, label) {
              Ok(PathParameter(schema: schema, ..)) -> {
                let schema = fetch_schema(schema, components.schemas)
                Ok(MatchSegment(label, schema))
              }
              _ -> Error("Don't have a matching parameter for: " <> label)
            }
          }
          name -> Ok(FixedSegment(name))
        }
      })
    }
    _ -> Error("pattern must start with '/' and be valid url")
  }
}

pub fn fetch_schema(ref, schemas) {
  case ref {
    Inline(schema) -> schema
    Ref(ref: "#/components/schemas/" <> name, ..) -> {
      let assert Ok(schema) = dict.get(schemas, name)
      schema
    }
    Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}

pub fn fetch_parameter(ref, parameters) {
  case ref {
    Inline(parameter) -> parameter
    Ref(ref: "#/components/parameters/" <> name, ..) -> {
      let assert Ok(Inline(parameter)) = dict.get(parameters, name)
      parameter
    }
    Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}

pub fn fetch_request_body(ref, request_bodies) {
  case ref {
    Inline(request_body) -> request_body
    Ref(ref: "#/components/requestBodies/" <> name, ..) -> {
      let assert Ok(Inline(request_body)) = dict.get(request_bodies, name)
      request_body
    }
    Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}

pub fn fetch_response(ref, responses) {
  case ref {
    Inline(response) -> response
    Ref(ref: "#/components/responses/" <> name, ..) -> {
      let assert Ok(Inline(response)) = dict.get(responses, name)
      response
    }
    Ref(ref: ref, ..) -> panic as { "not a valid ref" <> ref }
  }
}
