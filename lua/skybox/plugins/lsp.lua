local S = vim.diagnostic.severity
local methods = vim.lsp.protocol.Methods
local ui = require('skybox.util.ui')
local keymap = require('skybox.util.keymap')

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      max_concurrent_installers = 20,
      ui = {
        border = ui.cur_border,
        height = 0.8,
        icons = {
          package_installed = ui.icons.bullet,
          package_pending = ui.icons.ellipses,
          package_uninstalled = ui.icons.o_bullet,
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
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", config = function() end },
      { "smjonas/inc-rename.nvim",           opts = {} },
      { "mrcjkb/rustaceanvim",               lazy = true },
    },
    opts = function()
      local ret = {
        on_attach = function(client, bufnr)
        end,
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          severity_sort = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = (vim.fn.has("nvim-0.10") == 1) and "icons" or ui.icons.bullet
          },
          signs = {
            text = {
              [S.ERROR] = ui.lsp.error,
              [S.HINT] = ui.lsp.hint,
              [S.INFO] = ui.lsp.info,
              [S.WARN] = ui.lsp.warn,
            },
          },
        },
        -- requires nvim >= 0.10.0, you have to configure lsp to provide them
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }
        },
        -- requires nvim >= 0.10.0, you have to configure lsp to provide them
        codelens = {
          enabled = false
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true
            }
          },
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
        },
        -- options for vim.lsp.buf.format
        format = {
          formatting_options = nil,
          timeout_ms = nil
        },
        -- LSP server settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            mason = true, -- autoinstalled by mason
            -- use this to add any additional keymaps:
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            }
          },
          clangd = {
            keys = {
              { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            },
            root_dir = function(fname)
              return require("lspconfig.util").root_pattern(
                "Makefile",
                "configure.ac",
                "configure.in",
                "config.h.in",
                "meson.build",
                "meson_options.txt",
                "build.ninja"
              )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                fname
              ) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            end,
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
            cmd = {
              "clangd",
              "--log=verbose",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
          },
          nixd = {
            mason = false,
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, (fun(server:string, opts: lspconfig.options):boolean?)|boolean>
        setup = {
          ["rust_analyzer"] = true,
          clangd = function(_, opts)
            local clangd_ext_opts = Skybox.opts("clangd_extensions.nvim")
            require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
            vim.lsp.set_log_level("DEBUG")
            return false
          end
        }
      }
      function ret.on_attach(client, bufnr)
        client.server_capabilities.documentHighlightProvider = nil -- disable autohighlight of document
        local lsp = vim.lsp.buf

        if vim.fn.has("nvim-0.10") == 1 then
          if ret.inlay_hints.enabled and client.supports_method(methods.textDocument_inlayHint) then
            if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "" and not vim.tbl_contains(ret.inlay_hints.exclude, vim.bo[bufnr].filetype) then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end

          if ret.codelens.enabled and vim.lsp.codelens and client.supports_method(methods.textDocument_codeLens) then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh
            })
          end
        end

        local nmap = keymap.create_mapper("n")

        nmap("gl", function()
          vim.diagnostic.open_float({ border = ui.cur_border })
        end, { desc = "view [l]sp diagnostic float" })

        if client.supports_method(methods.textDocument_formatting) then
          nmap("<leader>lf", function()
            lsp.format({ timeout_ms = 2000 })
          end, { desc = "[f]ormat with [l]sp" })
        end

        if client.supports_method(methods.textDocument_rename) then
          nmap("<leader>lr", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end, { desc = "[l]sp [r]ename", expr = true })
        end

        if client.supports_method(methods.textDocument_definition) then
          nmap("gd", "<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<CR>",
            { desc = "[g]oto [d]efinition" })
        end

        if client.supports_method(methods.textDocument_references) then
          nmap("gr", "<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<CR>",
            { desc = "[g]oto [r]eference" })
        end

        if client.supports_method(methods.textDocument_implementation) then
          nmap("gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<CR>",
            { desc = "[g]oto [i]mplentation" })
        end

        if client.supports_method(methods.textDocument_codeAction) then
          nmap("<leader>lc", require('fzf-lua').lsp_code_actions, { desc = "[l]sp [c]ode action" })
        end

        if client.supports_method(methods.textDocument_declaration) then
          nmap("gD", "<cmd>FzfLua lsp_declarations jump_to_single_result=true ignore_current_line=true<CR>",
            { desc = "[g]oto [D]eclaration" })
        end

        if client.supports_method(methods.textDocument_typeDefinition) then
          nmap("gy", "<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<CR>")
        end

        if client.supports_method(methods.textDocument_hover) then
          nmap("K", lsp.hover, { desc = "Lsp Hover" })
        end

        if client.supports_method(methods.textDocument_signatureHelp) then
          keymap.set("i", "<C-k>", lsp.signature_help, { desc = "Lsp Signature Help" })
        end
      end

      return ret
    end,
    config = function(_, opts)
      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = S[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and ui.icons.bullet
            or function(diagnostic)
              local icons = ui.lsp
              for d, icon in pairs(icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                  return icon
                end
              end
            end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_blink, blink = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = opts.on_attach,
        }, servers[server] or {})

        if server_opts.enabled == false then return end
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then return end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then return end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mlsp_servers = {}
      if have_mason then
        all_mlsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason = false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = ensure_installed,
          handlers = { setup }
        })
      end
    end,
  },
  -- { -- QoL features for folding
  --   "chrisgrieser/nvim-origami",
  --   event = "VeryLazy",
  --   opts = true,
  -- },
  { -- use LSP as folding provider
    "kevinhwang91/nvim-ufo",
    -- cond = vim.o.foldlevel > 0 and vim.o.foldmethod ~= "manual",
    dependencies = "kevinhwang91/promise-async",
    -- event = "UIEnter", -- needed for folds to load in time and comments being closed
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    keys = {
      { "z?", vim.cmd.UfoInspect, desc = "󱃄 :UfoInspect" },
      {
        "zm",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "󱃄 Close All Folds",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds({ "comment", "imports" })
        end,
        desc = "󱃄 Open Regular Folds",
      },
      {
        "z1",
        function()
          require("ufo").closeFoldsWith(1)
        end,
        desc = "󱃄 Close L1 Folds",
      },
      {
        "z2",
        function()
          require("ufo").closeFoldsWith(2)
        end,
        desc = "󱃄 Close L2 Folds",
      },
      {
        "z3",
        function()
          require("ufo").closeFoldsWith(3)
        end,
        desc = "󱃄 Close L3 Folds",
      },
    },
    init = function()
      -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
      -- auto-closing them after leaving insert mode, however ufo does not seem to
      -- have equivalents for zr and zm because there is no saved fold level.
      -- Consequently, the vim-internal fold levels need to be disabled by setting
      -- them to 99.
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    opts = {
      -- when opening the buffer, close these fold kinds
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        -- use `:UfoInspect` to get see available fold kinds
      },
      open_fold_hl_timeout = 800,
      provider_selector = function(_, ft, buftype)
        -- PERF disable folds on `log`, and only use `indent` for `bib` files
        if vim.tbl_contains({ "log", "ghostty", "conf", "tmux", "oil" }, ft) then
          return ""
        end
        -- ufo accepts only two kinds as priority, see https://github.com/kevinhwang91/nvim-ufo/issues/256
        if ft == "" or buftype ~= "" or vim.startswith(ft, "git") or ft == "applescript" then
          return "indent"
        end
        return { "lsp", "indent" }
      end,
      -- show folds with number of folded lines instead of just the icon
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local hlgroup = "NonText"
        local icon = ""
        local newVirtText = {}
        local suffix = ("  %s %d"):format(icon, endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, hlgroup })
        return newVirtText
      end,
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  }
}
