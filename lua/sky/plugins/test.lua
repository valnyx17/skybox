return {
    "nvim-neotest/neotest",
    dependencies = {
        { "pablobfonseca/nvim-nio",       branch = "fix-deprecations" },
        { "nvim-neotest/neotest-plenary", dependencies = { "nvim-lua/plenary.nvim" } },
        "tpope/vim-projectionist",
        "antoinemadec/FixCursorHold.nvim",
        "jfpedroza/neotest-elixir",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-jest",
        {
            "stevearc/overseer.nvim",
            cmd = {
                "OverseerToggle",
                "OverseerOpen",
                "OverseerRun",
                "OverseerBuild",
                "OverseerClose",
                "OverseerLoadBundle",
                "OverseerSaveBundle",
                "OverseerDeleteBundle",
                "OverseerRunCmd",
                "OverseerQuickAction",
                "OverseerTaskAction",
            },
            keys = {
                { "<localleader>tsR", "<cmd>OverseerRunCmd<cr>",       desc = "Run Command" },
                { "<localleader>tsa", "<cmd>OverseerTaskAction<cr>",   desc = "Task Action" },
                { "<localleader>tsb", "<cmd>OverseerBuild<cr>",        desc = "Build" },
                { "<localleader>tsc", "<cmd>OverseerClose<cr>",        desc = "Close" },
                { "<localleader>tsd", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
                { "<localleader>tsl", "<cmd>OverseerLoadBundle<cr>",   desc = "Load Bundle" },
                { "<localleader>tso", "<cmd>OverseerOpen<cr>",         desc = "Open" },
                { "<localleader>tsq", "<cmd>OverseerQuickAction<cr>",  desc = "Quick Action" },
                { "<localleader>tsr", "<cmd>OverseerRun<cr>",          desc = "Run" },
                { "<localleader>tss", "<cmd>OverseerSaveBundle<cr>",   desc = "Save Bundle" },
                { "<localleader>tst", "<cmd>OverseerToggle<cr>",       desc = "Toggle" },
            },
            opts = {},
        },
    },
    config = function()
        local neotest = require("neotest")
        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        local nt = {}

        nt.env = nil

        function nt.run(arg)
            local default_env = nt.env or {}
            local args

            if type(arg) == "table" then
                local env = arg.env or {}
                arg.env = vim.tbl_extend("force", default_env, env)
                args = arg
            else
                args = { arg, env = default_env }
            end

            print("Neotest run called with arg", args[1])
            require("neotest").run.run(args)
        end

        function nt.run_file(args)
            args = args or {}
            args[1] = vim.fn.expand("%")
            nt.run(args)
        end

        function nt.run_suite(args)
            args = args or {}
            args[1] = vim.fn.getcwd()
            nt.run(args)
        end

        function nt.read_env(...) nt.env = vim.fn.DotenvRead(...) end

        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+",
                        "")
                    return message
                end,
            },
        }, neotest_ns)

        require("neotest.logging"):set_level("trace")

        require("neotest").setup({
            log_level = L.INFO,
            discovery = { enabled = false },
            diagnostic = { enabled = true },
            consumers = {
                overseer = require("neotest.consumers.overseer"),
            },
            output = { open_on_run = true },
            -- output = {
            --   enabled = true,
            --   open_on_run = false,
            -- },
            overseer = {
                enabled = true,
                force_default = true,
            },
            status = {
                enabled = true,
            },
            -- output_panel = {
            --   enabled = true,
            --   open = "botright split | resize 25",
            -- },
            -- quickfix = {
            --   enabled = false,
            --   open = function() vim.cmd("Trouble quickfix") end,
            -- },
            icons = {
                expanded = "",
                child_prefix = "",
                child_indent = "",
                final_child_prefix = "",
                non_collapsible = "",
                collapsed = "",

                passed = v.test.icons.passed,
                running = v.test.icons.running,
                skipped = v.test.icons.skipped,
                failed = v.test.icons.failed,
                unknown = v.test.icons.unknown,
                running_animated = vim.tbl_map(function(s) return s .. " " end,
                    { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
                -- running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                -- running_animated = vim.tbl_map(
                --   function(s) return s .. " " end,
                --   { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                -- ),
                -- running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
            },
            summary = {
                mappings = {
                    jumpto = "<cr>",
                    -- jumpto = "gf",
                    expand = "<tab>",
                    -- expand = { "<Space>", "<2-LeftMouse>" },
                    -- expand = "l",
                    attach = "a",
                    expand_all = "L",
                    output = "o",
                    run = "<C-r>",
                    short = "p",
                    stop = "u",
                },
            },
            adapters = {
                require("neotest-plenary"),
                require("neotest-elixir")({
                    args = { "--trace" },
                    strategy = "iex",
                    iex_shell_direction = "vertical",
                    extra_formatters = { "ExUnit.CLIFormatter", "ExUnitNotifier" },
                }),
                require("neotest-jest")({
                    -- jestCommand = "npm test --",
                    -- jestConfigFile = "jest.config.js",
                    cwd = require("neotest-jest").root,
                    -- cwd = function(path) return require("lspconfig.util").root_pattern("package.json", "jest.config.js")(path) end,
                }),
            },
        })

        vim.api.nvim_create_user_command("Neotest", nt.run_suite, {})
        vim.api.nvim_create_user_command("NeotestFile", nt.run_file, {})
        vim.api.nvim_create_user_command("NeotestNearest", nt.run, {})
        vim.api.nvim_create_user_command("NeotestLast", neotest.run.run_last, {})
        vim.api.nvim_create_user_command("NeotestAttach", neotest.run.attach, {})
        vim.api.nvim_create_user_command("NeotestSummary", neotest.summary.toggle, {})
        vim.api.nvim_create_user_command("NeotestOutput", neotest.output.open, {})

        --
        -- vim.keymap.set("n", "<leader>tn", function() neotest.run.run({}) end)
        -- vim.keymap.set("n", "<leader>tt", function() neotest.run.run({ vim.api.nvim_buf_get_name(0) }) end)
        -- vim.keymap.set("n", "<leader>ta", function()
        --   for _, adapter_id in ipairs(neotest.run.adapters()) do
        --     neotest.run.run({ suite = true, adapter = adapter_id })
        --   end
        -- end)
        -- vim.keymap.set("n", "<leader>tl", function() neotest.run.run_last() end)
        -- vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end)
        -- vim.keymap.set("n", "<leader>tp", function() neotest.summary.toggle() end)
        -- vim.keymap.set("n", "<leader>to", function() neotest.output.open({ short = true }) end)
    end,
    keys = {
        {
            "<localleader>tn",
            function() require("neotest").run.run({}) end,
            mode = "n",
            desc = "run tests",
        },
        {
            "<localleader>tt",
            function() require("neotest").run.run({ vim.api.nvim_buf_get_name(0) }) end,
            mode = "n",
            desc = "run tests from current file",
        },
        {
            "<localleader>ta",
            function()
                for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do
                    require("neotest").run.run({ suite = true, adapter = adapter_id })
                end
            end,
            mode = "n",
            desc = "run entire suite for all adapters"
        },
        {
            "<localleader>tl",
            function() require("neotest").run.run_last() end,
            mode = "n",
            desc = "re-run last test",
        },
        {
            "<localleader>td",
            function() require("neotest").run.run({ strategy = "dap" }) end,
            mode = "n",
            desc = "run tests with dap",
        },
        {
            "<localleader>to",
            function() require("neotest").output.open() end,
            mode = "n",
            desc = "open output",
        },
        { "<localleader>tp", "<cmd>A<cr>",  desc = "open alt (edit)" },
        { "<localleader>tP", "<cmd>AV<cr>", desc = "open alt (vsplit)" },
    }
}
