local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({
    source = "neovim/nvim-lspconfig",
    depends = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    }
})

add({ source = "WhoIsSethDaniel/mason-tool-installer.nvim" })
add({ source = "j-hui/fidget.nvim" })
add({ source = "Wansmer/symbol-usage.nvim" })

require("lspconfig.ui.windows").default_options.border = tools.ui.cur_border
vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })

local caps = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    -- blink supports additional completion capabilities, so broadcast that to servers.
    require("blink.cmp").get_lsp_capabilities(),
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
local lsp = require('lsp')
require("lspconfig")["nixd"].setup({
    on_attach = lsp.on_attach,
    hints = {
        enabled = true
    },
    capabilities = caps
})

require("mason-tool-installer").setup({
    ensure_installed = {
        "beautysh",
        "biome",
        "eslint-lsp",
        "gopls",
        "prettier",
        "astro",
        "codelldb"
    },
    automatic_installation = true,
})

require("mason").setup(
    {
        max_concurrent_installers = 20,
        ui = {
            border = tools.ui.cur_border,
            height = 0.8,
            icons = {
                package_installed = tools.ui.icons.bullet,
                package_pending = tools.ui.icons.ellipses,
                package_uninstalled = tools.ui.icons.o_bullet,
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
)

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "dockerls",
        "jsonls",
        "lua_ls",
        "pyright",
        "ts_ls",
        "rust_analyzer"
    }
})

local populate_setup = function(servers_tbl, attach_fn)
    local init_server = function(server_name, server_cfg, attach, default_caps)
        server_cfg.on_attach = attach
        server_cfg.hints = { enabled = true }
        server_cfg.capabilities = default_caps
        require("lspconfig")[server_name].setup(server_cfg)
    end

    local caps = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        -- blink supports additional completion capabilities, so broadcast that to servers.
        require("blink.cmp").get_lsp_capabilities(),
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

local lsp = require("lsp")
require("mason-lspconfig").setup_handlers(populate_setup(lsp.servers, lsp.on_attach))
