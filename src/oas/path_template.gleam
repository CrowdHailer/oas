import gleam/list
import gleam/string

pub type Segment {
  Fixed(String)
  Variable(String)
}

pub fn parse(raw) {
  case raw {
    "/" <> rest -> {
      let rest = drop_from(rest, "?")
      let rest = drop_from(rest, "#")
      string.split(rest, "/")
      |> list.try_map(parse_segment)
    }
    _ -> Error(Nil)
  }
}

fn parse_segment(raw) {
  case string.starts_with(raw, "{") && string.ends_with(raw, "}") {
    True -> {
      let variable =
        raw
        |> string.drop_start(1)
        |> string.drop_end(1)
      case contains_any(variable, ["{", "}"]) {
        True -> Error(Nil)
        False -> Ok(Variable(variable))
      }
    }
    False ->
      case contains_any(raw, ["{", "}"]) {
        True -> Error(Nil)
        False -> Ok(Fixed(raw))
      }
  }
}

fn contains_any(string, items) {
  list.any(items, string.contains(string, _))
}

fn drop_from(str, on) {
  case string.split_once(str, on) {
    Ok(#(before, _)) -> before
    Error(Nil) -> str
  }
}
