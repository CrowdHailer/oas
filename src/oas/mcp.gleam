import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/option.{type Option}
import oas
import oas/decodex
import oas/json_rpc
import oas/mcp/tool

pub fn request_decoder() {
  json_rpc.request_decoder(decoders(), Ping)
}

fn decoders() {
  [
    #("initialize", json_rpc.FromParams(initialize_decoder())),
    #("notifications/initialized", json_rpc.NoParams(Initialized)),
    #("tools/list", json_rpc.FromParams(list_tools_decoder())),
    #("tools/call", json_rpc.FromParams(call_tool_decoder())),
    #("resources/list", json_rpc.FromParams(list_resources_decoder())),
  ]
}

pub type Params {
  Initialize(
    protocol_version: String,
    capabilities: ClientCapabilities,
    // TODO client_info
  )
  Initialized
  ListTools(
    // cursor value is opaque
    cursor: Option(String),
  )
  ListResources(
    // cursor value is opaque
    cursor: Option(String),
  )
  CallTool(name: String, arguments: Dynamic)
  Ping
}

fn initialize_decoder() {
  use protocol_version <- decode.field("protocolVersion", decode.string)
  use capabilities <- decode.field(
    "capabilities",
    client_capabilities_decoder(),
  )
  decode.success(Initialize(protocol_version, capabilities))
}

pub type ClientCapabilities {
  ClientCapabilities(list_changeds: Bool)
}

pub fn client_capabilities_decoder() {
  // TODO parse
  decode.success(ClientCapabilities(True))
}

pub type InitializeResult {
  InitializeResult(
    protocol_version: String,
    capabilities: ServerCapabilities,
    server_info: Implementation,
  )
}

pub fn encode_initialize_result(result) {
  let InitializeResult(protocol_version:, capabilities:, server_info:) = result
  json.object([
    #("protocolVersion", json.string(protocol_version)),
    #("capabilities", encode_server_capabilities(capabilities)),
    #("serverInfo", encode_implementation(server_info)),
  ])
}

pub type ServerCapabilities {
  ServerCapabilities(tools: Dict(String, Bool), resources: Resources)
}

fn encode_server_capabilities(capabilities) {
  let ServerCapabilities(tools:, resources:) = capabilities
  json.object([
    #("tools", json.dict(tools, fn(id) { id }, json.bool)),
    #("resources", encode_resources(resources)),
  ])
}

pub type Resources {
  Resources(subscribe: Bool, list_changes: Bool)
}

fn encode_resources(resources) {
  let Resources(subscribe:, list_changes:) = resources
  json.object([
    #("subscribe", json.bool(subscribe)),
    #("listChanges", json.bool(list_changes)),
  ])
}

// Called implementation in spec not ServerInfo
pub type Implementation {
  Implementation(name: String, title: String, version: String)
}

pub fn encode_implementation(implementation) {
  let Implementation(name:, title:, version:) = implementation
  json.object([
    #("name", json.string(name)),
    #("title", json.string(title)),
    #("version", json.string(version)),
  ])
}

fn list_tools_decoder() {
  use cursor <- oas.optional_field("cursor", decode.string)
  decode.success(ListTools(cursor))
}

pub type ListToolsResult {
  ListToolsResult(tools: List(tool.Tool), next_cursor: Option(String))
}

pub fn list_tools_result_decoder() {
  use tools <- decode.field("tools", decode.list(tool.decoder()))
  use next_cursor <- oas.optional_field("next_cursor", decode.string)
  decode.success(ListToolsResult(tools, next_cursor))
}

pub fn encode_list_tools_result(result) {
  let ListToolsResult(tools:, next_cursor:) = result
  json.object([
    #("tools", json.array(tools, tool.encode)),
    #("next_cursor", json.nullable(next_cursor, json.string)),
  ])
}

fn call_tool_decoder() {
  use name <- decode.field("name", decode.string)
  use arguments <- decode.field("arguments", decodex.any())
  decode.success(CallTool(name, arguments))
}

pub type CallToolResult {
  Structured(data: Json)
}

pub fn encode_call_tool_result(result) {
  let Structured(data:) = result
  json.object([
    #(
      "content",
      json.array([json.to_string(data)], fn(text) {
        json.object([
          #("type", json.string("text")),
          #("text", json.string(text)),
        ])
      }),
    ),
    #("structuredContent", data),
    #("isError", json.bool(False)),
  ])
}

fn list_resources_decoder() {
  use cursor <- oas.optional_field("cursor", decode.string)
  decode.success(ListResources(cursor))
}

pub type ListResourcesResult {
  ListResourcesResult(
    resources: List(resource.Resource),
    next_cursor: Option(String),
  )
}

pub fn list_resources_result_decoder() {
  use resources <- decode.field("resources", decode.list(tool.decoder()))
  use next_cursor <- oas.optional_field("next_cursor", decode.string)
  decode.success(ListToolsResult(resources, next_cursor))
}

pub fn encode_list_resources_result(result) {
  let ListResourcesResult(resources:, next_cursor:) = result
  json.object([
    #("resources", json.array(resources, tool.encode)),
    #("next_cursor", json.nullable(next_cursor, json.string)),
  ])
}
