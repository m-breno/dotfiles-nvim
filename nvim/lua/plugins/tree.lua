return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {"<c-n>", "<cmd>Neotree toggle reveal<CR>", silent = true, desc = "Toggle sidebar" },
      {"<c-b>", "<cmd>Neotree focus<CR>", silent = true, desc = "Focus sidebar" },
    },
    opts = {}
  },
}
