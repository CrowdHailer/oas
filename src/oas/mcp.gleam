import gleam/dynamic/decode
import oas/json_rpc
import oas/mcp/messages

pub fn request_decoder() {
  json_rpc.request_decoder(decoders(), Ping)
}

fn decoders() {
  [
    #(
      "initialize",
      json_rpc.FromParams(
        messages.initialize_request_decoder() |> decode.map(Initialize),
      ),
    ),
    #("notifications/initialized", json_rpc.NoParams(Initialized)),
    #(
      "tools/list",
      json_rpc.FromParams(
        messages.list_tools_request_decoder() |> decode.map(ListTools),
      ),
    ),
    #(
      "tools/call",
      json_rpc.FromParams(
        messages.call_tool_request_decoder() |> decode.map(CallTool),
      ),
    ),
    #(
      "resources/list",
      json_rpc.FromParams(
        messages.list_resources_request_decoder() |> decode.map(ListResources),
      ),
    ),
    #("prompts/list", json_rpc.NoParams(ListPrompts)),
  ]
}

pub type Params {
  Initialize(messages.InitializeRequest)
  Initialized
  ListTools(messages.ListToolsRequest)
  CallTool(messages.CallToolRequest)
  ListResources(messages.ListResourcesRequest)
  ListPrompts
  Ping
}
