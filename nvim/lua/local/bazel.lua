local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.bazel_query_picker = function(opts)
  opts = opts or {}
  opts.query = opts.query or "kind(\"rule\", //...)"

  -- default to using the current buffer's workspace
  opts.cwd = opts.cwd or vim.fn.expand("%h")

  pickers.new(opts, {
    prompt_title = "Bazel Targets",
    finder = finders.new_oneshot_job(
      { "bazelisk", "query", opts.query },
      opts
    ),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        print("Selected Bazel target: " .. selection.value)
        -- Add your logic here for what to do with the selected target
        vim.fn.setreg('+', selection.value)
      end)
      return true
    end,
  }):find()
end

return M
