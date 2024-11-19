return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
        {
            "zbirenbaum/copilot.lua",
            opts = {
                panel = { enabled = false },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = true,
                    keymap = {
                        accept = "<M-A>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<M-D>"
                    }
                },
                filetypes = {
                    markdown = true,
                    help = true
                }
            }
        },
    },
    build = "make tiktoken",
    opts = {
        model = "claude-3.5-sonnet",
        context = "buffers",
        question_header = "## Message: ",
        answer_header = "## Response: ",
        show_folds = false,

        prompts = {
            Explain = {
                prompt =
                "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text, include the selected text as a codeblock in your reply.",
            },
            Review = {
                prompt =
                "/COPILOT_REVIEW Review the selected code, include the selected text as a codeblock in your reply.",
            },
            Fix = {
                prompt =
                "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
            },
            Optimize = {
                prompt =
                "/COPILOT_GENERATE Optimize the selected code to improve performance and readability, include the selected text as a codeblock in your reply.",
            },
            Docs = {
                prompt =
                "/COPILOT_GENERATE Please add documentation comment for the selection, include the selected text as a codeblock in your reply.",
            },
            Tests = {
                prompt = "/COPILOT_GENERATE Please generate tests for my code.",
            },
        },
        window = {
            layout = "float",
            relative = "win",
            width = math.floor(math.max(40, vim.api.nvim_win_get_width(0) * 0.4)),
            height = 1,
            row = 0,
            col = math.floor(math.max(40, vim.api.nvim_win_get_width(0) * 0.6)),
            title = "Copilot Chat",
        },
        mappings = {
            complete = { detail = "Use @<Tab> or /<Tab> for options.", insert = "<Tab>" },
            close = { normal = "q", insert = "<C-c>" },
            reset = { normal = "<C-l>", insert = "<C-l>" },
            submit_prompt = { normal = "<CR>", insert = "<C-s>" },
            accept_diff = { normal = "<C-y>", insert = "<C-y>" },
            yank_diff = { normal = "gy", register = '"' },
            show_diff = { normal = "gd" },
            show_system_prompt = { normal = "gp" },
            show_user_selection = { normal = "gs" },
        },
    }
}
