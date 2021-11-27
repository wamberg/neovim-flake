{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.vim.fuzzyfind.telescope;
in
{
  options.vim.fuzzyfind.telescope = {
    enable = mkEnableOption "Enable telescope";


  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-telescope
      popup-nvim
      plenary-nvim
    ];

    vim.luaConfigRC = ''
      local wk = require("which-key")

      wk.register({
        f = {
          name = "Find",
          a = { "All Files" },
          b = { "Find Buffer"},
          f = { "Find File"},
          h = { "Find Header"},
          x = { "Close buffer" },
        },
      }, { prefix = "<leader>" })
    '';

    vim.nnoremap = {
      "<leader>fa" = "<cmd>Telescope find_files<cr>";
      "<leader>ff" = "<cmd>Telescope git_files<cr>";
      "<leader>fg" = "<cmd>Telescope live_grep<cr>";
      "<leader>fh" = "<cmd>Telescope grep_string search=^#\\  use_regex=true=<cr>";
      "<leader>fb" = "<cmd>Telescope buffers<cr>";
      "<leader>bx" = "<cmd>bdelete<cr>";
    };

  };
}
