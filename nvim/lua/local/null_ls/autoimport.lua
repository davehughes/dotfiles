-- null-ls/none-ls formatting helper enabling python autoimport
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
  name = "autoimport",
  meta = {
    url = "https://lyz-code.github.io/autoimport/",
    description = "Python import management",
  },
  method = FORMATTING,
  filetypes = { "python" },
  generator_opts = {
    command = "autoimport",
    args = {
      "$FILENAME",
      "-",
    },
    to_stdin = true,
  },
  factory = h.formatter_factory,
})
