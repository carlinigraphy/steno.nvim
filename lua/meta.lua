---@meta

---@alias stack datum[]

---@class (exact) datum
---@field input string
---@field buffer ( [string, string] )[]

---@class rule
---@field output string
---@field negates? string[]  Patterns negated by this rule

---@class (exact) code
---@field value string
