import gleam/dict
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import non_empty_list
import oas
import oas/generator/utils

pub fn boolean() {
  oas.Boolean(
    nullable: False,
    title: None,
    description: None,
    deprecated: False,
  )
}

pub fn integer() {
  oas.Integer(
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
  oas.Number(
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
  oas.String(
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
  oas.Object(
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

pub fn field(key, schema) {
  #(key, oas.Inline(schema), True)
}

pub fn optional_field(key, schema) {
  #(key, oas.Inline(schema), False)
}

pub fn encode(schema) {
  case schema {
    oas.Boolean(nullable:, title:, description:, deprecated:) ->
      json_object([
        #("type", Some(json.string("boolean"))),
        #("nullable", Some(json.bool(nullable))),
        #("title", option.map(title, json.string)),
        #("description", option.map(description, json.string)),
        #("deprecated", Some(json.bool(deprecated))),
      ])
    oas.Integer(..) as int -> {
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
    oas.Number(..) as number -> {
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
    oas.String(..) as string -> {
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
    oas.Null(..) as null -> {
      json_object([
        #("type", Some(json.string("null"))),
        #("title", option.map(null.title, json.string)),
        #("description", option.map(null.description, json.string)),
        #("deprecated", Some(json.bool(null.deprecated))),
      ])
    }
    oas.Array(..) as array -> {
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
    oas.Object(..) as object -> {
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
    oas.AllOf(varients) -> {
      json_object([
        #(
          "allOf",
          Some(json.array(non_empty_list.to_list(varients), ref_encode)),
        ),
      ])
    }
    oas.AnyOf(varients) -> {
      json_object([
        #(
          "anyOf",
          Some(json.array(non_empty_list.to_list(varients), ref_encode)),
        ),
      ])
    }
    oas.OneOf(varients) -> {
      json_object([
        #(
          "oneOf",
          Some(json.array(non_empty_list.to_list(varients), ref_encode)),
        ),
      ])
    }
    oas.AlwaysPasses -> json.bool(True)
    oas.AlwaysFails -> json.bool(False)
  }
}

fn ref_encode(ref) {
  case ref {
    oas.Inline(schema) -> encode(schema)
    oas.Ref(reference, ..) -> json.object([#("$ref", json.string(reference))])
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

pub fn to_any(schema) {
  case schema {
    oas.Boolean(nullable:, title:, description:, deprecated:) ->
      any_object([
        #("type", Some(utils.String("boolean"))),
        #("nullable", Some(utils.Boolean(nullable))),
        #("title", option.map(title, utils.String)),
        #("description", option.map(description, utils.String)),
        #("deprecated", Some(utils.Boolean(deprecated))),
      ])
    oas.Integer(..) as int -> {
      any_object([
        #("type", Some(utils.String("integer"))),
        #("multipleOf", option.map(int.multiple_of, utils.Integer)),
        #("maximum", option.map(int.maximum, utils.Integer)),
        #("exclusiveMaximum", option.map(int.exclusive_maximum, utils.Integer)),
        #("minimum", option.map(int.minimum, utils.Integer)),
        #("exclusiveMinimum", option.map(int.exclusive_minimum, utils.Integer)),
        #("nullable", Some(utils.Boolean(int.nullable))),
        #("title", option.map(int.title, utils.String)),
        #("description", option.map(int.description, utils.String)),
        #("deprecated", Some(utils.Boolean(int.deprecated))),
      ])
    }
    oas.Number(..) as number -> {
      any_object([
        #("type", Some(utils.String("number"))),
        #("multipleOf", option.map(number.multiple_of, utils.Integer)),
        #("maximum", option.map(number.maximum, utils.Integer)),
        #(
          "exclusiveMaximum",
          option.map(number.exclusive_maximum, utils.Integer),
        ),
        #("minimum", option.map(number.minimum, utils.Integer)),
        #(
          "exclusiveMinimum",
          option.map(number.exclusive_minimum, utils.Integer),
        ),
        #("nullable", Some(utils.Boolean(number.nullable))),
        #("title", option.map(number.title, utils.String)),
        #("description", option.map(number.description, utils.String)),
        #("deprecated", Some(utils.Boolean(number.deprecated))),
      ])
    }
    oas.String(..) as string -> {
      any_object([
        #("type", Some(utils.String("string"))),
        #("MaxLength", option.map(string.max_length, utils.Integer)),
        #("MinLength", option.map(string.min_length, utils.Integer)),
        #("Pattern", option.map(string.pattern, utils.String)),
        #("Format", option.map(string.format, utils.String)),
        #("nullable", Some(utils.Boolean(string.nullable))),
        #("title", option.map(string.title, utils.String)),
        #("description", option.map(string.description, utils.String)),
        #("deprecated", Some(utils.Boolean(string.deprecated))),
      ])
    }
    oas.Null(..) as null -> {
      any_object([
        #("type", Some(utils.String("null"))),
        #("title", option.map(null.title, utils.String)),
        #("description", option.map(null.description, utils.String)),
        #("deprecated", Some(utils.Boolean(null.deprecated))),
      ])
    }
    oas.Array(..) as array -> {
      any_object([
        #("type", Some(utils.String("array"))),
        #("maxItems", option.map(array.max_items, utils.Integer)),
        #("minItems", option.map(array.min_items, utils.Integer)),
        #("uniqueItems", Some(utils.Boolean(array.unique_items))),
        #("items", Some(ref_to_any(array.items))),
        #("nullable", Some(utils.Boolean(array.nullable))),
        #("title", option.map(array.title, utils.String)),
        #("description", option.map(array.description, utils.String)),
        #("deprecated", Some(utils.Boolean(array.deprecated))),
      ])
    }
    oas.Object(..) as object -> {
      any_object([
        #("type", Some(utils.String("object"))),
        #(
          "properties",
          Some(utils.Object(
            object.properties |> dict.map_values(fn(_, v) { ref_to_any(v) }),
          )),
        ),
        #(
          "additionalProperties",
          option.map(object.additional_properties, ref_to_any),
        ),
        #("maxProperties", option.map(object.max_properties, utils.Integer)),
        #("minProperties", Some(utils.Integer(object.min_properties))),
        #(
          "required",
          Some(utils.Array(list.map(object.required, utils.String))),
        ),
        #("nullable", Some(utils.Boolean(object.nullable))),
        #("title", option.map(object.title, utils.String)),
        #("description", option.map(object.description, utils.String)),
        #("deprecated", Some(utils.Boolean(object.deprecated))),
      ])
    }
    oas.AllOf(varients) -> {
      any_object([
        #(
          "allOf",
          Some(
            utils.Array(list.map(non_empty_list.to_list(varients), ref_to_any)),
          ),
        ),
      ])
    }
    oas.AnyOf(varients) -> {
      any_object([
        #(
          "anyOf",
          Some(
            utils.Array(list.map(non_empty_list.to_list(varients), ref_to_any)),
          ),
        ),
      ])
    }
    oas.OneOf(varients) -> {
      any_object([
        #(
          "oneOf",
          Some(
            utils.Array(list.map(non_empty_list.to_list(varients), ref_to_any)),
          ),
        ),
      ])
    }
    oas.AlwaysPasses -> utils.Boolean(True)
    oas.AlwaysFails -> utils.Boolean(False)
  }
}

fn ref_to_any(ref) {
  case ref {
    oas.Inline(schema) -> to_any(schema)
    oas.Ref(reference, ..) ->
      utils.Object(dict.from_list([#("$ref", utils.String(reference))]))
  }
}

fn any_object(properties) {
  list.filter_map(properties, fn(property) {
    let #(key, value) = property
    case value {
      Some(value) -> Ok(#(key, value))
      None -> Error(Nil)
    }
  })
  |> dict.from_list
  |> utils.Object
}
