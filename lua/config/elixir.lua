-- elixir Setup
require({
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            elixirls = {
                keys = {
                    {
                        "<leader>cp",
                        function()
                            local params = vim.lsp.util.make_position_params()
                            LazyVim.lsp.execute({
                                command = "manipulatePipes:serverid",
                                arguments = {
                                    "toPipe",
                                    params.textDocument.uri,
                                    params.position.line,
                                    params.position.character,
                                },
                            })
                        end,
                        desc = "To Pipe",
                    },
                    {
                        "<leader>cP",
                        function()
                            local params = vim.lsp.util.make_position_params()
                            LazyVim.lsp.execute({
                                command = "manipulatePipes:serverid",
                                arguments = {
                                    "fromPipe",
                                    params.textDocument.uri,
                                    params.position.line,
                                    params.position.character,
                                },
                            })
                        end,
                        desc = "From Pipe",
                    },
                },
            },
        },
    },
})

require("lazy").setup({
    -- other plugins
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "elixir", "eex", "heex" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
})

require("lazy").setup({
    -- other plugins
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- install different completion source
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                -- add different completion source
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                -- using default mapping preset
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                snippet = {
                    -- you must specify a snippet engine
                    expand = function(args)
                        -- using neovim v0.10 native snippet feature
                        -- you can also use other snippet engines
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end,
    },
})

lspconfig.emmet_ls.setup({
    capabilities = capabilities,
    filetypes = { "html", "css", "elixir", "eelixir", "heex" },
})
