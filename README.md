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

## Credit

Created for [EYG](https://eyg.run/), a new integration focused programming language.