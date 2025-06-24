# oas

Parse an open api (previously swagger) spec.

[![Package Version](https://img.shields.io/hexpm/v/oas)](https://hex.pm/packages/oas)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/oas/)

```sh
gleam add oas@1
```

The `oas` library provides a decoder that is designed to be used with JSON or YAML.

```gleam
import gleam/json
import oas

pub fn main() {
  let raw = todo as "some schema content"
  let result = json.decode(raw, oas.decoder)
  case result {
    Ok(oas.Document(paths: paths, components: components, ..)) -> {
      // use oas spec
    }
    Error(_) -> panic as "could not decode"
  }
}
```

Further documentation can be found at <https://hexdocs.pm/oas>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Missing features

The following have not been present in the API's I have worked with.
Notably security is usually described in human readable language as part of API docs.

Contributions to add these are welcome. They will not require a breaking change to upgrade so I am committing to a 1.0 release

- Webhooks
- external docs
- security schemas

## Notes

### Nullability

OpenAPI 3.0.x was build on "JSON Schema Specification Wright Draft 00"
The OpenAPI spec defines a `nullable` field on all schema data types.
As an extension to the JSON Schema draft.

OpenAPI 3.1.x uses "https://tools.ietf.org/html/draft-bhutton-json-schema-validation-00#section-6.1.1"
This version of the spec allows lists of types in the data model.
A nullable type should be represented by `"type": ["null", "string"]`

While `nullable` is not needed it is still supported for backwards compatability.
Several specs still exist on 3.0.x versions, for example githubs.

**OAS supports parsing lists for the `type` only if it contains one item or two items where one is null.**

### Nullable and not required

To create full fidelity with the API such a field should have a type of `Option(Option(T))`
In most cases there is no value exposing this to the users.

The one API where it is worth exposing is if posting to an endpoint with patch semantics.
A missing field indicates no change. A present field with value of null means set the field to null.

### Boolean JSON schemas
https://json-schema.org/draft/2020-12/json-schema-core#section-4.3.2

A schema value of `true` is equivalent to an empty schema `{}` and will always validate.
A schema value of `false` is equivalent to a schema that will never validate.

These "types" are decoded as `oas.AlwayPasses` and `oas.AlwaysFails` respectively.

### Additional properties

> Omitting this keyword has the same assertion behavior as an empty schema.

So if this value is not set it is the same as having a value of always passes

## Credit

Created for [EYG](https://eyg.run/), a new integration focused programming language.