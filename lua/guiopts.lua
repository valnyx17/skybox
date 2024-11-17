local gui_opts = {
    -- general
    hide_mouse_when_typing = true,
    remember_window_size = true,

    -- visuals/animations
    cursor_vfx_mode = "wireframe",
    cursor_animation_length = 0.03,
    cursor_trail_size = 0.9,
    refresh_rate = 144,
    padding_top = 20,
    padding_bottom = 20,
    padding_right = 20,
    padding_left = 20,

    -- theme
    -- neovide_transparency = 0.0,
    transparency = 0.95,
}

for x, y in pairs(gui_opts) do
    vim.g["neovide_" .. x] = y
end

vim.o.guifont = "CommitMono:h12.5:#e-subpixelantialias"
