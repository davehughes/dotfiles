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
  "chentoast/marks.nvim",
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
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "vim-scripts/sudo.vim",
  "janko/vim-test",
  "kylechui/nvim-surround",
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  "ludovicchabant/vim-gutentags",

  -- git --
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "lewis6991/gitsigns.nvim",

  -- language-specific --
  "Olical/conjure",
  { "Olical/nfnl", filetype = "fennel" },
  {
    "alexander-born/bazel.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- lsp, checkers, and fixers --
  -- "dense-analysis/ale",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  -- note: most of these plugins require backing tools to be installed out-of-band, which I tend to do
  -- in my home-manager config.
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    }
  },
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

  -- completion and snippets
  {
    "hrsh7th/nvim-cmp",
    dependencies = "onsails/lspkind.nvim",
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "kristijanhusak/vim-dadbod-completion",
  "alexander-born/cmp-bazel",
  "zbirenbaum/copilot.lua",
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "zbirenbaum/copilot.lua",
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = "L3MON4D3/LuaSnip",
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = "L3MON4D3/LuaSnip",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
  },
  "PaterJason/cmp-conjure",

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
  "kristijanhusak/vim-dadbod-completion",
  "kristijanhusak/vim-dadbod-ui",
  "dermusikman/sonicpi.vim",
  {
    -- important: this requires lua 5.1 to be in the path and doesn't seem to know about nvim's copy;
    -- I was able to get rocks installing by adding the lua5_1 package to my home-manager deps
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = {
        "lua-curl",
        "nvim-nio",
        "mimetypes",
        "xml2lua",
        "lpeg",
        -- note: this currently needs to be patched, since the luarocks version has a bug
        -- that breaks require()
        "luajson",
      },
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
vim.opt.signcolumn = "yes"
-- vim.opt.wildignore+=*.o,*.obj,.git,*.pyc,*.egg-info,*.vim,*/htmlcov/*,*/vendor/*
vim.g.mapleader = "\\"
vim.g.maplocalleader = ";"

-- appearance
vim.opt.termguicolors = true
vim.cmd([[ colorscheme everforest ]])
vim.g.everforest_transparent_background = 1
-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "None", bg = "None" })

-- key mappings
local function keymap(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  keymap("n", shortcut, command)
end

local function vmap(shortcut, command)
  keymap("v", shortcut, command)
end

local nvim_lua_init_path = "${HOME}/.config/home-manager/nvim/init.lua"
nmap("<Leader>ne", ":edit" .. nvim_lua_init_path .. "<CR>")
nmap("<Leader>nr", ":luafile" .. nvim_lua_init_path .. "<CR>")
nmap("<C-o>", ":Telescope buffers<CR>")
nmap("<C-p>", ":Telescope git_files<CR>")
nmap("<C-i>", ":Telescope live_grep<CR>")
-- nmap("<C-c>", ":Telescope aichats<CR>")
-- nmap("<C-m>", ":Telescope marks<CR>")
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
    file_ignore_patterns = {
      ".__yobi_legacy",
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
require("telescope").load_extension("luasnip")

-- Oil
nmap("<Leader>.", ":Oil<CR>")
require("oil").setup {
  view_options = {
    show_hidden = true,
  }
}

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "clojure",
    "cpp",
    "css",
    "dockerfile",
    "fennel",
    "go",
    "hcl",
    "html",
    "http",
    "java",
    "json",
    "kotlin",
    "lua",
    "markdown",
    "nix",
    "python",
    "ruby",
    "rust",
    "scala",
    "starlark",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
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
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pylsp",
    "ruby_lsp",
    "clojure_lsp",
    "fennel_language_server",
  },
})

local lspconfig = require 'lspconfig'
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.lua_ls.setup {
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
}

lspconfig.clojure_lsp.setup {}

require('lspconfig.configs').fennel_language_server = {
  default_config = {
    -- replace it with true path
    cmd = { 'fennel-language-server' },
    filetypes = { 'fennel' },
    single_file_support = true,
    -- source code resides in directory `fnl/`
    root_dir = lspconfig.util.root_pattern("fnl", "lua"),
    settings = {
      fennel = {
        workspace = {
          -- If you are using hotpot.nvim or aniseed,
          -- make the server aware of neovim runtime files.
          library = vim.api.nvim_list_runtime_paths(),
        },
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },
}

lspconfig.fennel_language_server.setup {}

-- null-ls (or here, none-ls a compatible successor) setup
-- Adapts a bunch of tools that aren't full-fledged LSPs to play with the LSP client.
--
-- NOTE: the maintainers purged a bunch of builtins that had viable alternatives. This issue discussion
-- is the Rosetta Stone for figuring out what to move to if your beloved builtin was removed:
-- -> https://github.com/nvimtools/none-ls.nvim/discussions/81
local nls = require("null-ls")
nls.setup {
  sources = {
    nls.builtins.diagnostics.selene,
    require("none-ls.formatting.jq"),
    require("local.null_ls.autoimport").with({
      env = function(params)
        print("loading autoimport env")
        return { PYTHONPATH = "/Users/dave/projects/lolmax/.venv/lib/python3.10/site-packages/" }
      end,
    }),
  },
}

-- MANUAL STEP: need to install plugins via:
-- `:PylspInstall pyls-isort pylsp-mypy pylsp-rope python-lsp-ruff ...`
--
-- For configuration options, see:
-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
lspconfig.pylsp.setup({
  capabilities = lsp_capabilities,
  settings = {
    pylsp = {
      plugins = {
        flake8 = { enabled = false },
        autopep8 = { enabled = false },
        mccabe = { enabled = false },
        -- I couldn't get rope working the way I want, so I'm using a hand-rolled null-ls wrapper around autoimport instead
        -- rope_autoimport = { enabled = false },
        -- pylsp_rope = {
        --   autoimport = { enabled = true },
        -- },
      }
    },
  },
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
  callback({
    type = "server",
    host = config.host or "127.0.0.1",
    port = config.port or 8086,
  })
end
dap.configurations.lua = {
  {
    type = "lua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

require("nvim-surround").setup {}
require("marks").setup {}
require("gitsigns").setup {
  numhl = true,
  linehl = true,
}

-- customize gitsigns icons
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

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

local clojureFtSettingsGroup = vim.api.nvim_create_augroup("Clojure settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "clojure",
  callback = function()
    -- eval the current buffer
    nmap("[e", ":Eval<CR>")

    -- reload the current namespace
    nmap("[r", ":Eval (use :reload-all (symbol (str *ns*)))<CR>")
  end,
  group = clojureFtSettingsGroup,
})

local dadbodFtSettingsGroup = vim.api.nvim_create_augroup("vim-dadbod autocmds", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require('cmp').setup.buffer({
      sources = {
        { name = 'vim-dadbod-completion' }
      }
    })
  end,
  group = dadbodFtSettingsGroup,
})

local bazelFtSettingsGroup = vim.api.nvim_create_augroup("Bazel settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "bzl",
  callback = function()
    print("loading bazel filetype settings")
    -- hook up go-to-definition to use bazel.nvim
    -- HACK: emulate tag-jump-based go-to-definition by setting a mark and a shortcut that
    -- lets us jump back (though only one level).
    nmap("<C-]>", function()
      vim.cmd(":mark T")
      vim.fn.GoToBazelDefinition()
    end)
    nmap("<C-t>", "'Tdm-")
  end,
  group = bazelFtSettingsGroup,
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

local function map_boolean_to_onoff_string(value)
  local t = {}
  t[true] = "on"
  t[false] = "off"
  return t[value]
end

-- toggle global completions
nmap("<Leader>C", function()
  local enabled = require("cmp.config").get().enabled
  cmp.setup({ enabled = not enabled })
  enabled = require("cmp.config").get().enabled
  print("completions " .. map_boolean_to_onoff_string(enabled) .. " (global)")
end)

cmp.setup({
  sources = {
    { name = "copilot" },
    { name = "conjure" },
    { name = "bazel" },
    { name = "path" },
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "vim-dadbod-completion", keyword_length = 2 },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
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

-- configure cmp-bazel to use bazelisk
vim.g.bazel_cmd = "bazelisk"

-- TODO: make the bindings here work so this is more useful than annoying
-- -- `/` cmdline setup.
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- -- `:` cmdline setup.
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     {
--       name = 'cmdline',
--       option = {
--         ignore_cmds = { 'Man', '!' }
--       }
--     }
--   })
-- })

-- lazy load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- map keys for snippet substitution navigation
keymap({ "i", "s" }, "<C-l>", function()
  luasnip.jump(1)
end)
keymap({ "i", "s" }, "<C-h>", function()
  luasnip.jump(-1)
end)

-- Copilot
require("copilot").setup({
  -- optionally disable suggestion and panel modules so they don't conflict with completions
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = false,
  },
})
-- require("copilot_cmp").setup()

-- AI setup
vim.g.vim_ai_token_file_path = "~/.config/openai.token"
vim.g.vim_ai_chat = {
  options = {
    model = "gpt-4",
    temperature = 0.2,
  },
}
nmap("<Leader>ai", ":AIChat<CR>")

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
