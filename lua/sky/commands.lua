return {
    setup = function()
        require("legendary").commands({
            { ":Profile", ":Lazy profile", description = "Open Lazy Profiler" },
        })
    end,
}
