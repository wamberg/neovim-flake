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
          a = { "<cmd>Telescope find_files<cr>", "All Files" },
          b = { "<cmd>Telescope buffers<cr>", "Find Buffer"},
          f = { "<cmd>Telescope git_files<cr>", "Find File"},
          g = { "<cmd>Telescope live_grep<cr>", "Find Grep"},
          h = { "<cmd>Telescope grep_string search=^#\\  use_regex=true=<cr>", "Find Header"},
          x = { "<cmd>bdelete<cr>", "Close File"},
        },
      }, { prefix = "<leader>" })
    '';

  };
}
