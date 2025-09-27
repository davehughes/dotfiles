local M = {}

local watch_group = vim.api.nvim_create_augroup("WatchMode", { clear = true })
local watch_enabled = {}

function M.watch_mode(opts)
  opts = opts or {}
  local follow = opts.follow ~= false -- default to true
  local bufnr = vim.api.nvim_get_current_buf()

  if watch_enabled[bufnr] then
    print("Watch mode already enabled for this buffer")
    return
  end

  watch_enabled[bufnr] = true
  vim.bo[bufnr].autoread = true
  vim.opt.updatetime = 200

  -- Check for file changes on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    group = watch_group,
    buffer = bufnr,
    callback = function()
      vim.cmd("checktime " .. bufnr)
    end
  })

  -- Handle file changes
  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = watch_group,
    buffer = bufnr,
    callback = function()
      if follow then
        vim.cmd("normal! G")
      end
    end
  })

  -- Clean up when buffer is deleted
  vim.api.nvim_create_autocmd("BufDelete", {
    group = watch_group,
    buffer = bufnr,
    callback = function()
      watch_enabled[bufnr] = nil
    end
  })

  local follow_msg = follow and " (following)" or ""
  print("Watch mode enabled" .. follow_msg)
end

function M.unwatch_mode()
  local bufnr = vim.api.nvim_get_current_buf()

  if not watch_enabled[bufnr] then
    print("Watch mode not enabled for this buffer")
    return
  end

  watch_enabled[bufnr] = nil

  -- Remove buffer-specific autocommands
  vim.api.nvim_clear_autocmds({
    group = watch_group,
    buffer = bufnr
  })

  print("Watch mode disabled")
end

function M.toggle_watch_mode(opts)
  local bufnr = vim.api.nvim_get_current_buf()

  if watch_enabled[bufnr] then
    M.unwatch_mode()
  else
    M.watch_mode(opts)
  end
end

return M
