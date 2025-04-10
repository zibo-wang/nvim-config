return {
  "one-d-wide/lazy-patcher.nvim",
  ft = "lazy", -- for lazy loading
  config = function()
    require("lazy-patcher").setup(
      {
        -- your options here
        -- e.g. lazy_path = "/path/to/lazy.nvim"
        patches_path = vim.fn.stdpath("config") .. "lua/patches", -- Directory where patch files are stored
        print_logs = true -- Print log messages while applying changes
      }
    )
  end
}
-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0 foldlevel=0
