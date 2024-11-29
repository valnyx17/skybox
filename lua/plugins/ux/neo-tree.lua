return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>fe", "<cmd>Neotree toggle reveal_force_cwd<cr>", mode = "n" },
    },
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_diagnostics = false,
        default_component_configs = {
            indent = {
                padding = 0,
                with_expanders = false,
                with_markers = false,
            },
            icon = {
                -- folder_closed = "",
                -- folder_open = "",
                -- folder_empty = "",
                folder_closed = "",
                folder_open = "",
                folder_empty = "󰜌",
                default = "",
                provider = function(icon, node, state)
                    if node.type == "file" or node.type == "terminal" then
                        local success, web_devicons = pcall(require, "nvim-web-devicons")
                        local name = node.type == "terminal" and "terminal" or node.name
                        if success then
                            local devicon, hl = web_devicons.get_icon(name)
                            icon.text = devicon or icon.text
                            icon.highlight = hl or icon.highlight
                        end
                    end
                end
            },
            git_status = {
                symbols = {
                    -- added = "",
                    added = v.ui.git.icons.add,
                    deleted = v.ui.git.icons.remove,
                    -- modified = "",
                    modified = v.ui.git.icons.mod,
                    renamed = v.ui.git.icons.rename,
                    untracked = "",
                    ignored = "",
                    unstaged = v.ui.git.icons.unstaged,
                    staged = "",
                    conflict = "",
                },
            },
        },
        window = {
            width = 25,
            mappings = {
                ["o"] = "open",
                ["h"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == 'directory' and node:is_expanded() then
                        require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
                    else
                        require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
                    end
                end,
                ["l"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == 'directory' then
                        if not node:is_expanded() then
                            require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
                        elseif node:has_children() then
                            require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
                        end
                    end
                end,
                ['e'] = function() vim.api.nvim_exec('Neotree focus filesystem left', true) end,
                ['b'] = function() vim.api.nvim_exec('Neotree focus buffers left', true) end,
                ['g'] = function() vim.api.nvim_exec('Neotree focus git_status left', true) end,
            },
        },
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                    "node_modules",
                    "__pycache__",
                },
            },
            -- follow_current_file = true,
            hijack_netrw_behavior = "open_current",
            use_libuv_file_watcher = true,
        },
        git_status = {
            window = {
                position = "float",
            },
        },
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function(_)
                    vim.opt_local.signcolumn = "auto"
                end,
            },
        },
    },
}
