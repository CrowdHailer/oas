import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import non_empty_list.{type NonEmptyList, NonEmptyList}
import oas/decodex
import oas/generator/utils

/// Node in the Specification that might be represented by a reference.
pub type Ref(t) {
  Ref(ref: String, summary: Option(String), description: Option(String))
  Inline(value: t)
}

pub fn ref_decoder(of: decode.Decoder(t)) -> decode.Decoder(Ref(t)) {
  decode.one_of(
    {
      use ref <- decode.field("$ref", decode.string)
      use summary <- decodex.optional_field("summary", decode.string)
      use description <- decodex.optional_field("description", decode.string)
      decode.success(Ref(ref, summary, description))
    },
    [decode.map(of, Inline)],
  )
}

/// Represents a decoded JSON schema.
/// 
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
    additional_properties: Option(Ref(Schema)),
    max_properties: Option(Int),
    // "Omitting this keyword has the same behavior as a value of 0"
    min_properties: Int,
    nullable: Bool,
    title: Option(String),
    description: Option(String),
    deprecated: Bool,
  )
  AllOf(NonEmptyList(Ref(Schema)))
  AnyOf(NonEmptyList(Ref(Schema)))
  OneOf(NonEmptyList(Ref(Schema)))
  Enum(NonEmptyList(utils.Any))
  AlwaysPasses
  AlwaysFails
}

fn properties_decoder() {
  decodex.default_field(
    "properties",
    decode.dict(decode.string, ref_decoder(decoder())),
    dict.new(),
    decode.success,
  )
}

fn type_decoder() {
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
          _ -> decode.failure(#("", nullable_decoder()), "Type")
        }
      }),
    ],
  )
}

pub fn decoder() {
  use <- decode.recursive()
  decode.one_of(
    {
      use #(type_, nullable_decoder) <- decodex.discriminate(
        "type",
        type_decoder(),
        Null(None, None, False),
      )
      case type_ {
        "boolean" ->
          {
            use nullable <- decode.then(nullable_decoder)
            use title <- decode.then(title_decoder())
            use description <- decode.then(description_decoder())
            use deprecated <- decode.then(deprecated_decoder())
            decode.success(Boolean(nullable, title, description, deprecated))
          }
          |> Ok
        "integer" ->
          {
            use multiple_of <- decodex.optional_field("multipleOf", decode.int)
            use maximum <- decodex.optional_field("maximum", decode.int)
            use exclusive_maximum <- decodex.optional_field(
              "exclusiveMaximum",
              decode.int,
            )
            use minimum <- decodex.optional_field("minimum", decode.int)
            use exclusive_minimum <- decodex.optional_field(
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
          |> Ok
        "number" ->
          {
            use multiple_of <- decodex.optional_field("multipleOf", decode.int)
            use maximum <- decodex.optional_field("maximum", decode.int)
            use exclusive_maximum <- decodex.optional_field(
              "exclusiveMaximum",
              decode.int,
            )
            use minimum <- decodex.optional_field("minimum", decode.int)
            use exclusive_minimum <- decodex.optional_field(
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
          |> Ok

        "string" ->
          {
            use max_length <- decodex.optional_field("maxLength", decode.int)
            use min_length <- decodex.optional_field("minLength", decode.int)
            use pattern <- decodex.optional_field("pattern", decode.string)
            use format <- decodex.optional_field("format", decode.string)
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
          |> Ok

        "null" ->
          {
            use title <- decode.then(title_decoder())
            use description <- decode.then(description_decoder())
            use deprecated <- decode.then(deprecated_decoder())
            decode.success(Null(title, description, deprecated))
          }
          |> Ok
        "array" ->
          {
            {
              use max_items <- decodex.optional_field("maxItems", decode.int)
              use min_items <- decodex.optional_field("minItems", decode.int)
              use unique_items <- decodex.default_field(
                "uniqueItems",
                decode.bool,
                False,
              )
              use items <- decode.field("items", ref_decoder(decoder()))
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
          |> Ok
        "object" ->
          {
            use properties <- decode.then(properties_decoder())
            use required <- decode.then(required_decoder())
            use additional_properties <- decodex.optional_field(
              "additionalProperties",
              ref_decoder(decoder()),
            )
            use max_properties <- decodex.optional_field(
              "maxProperties",
              decode.int,
            )
            // "Omitting this keyword has the same behavior as a value of 0"
            use min_properties <- decodex.default_field(
              "minProperties",
              decode.int,
              0,
            )
            use nullable <- decode.then(nullable_decoder)
            use title <- decode.then(title_decoder())
            use description <- decode.then(description_decoder())
            use deprecated <- decode.then(deprecated_decoder())
            decode.success(Object(
              properties,
              required,
              additional_properties,
              max_properties,
              min_properties,
              nullable,
              title,
              description,
              deprecated,
            ))
          }
          |> Ok
        type_ -> Error("valid schema type got: " <> type_)
      }
    },
    [
      decode.field(
        "allOf",
        non_empty_list_of_schema_decoder() |> decode.map(AllOf),
        decode.success,
      ),
      decode.field(
        "anyOf",
        non_empty_list_of_schema_decoder() |> decode.map(AnyOf),
        decode.success,
      ),
      decode.field(
        "oneOf",
        non_empty_list_of_schema_decoder() |> decode.map(OneOf),
        decode.success,
      ),
      decode.field(
        "enum",
        non_empty_list_of_any_decoder() |> decode.map(Enum),
        decode.success,
      ),
      decode.field(
        "const",
        utils.any_decoder()
          |> decode.map(fn(value) { Enum(non_empty_list.single(value)) }),
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

fn non_empty_list_of_schema_decoder() {
  use list <- decode.then(decode.list(ref_decoder(decoder())))
  case list {
    [] -> decode.failure(NonEmptyList(Inline(AlwaysFails), []), "")
    [a, ..rest] -> decode.success(NonEmptyList(a, rest))
  }
}

fn non_empty_list_of_any_decoder() {
  use list <- decode.then(decode.list(utils.any_decoder()))
  case list {
    [] -> decode.failure(NonEmptyList(utils.Null, []), "")
    [a, ..rest] -> decode.success(NonEmptyList(a, rest))
  }
}

fn required_decoder() {
  decodex.default_field(
    "required",
    decode.list(decode.string),
    [],
    decode.success,
  )
}

fn nullable_decoder() {
  decodex.default_field("nullable", decode.bool, False, decode.success)
}

fn title_decoder() {
  decodex.optional_field("title", decode.string, decode.success)
}

fn description_decoder() {
  decodex.optional_field("description", decode.string, decode.success)
}

fn deprecated_decoder() {
  decodex.default_field("deprecated", decode.bool, False, decode.success)
}

pub fn boolean() {
  Boolean(nullable: False, title: None, description: None, deprecated: False)
}

pub fn integer() {
  Integer(
    multiple_of: None,
    maximum: None,
    exclusive_maximum: None,
    minimum: None,
    exclusive_minimum: None,
    nullable: False,
    title: None,
    description: None,
    deprecated: False,
  )
}

pub fn number() {
  Number(
    multiple_of: None,
    maximum: None,
    exclusive_maximum: None,
    minimum: None,
    exclusive_minimum: None,
    nullable: False,
    title: None,
    description: None,
    deprecated: False,
  )
}

pub fn string() {
  String(
    max_length: None,
    min_length: None,
    pattern: None,
    format: None,
    nullable: False,
    title: None,
    description: None,
    deprecated: False,
  )
}

pub fn object(properties) {
  let #(properties, required) =
    list.fold(properties, #(dict.new(), []), fn(acc, property) {
      let #(properties, all_required) = acc
      let #(key, schema, is_required) = property
      let all_required = case is_required {
        True -> [key, ..all_required]
        False -> all_required
      }
      let properties = dict.insert(properties, key, schema)
      #(properties, all_required)
    })
  Object(
    properties:,
    required:,
    additional_properties: None,
    max_properties: None,
    min_properties: 0,
    nullable: False,
    title: None,
    description: None,
    deprecated: False,
  )
}

pub fn enum_of_strings(strings) {
  Enum(non_empty_list.map(strings, utils.String))
}

pub fn field(key, schema) {
  #(key, Inline(schema), True)
}

pub fn optional_field(key, schema) {
  #(key, Inline(schema), False)
}

pub fn encode(schema) {
  case schema {
    Boolean(nullable:, title:, description:, deprecated:) ->
      json_object([
        #("type", Some(json.string("boolean"))),
        #("nullable", Some(json.bool(nullable))),
        #("title", option.map(title, json.string)),
        #("description", option.map(description, json.string)),
        #("deprecated", Some(json.bool(deprecated))),
      ])
    Integer(..) as int -> {
      json_object([
        #("type", Some(json.string("integer"))),
        #("multipleOf", option.map(int.multiple_of, json.int)),
        #("maximum", option.map(int.maximum, json.int)),
        #("exclusiveMaximum", option.map(int.exclusive_maximum, json.int)),
        #("minimum", option.map(int.minimum, json.int)),
        #("exclusiveMinimum", option.map(int.exclusive_minimum, json.int)),
        #("nullable", Some(json.bool(int.nullable))),
        #("title", option.map(int.title, json.string)),
        #("description", option.map(int.description, json.string)),
        #("deprecated", Some(json.bool(int.deprecated))),
      ])
    }
    Number(..) as number -> {
      json_object([
        #("type", Some(json.string("number"))),
        #("multipleOf", option.map(number.multiple_of, json.int)),
        #("maximum", option.map(number.maximum, json.int)),
        #("exclusiveMaximum", option.map(number.exclusive_maximum, json.int)),
        #("minimum", option.map(number.minimum, json.int)),
        #("exclusiveMinimum", option.map(number.exclusive_minimum, json.int)),
        #("nullable", Some(json.bool(number.nullable))),
        #("title", option.map(number.title, json.string)),
        #("description", option.map(number.description, json.string)),
        #("deprecated", Some(json.bool(number.deprecated))),
      ])
    }
    String(..) as string -> {
      json_object([
        #("type", Some(json.string("string"))),
        #("MaxLength", option.map(string.max_length, json.int)),
        #("MinLength", option.map(string.min_length, json.int)),
        #("Pattern", option.map(string.pattern, json.string)),
        #("Format", option.map(string.format, json.string)),
        #("nullable", Some(json.bool(string.nullable))),
        #("title", option.map(string.title, json.string)),
        #("description", option.map(string.description, json.string)),
        #("deprecated", Some(json.bool(string.deprecated))),
      ])
    }
    Null(..) as null -> {
      json_object([
        #("type", Some(json.string("null"))),
        #("title", option.map(null.title, json.string)),
        #("description", option.map(null.description, json.string)),
        #("deprecated", Some(json.bool(null.deprecated))),
      ])
    }
    Array(..) as array -> {
      json_object([
        #("type", Some(json.string("array"))),
        #("maxItems", option.map(array.max_items, json.int)),
        #("minItems", option.map(array.min_items, json.int)),
        #("uniqueItems", Some(json.bool(array.unique_items))),
        #("items", Some(ref_encode(array.items))),
        #("nullable", Some(json.bool(array.nullable))),
        #("title", option.map(array.title, json.string)),
        #("description", option.map(array.description, json.string)),
        #("deprecated", Some(json.bool(array.deprecated))),
      ])
    }
    Object(..) as object -> {
      json_object([
        #("type", Some(json.string("object"))),
        #(
          "properties",
          Some(json.dict(object.properties, fn(x) { x }, ref_encode)),
        ),
        #(
          "additionalProperties",
          option.map(object.additional_properties, ref_encode),
        ),
        #("maxProperties", option.map(object.max_properties, json.int)),
        #("minProperties", Some(json.int(object.min_properties))),
        #("required", Some(json.array(object.required, json.string))),
        #("nullable", Some(json.bool(object.nullable))),
        #("title", option.map(object.title, json.string)),
        #("description", option.map(object.description, json.string)),
        #("deprecated", Some(json.bool(object.deprecated))),
      ])
    }
    AllOf(varients) -> {
      json_object([
        #(
          "allOf",
          Some(json.array(non_empty_list.to_list(varients), ref_encode)),
        ),
      ])
    }
    AnyOf(varients) -> {
      json_object([
        #(
          "anyOf",
          Some(json.array(non_empty_list.to_list(varients), ref_encode)),
        ),
      ])
    }
    OneOf(varients) -> {
      json_object([
        #(
          "oneOf",
          Some(json.array(non_empty_list.to_list(varients), ref_encode)),
        ),
      ])
    }
    Enum(non_empty_list.NonEmptyList(value, [])) ->
      json_object([#("const", Some(utils.any_to_json(value)))])
    Enum(values) -> {
      let values = non_empty_list.to_list(values)
      json_object([#("enum", Some(json.array(values, utils.any_to_json)))])
    }
    AlwaysPasses -> json.bool(True)
    AlwaysFails -> json.bool(False)
  }
}

fn ref_encode(ref) {
  case ref {
    Inline(schema) -> encode(schema)
    Ref(reference, ..) -> json.object([#("$ref", json.string(reference))])
  }
}

fn json_object(properties) {
  list.filter_map(properties, fn(property) {
    let #(key, value) = property
    case value {
      Some(value) -> Ok(#(key, value))
      None -> Error(Nil)
    }
  })
  |> json.object
}
