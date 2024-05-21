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
require("lazy").setup({
  -- general
  "jremmen/vim-ripgrep",
  "tomtom/tcomment_vim",
  "easymotion/vim-easymotion",
  "majutsushi/tagbar",
  "honza/vim-snippets",
  "vim-scripts/spacehi.vim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-lua/plenary.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
  "vim-scripts/sudo.vim",
  "janko/vim-test",
  "kylechui/nvim-surround",

  -- git --
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "lewis6991/gitsigns.nvim",

  -- language-specific --
  "vim-ruby/vim-ruby",
  { "fatih/vim-go", ft = "go" },
  { "udalov/kotlin-vim", ft = "kotlin" },
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

  -- lsp, checkers, and fixers --
  -- "dense-analysis/ale",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- debugging
  "mfussenegger/nvim-dap",
  "suketa/nvim-dap-ruby",

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
}, {})

-- Set filetype based on file extension
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    tsx = "typescript",
    zshenv = "zsh",
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
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

nmap("<C-o>", ":Telescope buffers<CR>")
nmap("<C-p>", ":Telescope git_files<CR>")
nmap("<C-i>", ":Telescope live_grep<CR>")
nmap("<C-c>", ":Telescope aichats<CR>")
nmap("<C-f>", ":Rg<CR>")
nmap("<C-h>", ":bp<CR>")
nmap("<C-l>", ":bn<CR>")
nmap("<C-j>", ":wincmd w<CR>")
nmap("<C-k>", ":wincmd W<CR>")
nmap("<Leader>gh", "V :'<,'>GBrowse<CR>")
vmap("<Leader>gh", ":'<,'>GBrowse<CR>")
nmap("<Leader>e", ":luafile %<CR>")
-- TODO: figure out how to eval the visual selection
--vmap("<Leader>e", ":luafile<CR>")

-- comment toggle
nmap("<Leader>\\\\", "gcc")
vmap("<Leader>\\", "gc")

nmap("<Leader>t", ":TagbarToggle<cr>")
nmap("<Leader>T", ":Tags<cr>")

vim.cmd("highlight SpellBad term=underline gui=undercurl guisp=Orange")

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

-- LSP configuration
require'lspconfig'.sorbet.setup{}
require'lspconfig'.syntax_tree.setup{}
-- require'lspconfig'.ruby_lsp.setup{}

require("mason").setup()
require("nvim-surround").setup()

-- autoformat on demand and before save
nmap("<Leader>f", ":lua vim.lsp.buf.format({ async = false })<CR>")

vim.api.nvim_create_autocmd({"BufWritePre"}, {
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
