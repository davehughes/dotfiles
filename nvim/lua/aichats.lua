local find_files = require("telescope.builtin").find_files
local get_status = require("telescope.state").get_status

local aichats_default_directory = os.getenv("HOME") .. "/.local/aichats"

local function telescope_picker(opts)
  opts = opts or {}
  opts.search_dirs = opts.search_dirs or { aichats_default_directory }
  opts.cwd = opts.cwd or aichats_default_directory
  opts.path_display = function(opts, path)
    return short_label_from_path(path)
  end
  find_files(opts)
end

local function path_display_with_right_aligned_text(primary_text, right_aligned_text)
  local status = get_status(vim.api.nvim_get_current_buf())
  local available_width = vim.api.nvim_win_get_width(status.layout.results.winid) - status.picker.selection_caret:len() -
      2
  local min_gap = 2
  if #primary_text + #right_aligned_text + min_gap > available_width then
    return primary_text
  else
    return primary_text .. string.rep(" ", available_width - #primary_text - #right_aligned_text) .. right_aligned_text
  end
end

local function short_label_from_path(path)
  local name, _, date = path:match("([^/]+)(%.(%d+))%.aichat$")
  if name then
    return path_display_with_right_aligned_text(name, date)
  else
    return path
  end
end

local function filepath_for_current_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local status, filename = pcall(vim.api.nvim_buf_get_name, bufnr)
  if not status or filename == "" then
    return nil
  else
    return filename
  end
end

local function generate_filepath_for_chat_buffer(file_prefix)
  return string.format("%s/%s.%d.aichat", aichats_default_directory, file_prefix, os.date("%Y%m%d"))
end

local function save_current_chat_buffer()
  local existing_filepath = filepath_for_current_buffer()
  if existing_filepath == nil then
    local buffer_summary_for_filepath = "todo-implement-summary"
    local new_filepath = generate_filepath_for_chat_buffer(buffer_summary_for_filepath)
    vim.cmd(string.format("write %s", new_filepath))
  else
    vim.cmd("write")
  end
end

return {
  telescope_picker = telescope_picker,
  save_current_chat_buffer = save_current_chat_buffer
}
