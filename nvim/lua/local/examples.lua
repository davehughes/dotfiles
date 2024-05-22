-- Usage of `vim.ui.select` helper, which will show an interactive picker
local function select_example()
  local items = { 'something1', 'something2', 'something3' }
  local opts = {
    prompt = 'Listen to my riddles three',
    format_item = function(item)
      return item
    end,
  }
  local function callback(item, idx)
    vim.print("Selected item: " .. item .. " at index: " .. idx)
  end

  vim.ui.select(items, opts, callback)
end

-- nmap("<Leader>ts", select_example)
