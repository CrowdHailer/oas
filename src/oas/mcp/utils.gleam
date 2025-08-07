// import gleam/bit_array
// import gleam/http/request
// import gleam/javascript/array
import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/list

// import gleam/option

pub type Never {
  Never(Never)
}

// pub fn set_method(request, method) {
//   request.set_method(request, method)
// }

// pub fn append_path(request, path) {
//   request.set_path(request, request.path <> path)
// }

// pub fn set_query(request, query) {
//   let query =
//     list.filter_map(query, fn(q) {
//       let #(k, v) = q
//       case v {
//         option.Some(v) -> Ok(#(k, v))
//         option.None -> Error(Nil)
//       }
//     })
//   case query {
//     [] -> request
//     _ -> request.set_query(request, query)
//   }
// }

// pub fn set_body(request, mime, content) {
//   request
//   |> request.prepend_header("content-type", mime)
//   |> request.set_body(content)
// }

// pub fn json_to_bits(json) {
//   json
//   |> json.to_string
//   |> bit_array.from_string
// }

pub fn dict(dict, values) {
  json.dict(dict, fn(x) { x }, values)
}

// @external(javascript, "../netlify_ffi.mjs", "merge")
// fn do_merge(items: array.Array(json.Json)) -> json.Json

// pub fn merge(items) {
//   todo
//   // do_merge(array.from_list(items))
// }

pub fn decode_additional(except, decoder, next) {
  todo as "decode additional"
}

pub fn object(entries: List(#(String, json.Json))) {
  list.filter(entries, fn(entry) {
    let #(_, v) = entry
    v != json.null()
  })
  |> json.object
}

pub fn dynamic_to_json() {
  {
    use <- decode.recursive
    decode.one_of(
      decode.dict(decode.string, dynamic_to_json())
        |> decode.map(fn(data) {
          let entries = dict.to_list(data)
          json.object(entries)
        }),
      [
        decode.optional(decode.string)
          |> decode.map(json.nullable(_, json.string)),
        decode.bool |> decode.map(json.bool),
        decode.int |> decode.map(json.int),
        decode.float |> decode.map(json.float),
        decode.list(dynamic_to_json()) |> decode.map(json.array(_, fn(x) { x })),
      ],
    )
  }
}
