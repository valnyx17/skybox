local M = {}
local methods = vim.lsp.protocol.Methods

M.servers = {
    -- see $clangd -h, https://clangd.llvm.org/installation
    clangd = {
        cmd = {
            "clangd",
            "-j=6",
            "--all-scopes-completion",
            "--background-index", -- should include a compile_commands.json or .txt
            "--clang-tidy",
            "--cross-file-rename",
            "--completion-style=detailed",
            "--fallback-style=Microsoft",
            "--function-arg-placeholders",
            "--header-insertion-decorators",
            "--header-insertion=never",
            "--limit-results=10",
            "--pch-storage=memory",
            "--query-driver=/usr/include/*",
            "--suggest-missing-includes",
        },
    },
    -- https://github.com/sumneko/lua-language-server/blob/f7e0e7a4245578af8cef9eb5e3ec9ce65113684e/locale/en-us/setting.lua
    lua_ls = {
        settings = {
            Lua = {
                completion = { callSnippet = "Both" },
                format = {
                    enable = true,
                },
                hint = { enable = true },
                telemetry = { enable = false },
                workspace = { checkThirdParty = false },
            },
        },
    },
    ts_ls = {
        init_options = {
            preferences = { includeCompletionsForModuleExports = false },
        },
    },
    -- nixd = {},
    gopls = {},
    astro = {},
}

--- Sets up LSP keymaps and autocommands for the given buffer.
M.on_attach = function(client, bufnr)
    client.server_capabilities.documentHighlightProvider = nil -- disable autohighlight of document
    local lsp = vim.lsp.buf

    --- @param mode string|string[]
    --- @param lhs string
    --- @param rhs string|function
    --- @param desc string
    local function map(mode, lhs, rhs, desc, opts)
        opts = opts or {}
        require("legendary").keymap({
            lhs,
            rhs,
            mode = mode,
            description = desc,
            opts = vim.tbl_deep_extend("force", {
                buffer = bufnr,
                silent = true,
            }, opts),
        })
    end

    map("n", "gl", function()
        vim.diagnostic.open_float({ border = sky.ui.cur_border })
    end, "view [l]sp diagnostic float")

    if client.supports_method(methods.textDocument_formatting) then
        map("n", "<leader>lf", function()
            lsp.format({ timeout_ms = 2000 })
        end, "[f]ormat with [l]sp")
    end

    -- https://github.com/neovim/neovim/commit/448907f65d6709fa234d8366053e33311a01bdb9
    -- https://reddit.com/r/neovim/s/eDfG5BfuxW
    --if client.supports_method(methods.textDocument_inlayHint) then
    --     map('n', "<leader>th", function()
    --         local hint = vim.lsp.inlay_hint
    --         hint.enable(not hint.is_enabled(bufnr))
    --     end, "[t]oggle inlay [h]ints")
    -- end

    if client.supports_method(methods.textDocument_rename) then
        map("n", "<leader>lr", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, "[l]sp [r]ename", { expr = true })
    end

    if client.supports_method(methods.textDocument_definition) then
        map("n", "gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")
    end

    if client.supports_method(methods.textDocument_references) then
        map("n", "gR", require("telescope.builtin").lsp_references, "[g]oto [r]eference")
    end

    if client.supports_method(methods.textDocument_implementation) then
        map("n", "gI", require("telescope.builtin").lsp_implementations, "[g]oto [i]mplentation")
    end

    if client.supports_method(methods.textDocument_codeAction) then
        map("n", "<leader>lc", lsp.code_action, "[l]sp [c]ode action")
    end

    if client.supports_method(methods.textDocument_declaration) then
        map("n", "gD", lsp.declaration, "[g]oto [D]eclaration")
    end

    if client.supports_method(methods.textDocument_hover) then
        map("n", "K", lsp.hover, "Lsp Hover")
    end

    if client.supports_method(methods.textDocument_signatureHelp) then
        map("i", "<C-k>", lsp.signature_help, "Lsp Signature Help")
    end
end

M.icons = {
    error = "", -- alts: 󰬌      
    warn = "󰔷", -- alts: 󰬞 󰔷   ▲ 󰔷
    info = "󰙎", -- alts: 󰖧 󱂈 󰋼  󰙎   󰬐 󰰃     ● 󰬐 
    hint = "▫", -- alts:  󰬏 󰰀  󰌶 󰰂 󰰂 󰰁 󰫵 󰋢   
    ok = "✓", -- alts: ✓✓
    clients = "", -- alts:     󱉓 󱡠 󰾂 
}

return M
