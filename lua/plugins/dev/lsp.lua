local caps = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    -- blink supports additional completion capabilities, so broadcast that to servers.
    -- require("blink.cmp").get_lsp_capabilities(),
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true
                }
            },
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
        },
    }
)

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = {
                    max_concurrent_installers = 20,
                    ui = {
                        border = v.ui.cur_border,
                        height = 0.8,
                        icons = {
                            package_installed = v.ui.icons.bullet,
                            package_pending = v.ui.icons.ellipses,
                            package_uninstalled = v.ui.icons.o_bullet,
                        },
                    },
                    keymaps = {
                        toggle_server_expand = "<CR>",
                        install_server = "i",
                        update_server = "u",
                        check_server_version = "c",
                        update_all_servers = "U",
                        check_outdated_servers = "C",
                        uninstall_server = "X",
                        cancel_installation = "<C-c>",
                    },
                }
            },
            {
                "williamboman/mason-lspconfig.nvim",
                opts = {
                    ensure_installed = {
                        "clangd",
                        "dockerls",
                        "jsonls",
                        "lua_ls",
                        "pyright",
                        "ts_ls"
                    },
                },
                init = function()
                    local populate_setup = function(servers_tbl, attach_fn)
                        local init_server = function(server_name, server_cfg, attach, default_caps)
                            server_cfg.on_attach = attach
                            server_cfg.hints = { enabled = true }
                            server_cfg.capabilities = default_caps
                            require("lspconfig")[server_name].setup(server_cfg)
                        end

                        local setup_tbl = {
                            function(server_name)
                                init_server(server_name, {}, attach_fn, caps)
                            end
                        }

                        for name, cfg in pairs(servers_tbl) do
                            setup_tbl[name] = function()
                                init_server(name, cfg, attach_fn, caps)
                            end
                        end

                        return setup_tbl
                    end

                    local lsp = require('nyx.lsp')
                    require("mason-lspconfig").setup_handlers(populate_setup(lsp.servers, lsp.on_attach))
                end
            },
        },
        config = function()
            require("lspconfig.ui.windows").default_options.border = v.ui.cur_border
            vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
            local lsp = require('nyx.lsp')
            require("lspconfig")["nixd"].setup({
                on_attach = lsp.on_attach,
                hints = {
                    enabled = true
                },
                capabilities = caps,
                cmd = { "nixd" },
                settings = {
                    nixd = {
                        nixpkgs = {
                            expr = { "import <nixpkgs> {}", "import (builtins.getFlake \"/home/valerie/nixos\").inputs.nixpkgs {}" }
                        },
                        formatting = {
                            command = { "alejandra" }
                        },
                        options = {
                            nixos = {
                                expr = "(builtins.getFlake \"/home/valerie/nixos\").nixosConfigurations.waves.options"
                            }
                        }
                    }
                }
            })
        end
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = {
                "beautysh",
                "biome",
                "eslint-lsp",
                "gopls",
                "prettier",
            },
            automatic_installation = true,
        },
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            progress = {
                suppress_on_insert = true,
                display = {
                    done_ttl = 2,
                    progress_icon = { pattern = "grow_horizontal", period = 0.75 },
                    done_style = "NonText",
                    group_style = "NonText",
                    icon_style = "NonText",
                    progress_style = "NonText"
                },
            },
            notification = {
                window = {
                    border = v.ui.cur_border,
                    border_hl = "NonText",
                    normal_hl = "NonText",
                    winblend = 0,
                }
            }
        }
    },
    {
        "Wansmer/symbol-usage.nvim",
        event = 'LspAttach',
        opts = {
            hl = { link = 'NonText' },
            references = { enabled = true, include_declaration = false },
            definition = { enabled = true },
            implementation = { enabled = true }
        },
    },
    {
        "utilyre/barbecue.nvim",
        event = "LspAttach",
        dependencies = {
            "SmiteshP/nvim-navic",
        },
        opts = {}
    }
}
