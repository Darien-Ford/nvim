return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    enabled = true,
    init = false,
    opts = function()
        local dashboard = require("alpha.themes.dashboard")

        -- Define and set highlight groups for each logo line
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#311B92" }) -- Indigo
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#512DA8" }) -- Deep Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#673AB7" }) -- Deep Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#9575CD" }) -- Medium Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = "#B39DDB" }) -- Light Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = "#D1C4E9" }) -- Very Light Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardUsername", { fg = "#D1C4E9" }) -- light purple
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#8BC34A" }) -- Greenish
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#EDD691" })

        -- Set Header
        dashboard.section.header.type = "group"
        dashboard.section.header.val = {
            {
                type = "text",
                val = "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = require("alpha.fortune"),
                opts = { hl = "AlphaShortcut", shrink_margin = false, position = "center" },
            },
        }

        -- Set menu
        dashboard.section.buttons.val = {
            { type = "text", val = "Recent Files", opts = { hl = "NeovimDashboardLogo5", position = "center" } },
            require("alpha.themes.theta").mru(1, "", 5),
            { type = "padding", val = 1 },
            { type = "text", val = "Get Started", opts = { hl = "NeovimDashboardLogo5", position = "center" } },
            dashboard.button("e", "󰈮   New File", "<cmd>ene<CR>"),
            dashboard.button("SPC ee", "   File Explorer", "<cmd>NvimTreeToggle<CR>"),
            dashboard.button("SPC ff", "󰥨   Find File", "<cmd>Telescope find_files<CR>"),
            dashboard.button("SPC fs", "󱎸   Find Word", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("SPC wr", "󰁯   Restore Session For ./", "<cmd>SessionRestore<CR>"),
            dashboard.button("l", "󰒲   Lazy Dashboard", "<cmd>Lazy<CR>"),
            dashboard.button("m", "   Mason Dashboard", "<cmd>Mason<CR>"),
            dashboard.button("q", "󰈆   Quit", "<cmd>qa<CR>"),
        }

        for i = 5, #dashboard.section.buttons.val, 1 do
            dashboard.section.buttons.val[i].opts.hl = "NeovimDashboardLogo6"
            --dashboard.section.buttons.val[i].opts.hl_shortcut = "AlphaShortcut"
        end

        dashboard.section.header.opts.hl = "NeovimDashboardLogo1"
        dashboard.section.buttons.opts.hl = "NeovimDashboardLogo6"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        return dashboard
    end,

    config = function(_, dashboard)
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        -- Send config to alpha
        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                dashboard.section.footer.val = {
                    " ",
                    " ",
                    "⚡ " .. stats.loaded .. " of " .. stats.count .. " Plugins Loaded ⚡",
                    "            "
                        .. vim.version().major
                        .. "."
                        .. vim.version().minor
                        .. "."
                        .. vim.version().patch,
                }
                pcall(vim.cmd.AlphaRedraw)
            end,
        })

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
