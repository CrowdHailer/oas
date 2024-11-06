import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/http
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result.{try}
import gleam/string

/// This is the root object of the OpenAPI document.
pub type Document {
  Document(
    version: String,
    info: Info,
    paths: Dict(String, PathItem),
    components: Components,
  )
}

pub fn decoder(top) {
  dynamic.decode4(
    Document,
    dynamic.field("openapi", dynamic.string),
    dynamic.field("info", info_decoder),
    dynamic.field("paths", paths_decoder(_, top)),
    dynamic.field("components", components_decoder(_, top)),
  )(top)
}

/// The object provides metadata about the API. The metadata MAY be used by the clients if needed, and MAY be presented in editing or documentation generation tools for convenience.
pub type Info {
  Info(version: String)
}

fn info_decoder(raw) {
  dynamic.decode1(Info, dynamic.field("version", dynamic.string))(raw)
}

/// Describes the operations available on a single path. 
pub type PathItem {
  PathItem(
    summary: Option(String),
    description: Option(String),
    parameters: List(Parameter),
    operations: List(#(http.Method, Operation)),
  )
}

fn paths_decoder(raw, top) {
  dynamic.dict(dynamic.string, path_decoder(_, top))(raw)
}

fn path_decoder(raw, top) {
  use maybe_parameters <- try(dynamic.optional_field(
    "parameters",
    dynamic.list(parameter_decoder(_, top)),
  )(raw))
  let parameters = option.unwrap(maybe_parameters, [])
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
      use maybe <- try(dynamic.optional_field(key, operation_decoder(_, top))(
        raw,
      ))
      Ok(#(method, maybe))
    })
    |> result.all(),
  )
  let operations =
    list.filter_map(maybe_operations, fn(maybe) {
      let #(method, maybe) = maybe
      case maybe {
        option.Some(value) -> Ok(#(method, value))
        option.None -> Error(Nil)
      }
    })
  use summary <- try(dynamic.optional_field("summary", dynamic.string)(raw))
  use description <- try(dynamic.optional_field("description", dynamic.string)(
    raw,
  ))
  Ok(PathItem(summary, description, parameters, operations))
}

pub type Components {
  Components(schemas: Dict(String, Schema))
}

fn components_decoder(raw, top) {
  dynamic.decode1(
    Components,
    dynamic.field(
      "schemas",
      dynamic.dict(dynamic.string, schema_decoder(_, top)),
    ),
  )(raw)
}

pub type Parameter {
  QueryParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: Schema,
  )
  PathParameter(name: String, schema: Schema)
  HeaderParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: Schema,
  )
  CookieParameter(
    name: String,
    description: Option(String),
    required: Bool,
    schema: Schema,
  )
}

fn parameter_decoder(raw, top) {
  use content <- try(follow_if_ref(raw, top))
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
            dynamic.field("schema", schema_decoder(_, top)),
          )(content)
        }
        "header" -> {
          dynamic.decode4(
            HeaderParameter,
            dynamic.field("name", dynamic.string),
            dynamic.optional_field("description", dynamic.string),
            dynamic.optional_field("required", dynamic.bool)
              |> with_default(False),
            dynamic.field("schema", schema_decoder(_, top)),
          )(content)
        }
        "path" ->
          dynamic.decode2(
            PathParameter,
            dynamic.field("name", dynamic.string),
            dynamic.field("schema", schema_decoder(_, top)),
          )(content)

        "cookie" ->
          dynamic.decode4(
            HeaderParameter,
            dynamic.field("name", dynamic.string),
            dynamic.optional_field("description", dynamic.string),
            dynamic.optional_field("required", dynamic.bool)
              |> with_default(False),
            dynamic.field("schema", schema_decoder(_, top)),
          )(content)
        _ -> Error([dynamic.DecodeError("valid in field", in, [])])
      }
    }),
  ])(content)
}

pub type Operation {
  Operation(
    tags: List(String),
    summary: Option(String),
    description: Option(String),
    operation_id: String,
    parameters: List(Parameter),
    request_body: Option(RequestBody),
    responses: Dict(Status, Response),
  )
}

fn operation_decoder(raw, top) {
  dynamic.decode7(
    Operation,
    dynamic.field("tags", dynamic.list(dynamic.string)),
    dynamic.optional_field("summary", dynamic.string),
    dynamic.optional_field("description", dynamic.string),
    dynamic.field("operationId", dynamic.string),
    fn(raw) {
      use maybe_parameters <- try(dynamic.optional_field(
        "parameters",
        dynamic.list(parameter_decoder(_, top)),
      )(raw))
      let parameters = option.unwrap(maybe_parameters, [])
      Ok(parameters)
    },
    dynamic.optional_field("requestBody", request_body_decoder(_, top)),
    dynamic.field(
      "responses",
      dynamic.dict(status_decoder, response_decoder(_, top)),
    ),
  )(raw)
}

pub type RequestBody {
  RequestBody(
    description: Option(String),
    content: Dict(String, MediaType),
    required: Bool,
  )
}

fn request_body_decoder(raw, top) {
  use content <- try(follow_if_ref(raw, top))
  dynamic.decode3(
    RequestBody,
    dynamic.optional_field("description", dynamic.string),
    dynamic.field("content", content_decoder(_, top)),
    dynamic.optional_field("required", dynamic.bool)
      |> with_default(False),
  )(content)
}

fn content_decoder(raw, top) {
  dynamic.dict(dynamic.string, media_type_decoder(_, top))(raw)
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

pub type Response {
  Response(
    description: String,
    headers: Dict(String, Header),
    content: Option(Dict(String, MediaType)),
  )
}

fn response_decoder(raw, top) {
  use content <- try(follow_if_ref(raw, top))
  dynamic.decode3(
    Response,
    dynamic.field("description", dynamic.string),
    fn(raw) {
      use headers <- try(dynamic.optional_field(
        "headers",
        dynamic.dict(dynamic.string, decode_header(_, top)),
      )(raw))
      Ok(option.unwrap(headers, dict.new()))
    },
    dynamic.optional_field("content", content_decoder(_, top)),
  )(content)
}

pub type Header {
  Header(description: Option(String), required: Bool, schema: Schema)
}

fn decode_header(raw, top) {
  use content <- try(follow_if_ref(raw, top))
  dynamic.decode3(
    Header,
    dynamic.optional_field("description", dynamic.string),
    dynamic.optional_field("required", dynamic.bool)
      |> with_default(False),
    dynamic.field("schema", schema_decoder(_, top)),
  )(content)
}

pub type MediaType {
  MediaType(schema: Schema)
}

fn media_type_decoder(raw, top) {
  dynamic.decode1(MediaType, dynamic.field("schema", schema_decoder(_, top)))(
    raw,
  )
}

pub type Schema {
  Boolean
  Integer
  Number
  String
  Array(Schema)
  Object(properties: Dict(String, Schema))
}

fn schema_decoder(raw, top) {
  use content <- try(follow_if_ref(raw, top))
  dynamic.any([
    dynamic.field("type", fn(field) {
      use type_ <- try(dynamic.string(field))
      case type_ {
        "boolean" -> Ok(Boolean)
        "integer" -> Ok(Integer)
        "number" -> Ok(Number)
        "string" -> Ok(String)
        "array" -> {
          use items <- try(dynamic.field("items", schema_decoder(_, top))(
            content,
          ))
          Ok(Array(items))
        }
        "object" -> decode_object(content, top)
        _ -> Error([dynamic.DecodeError("json type", type_, [])])
      }
    }),
    dynamic.field("allOf", fn(raw) {
      use elements <- try(
        dynamic.list(fn(raw) {
          use content <- try(follow_if_ref(raw, top))
          decode_properties(content, top)
        })(raw),
      )

      let assert Ok(properties) = list.reduce(elements, dict.merge)
      Ok(Object(properties))
    }),
  ])(content)
}

fn decode_object(raw, top) {
  dynamic.decode1(Object, decode_properties(_, top))(raw)
}

fn decode_properties(raw, top) {
  use properties <- try(dynamic.optional_field(
    "properties",
    dynamic.dict(dynamic.string, schema_decoder(_, top)),
  )(raw))
  Ok(option.unwrap(properties, dict.new()))
}

fn follow_path(path, top) {
  list.try_fold(path, top, fn(spec, item) { dynamic.field(item, Ok)(spec) })
}

fn follow_if_ref(raw, top) {
  case dynamic.field("$ref", dynamic.string)(raw) {
    Ok(ref) -> {
      let path = string.split(ref, "/")
      case path {
        ["#", ..path] -> {
          let assert Ok(spec) = follow_path(path, top)
          Ok(spec)
        }
        _ -> Error([dynamic.DecodeError("local ref path", ref, [])])
      }
    }
    Error(_) -> Ok(raw)
  }
}

fn with_default(decoder, value) {
  fn(raw) {
    use decoded <- try(decoder(raw))
    Ok(option.unwrap(decoded, value))
  }
}
