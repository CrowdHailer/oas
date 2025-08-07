import gleam/dict
import gleam/dynamic/decode
import gleam/option.{None}
import oas/json_rpc
import oas/mcp/messages

pub fn request_decoder() {
  json_rpc.request_decoder(
    decoders(),
    Ping(messages.PingRequest(None, dict.new())),
  )
}

fn decoders() {
  [
    #(
      "notifications/cancelled",
      json_rpc.FromParams(
        messages.cancelled_notification_decoder() |> decode.map(Cancelled),
      ),
    ),
    #(
      "notifications/initialized",
      json_rpc.OptionalParams(
        messages.initialized_notification_decoder() |> decode.map(Initialized),
      ),
    ),
    #(
      "notifications/progress",
      json_rpc.FromParams(
        messages.progress_notification_decoder() |> decode.map(Progress),
      ),
    ),
    #(
      "notifications/roots/list_changed",
      json_rpc.FromParams(
        messages.roots_list_changed_notification_decoder()
        |> decode.map(RootsListChanged),
      ),
    ),
    #(
      "initialize",
      json_rpc.FromParams(
        messages.initialize_request_decoder() |> decode.map(Initialize),
      ),
    ),
    #(
      "ping",
      json_rpc.FromParams(messages.ping_request_decoder() |> decode.map(Ping)),
    ),
    #(
      "resources/list",
      json_rpc.FromParams(
        messages.list_resources_request_decoder() |> decode.map(ListResources),
      ),
    ),
    #(
      "resources/templates/list",
      json_rpc.FromParams(
        messages.list_resource_templates_request_decoder()
        |> decode.map(ListResourceTemplates),
      ),
    ),
    #(
      "resources/read",
      json_rpc.FromParams(
        messages.read_resource_request_decoder()
        |> decode.map(ReadResource),
      ),
    ),
    #(
      "resources/subscribe",
      json_rpc.FromParams(
        messages.subscribe_request_decoder()
        |> decode.map(Subscribe),
      ),
    ),
    #(
      "resources/unsubscribe",
      json_rpc.FromParams(
        messages.unsubscribe_request_decoder()
        |> decode.map(Unsubscribe),
      ),
    ),
    #(
      "prompts/list",
      json_rpc.FromParams(
        messages.list_prompts_request_decoder() |> decode.map(ListPrompts),
      ),
    ),
    #(
      "prompts/get",
      json_rpc.FromParams(
        messages.get_prompt_request_decoder() |> decode.map(GetPrompt),
      ),
    ),
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
      "logging/setLevel",
      json_rpc.FromParams(
        messages.set_level_request_decoder() |> decode.map(SetLevel),
      ),
    ),
    #(
      "completion/complete",
      json_rpc.FromParams(
        messages.complete_request_decoder() |> decode.map(Complete),
      ),
    ),
  ]
}

pub type Params {
  // Client Notifications
  Cancelled(messages.CancelledNotification)
  Initialized(messages.InitializedNotification)
  Progress(messages.ProgressNotification)
  RootsListChanged(messages.RootsListChangedNotification)

  // client Requests
  Initialize(messages.InitializeRequest)
  Ping(messages.PingRequest)
  ListResources(messages.ListResourcesRequest)
  ListResourceTemplates(messages.ListResourceTemplatesRequest)
  ReadResource(messages.ReadResourceRequest)
  Subscribe(messages.SubscribeRequest)
  Unsubscribe(messages.UnsubscribeRequest)
  ListPrompts(messages.ListPromptsRequest)
  GetPrompt(messages.GetPromptRequest)
  ListTools(messages.ListToolsRequest)
  CallTool(messages.CallToolRequest)
  SetLevel(messages.SetLevelRequest)
  Complete(messages.CompleteRequest)
}
