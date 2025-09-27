local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

local telescope_extension = require("local.bazel")

return telescope.register_extension {
  exports = {
    bazel = telescope_extension.bazel_query_picker,
  },
}
