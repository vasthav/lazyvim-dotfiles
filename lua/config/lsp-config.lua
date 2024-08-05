-- Ensure packer is installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand to reload neovim whenever you save the init.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- Install your plugins here
packer.startup(function(use)
    use("wbthomason/packer.nvim") -- Have packer manage itself
    use("neovim/nvim-lspconfig")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("L3MON4D3/LuaSnip")
    use("jose-elias-alvarez/null-ls.nvim")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- Setup LSP configuration for Tailwind CSS
local lspconfig = require("lspconfig")

lspconfig.tailwindcss.setup({
    on_attach = function(client, bufnr)
        local buf_map = vim.api.nvim_buf_set_keymap
        local buf_opts = { noremap = true, silent = true }

        buf_map(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", buf_opts)
        buf_map(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", buf_opts)
        buf_map(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", buf_opts)
    end,
    -- capabilities = capabilities,
    filetypes = { "html", "elixir", "eelixir", "ex", "heex" },
    init_options = {
        userLanguages = {
            elixir = "html-eex",
            eelixir = "html-eex",
            heex = "html-eex",
        },
    },
})

-- Setup nvim-cmp
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})

-- Setup null-ls for Prettier
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            filetypes = {
                "html",
                "css",
                "javascript",
                "typescript",
                "vue",
                "svelte",
                "json",
                "javascriptreact",
                "typescriptreact",
                "tsx",
                "jsx",
            },
            extra_filetypes = { "tsx", "jsx" },
        }),
    },
    on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
            vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
        augroup END
      ]])
        end
    end,
})
