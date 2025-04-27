import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/http
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result.{try}
import gleam/string

fn default_field(key, decoder, default) {
  optional_field(key, decoder)
  |> with_default(default)
}

fn optional_field(key, decoder) {
  fn(raw) {
    let decoder = dynamic.optional_field(key, dynamic.optional(decoder))
    use decoded <- try(decoder(raw))
    case decoded {
      Some(Some(value)) -> Some(value)
      _ -> None
    }
    |> Ok
  }
}

fn with_default(decoder, value) {
  fn(raw) {
    use decoded <- try(decoder(raw))
    Ok(option.unwrap(decoded, value))
  }
}

fn add_to_decode_error_path(
  error: dynamic.DecodeError,
  path: String,
) -> dynamic.DecodeError {
  dynamic.DecodeError(..error, path: list.append(error.path, [path]))
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

pub fn decoder(top) {
  dynamic.decode6(
    Document,
    dynamic.field("openapi", dynamic.string),
    dynamic.field("info", info_decoder),
    optional_field("jsonSchemaDialect", dynamic.string),
    default_field("servers", dynamic.list(server_decoder), []),
    default_field("paths", paths_decoder, dict.new()),
    default_field(
      "components",
      components_decoder,
      Components(dict.new(), dict.new(), dict.new(), dict.new()),
    ),
  )(top)
}

/// Node in the Specification that might be represented by a reference.
pub type Ref(t) {
  Ref(ref: String, summary: Option(String), description: Option(String))
  Inline(value: t)
}

fn ref_decoder(of: dynamic.Decoder(t)) -> dynamic.Decoder(Ref(t)) {
  dynamic.any([
    dynamic.decode3(
      Ref,
      dynamic.field("$ref", dynamic.string),
      optional_field("summary", dynamic.string),
      optional_field("description", dynamic.string),
    ),
    dynamic.decode1(Inline, of),
  ])
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

fn info_decoder(raw) {
  dynamic.decode7(
    Info,
    dynamic.field("title", dynamic.string),
    optional_field("summary", dynamic.string),
    optional_field("description", dynamic.string),
    optional_field("termsOfService", dynamic.string),
    optional_field("contact", contact_decoder),
    optional_field("license", license_decoder),
    dynamic.field("version", dynamic.string),
  )(raw)
}

/// Contact information for the exposed API.
pub type Contact {
  Contact(name: Option(String), url: Option(String), email: Option(String))
}

fn contact_decoder(raw) {
  dynamic.decode3(
    Contact,
    optional_field("name", dynamic.string),
    optional_field("url", dynamic.string),
    optional_field("email", dynamic.string),
  )(raw)
}

/// License information for the exposed API.
pub type Licence {
  Licence(name: String, identifier: Option(String), url: Option(String))
}

fn license_decoder(raw) {
  dynamic.decode3(
    Licence,
    dynamic.field("name", dynamic.string),
    optional_field("identifier", dynamic.string),
    optional_field("url", dynamic.string),
  )(raw)
}

/// An object representing a Server.
pub type Server {
  Server(
    url: String,
    description: Option(String),
    variables: Dict(String, ServerVariable),
  )
}

fn server_decoder(raw) {
  dynamic.decode3(
    Server,
    dynamic.field("url", dynamic.string),
    optional_field("description", dynamic.string),
    default_field(
      "variables",
      dynamic.dict(dynamic.string, server_variable_decoder),
      dict.new(),
    ),
  )(raw)
}

/// An object representing a Server Variable for server URL template substitution.
pub type ServerVariable {
  ServerVariable(
    enum: List(String),
    default: String,
    description: Option(String),
  )
}

fn server_variable_decoder(raw) {
  dynamic.decode3(
    ServerVariable,
    dynamic.field("enum", dynamic.list(dynamic.string)),
    dynamic.field("default", dynamic.string),
    optional_field("description", dynamic.string),
  )(raw)
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

fn paths_decoder(raw) {
  dynamic.dict(dynamic.string, path_decoder)(raw)
}

fn path_decoder(raw) {
  dynamic.decode4(
    PathItem,
    optional_field("summary", dynamic.string),
    optional_field("description", dynamic.string),
    default_field(
      "parameters",
      dynamic.list(ref_decoder(parameter_decoder)),
      [],
    ),
    fn(raw) {
      use maybe_operations <- try(
        [
          #("get", http.Get),
          #("put", http.Put),
          #("post", http.Post),
          #("delete", http.Delete),
          #("options", http.Options),
          #("head", http.Head),
          #("patch", http.Patch),
          #("trace", http.Trace),
        ]
        |> list.map(fn(lookup) {
          let #(key, method) = lookup
          use maybe <- try(dynamic.optional_field(key, operation_decoder)(raw))
          Ok(#(method, maybe))
        })
        |> result.all(),
      )
      list.filter_map(maybe_operations, fn(maybe) {
        let #(method, maybe) = maybe
        case maybe {
          option.Some(value) -> Ok(#(method, value))
          option.None -> Error(Nil)
        }
      })
      |> Ok
    },
  )(raw)
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
pub fn components_decoder(raw) {
  dynamic.decode4(
    Components,
    default_field("schemas", dictionary_decoder(schema_decoder), dict.new()),
    default_field(
      "responses",
      dynamic.dict(dynamic.string, ref_decoder(response_decoder)),
      dict.new(),
    ),
    default_field(
      "parameters",
      dynamic.dict(dynamic.string, ref_decoder(parameter_decoder)),
      dict.new(),
    ),
    default_field(
      "requestBodies",
      dynamic.dict(dynamic.string, ref_decoder(request_body_decoder)),
      dict.new(),
    ),
  )(raw)
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

fn parameter_decoder(raw) {
  dynamic.any([
    dynamic.field("in", fn(field) {
      use in <- try(dynamic.string(field))
      case in {
        "query" -> {
          dynamic.decode4(
            QueryParameter,
            dynamic.field("name", dynamic.string),
            dynamic.optional_field("description", dynamic.string),
            dynamic.optional_field("required", dynamic.bool)
              |> with_default(False),
            dynamic.field("schema", ref_decoder(schema_decoder)),
          )(raw)
        }
        "header" -> {
          dynamic.decode4(
            HeaderParameter,
            dynamic.field("name", dynamic.string),
            dynamic.optional_field("description", dynamic.string),
            dynamic.optional_field("required", dynamic.bool)
              |> with_default(False),
            dynamic.field("schema", ref_decoder(schema_decoder)),
          )(raw)
        }
        "path" ->
          dynamic.decode2(
            PathParameter,
            dynamic.field("name", dynamic.string),
            dynamic.field("schema", ref_decoder(schema_decoder)),
          )(raw)

        "cookie" ->
          dynamic.decode4(
            HeaderParameter,
            dynamic.field("name", dynamic.string),
            dynamic.optional_field("description", dynamic.string),
            dynamic.optional_field("required", dynamic.bool)
              |> with_default(False),
            dynamic.field("schema", ref_decoder(schema_decoder)),
          )(raw)
        _ -> Error([dynamic.DecodeError("valid in field", in, [])])
      }
    }),
  ])(raw)
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

fn operation_decoder(raw) {
  dynamic.decode7(
    Operation,
    default_field("tags", dynamic.list(dynamic.string), []),
    optional_field("summary", dynamic.string),
    optional_field("description", dynamic.string),
    dynamic.field("operationId", dynamic.string),
    default_field(
      "parameters",
      dynamic.list(ref_decoder(parameter_decoder)),
      [],
    ),
    optional_field("requestBody", ref_decoder(request_body_decoder)),
    dynamic.field(
      "responses",
      dynamic.dict(status_decoder, ref_decoder(response_decoder)),
    ),
  )(raw)
}

/// Describes a single request body.
pub type RequestBody {
  RequestBody(
    description: Option(String),
    content: Dict(String, MediaType),
    required: Bool,
  )
}

fn request_body_decoder(raw) {
  dynamic.decode3(
    RequestBody,
    dynamic.optional_field("description", dynamic.string),
    dynamic.field("content", content_decoder),
    default_field("required", dynamic.bool, False),
  )(raw)
}

fn content_decoder(raw) {
  dynamic.dict(dynamic.string, media_type_decoder)(raw)
}

pub type Status {
  Default
  Status(Int)
}

fn status_decoder(raw) {
  use key <- try(dynamic.string(raw))
  case key {
    "default" -> Ok(Default)
    key ->
      case int.parse(key) {
        Ok(i) -> Ok(Status(i))
        Error(Nil) -> Error([dynamic.DecodeError("integer", key, [])])
      }
  }
}

/// Describes a single response from an API Operation
pub type Response {
  Response(
    description: Option(String),
    headers: Dict(String, Ref(Header)),
    content: Dict(String, MediaType),
  )
}

fn response_decoder(raw) {
  dynamic.decode3(
    Response,
    optional_field("description", dynamic.string),
    default_field(
      "headers",
      dynamic.dict(dynamic.string, ref_decoder(decode_header)),
      dict.new(),
    ),
    default_field("content", content_decoder, dict.new()),
  )(raw)
}

pub type Header {
  Header(description: Option(String), required: Bool, schema: Schema)
}

fn decode_header(raw) {
  dynamic.decode3(
    Header,
    dynamic.optional_field("description", dynamic.string),
    dynamic.optional_field("required", dynamic.bool)
      |> with_default(False),
    dynamic.field("schema", schema_decoder),
  )(raw)
}

/// Each Media Type Object provides schema and examples for the media type identified by its key.
pub type MediaType {
  MediaType(schema: Ref(Schema))
}

fn media_type_decoder(raw) {
  dynamic.decode1(
    MediaType,
    dynamic.field("schema", ref_decoder(schema_decoder)),
  )(raw)
}

/// Represents a decoded JSON schema.
/// 
/// Chosen not to support additional properties
/// Chosen to add metadata inline as it doesn't belong on ref object
/// https://json-schema.org/draft/2020-12/json-schema-validation#name-a-vocabulary-for-basic-meta
pub type Schema {
  Boolean(title: Option(String), description: Option(String), deprecated: Bool)
  Integer(
    multiple_of: Option(Int),
    maximum: Option(Int),
    exclusive_maximum: Option(Int),
    minimum: Option(Int),
    exclusive_minimum: Option(Int),
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
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  Object(
    properties: Dict(String, Ref(Schema)),
    required: List(String),
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  AllOf(List(Ref(Dict(String, Ref(Schema)))))
  AnyOf(List(Ref(Schema)))
  OneOf(List(Ref(Schema)))
}

fn dictionary_decoder(value_decoder) {
  fn(raw) {
    dynamic.dict(dynamic.string, dynamic.dynamic)(raw)
    |> result.then(fn(dict_with_dyn) {
      dict.fold(
        over: dict_with_dyn,
        from: Ok(dict.new()),
        with: fn(acc, key, value) {
          case acc {
            Error(errors) -> Error(errors)
            Ok(dict) -> {
              case value_decoder(value) {
                Ok(schema) -> Ok(dict.insert(dict, key, schema))
                Error(errors) -> {
                  Error(list.map(errors, add_to_decode_error_path(_, key)))
                }
              }
            }
          }
        },
      )
    })
  }
}

fn schema_decoder(raw) {
  dynamic.any([
    dynamic.field("type", fn(field) {
      use type_ <- try(dynamic.string(field))
      case type_ {
        "boolean" ->
          dynamic.decode3(
            Boolean,
            decode_title,
            decode_description,
            decode_deprecated,
          )(raw)
        "integer" ->
          dynamic.decode8(
            Integer,
            optional_field("multipleOf", dynamic.int),
            optional_field("maximum", dynamic.int),
            optional_field("exclusiveMaximum", dynamic.int),
            optional_field("minimum", dynamic.int),
            optional_field("exclusiveMinimum", dynamic.int),
            decode_title,
            decode_description,
            decode_deprecated,
          )(raw)
        "number" ->
          dynamic.decode8(
            Number,
            optional_field("multipleOf", dynamic.int),
            optional_field("maximum", dynamic.int),
            optional_field("exclusiveMaximum", dynamic.int),
            optional_field("minimum", dynamic.int),
            optional_field("exclusiveMinimum", dynamic.int),
            decode_title,
            decode_description,
            decode_deprecated,
          )(raw)
        "string" ->
          dynamic.decode7(
            String,
            optional_field("maxLength", dynamic.int),
            optional_field("minLength", dynamic.int),
            optional_field("pattern", dynamic.string),
            optional_field("format", dynamic.string),
            decode_title,
            decode_description,
            decode_deprecated,
          )(raw)
        "null" ->
          dynamic.decode3(
            Null,
            decode_title,
            decode_description,
            decode_deprecated,
          )(raw)
        "array" -> {
          dynamic.decode7(
            Array,
            optional_field("maxItems", dynamic.int),
            optional_field("minItems", dynamic.int),
            default_field("uniqueItems", dynamic.bool, False),
            dynamic.field("items", ref_decoder(schema_decoder)),
            decode_title,
            decode_description,
            decode_deprecated,
          )(raw)
        }
        "object" -> decode_object(raw)
        _ -> {
          Error([dynamic.DecodeError("json type", type_, [])])
        }
      }
    }),
    dynamic.field(
      "allOf",
      dynamic.decode1(AllOf, dynamic.list(ref_decoder(decode_properties))),
    ),
    dynamic.field(
      "anyOf",
      dynamic.decode1(AnyOf, dynamic.list(ref_decoder(schema_decoder))),
    ),
    dynamic.field(
      "oneOf",
      dynamic.decode1(OneOf, dynamic.list(ref_decoder(schema_decoder))),
    ),
  ])(raw)
}

fn decode_object(raw) {
  dynamic.decode5(
    Object,
    decode_properties,
    decode_required,
    decode_title,
    decode_description,
    decode_deprecated,
  )(raw)
}

fn decode_properties(raw) {
  default_field(
    "properties",
    dictionary_decoder(ref_decoder(schema_decoder)),
    dict.new(),
  )(raw)
}

fn decode_required(raw) {
  default_field("required", dynamic.list(dynamic.string), [])(raw)
}

fn decode_title(raw) {
  optional_field("title", dynamic.string)(raw)
}

fn decode_description(raw) {
  optional_field("description", dynamic.string)(raw)
}

fn decode_deprecated(raw) {
  default_field("deprecated", dynamic.bool, False)(raw)
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
  case pattern {
    "/" <> pattern -> {
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
              _ -> Error(Nil)
            }
          }
          name -> Ok(FixedSegment(name))
        }
      })
    }
    _ -> Error(Nil)
  }
}

pub fn fetch_schema(ref, schemas) {
  case ref {
    Inline(schema) -> schema
    Ref(ref: "#/components/schemas/" <> name, ..) -> {
      let assert Ok(schema) = dict.get(schemas, name)
      schema
    }
    Ref(ref: ref, ..) -> {
      io.debug(ref)
      panic as "not valid ref"
    }
  }
}

pub fn fetch_parameter(ref, parameters) {
  case ref {
    Inline(parameter) -> parameter
    Ref(ref: "#/components/parameters/" <> name, ..) -> {
      let assert Ok(Inline(parameter)) = dict.get(parameters, name)
      parameter
    }
    Ref(ref: ref, ..) -> {
      io.debug(ref)
      panic as "not valid ref"
    }
  }
}

pub fn fetch_request_body(ref, request_bodies) {
  case ref {
    Inline(request_body) -> request_body
    Ref(ref: "#/components/requestBodies/" <> name, ..) -> {
      let assert Ok(Inline(request_body)) = dict.get(request_bodies, name)
      request_body
    }
    Ref(ref: ref, ..) -> {
      io.debug(ref)
      panic as "not valid ref"
    }
  }
}

pub fn fetch_response(ref, responses) {
  case ref {
    Inline(response) -> response
    Ref(ref: "#/components/responses/" <> name, ..) -> {
      let assert Ok(Inline(response)) = dict.get(responses, name)
      response
    }
    Ref(ref: ref, ..) -> {
      io.debug(ref)
      panic as "not valid ref"
    }
  }
}
