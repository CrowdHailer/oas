import gleam/dynamic/decode.{type Decoder}
import gleam/option.{None}

pub fn default_field(key, decoder, default, k) {
  decode.optional_field(
    key,
    default,
    decode.optional(decoder) |> decode.map(option.unwrap(_, or: default)),
    k,
  )
}

pub fn optional_field(key, decoder, k) {
  decode.optional_field(key, None, decode.optional(decoder), k)
}

pub fn discriminate(
  field: name,
  decoder: Decoder(d),
  default: t,
  choose: fn(d) -> Result(Decoder(t), String),
) -> Decoder(t) {
  use on <- decode.optional_field(
    field,
    decode.failure(default, "Discriminator"),
    decode.map(decoder, fn(on) {
      case choose(on) {
        Ok(decoder) -> decoder
        Error(message) -> decode.failure(default, message)
      }
    }),
  )
  on
}

pub fn any() {
  decode.new_primitive_decoder("any", Ok)
}
