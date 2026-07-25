return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- treesitter's indent queries don't know how to continue /** */ comment
      -- blocks, so C/C++ falls back to Vim's native cindent, which does.
      indent = { enable = true, disable = { "c", "cpp" } },
    },
  },
}
