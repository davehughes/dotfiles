-- Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- package management
local lazy_plugins = {
  -- general
  "jremmen/vim-ripgrep",
  "tomtom/tcomment_vim",
  "easymotion/vim-easymotion",
  "majutsushi/tagbar",
  "honza/vim-snippets",
  "vim-scripts/spacehi.vim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  "nvim-telescope/telescope-ui-select.nvim",
  "vim-scripts/sudo.vim",
  "janko/vim-test",
  "kylechui/nvim-surround",

  -- git --
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "lewis6991/gitsigns.nvim",

  -- language-specific --
  "vim-ruby/vim-ruby",
  {
    "fatih/vim-go",
    ft = "go",
  },
  {
    "udalov/kotlin-vim",
    ft = "kotlin",
  },
  "honza/dockerfile.vim",
  "leafgarland/typescript-vim",
  {
    -- see more elaborate setup here: https://github.com/scalameta/nvim-metals/discussions/39
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local config = require("metals").bare_config()
      config.on_attach = function(client, _bufnr)
        require("metals").setup_dap()
        -- TODO: set key mappings
      end
      return config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  "Olical/conjure",

  -- lsp, checkers, and fixers --
  -- "dense-analysis/ale",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "nvimtools/none-ls.nvim",
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      -- require("your.null-ls.config") -- require your null-ls config here (example below)
    end,
  },

  -- completion and snippets
  {
    "hrsh7th/nvim-cmp",
    dependencies = "onsails/lspkind.nvim"
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "kristijanhusak/vim-dadbod-completion",
  "zbirenbaum/copilot.lua",
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "zbirenbaum/copilot.lua"
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = "L3MON4D3/LuaSnip"
  },

  -- debugging
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",
  "nvim-neotest/nvim-nio",
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  "jbyuki/one-small-step-for-vimkind",

  -- colorschemes
  -- Mostly found on vimcolorschemes.com. `:Telescope colorscheme` to kick the tires.
  "morhetz/gruvbox",
  "shaunsingh/solarized.nvim",
  "shaunsingh/nord.nvim",
  "folke/tokyonight.nvim",
  "rose-pine/neovim",
  "sainnhe/everforest",
  "sainnhe/edge",
  "sainnhe/sonokai",
  "sainnhe/gruvbox-material",
  "maxmx03/fluoromachine.nvim",

  -- interfaces to external systems --
  "madox2/vim-ai",
  "tpope/vim-dadbod",
  "dermusikman/sonicpi.vim",
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  },
}

-- Lazy doesn't support hot reloading, so we need to check if it's already been loaded
if vim.g.lazy_loaded == nil then
  require("lazy").setup(lazy_plugins, {})
  vim.g.lazy_loaded = true
end

-- Set filetype based on file extension for extensions that are not recognized by default
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    tsx = "typescript",
    zshenv = "zsh",
    bb = "clojure",
    edn = "clojure",
  },
})

vim.opt.compatible = false
vim.opt.modelines = 0
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.textwidth = 120
vim.opt.backspace = "indent,eol,start"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.guicursor = ""
vim.opt.tags = ".tags,tags,env/lib/tags,env/src/tags"
vim.opt.clipboard = "unnamed"
-- vim.opt.wildignore+=*.o,*.obj,.git,*.pyc,*.egg-info,*.vim,*/htmlcov/*,*/vendor/*
vim.g.mapleader = "\\"
vim.cmd([[
" File-specific key mappings
" + Eval line or visual selection
au FileType clojure map [e :Eval<CR>
" + Reload current namespace
au FileType clojure map [r :Eval (use :reload-all (symbol (str *ns*)))<CR>
]])

-- appearance
vim.opt.termguicolors = true
vim.cmd([[ colorscheme everforest ]])
vim.g.everforest_transparent_background = 1
-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "None", bg = "None" })

-- key mappings
local function map(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map("n", shortcut, command)
end

local function vmap(shortcut, command)
  map("v", shortcut, command)
end

local nvim_lua_init_path = "${HOME}/.config/home-manager/nvim/init.lua"
nmap("<Leader>ne", ":edit" .. nvim_lua_init_path .. "<CR>")
nmap("<Leader>nr", ":luafile" .. nvim_lua_init_path .. "<CR>")
nmap("<C-o>", ":Telescope buffers<CR>")
nmap("<C-p>", ":Telescope git_files<CR>")
nmap("<C-i>", ":Telescope live_grep<CR>")
-- nmap("<C-c>", ":Telescope aichats<CR>")
nmap("<C-m>", ":Telescope marks<CR>")
nmap("<C-f>", ":Rg<CR>")
nmap("<C-h>", ":bp<CR>")
nmap("<C-l>", ":bn<CR>")
nmap("<C-j>", ":wincmd w<CR>")
nmap("<C-k>", ":wincmd W<CR>")
nmap("<Leader>gh", "V :'<,'>GBrowse<CR>")
vmap("<Leader>gh", ":'<,'>GBrowse<CR>")

nmap("<Leader>t", ":TagbarToggle<cr>")
nmap("<Leader>T", ":Tags<cr>")

-- Telescope settings
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        -- Disable the default item up/down mappings
        ["<c-N>"] = false,
        ["<c-P>"] = false,
        -- ...and climb aboard the HJKL train
        ["<C-J>"] = actions.move_selection_next,
        ["<C-K>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "cpp",
    "clojure",
    "go",
    "lua",
    "python",
    "rust",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "markdown",
    "bash",
    "html",
    "css",
    "ruby",
    "scala",
    "json",
    "yaml",
    "toml",
    "dockerfile",
    "terraform",
    "hcl",
    "java",
    "kotlin",
  },
  highlight = {
    enable = true,

    -- disable highlight for large files
    disable = function(_lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
})
-- HACK: I needed to muck around to get vim help docs displaying properly, since there was a conflict
-- with the parser in the underlying nix package. Running:
--
--   :echo nvim_get_runtime_file('parser', v:true)
--
-- yielded two entries, with one in the nix store. When I force-deleted the parser directcry from the
-- nix store and relaunched nvim, things started working as expected.

-- LSP configuration
require("mason").setup()
require("mason-nvim-dap").setup({
  ensure_installed = { "python", "ruby" },
})
require("mason-null-ls").setup({
  ensure_installed = { "jq" },
  handlers = {},
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ruff",
    "ruff_lsp",
    "pyright",
    "ruby_lsp",
    "clojure_lsp",
  },
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").lua_ls.setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    })
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  capabilities = lsp_capabilities,
})
require("lspconfig").ruff_lsp.setup({
  on_attach = function(client, _bufnr)
    if client.name == "ruff_lsp" then
      -- example: conditionally disable LSP features
      client.server_capabilities.hoverProvider = false
    end
  end,
  init_options = {
    settings = {
      args = {},
      -- ruff = {
      --   check = {
      --     on_save = true
      --   }
      -- }
    },
  },
  capabilities = lsp_capabilities,
})
require("lspconfig").pyright.setup({
  settings = {
    pyright = {
      disableOrganizeImports = false,
    },
    -- python = {
    --   -- analysis = {
    --   --   -- Ignore all files for analysis to exclusively use Ruff for linting
    --   --   ignore = { '*' },
    --   -- },
    -- },
  },
  capabilities = lsp_capabilities,
})

require("lspconfig").sorbet.setup({
  capabilities = lsp_capabilities,
})

require("lspconfig").syntax_tree.setup({
  capabilities = lsp_capabilities,
})

require("lspconfig").ruby_lsp.setup({
  capabilities = lsp_capabilities,
})

require("lspconfig").clojure_lsp.setup({
  capabilities = lsp_capabilities,
})

-- DAP configuration
local dap = require("dap")
nmap("<Leader>db", ":lua require('dap').toggle_breakpoint()<CR>")
nmap("<Leader>dc", ":lua require('dap').continue()<CR>")
nmap("<Leader>dh", ":lua require('dap.ui.widgets').hover()<CR>")
nmap("<Leader>dp", ":lua require('dap.ui.widgets').preview()<CR>")

local function show_dap_filetype_info()
  local info = {
    filetype = vim.bo.filetype,
    adapter = dap.adapters[vim.bo.filetype],
    configuration = dap.configurations[vim.bo.filetype],
  }
  vim.api.nvim_echo({ { vim.inspect(info) } }, false, {})
end
nmap("<Leader>d?", show_dap_filetype_info)

local dapWinSettingsGroup = vim.api.nvim_create_augroup("DAP window settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-float",
  callback = function()
    -- close the floating window
    nmap("<Leader>dq", ":close!<CR>")
    nmap("q", ":close!<CR>")
  end,
  group = dapWinSettingsGroup,
})

local globalHighlightsNamespace = 0
vim.api.nvim_set_hl(globalHighlightsNamespace, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(globalHighlightsNamespace, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(globalHighlightsNamespace, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DapBreakpoint",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapLogPoint",
  { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

dap.listeners.before.attach["local.dap.repl"] = function()
  require("dap.repl").open()
end
dap.listeners.before.launch["local.dap.repl"] = function()
  require("dap.repl").open()
end
dap.listeners.before.event_terminated["local.dap.repl"] = function()
  require("dap.repl").close()
end
dap.listeners.before.event_exited["local.dap.repl"] = function()
  require("dap.repl").close()
end

-- DAP-UI configuration
-- local dapui = require("dapui")
-- dapui.setup()
-- dap.listeners.before.attach.dapui_config = function()
--   dapui.open()
-- end
-- dap.listeners.before.launch.dapui_config = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated.dapui_config = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--   dapui.close()
-- end

dap.adapters.python = {
  type = "executable",
  -- TODO: control this with a dynamic nvim setting
  command = vim.fn.exepath("python3"),
  args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path then
        return venv_path .. "/bin/python"
      else
        return vim.fn.exepath("python")
      end
    end,
  },
}

dap.adapters.lua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
dap.configurations.lua = {
  {
    type = "lua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

require("nvim-surround").setup()

local luaFtSettingsGroup = vim.api.nvim_create_augroup("Lua settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    -- eval the current buffer
    nmap("<Leader>e", ":luafile %<CR>")

    -- TODO: figure out how to eval the visual selection
    --vmap("<Leader>e", ":luafile<CR>")

    -- launch 'one-small-step-for-vimkind' debugger server
    nmap("<Leader>ds", ":lua require('osv').launch({port = 8086})<CR>")

    -- run debug session against the current buffer
    nmap("<Leader>de", ":lua require('osv').run_this()<CR>")
  end,
  group = luaFtSettingsGroup,
})

-- autoformat via lsp on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  -- pattern = { "*.rb" },
  callback = function(ev)
    vim.lsp.buf.format({ async = false })
  end,
})

-- Completion
local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  sources = {
    { name = "copilot" },
    { name = "path" },
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "vim-dadbod-completion", keyword_length = 2 },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      elseif has_words_before() then
        cmp.complete()
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        end
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local cmp_format = require("lspkind").cmp_format({
        mode = "symbol",
        maxwidth = 80,
        symbol_map = {
          Copilot = "",
        },
      })
      local kind = cmp_format(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"

      return kind
    end,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
})

-- Copilot
require("copilot").setup({
  -- disable suggestion and panel modules so they don't conflict with copilot-cmp completions
  suggestion = { enabled = false },
  panel = { enabled = false },
})
require("copilot_cmp").setup()

-- AI setup
vim.g.vim_ai_token_file_path = "~/.config/openai.token"
vim.g.vim_ai_chat = {
  options = {
    model = "gpt-4",
    temperature = 0.2,
  },
}
nmap("<Leader>c", ":AIChat<CR>")

-- Highlights
-- Customization for Pmenu (used by nvim-cmp)
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })