{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.editor;
in
{
  options.vim.editor = {
    colorPreview = mkOption {
      description = "Enable color previews";
      type = types.bool;
      default = true;
    };

  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (if cfg.colorPreview then vim-css-color else null)
      vim-tmux-navigator
      nvim-which-key
    ];

    vim.luaConfigRC = ''
      require("which-key").setup {
        plugins = {
          spelling = {
            enabled = true
          }
        }
      }
    '';

  };
  imports = [
    ./vimwiki.nix
  ];
}
