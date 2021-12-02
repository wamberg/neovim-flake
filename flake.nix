{
  description = "wamberg NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Vim plugins
    completion-nvim = { url = "github:nvim-lua/completion-nvim"; flake = false; };
    editorconfig-vim = { url = "github:editorconfig/editorconfig-vim"; flake = false; };
    fugitive = { url = "github:tpope/vim-fugitive"; flake = false; };
    github-theme = { url = "github:projekt0n/github-nvim-theme"; flake = false; };
    lightline-vim = { url = "github:itchyny/lightline.vim"; flake = false; };
    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    nvim-treesitter-context = { url = "github:romgrk/nvim-treesitter-context"; flake = false; };
    nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    popup-nvim = { url = "github:nvim-lua/popup.nvim"; flake = false; };
    rnix-lsp.url = github:nix-community/rnix-lsp;
    vim-css-color = { url = "github:ap/vim-css-color"; flake = false; };
    vim-gitgutter = { url = "github:airblade/vim-gitgutter"; flake = false; };
    vim-nix = { url = "github:LnL7/vim-nix"; flake = false; };
    vim-test = { url = "github:vim-test/vim-test"; flake = false; };
    vim-tmux-navigator = { url = "github:christoomey/vim-tmux-navigator"; flake = false; };
    vimwiki = { url = "github:vimwiki/vimwiki"; flake = false; };
  };

  outputs = { nixpkgs, flake-utils, neovim, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        plugins = [
          "completion-nvim"
          "editorconfig-vim"
          "fugitive"
          "github-theme"
          "lightline-vim"
          "nvim-lightbulb"
          "nvim-lspconfig"
          "nvim-telescope"
          "nvim-treesitter"
          "nvim-treesitter-context"
          "nvim-web-devicons"
          "nvim-which-key"
          "plenary-nvim"
          "popup-nvim"
          "vim-css-color"
          "vim-gitgutter"
          "vim-nix"
          "vim-test"
          "vim-tmux-navigator"
          "vimwiki"
        ];

        pluginOverlay = lib.buildPluginOverlay;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            pluginOverlay
            (final: prev: {
              neovim-nightly = neovim.defaultPackage.${system};
              rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            })
          ];
        };

        lib = import ./lib { inherit pkgs inputs plugins; };

        neovimBuilder = lib.neovimBuilder;
      in
      rec {
        inherit neovimBuilder pkgs;

        apps = {
          nvim = {
            type = "app";
            program = "${defaultPackage}/bin/nvim";
          };
        };

        defaultApp = apps.nvim;

        defaultPackage = packages.neovimWamberg;


        overlay = (self: super: {
          inherit neovimBuilder;
          neovimWamberg = packages.neovimWamberg;
          neovimPlugins = pkgs.neovimPlugins;
        });

        packages.neovimWamberg = neovimBuilder {
          config = {
            vim.disableArrows = true;
            vim.editor.colorPreview = true;
            vim.formatting.editorConfig.enable = true;
            vim.fuzzyfind.telescope.enable = true;
            vim.git.enable = true;
            vim.lsp.bash = true;
            vim.lsp.clang = true;
            vim.lsp.cmake = false; # Currently broken
            vim.lsp.css = true;
            vim.lsp.docker = true;
            vim.lsp.enable = true;
            vim.lsp.go = true;
            vim.lsp.html = true;
            vim.lsp.json = true;
            vim.lsp.lightbulb = true;
            vim.lsp.nix = true;
            vim.lsp.python = true;
            vim.lsp.ruby = true;
            vim.lsp.rust = true;
            vim.lsp.terraform = true;
            vim.lsp.tex = true;
            vim.lsp.typescript = true;
            vim.lsp.variableDebugPreviews = true;
            vim.lsp.vimscript = true;
            vim.lsp.yaml = true;
            vim.statusline.lightline.enable = true;
            vim.statusline.lightline.theme = "powerline";
            vim.editor.vimwiki.enable = true;
            vim.test.enable = true;
            vim.theme.github.enable = true;
            vim.viAlias = true;
            vim.vimAlias = true;
          };
        };
      });
}
