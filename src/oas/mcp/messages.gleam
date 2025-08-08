import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option, None}
import oas/generator/utils

pub type BaseMetadata {
  BaseMetadata(name: String, title: Option(String))
}

pub type SamplingMessage {
  SamplingMessage(role: Role, content: utils.Any)
}

pub type PromptArgument {
  PromptArgument(
    name: String,
    title: Option(String),
    description: Option(String),
    required: Option(Bool),
  )
}

pub type ReadResourceResult {
  ReadResourceResult(
    meta: Option(dict.Dict(String, utils.Any)),
    contents: List(utils.Any),
  )
}

pub type ClientCapabilities {
  ClientCapabilities(
    sampling: Option(dict.Dict(String, utils.Any)),
    experimental: Option(dict.Dict(String, dict.Dict(String, utils.Any))),
    elicitation: Option(dict.Dict(String, utils.Any)),
    roots: Option(Internal0),
  )
}

pub type ListResourceTemplatesRequest {
  ListResourceTemplatesRequest(cursor: Option(String))
}

pub type Root {
  Root(
    meta: Option(dict.Dict(String, utils.Any)),
    name: Option(String),
    uri: String,
  )
}

pub type EnumSchema {
  EnumSchema(
    enum: List(String),
    enum_names: Option(List(String)),
    title: Option(String),
    type_: String,
    description: Option(String),
  )
}

pub type PaginatedRequest {
  PaginatedRequest(cursor: Option(String))
}

pub type ResourceTemplateReference {
  ResourceTemplateReference(uri: String, type_: String)
}

pub type PromptMessage {
  PromptMessage(role: Role, content: ContentBlock)
}

pub type AudioContent {
  AudioContent(
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    data: String,
    mime_type: String,
    type_: String,
  )
}

pub type ElicitRequest {
  ElicitRequest(message: String, requested_schema: Internal1)
}

pub type CreateMessageRequest {
  CreateMessageRequest(
    include_context: Option(String),
    messages: List(SamplingMessage),
    model_preferences: Option(ModelPreferences),
    metadata: Option(dict.Dict(String, utils.Any)),
    stop_sequences: Option(List(String)),
    system_prompt: Option(String),
    temperature: Option(Float),
    max_tokens: Int,
  )
}

pub type Prompt {
  Prompt(
    meta: Option(dict.Dict(String, utils.Any)),
    name: String,
    arguments: Option(List(PromptArgument)),
    title: Option(String),
    description: Option(String),
  )
}

pub type ListResourcesResult {
  ListResourcesResult(
    meta: Option(dict.Dict(String, utils.Any)),
    resources: List(Resource),
    next_cursor: Option(String),
  )
}

pub type Annotations {
  Annotations(
    priority: Option(Float),
    audience: Option(List(Role)),
    last_modified: Option(String),
  )
}

pub type SubscribeRequest {
  SubscribeRequest(uri: String)
}

pub type BlobResourceContents {
  BlobResourceContents(
    meta: Option(dict.Dict(String, utils.Any)),
    uri: String,
    mime_type: Option(String),
    blob: String,
  )
}

pub type PromptReference {
  PromptReference(name: String, title: Option(String), type_: String)
}

pub type ResourceLink {
  ResourceLink(
    size: Option(Int),
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    name: String,
    uri: String,
    mime_type: Option(String),
    title: Option(String),
    type_: String,
    description: Option(String),
  )
}

pub type Jsonrpcnotification {
  Jsonrpcnotification(
    method_: String,
    params: Option(Internal2),
    jsonrpc: String,
  )
}

pub type ResourceContents {
  ResourceContents(
    meta: Option(dict.Dict(String, utils.Any)),
    uri: String,
    mime_type: Option(String),
  )
}

pub type ListResourcesRequest {
  ListResourcesRequest(cursor: Option(String))
}

pub type ResourceTemplate {
  ResourceTemplate(
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    uri_template: String,
    name: String,
    mime_type: Option(String),
    title: Option(String),
    description: Option(String),
  )
}

pub type CreateMessageResult {
  CreateMessageResult(
    meta: Option(dict.Dict(String, utils.Any)),
    stop_reason: Option(String),
    model: String,
    role: Role,
    content: utils.Any,
  )
}

pub type ElicitResult {
  ElicitResult(
    meta: Option(dict.Dict(String, utils.Any)),
    action: String,
    content: Option(dict.Dict(String, utils.Any)),
  )
}

pub type ToolListChangedNotification {
  ToolListChangedNotification(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type BooleanSchema {
  BooleanSchema(
    default: Option(Bool),
    title: Option(String),
    type_: String,
    description: Option(String),
  )
}

pub type ListResourceTemplatesResult {
  ListResourceTemplatesResult(
    meta: Option(dict.Dict(String, utils.Any)),
    next_cursor: Option(String),
    resource_templates: List(ResourceTemplate),
  )
}

pub type PaginatedResult {
  PaginatedResult(
    meta: Option(dict.Dict(String, utils.Any)),
    next_cursor: Option(String),
  )
}

pub type NumberSchema {
  NumberSchema(
    maximum: Option(Int),
    minimum: Option(Int),
    title: Option(String),
    type_: String,
    description: Option(String),
  )
}

pub type Jsonrpcerror {
  Jsonrpcerror(error: Internal3, id: RequestId, jsonrpc: String)
}

pub type Notification {
  Notification(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type ReadResourceRequest {
  ReadResourceRequest(uri: String)
}

pub type ToolAnnotations {
  ToolAnnotations(
    idempotent_hint: Option(Bool),
    read_only_hint: Option(Bool),
    destructive_hint: Option(Bool),
    open_world_hint: Option(Bool),
    title: Option(String),
  )
}

pub type TextContent {
  TextContent(
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    text: String,
    type_: String,
  )
}

pub type SetLevelRequest {
  SetLevelRequest(level: LoggingLevel)
}

pub type InitializeResult {
  InitializeResult(
    protocol_version: String,
    meta: Option(dict.Dict(String, utils.Any)),
    instructions: Option(String),
    server_info: Implementation,
    capabilities: ServerCapabilities,
  )
}

pub type Resource {
  Resource(
    size: Option(Int),
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    name: String,
    uri: String,
    mime_type: Option(String),
    title: Option(String),
    description: Option(String),
  )
}

pub type ListPromptsResult {
  ListPromptsResult(
    meta: Option(dict.Dict(String, utils.Any)),
    next_cursor: Option(String),
    prompts: List(Prompt),
  )
}

pub type ModelPreferences {
  ModelPreferences(
    intelligence_priority: Option(Float),
    speed_priority: Option(Float),
    hints: Option(List(ModelHint)),
    cost_priority: Option(Float),
  )
}

pub type Request {
  Request(
    meta: Option(Internal4),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type ModelHint {
  ModelHint(name: Option(String))
}

pub type RootsListChangedNotification {
  RootsListChangedNotification(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type ListRootsResult {
  ListRootsResult(meta: Option(dict.Dict(String, utils.Any)), roots: List(Root))
}

pub type ListToolsRequest {
  ListToolsRequest(cursor: Option(String))
}

pub type StringSchema {
  StringSchema(
    max_length: Option(Int),
    format: Option(String),
    title: Option(String),
    min_length: Option(Int),
    type_: String,
    description: Option(String),
  )
}

pub type Implementation {
  Implementation(name: String, version: String, title: Option(String))
}

pub type Jsonrpcrequest {
  Jsonrpcrequest(
    method_: String,
    params: Option(Internal6),
    id: RequestId,
    jsonrpc: String,
  )
}

pub type ResourceListChangedNotification {
  ResourceListChangedNotification(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type LoggingMessageNotification {
  LoggingMessageNotification(
    level: LoggingLevel,
    data: utils.Never,
    logger: Option(String),
  )
}

pub type CallToolResult {
  CallToolResult(
    meta: Option(dict.Dict(String, utils.Any)),
    structured_content: Option(dict.Dict(String, utils.Any)),
    content: List(ContentBlock),
    is_error: Option(Bool),
  )
}

pub type TextResourceContents {
  TextResourceContents(
    meta: Option(dict.Dict(String, utils.Any)),
    uri: String,
    text: String,
    mime_type: Option(String),
  )
}

pub type GetPromptRequest {
  GetPromptRequest(name: String, arguments: Option(dict.Dict(String, String)))
}

pub type CompleteResult {
  CompleteResult(
    meta: Option(dict.Dict(String, utils.Any)),
    completion: Internal7,
  )
}

pub type CompleteRequest {
  CompleteRequest(
    context: Option(Internal8),
    ref: utils.Any,
    argument: Internal9,
  )
}

pub type GetPromptResult {
  GetPromptResult(
    meta: Option(dict.Dict(String, utils.Any)),
    messages: List(PromptMessage),
    description: Option(String),
  )
}

pub type EmbeddedResource {
  EmbeddedResource(
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    resource: utils.Any,
    type_: String,
  )
}

pub type Tool {
  Tool(
    output_schema: Option(Internal10),
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(ToolAnnotations),
    input_schema: Internal11,
    name: String,
    title: Option(String),
    description: Option(String),
  )
}

pub type ResourceUpdatedNotification {
  ResourceUpdatedNotification(uri: String)
}

pub type ProgressNotification {
  ProgressNotification(
    total: Option(Float),
    message: Option(String),
    progress_token: ProgressToken,
    progress: Float,
  )
}

pub type CallToolRequest {
  CallToolRequest(name: String, arguments: Option(dict.Dict(String, utils.Any)))
}

pub type ServerCapabilities {
  ServerCapabilities(
    resources: Option(Internal12),
    experimental: Option(dict.Dict(String, dict.Dict(String, utils.Any))),
    prompts: Option(Internal13),
    completions: Option(dict.Dict(String, utils.Any)),
    tools: Option(Internal14),
    logging: Option(dict.Dict(String, utils.Any)),
  )
}

pub type ListToolsResult {
  ListToolsResult(
    meta: Option(dict.Dict(String, utils.Any)),
    next_cursor: Option(String),
    tools: List(Tool),
  )
}

pub type CancelledNotification {
  CancelledNotification(reason: Option(String), request_id: RequestId)
}

pub type ListRootsRequest {
  ListRootsRequest(
    meta: Option(Internal15),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Result {
  Result(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type PingRequest {
  PingRequest(
    meta: Option(Internal16),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type PromptListChangedNotification {
  PromptListChangedNotification(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type ListPromptsRequest {
  ListPromptsRequest(cursor: Option(String))
}

pub type UnsubscribeRequest {
  UnsubscribeRequest(uri: String)
}

pub type ImageContent {
  ImageContent(
    meta: Option(dict.Dict(String, utils.Any)),
    annotations: Option(Annotations),
    data: String,
    mime_type: String,
    type_: String,
  )
}

pub type Jsonrpcresponse {
  Jsonrpcresponse(id: RequestId, result: Result, jsonrpc: String)
}

pub type InitializeRequest {
  InitializeRequest(
    protocol_version: String,
    capabilities: ClientCapabilities,
    client_info: Implementation,
  )
}

pub type InitializedNotification {
  InitializedNotification(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Internal0 {
  Internal0(list_changed: Option(Bool))
}

pub type Internal1 {
  Internal1(
    properties: dict.Dict(String, PrimitiveSchemaDefinition),
    type_: String,
    required: Option(List(String)),
  )
}

pub type Internal2 {
  Internal2(
    meta: Option(dict.Dict(String, utils.Any)),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Internal3 {
  Internal3(message: String, data: Option(utils.Never), code: Int)
}

pub type Internal4 {
  Internal4(
    progress_token: Option(ProgressToken),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Internal5 {
  Internal5(
    progress_token: Option(ProgressToken),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Internal6 {
  Internal6(
    meta: Option(Internal5),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Internal7 {
  Internal7(values: List(String), total: Option(Int), has_more: Option(Bool))
}

pub type Internal8 {
  Internal8(arguments: Option(dict.Dict(String, String)))
}

pub type Internal9 {
  Internal9(name: String, value: String)
}

pub type Internal10 {
  Internal10(
    properties: Option(dict.Dict(String, dict.Dict(String, utils.Any))),
    type_: String,
    required: Option(List(String)),
  )
}

pub type Internal11 {
  Internal11(
    properties: Option(dict.Dict(String, dict.Dict(String, utils.Any))),
    type_: String,
    required: Option(List(String)),
  )
}

pub type Internal12 {
  Internal12(subscribe: Option(Bool), list_changed: Option(Bool))
}

pub type Internal13 {
  Internal13(list_changed: Option(Bool))
}

pub type Internal14 {
  Internal14(list_changed: Option(Bool))
}

pub type Internal15 {
  Internal15(
    progress_token: Option(ProgressToken),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type Internal16 {
  Internal16(
    progress_token: Option(ProgressToken),
    additional_properties: dict.Dict(String, utils.Any),
  )
}

pub type ServerResult =
  utils.Any

pub type ClientRequest =
  utils.Any

pub type LoggingLevel =
  String

pub type ClientResult =
  utils.Any

pub type Jsonrpcmessage =
  utils.Any

pub type EmptyResult =
  utils.Never

pub type RequestId =
  utils.Any

pub type ServerRequest =
  utils.Any

pub type ProgressToken =
  utils.Any

pub type ServerNotification =
  utils.Any

pub type ContentBlock =
  utils.Any

pub type ClientNotification =
  utils.Any

pub type Role =
  String

pub type Cursor =
  String

pub type PrimitiveSchemaDefinition =
  utils.Any

pub fn internal_16_decoder() {
  use progress_token <- decode.optional_field(
    "progressToken",
    None,
    decode.optional(progress_token_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["progressToken"],
    utils.any_decoder(),
  )
  decode.success(Internal16(
    progress_token: progress_token,
    additional_properties: additional_properties,
  ))
}

pub fn internal_16_encode(data: Internal16) {
  utils.object([
    #(
      "progressToken",
      json.nullable(data.progress_token, progress_token_encode),
    ),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn internal_15_decoder() {
  use progress_token <- decode.optional_field(
    "progressToken",
    None,
    decode.optional(progress_token_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["progressToken"],
    utils.any_decoder(),
  )
  decode.success(Internal15(
    progress_token: progress_token,
    additional_properties: additional_properties,
  ))
}

pub fn internal_15_encode(data: Internal15) {
  utils.object([
    #(
      "progressToken",
      json.nullable(data.progress_token, progress_token_encode),
    ),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn internal_14_decoder() {
  use list_changed <- decode.optional_field(
    "listChanged",
    None,
    decode.optional(decode.bool),
  )
  decode.success(Internal14(list_changed: list_changed))
}

pub fn internal_14_encode(data: Internal14) {
  utils.object([#("listChanged", json.nullable(data.list_changed, json.bool))])
}

pub fn internal_13_decoder() {
  use list_changed <- decode.optional_field(
    "listChanged",
    None,
    decode.optional(decode.bool),
  )
  decode.success(Internal13(list_changed: list_changed))
}

pub fn internal_13_encode(data: Internal13) {
  utils.object([#("listChanged", json.nullable(data.list_changed, json.bool))])
}

pub fn internal_12_decoder() {
  use subscribe <- decode.optional_field(
    "subscribe",
    None,
    decode.optional(decode.bool),
  )
  use list_changed <- decode.optional_field(
    "listChanged",
    None,
    decode.optional(decode.bool),
  )
  decode.success(Internal12(subscribe: subscribe, list_changed: list_changed))
}

pub fn internal_12_encode(data: Internal12) {
  utils.object([
    #("subscribe", json.nullable(data.subscribe, json.bool)),
    #("listChanged", json.nullable(data.list_changed, json.bool)),
  ])
}

pub fn internal_11_decoder() {
  use properties <- decode.optional_field(
    "properties",
    None,
    decode.optional(decode.dict(
      decode.string,
      decode.dict(decode.string, utils.any_decoder()),
    )),
  )
  use type_ <- decode.field("type", decode.string)
  use required <- decode.optional_field(
    "required",
    None,
    decode.optional(decode.list(decode.string)),
  )
  decode.success(Internal11(
    properties: properties,
    type_: type_,
    required: required,
  ))
}

pub fn internal_11_encode(data: Internal11) {
  utils.object([
    #(
      "properties",
      json.nullable(
        data.properties,
        utils.dict(_, utils.dict(_, utils.any_to_json)),
      ),
    ),
    #("type", json.string(data.type_)),
    #("required", json.nullable(data.required, json.array(_, json.string))),
  ])
}

pub fn internal_10_decoder() {
  use properties <- decode.optional_field(
    "properties",
    None,
    decode.optional(decode.dict(
      decode.string,
      decode.dict(decode.string, utils.any_decoder()),
    )),
  )
  use type_ <- decode.field("type", decode.string)
  use required <- decode.optional_field(
    "required",
    None,
    decode.optional(decode.list(decode.string)),
  )
  decode.success(Internal10(
    properties: properties,
    type_: type_,
    required: required,
  ))
}

pub fn internal_10_encode(data: Internal10) {
  utils.object([
    #(
      "properties",
      json.nullable(
        data.properties,
        utils.dict(_, utils.dict(_, utils.any_to_json)),
      ),
    ),
    #("type", json.string(data.type_)),
    #("required", json.nullable(data.required, json.array(_, json.string))),
  ])
}

pub fn internal_9_decoder() {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)
  decode.success(Internal9(name: name, value: value))
}

pub fn internal_9_encode(data: Internal9) {
  utils.object([
    #("name", json.string(data.name)),
    #("value", json.string(data.value)),
  ])
}

pub fn internal_8_decoder() {
  use arguments <- decode.optional_field(
    "arguments",
    None,
    decode.optional(decode.dict(decode.string, decode.string)),
  )
  decode.success(Internal8(arguments: arguments))
}

pub fn internal_8_encode(data: Internal8) {
  utils.object([
    #("arguments", json.nullable(data.arguments, utils.dict(_, json.string))),
  ])
}

pub fn internal_7_decoder() {
  use values <- decode.field("values", decode.list(decode.string))
  use total <- decode.optional_field("total", None, decode.optional(decode.int))
  use has_more <- decode.optional_field(
    "hasMore",
    None,
    decode.optional(decode.bool),
  )
  decode.success(Internal7(values: values, total: total, has_more: has_more))
}

pub fn internal_7_encode(data: Internal7) {
  utils.object([
    #("values", json.array(_, json.string)(data.values)),
    #("total", json.nullable(data.total, json.int)),
    #("hasMore", json.nullable(data.has_more, json.bool)),
  ])
}

pub fn internal_6_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(internal_5_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(Internal6(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn internal_6_encode(data: Internal6) {
  utils.object([
    #("_meta", json.nullable(data.meta, internal_5_encode)),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn internal_5_decoder() {
  use progress_token <- decode.optional_field(
    "progressToken",
    None,
    decode.optional(progress_token_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["progressToken"],
    utils.any_decoder(),
  )
  decode.success(Internal5(
    progress_token: progress_token,
    additional_properties: additional_properties,
  ))
}

pub fn internal_5_encode(data: Internal5) {
  utils.object([
    #(
      "progressToken",
      json.nullable(data.progress_token, progress_token_encode),
    ),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn internal_4_decoder() {
  use progress_token <- decode.optional_field(
    "progressToken",
    None,
    decode.optional(progress_token_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["progressToken"],
    utils.any_decoder(),
  )
  decode.success(Internal4(
    progress_token: progress_token,
    additional_properties: additional_properties,
  ))
}

pub fn internal_4_encode(data: Internal4) {
  utils.object([
    #(
      "progressToken",
      json.nullable(data.progress_token, progress_token_encode),
    ),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn internal_3_decoder() {
  use message <- decode.field("message", decode.string)
  use data <- decode.optional_field(
    "data",
    None,
    decode.optional(
      decode.new_primitive_decoder("Never", fn(_) {
        panic as "tried to decode a never decode value"
      }),
    ),
  )
  use code <- decode.field("code", decode.int)
  decode.success(Internal3(message: message, data: data, code: code))
}

pub fn internal_3_encode(data: Internal3) {
  utils.object([
    #("message", json.string(data.message)),
    #(
      "data",
      json.nullable(data.data, fn(_data) {
        panic as "never value cannot be encoded"
      }),
    ),
    #("code", json.int(data.code)),
  ])
}

pub fn internal_2_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(Internal2(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn internal_2_encode(data: Internal2) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn internal_1_decoder() {
  use properties <- decode.field(
    "properties",
    decode.dict(decode.string, primitive_schema_definition_decoder()),
  )
  use type_ <- decode.field("type", decode.string)
  use required <- decode.optional_field(
    "required",
    None,
    decode.optional(decode.list(decode.string)),
  )
  decode.success(Internal1(
    properties: properties,
    type_: type_,
    required: required,
  ))
}

pub fn internal_1_encode(data: Internal1) {
  utils.object([
    #(
      "properties",
      utils.dict(_, primitive_schema_definition_encode)(data.properties),
    ),
    #("type", json.string(data.type_)),
    #("required", json.nullable(data.required, json.array(_, json.string))),
  ])
}

pub fn internal_0_decoder() {
  use list_changed <- decode.optional_field(
    "listChanged",
    None,
    decode.optional(decode.bool),
  )
  decode.success(Internal0(list_changed: list_changed))
}

pub fn internal_0_encode(data: Internal0) {
  utils.object([#("listChanged", json.nullable(data.list_changed, json.bool))])
}

pub fn initialized_notification_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(InitializedNotification(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn initialized_notification_encode(data: InitializedNotification) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn initialize_request_decoder() {
  use protocol_version <- decode.field("protocolVersion", decode.string)
  use capabilities <- decode.field(
    "capabilities",
    client_capabilities_decoder(),
  )
  use client_info <- decode.field("clientInfo", implementation_decoder())
  decode.success(InitializeRequest(
    protocol_version: protocol_version,
    capabilities: capabilities,
    client_info: client_info,
  ))
}

pub fn initialize_request_encode(data: InitializeRequest) {
  utils.object([
    #("protocolVersion", json.string(data.protocol_version)),
    #("capabilities", client_capabilities_encode(data.capabilities)),
    #("clientInfo", implementation_encode(data.client_info)),
  ])
}

pub fn jsonrpcresponse_decoder() {
  use id <- decode.field("id", request_id_decoder())
  use result <- decode.field("result", result_decoder())
  use jsonrpc <- decode.field("jsonrpc", decode.string)
  decode.success(Jsonrpcresponse(id: id, result: result, jsonrpc: jsonrpc))
}

pub fn jsonrpcresponse_encode(data: Jsonrpcresponse) {
  utils.object([
    #("id", request_id_encode(data.id)),
    #("result", result_encode(data.result)),
    #("jsonrpc", json.string(data.jsonrpc)),
  ])
}

pub fn image_content_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use data <- decode.field("data", decode.string)
  use mime_type <- decode.field("mimeType", decode.string)
  use type_ <- decode.field("type", decode.string)
  decode.success(ImageContent(
    meta: meta,
    annotations: annotations,
    data: data,
    mime_type: mime_type,
    type_: type_,
  ))
}

pub fn image_content_encode(data: ImageContent) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("data", json.string(data.data)),
    #("mimeType", json.string(data.mime_type)),
    #("type", json.string(data.type_)),
  ])
}

pub fn unsubscribe_request_decoder() {
  use uri <- decode.field("uri", decode.string)
  decode.success(UnsubscribeRequest(uri: uri))
}

pub fn unsubscribe_request_encode(data: UnsubscribeRequest) {
  utils.object([#("uri", json.string(data.uri))])
}

pub fn list_prompts_request_decoder() {
  use cursor <- decode.optional_field(
    "cursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(ListPromptsRequest(cursor: cursor))
}

pub fn list_prompts_request_encode(data: ListPromptsRequest) {
  utils.object([#("cursor", json.nullable(data.cursor, json.string))])
}

pub fn prompt_list_changed_notification_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(PromptListChangedNotification(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn prompt_list_changed_notification_encode(
  data: PromptListChangedNotification,
) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn ping_request_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(internal_16_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(PingRequest(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn ping_request_encode(data: PingRequest) {
  utils.object([
    #("_meta", json.nullable(data.meta, internal_16_encode)),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(Result(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn result_encode(data: Result) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn list_roots_request_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(internal_15_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(ListRootsRequest(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn list_roots_request_encode(data: ListRootsRequest) {
  utils.object([
    #("_meta", json.nullable(data.meta, internal_15_encode)),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn cancelled_notification_decoder() {
  use reason <- decode.optional_field(
    "reason",
    None,
    decode.optional(decode.string),
  )
  use request_id <- decode.field("requestId", request_id_decoder())
  decode.success(CancelledNotification(reason: reason, request_id: request_id))
}

pub fn cancelled_notification_encode(data: CancelledNotification) {
  utils.object([
    #("reason", json.nullable(data.reason, json.string)),
    #("requestId", request_id_encode(data.request_id)),
  ])
}

pub fn primitive_schema_definition_decoder() {
  utils.any_decoder()
}

pub fn primitive_schema_definition_encode(data: PrimitiveSchemaDefinition) {
  utils.any_to_json(data)
}

pub fn list_tools_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use next_cursor <- decode.optional_field(
    "nextCursor",
    None,
    decode.optional(decode.string),
  )
  use tools <- decode.field("tools", decode.list(tool_decoder()))
  decode.success(ListToolsResult(
    meta: meta,
    next_cursor: next_cursor,
    tools: tools,
  ))
}

pub fn list_tools_result_encode(data: ListToolsResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("nextCursor", json.nullable(data.next_cursor, json.string)),
    #("tools", json.array(_, tool_encode)(data.tools)),
  ])
}

pub fn server_capabilities_decoder() {
  use resources <- decode.optional_field(
    "resources",
    None,
    decode.optional(internal_12_decoder()),
  )
  use experimental <- decode.optional_field(
    "experimental",
    None,
    decode.optional(decode.dict(
      decode.string,
      decode.dict(decode.string, utils.any_decoder()),
    )),
  )
  use prompts <- decode.optional_field(
    "prompts",
    None,
    decode.optional(internal_13_decoder()),
  )
  use completions <- decode.optional_field(
    "completions",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use tools <- decode.optional_field(
    "tools",
    None,
    decode.optional(internal_14_decoder()),
  )
  use logging <- decode.optional_field(
    "logging",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  decode.success(ServerCapabilities(
    resources: resources,
    experimental: experimental,
    prompts: prompts,
    completions: completions,
    tools: tools,
    logging: logging,
  ))
}

pub fn server_capabilities_encode(data: ServerCapabilities) {
  utils.object([
    #("resources", json.nullable(data.resources, internal_12_encode)),
    #(
      "experimental",
      json.nullable(
        data.experimental,
        utils.dict(_, utils.dict(_, utils.any_to_json)),
      ),
    ),
    #("prompts", json.nullable(data.prompts, internal_13_encode)),
    #(
      "completions",
      json.nullable(data.completions, utils.dict(_, utils.any_to_json)),
    ),
    #("tools", json.nullable(data.tools, internal_14_encode)),
    #("logging", json.nullable(data.logging, utils.dict(_, utils.any_to_json))),
  ])
}

pub fn call_tool_request_decoder() {
  use name <- decode.field("name", decode.string)
  use arguments <- decode.optional_field(
    "arguments",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  decode.success(CallToolRequest(name: name, arguments: arguments))
}

pub fn call_tool_request_encode(data: CallToolRequest) {
  utils.object([
    #("name", json.string(data.name)),
    #(
      "arguments",
      json.nullable(data.arguments, utils.dict(_, utils.any_to_json)),
    ),
  ])
}

pub fn progress_notification_decoder() {
  use total <- decode.optional_field(
    "total",
    None,
    decode.optional(decode.float),
  )
  use message <- decode.optional_field(
    "message",
    None,
    decode.optional(decode.string),
  )
  use progress_token <- decode.field("progressToken", progress_token_decoder())
  use progress <- decode.field("progress", decode.float)
  decode.success(ProgressNotification(
    total: total,
    message: message,
    progress_token: progress_token,
    progress: progress,
  ))
}

pub fn progress_notification_encode(data: ProgressNotification) {
  utils.object([
    #("total", json.nullable(data.total, json.float)),
    #("message", json.nullable(data.message, json.string)),
    #("progressToken", progress_token_encode(data.progress_token)),
    #("progress", json.float(data.progress)),
  ])
}

pub fn resource_updated_notification_decoder() {
  use uri <- decode.field("uri", decode.string)
  decode.success(ResourceUpdatedNotification(uri: uri))
}

pub fn resource_updated_notification_encode(data: ResourceUpdatedNotification) {
  utils.object([#("uri", json.string(data.uri))])
}

pub fn tool_decoder() {
  use output_schema <- decode.optional_field(
    "outputSchema",
    None,
    decode.optional(internal_10_decoder()),
  )
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(tool_annotations_decoder()),
  )
  use input_schema <- decode.field("inputSchema", internal_11_decoder())
  use name <- decode.field("name", decode.string)
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(Tool(
    output_schema: output_schema,
    meta: meta,
    annotations: annotations,
    input_schema: input_schema,
    name: name,
    title: title,
    description: description,
  ))
}

pub fn tool_encode(data: Tool) {
  utils.object([
    #("outputSchema", json.nullable(data.output_schema, internal_10_encode)),
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, tool_annotations_encode)),
    #("inputSchema", internal_11_encode(data.input_schema)),
    #("name", json.string(data.name)),
    #("title", json.nullable(data.title, json.string)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn embedded_resource_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use resource <- decode.field("resource", utils.any_decoder())
  use type_ <- decode.field("type", decode.string)
  decode.success(EmbeddedResource(
    meta: meta,
    annotations: annotations,
    resource: resource,
    type_: type_,
  ))
}

pub fn embedded_resource_encode(data: EmbeddedResource) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("resource", utils.any_to_json(data.resource)),
    #("type", json.string(data.type_)),
  ])
}

pub fn get_prompt_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use messages <- decode.field(
    "messages",
    decode.list(prompt_message_decoder()),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(GetPromptResult(
    meta: meta,
    messages: messages,
    description: description,
  ))
}

pub fn get_prompt_result_encode(data: GetPromptResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("messages", json.array(_, prompt_message_encode)(data.messages)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn cursor_decoder() {
  decode.string
}

pub fn cursor_encode(data: Cursor) {
  json.string(data)
}

pub fn complete_request_decoder() {
  use context <- decode.optional_field(
    "context",
    None,
    decode.optional(internal_8_decoder()),
  )
  use ref <- decode.field("ref", utils.any_decoder())
  use argument <- decode.field("argument", internal_9_decoder())
  decode.success(CompleteRequest(context: context, ref: ref, argument: argument))
}

pub fn complete_request_encode(data: CompleteRequest) {
  utils.object([
    #("context", json.nullable(data.context, internal_8_encode)),
    #("ref", utils.any_to_json(data.ref)),
    #("argument", internal_9_encode(data.argument)),
  ])
}

pub fn complete_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use completion <- decode.field("completion", internal_7_decoder())
  decode.success(CompleteResult(meta: meta, completion: completion))
}

pub fn complete_result_encode(data: CompleteResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("completion", internal_7_encode(data.completion)),
  ])
}

pub fn role_decoder() {
  decode.string
}

pub fn role_encode(data: Role) {
  json.string(data)
}

pub fn client_notification_decoder() {
  utils.any_decoder()
}

pub fn client_notification_encode(data: ClientNotification) {
  utils.any_to_json(data)
}

pub fn get_prompt_request_decoder() {
  use name <- decode.field("name", decode.string)
  use arguments <- decode.optional_field(
    "arguments",
    None,
    decode.optional(decode.dict(decode.string, decode.string)),
  )
  decode.success(GetPromptRequest(name: name, arguments: arguments))
}

pub fn get_prompt_request_encode(data: GetPromptRequest) {
  utils.object([
    #("name", json.string(data.name)),
    #("arguments", json.nullable(data.arguments, utils.dict(_, json.string))),
  ])
}

pub fn text_resource_contents_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use uri <- decode.field("uri", decode.string)
  use text <- decode.field("text", decode.string)
  use mime_type <- decode.optional_field(
    "mimeType",
    None,
    decode.optional(decode.string),
  )
  decode.success(TextResourceContents(
    meta: meta,
    uri: uri,
    text: text,
    mime_type: mime_type,
  ))
}

pub fn text_resource_contents_encode(data: TextResourceContents) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("uri", json.string(data.uri)),
    #("text", json.string(data.text)),
    #("mimeType", json.nullable(data.mime_type, json.string)),
  ])
}

pub fn content_block_decoder() {
  utils.any_decoder()
}

pub fn content_block_encode(data: ContentBlock) {
  utils.any_to_json(data)
}

pub fn call_tool_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use structured_content <- decode.optional_field(
    "structuredContent",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use content <- decode.field("content", decode.list(content_block_decoder()))
  use is_error <- decode.optional_field(
    "isError",
    None,
    decode.optional(decode.bool),
  )
  decode.success(CallToolResult(
    meta: meta,
    structured_content: structured_content,
    content: content,
    is_error: is_error,
  ))
}

pub fn call_tool_result_encode(data: CallToolResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #(
      "structuredContent",
      json.nullable(data.structured_content, utils.dict(_, utils.any_to_json)),
    ),
    #("content", json.array(_, content_block_encode)(data.content)),
    #("isError", json.nullable(data.is_error, json.bool)),
  ])
}

pub fn logging_message_notification_decoder() {
  use level <- decode.field("level", logging_level_decoder())
  use data <- decode.field(
    "data",
    decode.new_primitive_decoder("Never", fn(_) {
      panic as "tried to decode a never decode value"
    }),
  )
  use logger <- decode.optional_field(
    "logger",
    None,
    decode.optional(decode.string),
  )
  decode.success(LoggingMessageNotification(
    level: level,
    data: data,
    logger: logger,
  ))
}

pub fn logging_message_notification_encode(data: LoggingMessageNotification) {
  utils.object([
    #("level", logging_level_encode(data.level)),
    #("data", fn(_data) { panic as "never value cannot be encoded" }(data.data)),
    #("logger", json.nullable(data.logger, json.string)),
  ])
}

pub fn resource_list_changed_notification_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(ResourceListChangedNotification(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn resource_list_changed_notification_encode(
  data: ResourceListChangedNotification,
) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn jsonrpcrequest_decoder() {
  use method_ <- decode.field("method", decode.string)
  use params <- decode.optional_field(
    "params",
    None,
    decode.optional(internal_6_decoder()),
  )
  use id <- decode.field("id", request_id_decoder())
  use jsonrpc <- decode.field("jsonrpc", decode.string)
  decode.success(Jsonrpcrequest(
    method_: method_,
    params: params,
    id: id,
    jsonrpc: jsonrpc,
  ))
}

pub fn jsonrpcrequest_encode(data: Jsonrpcrequest) {
  utils.object([
    #("method", json.string(data.method_)),
    #("params", json.nullable(data.params, internal_6_encode)),
    #("id", request_id_encode(data.id)),
    #("jsonrpc", json.string(data.jsonrpc)),
  ])
}

pub fn implementation_decoder() {
  use name <- decode.field("name", decode.string)
  use version <- decode.field("version", decode.string)
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  decode.success(Implementation(name: name, version: version, title: title))
}

pub fn implementation_encode(data: Implementation) {
  utils.object([
    #("name", json.string(data.name)),
    #("version", json.string(data.version)),
    #("title", json.nullable(data.title, json.string)),
  ])
}

pub fn string_schema_decoder() {
  use max_length <- decode.optional_field(
    "maxLength",
    None,
    decode.optional(decode.int),
  )
  use format <- decode.optional_field(
    "format",
    None,
    decode.optional(decode.string),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use min_length <- decode.optional_field(
    "minLength",
    None,
    decode.optional(decode.int),
  )
  use type_ <- decode.field("type", decode.string)
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(StringSchema(
    max_length: max_length,
    format: format,
    title: title,
    min_length: min_length,
    type_: type_,
    description: description,
  ))
}

pub fn string_schema_encode(data: StringSchema) {
  utils.object([
    #("maxLength", json.nullable(data.max_length, json.int)),
    #("format", json.nullable(data.format, json.string)),
    #("title", json.nullable(data.title, json.string)),
    #("minLength", json.nullable(data.min_length, json.int)),
    #("type", json.string(data.type_)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn list_tools_request_decoder() {
  use cursor <- decode.optional_field(
    "cursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(ListToolsRequest(cursor: cursor))
}

pub fn list_tools_request_encode(data: ListToolsRequest) {
  utils.object([#("cursor", json.nullable(data.cursor, json.string))])
}

pub fn list_roots_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use roots <- decode.field("roots", decode.list(root_decoder()))
  decode.success(ListRootsResult(meta: meta, roots: roots))
}

pub fn list_roots_result_encode(data: ListRootsResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("roots", json.array(_, root_encode)(data.roots)),
  ])
}

pub fn roots_list_changed_notification_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(RootsListChangedNotification(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn roots_list_changed_notification_encode(
  data: RootsListChangedNotification,
) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn model_hint_decoder() {
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  decode.success(ModelHint(name: name))
}

pub fn model_hint_encode(data: ModelHint) {
  utils.object([#("name", json.nullable(data.name, json.string))])
}

pub fn request_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(internal_4_decoder()),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(Request(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn request_encode(data: Request) {
  utils.object([
    #("_meta", json.nullable(data.meta, internal_4_encode)),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn model_preferences_decoder() {
  use intelligence_priority <- decode.optional_field(
    "intelligencePriority",
    None,
    decode.optional(decode.float),
  )
  use speed_priority <- decode.optional_field(
    "speedPriority",
    None,
    decode.optional(decode.float),
  )
  use hints <- decode.optional_field(
    "hints",
    None,
    decode.optional(decode.list(model_hint_decoder())),
  )
  use cost_priority <- decode.optional_field(
    "costPriority",
    None,
    decode.optional(decode.float),
  )
  decode.success(ModelPreferences(
    intelligence_priority: intelligence_priority,
    speed_priority: speed_priority,
    hints: hints,
    cost_priority: cost_priority,
  ))
}

pub fn model_preferences_encode(data: ModelPreferences) {
  utils.object([
    #(
      "intelligencePriority",
      json.nullable(data.intelligence_priority, json.float),
    ),
    #("speedPriority", json.nullable(data.speed_priority, json.float)),
    #("hints", json.nullable(data.hints, json.array(_, model_hint_encode))),
    #("costPriority", json.nullable(data.cost_priority, json.float)),
  ])
}

pub fn server_notification_decoder() {
  utils.any_decoder()
}

pub fn server_notification_encode(data: ServerNotification) {
  utils.any_to_json(data)
}

pub fn list_prompts_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use next_cursor <- decode.optional_field(
    "nextCursor",
    None,
    decode.optional(decode.string),
  )
  use prompts <- decode.field("prompts", decode.list(prompt_decoder()))
  decode.success(ListPromptsResult(
    meta: meta,
    next_cursor: next_cursor,
    prompts: prompts,
  ))
}

pub fn list_prompts_result_encode(data: ListPromptsResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("nextCursor", json.nullable(data.next_cursor, json.string)),
    #("prompts", json.array(_, prompt_encode)(data.prompts)),
  ])
}

pub fn resource_decoder() {
  use size <- decode.optional_field("size", None, decode.optional(decode.int))
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use name <- decode.field("name", decode.string)
  use uri <- decode.field("uri", decode.string)
  use mime_type <- decode.optional_field(
    "mimeType",
    None,
    decode.optional(decode.string),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(Resource(
    size: size,
    meta: meta,
    annotations: annotations,
    name: name,
    uri: uri,
    mime_type: mime_type,
    title: title,
    description: description,
  ))
}

pub fn resource_encode(data: Resource) {
  utils.object([
    #("size", json.nullable(data.size, json.int)),
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("name", json.string(data.name)),
    #("uri", json.string(data.uri)),
    #("mimeType", json.nullable(data.mime_type, json.string)),
    #("title", json.nullable(data.title, json.string)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn initialize_result_decoder() {
  use protocol_version <- decode.field("protocolVersion", decode.string)
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use instructions <- decode.optional_field(
    "instructions",
    None,
    decode.optional(decode.string),
  )
  use server_info <- decode.field("serverInfo", implementation_decoder())
  use capabilities <- decode.field(
    "capabilities",
    server_capabilities_decoder(),
  )
  decode.success(InitializeResult(
    protocol_version: protocol_version,
    meta: meta,
    instructions: instructions,
    server_info: server_info,
    capabilities: capabilities,
  ))
}

pub fn initialize_result_encode(data: InitializeResult) {
  utils.object([
    #("protocolVersion", json.string(data.protocol_version)),
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("instructions", json.nullable(data.instructions, json.string)),
    #("serverInfo", implementation_encode(data.server_info)),
    #("capabilities", server_capabilities_encode(data.capabilities)),
  ])
}

pub fn set_level_request_decoder() {
  use level <- decode.field("level", logging_level_decoder())
  decode.success(SetLevelRequest(level: level))
}

pub fn set_level_request_encode(data: SetLevelRequest) {
  utils.object([#("level", logging_level_encode(data.level))])
}

pub fn progress_token_decoder() {
  utils.any_decoder()
}

pub fn progress_token_encode(data: ProgressToken) {
  utils.any_to_json(data)
}

pub fn text_content_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use text <- decode.field("text", decode.string)
  use type_ <- decode.field("type", decode.string)
  decode.success(TextContent(
    meta: meta,
    annotations: annotations,
    text: text,
    type_: type_,
  ))
}

pub fn text_content_encode(data: TextContent) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("text", json.string(data.text)),
    #("type", json.string(data.type_)),
  ])
}

pub fn tool_annotations_decoder() {
  use idempotent_hint <- decode.optional_field(
    "idempotentHint",
    None,
    decode.optional(decode.bool),
  )
  use read_only_hint <- decode.optional_field(
    "readOnlyHint",
    None,
    decode.optional(decode.bool),
  )
  use destructive_hint <- decode.optional_field(
    "destructiveHint",
    None,
    decode.optional(decode.bool),
  )
  use open_world_hint <- decode.optional_field(
    "openWorldHint",
    None,
    decode.optional(decode.bool),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  decode.success(ToolAnnotations(
    idempotent_hint: idempotent_hint,
    read_only_hint: read_only_hint,
    destructive_hint: destructive_hint,
    open_world_hint: open_world_hint,
    title: title,
  ))
}

pub fn tool_annotations_encode(data: ToolAnnotations) {
  utils.object([
    #("idempotentHint", json.nullable(data.idempotent_hint, json.bool)),
    #("readOnlyHint", json.nullable(data.read_only_hint, json.bool)),
    #("destructiveHint", json.nullable(data.destructive_hint, json.bool)),
    #("openWorldHint", json.nullable(data.open_world_hint, json.bool)),
    #("title", json.nullable(data.title, json.string)),
  ])
}

pub fn server_request_decoder() {
  utils.any_decoder()
}

pub fn server_request_encode(data: ServerRequest) {
  utils.any_to_json(data)
}

pub fn read_resource_request_decoder() {
  use uri <- decode.field("uri", decode.string)
  decode.success(ReadResourceRequest(uri: uri))
}

pub fn read_resource_request_encode(data: ReadResourceRequest) {
  utils.object([#("uri", json.string(data.uri))])
}

pub fn notification_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(Notification(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn notification_encode(data: Notification) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn jsonrpcerror_decoder() {
  use error <- decode.field("error", internal_3_decoder())
  use id <- decode.field("id", request_id_decoder())
  use jsonrpc <- decode.field("jsonrpc", decode.string)
  decode.success(Jsonrpcerror(error: error, id: id, jsonrpc: jsonrpc))
}

pub fn jsonrpcerror_encode(data: Jsonrpcerror) {
  utils.object([
    #("error", internal_3_encode(data.error)),
    #("id", request_id_encode(data.id)),
    #("jsonrpc", json.string(data.jsonrpc)),
  ])
}

pub fn request_id_decoder() {
  utils.any_decoder()
}

pub fn request_id_encode(data: RequestId) {
  utils.any_to_json(data)
}

pub fn empty_result_decoder() {
  decode.new_primitive_decoder("Never", fn(_) {
    panic as "tried to decode a never decode value"
  })
}

pub fn empty_result_encode(_data: EmptyResult) {
  panic as "never value cannot be encoded"
}

pub fn number_schema_decoder() {
  use maximum <- decode.optional_field(
    "maximum",
    None,
    decode.optional(decode.int),
  )
  use minimum <- decode.optional_field(
    "minimum",
    None,
    decode.optional(decode.int),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", decode.string)
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(NumberSchema(
    maximum: maximum,
    minimum: minimum,
    title: title,
    type_: type_,
    description: description,
  ))
}

pub fn number_schema_encode(data: NumberSchema) {
  utils.object([
    #("maximum", json.nullable(data.maximum, json.int)),
    #("minimum", json.nullable(data.minimum, json.int)),
    #("title", json.nullable(data.title, json.string)),
    #("type", json.string(data.type_)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn jsonrpcmessage_decoder() {
  utils.any_decoder()
}

pub fn jsonrpcmessage_encode(data: Jsonrpcmessage) {
  utils.any_to_json(data)
}

pub fn paginated_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use next_cursor <- decode.optional_field(
    "nextCursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(PaginatedResult(meta: meta, next_cursor: next_cursor))
}

pub fn paginated_result_encode(data: PaginatedResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("nextCursor", json.nullable(data.next_cursor, json.string)),
  ])
}

pub fn list_resource_templates_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use next_cursor <- decode.optional_field(
    "nextCursor",
    None,
    decode.optional(decode.string),
  )
  use resource_templates <- decode.field(
    "resourceTemplates",
    decode.list(resource_template_decoder()),
  )
  decode.success(ListResourceTemplatesResult(
    meta: meta,
    next_cursor: next_cursor,
    resource_templates: resource_templates,
  ))
}

pub fn list_resource_templates_result_encode(data: ListResourceTemplatesResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("nextCursor", json.nullable(data.next_cursor, json.string)),
    #(
      "resourceTemplates",
      json.array(_, resource_template_encode)(data.resource_templates),
    ),
  ])
}

pub fn boolean_schema_decoder() {
  use default <- decode.optional_field(
    "default",
    None,
    decode.optional(decode.bool),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", decode.string)
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(BooleanSchema(
    default: default,
    title: title,
    type_: type_,
    description: description,
  ))
}

pub fn boolean_schema_encode(data: BooleanSchema) {
  utils.object([
    #("default", json.nullable(data.default, json.bool)),
    #("title", json.nullable(data.title, json.string)),
    #("type", json.string(data.type_)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn tool_list_changed_notification_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use additional_properties <- utils.decode_additional(
    ["_meta"],
    utils.any_decoder(),
  )
  decode.success(ToolListChangedNotification(
    meta: meta,
    additional_properties: additional_properties,
  ))
}

pub fn tool_list_changed_notification_encode(data: ToolListChangedNotification) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    ..dict.to_list(
      dict.map_values(data.additional_properties, fn(_key, value) {
        utils.any_to_json(value)
      }),
    )
  ])
}

pub fn elicit_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use action <- decode.field("action", decode.string)
  use content <- decode.optional_field(
    "content",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  decode.success(ElicitResult(meta: meta, action: action, content: content))
}

pub fn elicit_result_encode(data: ElicitResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("action", json.string(data.action)),
    #("content", json.nullable(data.content, utils.dict(_, utils.any_to_json))),
  ])
}

pub fn client_result_decoder() {
  utils.any_decoder()
}

pub fn client_result_encode(data: ClientResult) {
  utils.any_to_json(data)
}

pub fn create_message_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use stop_reason <- decode.optional_field(
    "stopReason",
    None,
    decode.optional(decode.string),
  )
  use model <- decode.field("model", decode.string)
  use role <- decode.field("role", role_decoder())
  use content <- decode.field("content", utils.any_decoder())
  decode.success(CreateMessageResult(
    meta: meta,
    stop_reason: stop_reason,
    model: model,
    role: role,
    content: content,
  ))
}

pub fn create_message_result_encode(data: CreateMessageResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("stopReason", json.nullable(data.stop_reason, json.string)),
    #("model", json.string(data.model)),
    #("role", role_encode(data.role)),
    #("content", utils.any_to_json(data.content)),
  ])
}

pub fn resource_template_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use uri_template <- decode.field("uriTemplate", decode.string)
  use name <- decode.field("name", decode.string)
  use mime_type <- decode.optional_field(
    "mimeType",
    None,
    decode.optional(decode.string),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(ResourceTemplate(
    meta: meta,
    annotations: annotations,
    uri_template: uri_template,
    name: name,
    mime_type: mime_type,
    title: title,
    description: description,
  ))
}

pub fn resource_template_encode(data: ResourceTemplate) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("uriTemplate", json.string(data.uri_template)),
    #("name", json.string(data.name)),
    #("mimeType", json.nullable(data.mime_type, json.string)),
    #("title", json.nullable(data.title, json.string)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn list_resources_request_decoder() {
  use cursor <- decode.optional_field(
    "cursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(ListResourcesRequest(cursor: cursor))
}

pub fn list_resources_request_encode(data: ListResourcesRequest) {
  utils.object([#("cursor", json.nullable(data.cursor, json.string))])
}

pub fn resource_contents_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use uri <- decode.field("uri", decode.string)
  use mime_type <- decode.optional_field(
    "mimeType",
    None,
    decode.optional(decode.string),
  )
  decode.success(ResourceContents(meta: meta, uri: uri, mime_type: mime_type))
}

pub fn resource_contents_encode(data: ResourceContents) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("uri", json.string(data.uri)),
    #("mimeType", json.nullable(data.mime_type, json.string)),
  ])
}

pub fn jsonrpcnotification_decoder() {
  use method_ <- decode.field("method", decode.string)
  use params <- decode.optional_field(
    "params",
    None,
    decode.optional(internal_2_decoder()),
  )
  use jsonrpc <- decode.field("jsonrpc", decode.string)
  decode.success(Jsonrpcnotification(
    method_: method_,
    params: params,
    jsonrpc: jsonrpc,
  ))
}

pub fn jsonrpcnotification_encode(data: Jsonrpcnotification) {
  utils.object([
    #("method", json.string(data.method_)),
    #("params", json.nullable(data.params, internal_2_encode)),
    #("jsonrpc", json.string(data.jsonrpc)),
  ])
}

pub fn resource_link_decoder() {
  use size <- decode.optional_field("size", None, decode.optional(decode.int))
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use name <- decode.field("name", decode.string)
  use uri <- decode.field("uri", decode.string)
  use mime_type <- decode.optional_field(
    "mimeType",
    None,
    decode.optional(decode.string),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", decode.string)
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(ResourceLink(
    size: size,
    meta: meta,
    annotations: annotations,
    name: name,
    uri: uri,
    mime_type: mime_type,
    title: title,
    type_: type_,
    description: description,
  ))
}

pub fn resource_link_encode(data: ResourceLink) {
  utils.object([
    #("size", json.nullable(data.size, json.int)),
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("name", json.string(data.name)),
    #("uri", json.string(data.uri)),
    #("mimeType", json.nullable(data.mime_type, json.string)),
    #("title", json.nullable(data.title, json.string)),
    #("type", json.string(data.type_)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn prompt_reference_decoder() {
  use name <- decode.field("name", decode.string)
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", decode.string)
  decode.success(PromptReference(name: name, title: title, type_: type_))
}

pub fn prompt_reference_encode(data: PromptReference) {
  utils.object([
    #("name", json.string(data.name)),
    #("title", json.nullable(data.title, json.string)),
    #("type", json.string(data.type_)),
  ])
}

pub fn logging_level_decoder() {
  decode.string
}

pub fn logging_level_encode(data: LoggingLevel) {
  json.string(data)
}

pub fn blob_resource_contents_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use uri <- decode.field("uri", decode.string)
  use mime_type <- decode.optional_field(
    "mimeType",
    None,
    decode.optional(decode.string),
  )
  use blob <- decode.field("blob", decode.string)
  decode.success(BlobResourceContents(
    meta: meta,
    uri: uri,
    mime_type: mime_type,
    blob: blob,
  ))
}

pub fn blob_resource_contents_encode(data: BlobResourceContents) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("uri", json.string(data.uri)),
    #("mimeType", json.nullable(data.mime_type, json.string)),
    #("blob", json.string(data.blob)),
  ])
}

pub fn subscribe_request_decoder() {
  use uri <- decode.field("uri", decode.string)
  decode.success(SubscribeRequest(uri: uri))
}

pub fn subscribe_request_encode(data: SubscribeRequest) {
  utils.object([#("uri", json.string(data.uri))])
}

pub fn annotations_decoder() {
  use priority <- decode.optional_field(
    "priority",
    None,
    decode.optional(decode.float),
  )
  use audience <- decode.optional_field(
    "audience",
    None,
    decode.optional(decode.list(role_decoder())),
  )
  use last_modified <- decode.optional_field(
    "lastModified",
    None,
    decode.optional(decode.string),
  )
  decode.success(Annotations(
    priority: priority,
    audience: audience,
    last_modified: last_modified,
  ))
}

pub fn annotations_encode(data: Annotations) {
  utils.object([
    #("priority", json.nullable(data.priority, json.float)),
    #("audience", json.nullable(data.audience, json.array(_, role_encode))),
    #("lastModified", json.nullable(data.last_modified, json.string)),
  ])
}

pub fn list_resources_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use resources <- decode.field("resources", decode.list(resource_decoder()))
  use next_cursor <- decode.optional_field(
    "nextCursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(ListResourcesResult(
    meta: meta,
    resources: resources,
    next_cursor: next_cursor,
  ))
}

pub fn list_resources_result_encode(data: ListResourcesResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("resources", json.array(_, resource_encode)(data.resources)),
    #("nextCursor", json.nullable(data.next_cursor, json.string)),
  ])
}

pub fn prompt_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use name <- decode.field("name", decode.string)
  use arguments <- decode.optional_field(
    "arguments",
    None,
    decode.optional(decode.list(prompt_argument_decoder())),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(Prompt(
    meta: meta,
    name: name,
    arguments: arguments,
    title: title,
    description: description,
  ))
}

pub fn prompt_encode(data: Prompt) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("name", json.string(data.name)),
    #(
      "arguments",
      json.nullable(data.arguments, json.array(_, prompt_argument_encode)),
    ),
    #("title", json.nullable(data.title, json.string)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn create_message_request_decoder() {
  use include_context <- decode.optional_field(
    "includeContext",
    None,
    decode.optional(decode.string),
  )
  use messages <- decode.field(
    "messages",
    decode.list(sampling_message_decoder()),
  )
  use model_preferences <- decode.optional_field(
    "modelPreferences",
    None,
    decode.optional(model_preferences_decoder()),
  )
  use metadata <- decode.optional_field(
    "metadata",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use stop_sequences <- decode.optional_field(
    "stopSequences",
    None,
    decode.optional(decode.list(decode.string)),
  )
  use system_prompt <- decode.optional_field(
    "systemPrompt",
    None,
    decode.optional(decode.string),
  )
  use temperature <- decode.optional_field(
    "temperature",
    None,
    decode.optional(decode.float),
  )
  use max_tokens <- decode.field("maxTokens", decode.int)
  decode.success(CreateMessageRequest(
    include_context: include_context,
    messages: messages,
    model_preferences: model_preferences,
    metadata: metadata,
    stop_sequences: stop_sequences,
    system_prompt: system_prompt,
    temperature: temperature,
    max_tokens: max_tokens,
  ))
}

pub fn create_message_request_encode(data: CreateMessageRequest) {
  utils.object([
    #("includeContext", json.nullable(data.include_context, json.string)),
    #("messages", json.array(_, sampling_message_encode)(data.messages)),
    #(
      "modelPreferences",
      json.nullable(data.model_preferences, model_preferences_encode),
    ),
    #(
      "metadata",
      json.nullable(data.metadata, utils.dict(_, utils.any_to_json)),
    ),
    #(
      "stopSequences",
      json.nullable(data.stop_sequences, json.array(_, json.string)),
    ),
    #("systemPrompt", json.nullable(data.system_prompt, json.string)),
    #("temperature", json.nullable(data.temperature, json.float)),
    #("maxTokens", json.int(data.max_tokens)),
  ])
}

pub fn client_request_decoder() {
  utils.any_decoder()
}

pub fn client_request_encode(data: ClientRequest) {
  utils.any_to_json(data)
}

pub fn elicit_request_decoder() {
  use message <- decode.field("message", decode.string)
  use requested_schema <- decode.field("requestedSchema", internal_1_decoder())
  decode.success(ElicitRequest(
    message: message,
    requested_schema: requested_schema,
  ))
}

pub fn elicit_request_encode(data: ElicitRequest) {
  utils.object([
    #("message", json.string(data.message)),
    #("requestedSchema", internal_1_encode(data.requested_schema)),
  ])
}

pub fn audio_content_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use annotations <- decode.optional_field(
    "annotations",
    None,
    decode.optional(annotations_decoder()),
  )
  use data <- decode.field("data", decode.string)
  use mime_type <- decode.field("mimeType", decode.string)
  use type_ <- decode.field("type", decode.string)
  decode.success(AudioContent(
    meta: meta,
    annotations: annotations,
    data: data,
    mime_type: mime_type,
    type_: type_,
  ))
}

pub fn audio_content_encode(data: AudioContent) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("annotations", json.nullable(data.annotations, annotations_encode)),
    #("data", json.string(data.data)),
    #("mimeType", json.string(data.mime_type)),
    #("type", json.string(data.type_)),
  ])
}

pub fn prompt_message_decoder() {
  use role <- decode.field("role", role_decoder())
  use content <- decode.field("content", content_block_decoder())
  decode.success(PromptMessage(role: role, content: content))
}

pub fn prompt_message_encode(data: PromptMessage) {
  utils.object([
    #("role", role_encode(data.role)),
    #("content", content_block_encode(data.content)),
  ])
}

pub fn resource_template_reference_decoder() {
  use uri <- decode.field("uri", decode.string)
  use type_ <- decode.field("type", decode.string)
  decode.success(ResourceTemplateReference(uri: uri, type_: type_))
}

pub fn resource_template_reference_encode(data: ResourceTemplateReference) {
  utils.object([
    #("uri", json.string(data.uri)),
    #("type", json.string(data.type_)),
  ])
}

pub fn paginated_request_decoder() {
  use cursor <- decode.optional_field(
    "cursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(PaginatedRequest(cursor: cursor))
}

pub fn paginated_request_encode(data: PaginatedRequest) {
  utils.object([#("cursor", json.nullable(data.cursor, json.string))])
}

pub fn enum_schema_decoder() {
  use enum <- decode.field("enum", decode.list(decode.string))
  use enum_names <- decode.optional_field(
    "enumNames",
    None,
    decode.optional(decode.list(decode.string)),
  )
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use type_ <- decode.field("type", decode.string)
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  decode.success(EnumSchema(
    enum: enum,
    enum_names: enum_names,
    title: title,
    type_: type_,
    description: description,
  ))
}

pub fn enum_schema_encode(data: EnumSchema) {
  utils.object([
    #("enum", json.array(_, json.string)(data.enum)),
    #("enumNames", json.nullable(data.enum_names, json.array(_, json.string))),
    #("title", json.nullable(data.title, json.string)),
    #("type", json.string(data.type_)),
    #("description", json.nullable(data.description, json.string)),
  ])
}

pub fn root_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use uri <- decode.field("uri", decode.string)
  decode.success(Root(meta: meta, name: name, uri: uri))
}

pub fn root_encode(data: Root) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("name", json.nullable(data.name, json.string)),
    #("uri", json.string(data.uri)),
  ])
}

pub fn list_resource_templates_request_decoder() {
  use cursor <- decode.optional_field(
    "cursor",
    None,
    decode.optional(decode.string),
  )
  decode.success(ListResourceTemplatesRequest(cursor: cursor))
}

pub fn list_resource_templates_request_encode(
  data: ListResourceTemplatesRequest,
) {
  utils.object([#("cursor", json.nullable(data.cursor, json.string))])
}

pub fn client_capabilities_decoder() {
  use sampling <- decode.optional_field(
    "sampling",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use experimental <- decode.optional_field(
    "experimental",
    None,
    decode.optional(decode.dict(
      decode.string,
      decode.dict(decode.string, utils.any_decoder()),
    )),
  )
  use elicitation <- decode.optional_field(
    "elicitation",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use roots <- decode.optional_field(
    "roots",
    None,
    decode.optional(internal_0_decoder()),
  )
  decode.success(ClientCapabilities(
    sampling: sampling,
    experimental: experimental,
    elicitation: elicitation,
    roots: roots,
  ))
}

pub fn client_capabilities_encode(data: ClientCapabilities) {
  utils.object([
    #(
      "sampling",
      json.nullable(data.sampling, utils.dict(_, utils.any_to_json)),
    ),
    #(
      "experimental",
      json.nullable(
        data.experimental,
        utils.dict(_, utils.dict(_, utils.any_to_json)),
      ),
    ),
    #(
      "elicitation",
      json.nullable(data.elicitation, utils.dict(_, utils.any_to_json)),
    ),
    #("roots", json.nullable(data.roots, internal_0_encode)),
  ])
}

pub fn read_resource_result_decoder() {
  use meta <- decode.optional_field(
    "_meta",
    None,
    decode.optional(decode.dict(decode.string, utils.any_decoder())),
  )
  use contents <- decode.field("contents", decode.list(utils.any_decoder()))
  decode.success(ReadResourceResult(meta: meta, contents: contents))
}

pub fn read_resource_result_encode(data: ReadResourceResult) {
  utils.object([
    #("_meta", json.nullable(data.meta, utils.dict(_, utils.any_to_json))),
    #("contents", json.array(_, utils.any_to_json)(data.contents)),
  ])
}

pub fn prompt_argument_decoder() {
  use name <- decode.field("name", decode.string)
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  use description <- decode.optional_field(
    "description",
    None,
    decode.optional(decode.string),
  )
  use required <- decode.optional_field(
    "required",
    None,
    decode.optional(decode.bool),
  )
  decode.success(PromptArgument(
    name: name,
    title: title,
    description: description,
    required: required,
  ))
}

pub fn prompt_argument_encode(data: PromptArgument) {
  utils.object([
    #("name", json.string(data.name)),
    #("title", json.nullable(data.title, json.string)),
    #("description", json.nullable(data.description, json.string)),
    #("required", json.nullable(data.required, json.bool)),
  ])
}

pub fn sampling_message_decoder() {
  use role <- decode.field("role", role_decoder())
  use content <- decode.field("content", utils.any_decoder())
  decode.success(SamplingMessage(role: role, content: content))
}

pub fn sampling_message_encode(data: SamplingMessage) {
  utils.object([
    #("role", role_encode(data.role)),
    #("content", utils.any_to_json(data.content)),
  ])
}

pub fn server_result_decoder() {
  utils.any_decoder()
}

pub fn server_result_encode(data: ServerResult) {
  utils.any_to_json(data)
}

pub fn base_metadata_decoder() {
  use name <- decode.field("name", decode.string)
  use title <- decode.optional_field(
    "title",
    None,
    decode.optional(decode.string),
  )
  decode.success(BaseMetadata(name: name, title: title))
}

pub fn base_metadata_encode(data: BaseMetadata) {
  utils.object([
    #("name", json.string(data.name)),
    #("title", json.nullable(data.title, json.string)),
  ])
}
