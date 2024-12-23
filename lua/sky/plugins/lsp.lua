local M = {}

table.insert(M, {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = {
                max_concurrent_installers = 20,
                ui = {
                    border = sky.ui.cur_border,
                    height = 0.8,
                    icons = {
                        package_installed = sky.ui.icons.bullet,
                        package_pending = sky.ui.icons.ellipses,
                        package_uninstalled = sky.ui.icons.o_bullet,
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
            },
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    "dockerls",
                    "jsonls",
                    "lua_ls",
                    "ts_ls",
                },
            },
        },
        {
            "smjonas/inc-rename.nvim",
            opts = {},
        },
        {
            "mrcjkb/rustaceanvim",
            lazy = false,
        },
    },
    config = function()
        local lsp_defaults = require("lspconfig").util.default_config
        local caps = vim.tbl_deep_extend(
            "force",
            lsp_defaults.capabilities,
            -- require('cmp_nvim_lsp').default_capabilities(lsp_defaults.capabilities),
            require("blink.cmp").get_lsp_capabilities(lsp_defaults.capabilities),
            {
                textDocument = {
                    completion = {
                        completionItem = {
                            snippetSupport = true,
                        },
                    },
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            }
        )

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
                end,
                rust_analyzer = function() end, -- let rustaceanvim manage it.
            }

            for name, cfg in pairs(servers_tbl) do
                setup_tbl[name] = function()
                    init_server(name, cfg, attach_fn, caps)
                end
            end

            return setup_tbl
        end

        local lsp = require("sky.lsp")
        vim.g.rustaceanvim = {
            server = {
                capabilities = caps,
                on_attach = lsp.on_attach,
            },
        }
        require("mason-lspconfig").setup_handlers(populate_setup(lsp.servers, lsp.on_attach))

        require("lspconfig")["nixd"].setup({
            on_attach = lsp.on_attach,
            hints = {
                enabled = true,
            },
            capabilities = caps,
            cmd = { "nixd" },
            settings = {
                nixd = {
                    nixpkgs = {
                        expr = {
                            "import <nixpkgs> {}",
                            'import (builtins.getFlake "/home/valerie/nixos").inputs.nixpkgs {}',
                        },
                    },
                    formatting = {
                        command = { "alejandra" },
                    },
                    options = {
                        nixos = {
                            expr = '(builtins.getFlake "/home/valerie/nixos").nixosConfigurations.waves.options',
                        },
                    },
                },
            },
        })
    end,
})

table.insert(M, {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
        progress = {
            suppress_on_insert = true,
            display = {
                done_ttl = 2,
                progress_icon = { pattern = "grow_horizontal", period = 0.75 },
                done_style = "NonText",
                group_style = "NonText",
                icon_style = "NonText",
                progress_style = "NonText",
            },
        },
        notification = {
            window = {
                border = sky.ui.cur_border,
                border_hl = "NonText",
                normal_hl = "NonText",
                winblend = 0,
            },
        },
    },
})

return M
