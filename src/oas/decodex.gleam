import gleam/dynamic/decode.{type Decoder}

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
