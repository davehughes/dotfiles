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
    build = "make"
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim"
  },
  -- { "ThePrimeagen/harpoon", dependencies = "nvim-lua/plenary.nvim" },
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
    ft = "go"
  },
  {
    "udalov/kotlin-vim",
    ft = "kotlin"
  },
  "honza/dockerfile.vim",
  "leafgarland/typescript-vim",
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
      end

      return metals_config
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
    end
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

  -- debugging
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",
  "nvim-neotest/nvim-nio",
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
  },
  "jbyuki/one-small-step-for-vimkind",

  -- appearance --
  "vim-scripts/Colour-Sampler-Pack",
  "vim-scripts/ScrollColors",
  "morhetz/gruvbox",
  "altercation/vim-colors-solarized",

  -- interfaces to external systems --
  "madox2/vim-ai",
  "tpope/vim-dadbod",
  "dermusikman/sonicpi.vim",
  "github/copilot.vim",
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  }
}

if vim.g.lazy_loaded == nil then
  require("lazy").setup(lazy_plugins, {})
  vim.g.lazy_loaded = true
  -- else
  --   print("Lazy.nvim setup was already run and hot reloading is not supported; skipping.")
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
--vim.opt.spell = true
--vim.opt.backupdir=~/.vim/sessions//
--vim.opt.directory=~/.vim/sessions//
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
vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")
-- Use :COLORSCROLL to try out new color schemes
-- Transparent background
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

-- key mappings
local function map(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
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
local actions = require('telescope.actions')

require('telescope').setup {
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
  }
}

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c', 'cpp', 'clojure', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vim', 'vimdoc', 'markdown', 'bash',
    'html', 'css', 'ruby', 'scala', 'json', 'yaml', 'toml', 'dockerfile', 'terraform', 'hcl', 'java', 'kotlin',
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
}
-- HACK: I needed to muck around to get vim help docs displaying properly, since there was a conflict
-- with the parser in the underlying nix package. Running:
--
--   :echo nvim_get_runtime_file('parser', v:true)
--
-- yielded two entries, with one in the nix store. When I force-deleted the parser directcry from the
-- nix store and relaunched nvim, things started working as expected.

-- LSP configuration
require("mason").setup()
require("mason-nvim-dap").setup {
  ensure_installed = { "python", "ruby", }
}
require("mason-null-ls").setup {
  ensure_installed = { "jq" },
  handlers = {},
}
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "ruff", "ruff_lsp", "pyright", "ruby_lsp" }
}

require("lspconfig").lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
    },
  }
}
require("lspconfig").ruff_lsp.setup {
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
    }
  }
}
require("lspconfig").pyright.setup {
  settings = {
    pyright = {
      disableOrganizeImports = false
    },
    -- python = {
    --   -- analysis = {
    --   --   -- Ignore all files for analysis to exclusively use Ruff for linting
    --   --   ignore = { '*' },
    --   -- },
    -- },
  }
}
require("lspconfig").sorbet.setup {}
require("lspconfig").syntax_tree.setup {}
require("lspconfig").ruby_lsp.setup {}

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

local dapWinSettingsGroup = vim.api.nvim_create_augroup('DAP window settings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-float',
  callback = function()
    -- close the floating window
    nmap("<Leader>dq", ":close!<CR>")
    nmap("q", ":close!<CR>")
  end,
  group = dapWinSettingsGroup,
})

local globalHighlightsNamespace = 0
vim.api.nvim_set_hl(globalHighlightsNamespace, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(globalHighlightsNamespace, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(globalHighlightsNamespace, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

vim.fn.sign_define('DapBreakpoint', {
  text = '',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpoint',
  numhl =
  'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointCondition',
  { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

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

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

require("nvim-surround").setup()

local luaFtSettingsGroup = vim.api.nvim_create_augroup('Lua settings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
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
  end
})

-- AI setup
vim.g.vim_ai_token_file_path = '~/.config/openai.token'
vim.g.vim_ai_chat = {
  options = {
    model = "gpt-4",
    temperature = 0.2,
  },
}
nmap("<Leader>c", ":AIChat<CR>")
