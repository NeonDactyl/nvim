-- ~/.config/nvim/lua/neondactyl/keymap.lua
local M = {}

function M.setup_global_whichkey_maps(wk_instance)
-- Register your keymaps here
  wk_instance.add({
    -- Top-level Leader group
    { "<leader>", group = "Leader" },
  
    -- [F]ind group and its mappings
    { "<leader>f", group = "[F]ind" },
    { "<leader>ff", desc = "[F]ile" },
    { "<leader>fg", desc = "[G]rep" },
  
    -- [L]SP group and its mappings
    { "<leader>l", group = "[L]SP" },
    { "<leader>lc", desc = "[C]ode Action" },
    { "<leader>ld", desc = "[D]iagnostics" },
    { "<leader>lf", desc = "[F]ormat" },
    { "<leader>lr", desc = "[R]ename" },
    { "<leader>lw", desc = "[W]orkspace Diagnostics" },
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    { "<leader>gg", M.lazygit_toggle, desc = "ToggleLazygit" },
  })
end

-- If you have any other non-which-key specific keymaps you want to define here,
-- you can add them using vim.keymap.set. For example:
-- vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save File" })
--
-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

function M.setup_nvimtree_keymaps(bufnr)
  local api = require "nvim-tree.api"
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  
  -- Custom NvimTree mappings
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

function M.lazygit_toggle()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
      zindex = 200,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_)
    end,
    count = 99,
  }
  lazygit:toggle()
end

return M
