-- Neovim 0.12+ (uses vim.pack and the native vim.lsp.config/enable API)

vim.g.mapleader = ","
vim.g.maplocalleader = ","

------------------------------------------------------------------------
-- Options (non-defaults only)
------------------------------------------------------------------------
local o = vim.o
o.number = true
o.colorcolumn = "80"
o.smartindent = true
o.wrap = false
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamed"
o.list = true
o.listchars = "tab:>.,trail:.,extends:#,nbsp:."
o.background = "dark"
-- vim.opt.diffopt:append("vertical")
-- vim.opt.wildignore:append("*.pyc")
-- vim.g.netrw_list_hide = [[\.pyc$]]

-- ripgrep for :grep, plus the :Find helper
-- o.grepprg = "rg --vimgrep"
-- o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
-- vim.api.nvim_create_user_command("Find", function(opts)
--   vim.cmd("silent! grep! " .. opts.args)
--   vim.cmd("cwindow")
--   vim.cmd("redraw!")
-- end, { nargs = "+", bar = true })

------------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------------
-- Keep treesitter parsers in sync whenever vim.pack installs/updates it.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == "nvim-treesitter" and (d.kind == "install" or d.kind == "update") then
      if not d.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/deparr/tairiki.nvim",
  "https://github.com/folke/tokyonight.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/ibhagwan/fzf-lua",
  { src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4.x") },
  "https://github.com/folke/flash.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  -- version range = tagged releases, which ship a prebuilt fuzzy matcher
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  "https://github.com/tpope/vim-fugitive",
})

vim.cmd.colorscheme("tairiki-dimmed")

------------------------------------------------------------------------
-- Treesitter
------------------------------------------------------------------------
local ts_languages = { "javascript", "typescript", "tsx", "html", "css", "json" }
require("nvim-treesitter").install(ts_languages) -- async; skips what's installed

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "html", "css", "json",
  },
  callback = function(ev)
    -- fails (harmlessly) until the parser has finished installing
    if pcall(vim.treesitter.start) then
      -- the built-in regex indenters don't understand JSX
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

------------------------------------------------------------------------
-- Editing plugins
------------------------------------------------------------------------
require("nvim-surround").setup({})
require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup({})
require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
-- vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Flash search toggle" })

------------------------------------------------------------------------
-- Completion
------------------------------------------------------------------------
-- "default" preset: <C-n>/<C-p> to move, <C-y> to accept, <C-e> to dismiss,
-- <C-space> to open the menu or docs
require("blink.cmp").setup({
  keymap = { preset = "default" },
  completion = {
    documentation = { auto_show = true },
  },
  signature = { enabled = true },
})

------------------------------------------------------------------------
-- Diagnostics
------------------------------------------------------------------------
require("tiny-inline-diagnostic").setup({
  options = {
    add_messages = {
      display_count = true,
    },
    multilines = {
      enabled = true,
    },
  },
})
vim.diagnostic.config({ virtual_text = false })

------------------------------------------------------------------------
-- fzf-lua
------------------------------------------------------------------------
require("fzf-lua").setup({
  winopts = { preview = { layout = "vertical", vertical = "up:50%" } },
})

local function fzf(lhs, picker)
  vim.keymap.set("n", lhs, function()
    require("fzf-lua")[picker]()
  end)
end

fzf("<leader>f", "git_files")
fzf("<leader>F", "files")
-- "tags" come from the LSP rather than a ctags file (<C-]> also uses the LSP)
fzf("<leader>t", "lsp_live_workspace_symbols")
fzf("<leader>T", "lsp_document_symbols")
fzf(";", "buffers")
fzf("<leader>l", "lines")
fzf("<leader>b", "lines") -- same as <leader>l in the old vimrc
fzf("<Space>", "blines")
fzf("<leader>h", "oldfiles")

------------------------------------------------------------------------
-- LSP (JS/TS/JSX/TSX)
------------------------------------------------------------------------
-- Servers: typescript-language-server (+ typescript), oxlint, oxfmt
vim.lsp.enable({ "tsc", "oxlint", "oxfmt" })
-- vim.lsp.enable({ "oxlint", "oxfmt" })

local lsp_group = vim.api.nvim_create_augroup("user.lsp", { clear = true })

-- local lspconfig = require('lspconfig')
-- vim.lsp.config("tsc", {
--   cmd = { "npx", "tsc", "--lsp", "--stdio" },
--   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
--   root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", ".git"),
--   -- Optional: Performance tuning configuration 
--   init_options = {
--     hostInfo = "neovim"
--   }
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })

    -- Format on save with oxfmt only (ts_ls also offers formatting; ignore it)
    if client.name == "oxfmt" then
      local fmt_group = vim.api.nvim_create_augroup("user.oxfmt." .. args.buf, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_group,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, name = "oxfmt", timeout_ms = 2000 })
        end,
      })
    end
  end,
})

-- Keep nvim-lspconfig's own oxfmt root detection, just skip foreign buffers.
-- local oxfmt_root_dir = vim.lsp.config.oxfmt and vim.lsp.config.oxfmt.root_dir
-- if oxfmt_root_dir then
--   vim.lsp.config("oxfmt", {
--     root_dir = function(bufnr, on_dir)
--       if not is_foreign_buffer(bufnr) then
--         oxfmt_root_dir(bufnr, on_dir)
--       end
--     end,
--   })
-- end

------------------------------------------------------------------------
-- Mappings
------------------------------------------------------------------------
local map = vim.keymap.set

-- map("n", "<leader><space>", "<cmd>noh<cr>")

-- Tab jumps between matching pairs (needs matchit's % mapping, hence remap)
vim.cmd.packadd("matchit")
map({ "n", "x", "o" }, "<Tab>", "%", { remap = true })

map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "$")
map("x", "L", "g_")

-- reselect last changed/pasted text
map({ "n", "x", "o" }, "<leader>v", "`[V`]")

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
-- diagnostic window
-- map("n", "<leader>d", "<C-w>d")

map("n", "<leader>c", ":ccl | pc | noh<CR>")

map("n", "<leader>s", "<cmd>Git<cr>") -- fugitive status

-- append the Jira-style key from the branch name, e.g. "[ABC-123] "
map("n", "<leader>j", function()
  local key = vim.fn.system("git symbolic-ref HEAD"):match("%u+%-%d+")
  if key then
    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line() .. "[" .. key .. "] ")
  end
end)


-- vim.diagnostic.config({ virtual_text = false })
-- vim.o.updatetime = 250
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
-- vim.diagnostic.config({
--   virtual_text = true,
--   severity_sort = true,
-- })

------------------------------------------------------------------------
-- Filetype abbreviations
------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function(ev)
    map("ia", "log", "console.log()<Left>", { buffer = ev.buf })
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "html", "htmldjango", "jinja" },
--   callback = function(ev)
--     map("ia", "tt", "{{}}<Left><Left>", { buffer = ev.buf })
--     map("ia", "vv", "{%%}<Left><Left>", { buffer = ev.buf })
--   end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "html",
--   callback = function(ev)
--     map("i", ",/", "</<C-X><C-O>", { buffer = ev.buf, remap = true })
--   end,
-- })
