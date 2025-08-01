import gleam/json
import gleam/option.{type Option}

pub type Prompt {
  Prompt
}

pub fn encode(resource) {
  let Prompt = resource
  json.object([])
}
