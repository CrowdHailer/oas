# mcp_gen

## Notes 

### List of types

OAS doesn't support list of types.

- type is changed to `true` on additionalProperties on ElicitResult
- RequestId is `true`
- ProgressToken is `true`

### Requests

The `Request` type is not referenced anywhere in the definitions, but is used to specify a JSON RPC request
Most other `XRequest` definitions are a contant and parameters