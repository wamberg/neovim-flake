{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.editor.vimwiki;
in
{
  options.vim.editor.vimwiki = {
    enable = mkEnableOption "Enable vimwiki";
  };

  config = mkIf (cfg.enable) ({
    vim.startPlugins = with pkgs.neovimPlugins; [ vimwiki ];

    vim.configRC = ''
      let g:zettelkasten = '~/dev/garden/'
      let g:vimwiki_list = [{'path': zettelkasten,
                            \ 'path_html': '/tmp/garden_html/',
                            \ 'syntax': 'markdown',
                            \ 'ext': '.md'}]
      let g:vimwiki_global_ext = 0
      hi VimwikiLink term=underline ctermfg=DarkBlue guifg=DarkBlue gui=underline
      hi VimwikiHeader2 ctermfg=DarkMagenta guifg=DarkMagenta
      hi VimwikiHeader3 ctermfg=DarkGreen guifg=DarkBlue

      " Disable table_mappings that override <tab>
      let g:vimwiki_key_mappings = {
            \ 'table_mappings': 0,
            \ }

      " Create new notes
      command! NewNote :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . ".md"
    '';

    vim.luaConfigRC = builtins.readFile ./zettel.lua;
  });
}

