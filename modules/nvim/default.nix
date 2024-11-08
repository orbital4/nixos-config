{ pkgs, nixvim, ... }: {
    imports = [
        nixvim.homeManagerModules.nixvim
    ];
    
    home.packages = with pkgs; [
        nodejs
    ];

    programs.nixvim = {
        enable = true;
        defaultEditor = true;

        ############################################################
        # Colorscheme
        ############################################################
        colorschemes.gruvbox = {
            enable = true;
        };

        highlight = {
            Indent = {
                fg = "#171717";
            };
        };

        highlightOverride = {
            Normal = {
                bg = "#000000";
            };
            CursorLine = {
                bg = "#111111";
            };
            SignColumn = {
                bg = "NONE";
                ctermbg = "NONE";
            };
            StatusLine = {
                # fg = "#111111";
                bg = "#000000";
            };
        };

        ############################################################
        # Sets
        ############################################################
        opts = {
            number = true;
            showmode = false;
            clipboard = "unnamedplus";
            breakindent = true;
            undofile = true;
            ignorecase = true;
            smartcase = true;
            
            cursorline = true;
            scrolloff = 10;
            termguicolors = true;
            signcolumn = "yes";
            
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
            smartindent = true;
            
            hlsearch = false;
            incsearch = true;

            # :h conceallevel
            conceallevel = 2;

            # Decrease update time
            updatetime = 50;

            # Decrease mapped sequence wait time
            # Displays which-key popup sooner
            timeoutlen = 300;
            
            # Sets how neovim will display certain whitespace characters in the editor
            #    See `:help 'list'`
            #    See `:help 'listchars'`
            list = true;
            # .__raw here means that this field is raw lua code
            listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
        };

        ############################################################
        # Keymaps
        ############################################################
        globals = {
            mapleader = " ";
            maplocalleader = " ";
        };

        keymaps = [
            { mode = "n"; key = "q"; action = "<cmd>quit<CR>"; }

            # Keep cursor centered
            { mode = "n"; key = "j"; action = "jzz"; }
            { mode = "n"; key = "k"; action = "kzz"; }

            # Move selected lines up and down
            { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
            { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }
            
            # Keep centered when using J
            { mode = "n"; key = "J"; action = "mzJ`z"; }

            # Keep centered when half-page jumping
            { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; }
            { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; }
            
            # Keep centered when jumping between search terms
            { mode = "n"; key = "n"; action = "nzzzv"; }
            { mode = "n"; key = "N"; action = "Nzzzv"; }
            
            # Undo and redo in insert mode
            # <C-o> temporarily escape insert mode
            { mode = "i"; key = "<C-z>"; action = "<C-o>u"; }
            { mode = "i"; key = "<C-y>"; action = "<C-o><C-r>"; }

            # Navigate between files with Shift+Alt+H (previous file) and Shift+Alt+L (next file)
            { mode = "n"; key = "<S-A-h>"; action = ":bp<CR>"; }
            { mode = "n"; key = "<S-A-l>"; action = ":bn<CR>"; }
        ];

        ############################################################
        # Plugins
        ############################################################
        plugins.treesitter = {
            enable = true;
            settings.highlight.enable = true;
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
                # Markup/Misc
                json
                make
                markdown
                nix
                regex
                toml
                vim
                vimdoc
                xml
                yaml
                # Programming
                c
                bash
                lua
                javascript
                python
                rust
                go
            ];
        };

        plugins.ts-autotag = {
            enable = true;
            luaConfig.post = "
                require('nvim-ts-autotag').setup({
                    opts = {
                        enable_close = true,
                        enable_rename = true,
                        enable_close_on_slash = false
                    },
                })
            ";
        };

        plugins.nvim-autopairs = {
            enable = true;
        };

        plugins.indent-blankline = {
            enable = true;
            settings = {
                indent = {
                    char = "▏";
                    highlight = "Indent";
                };
                scope = {
                    show_start = false;
                    show_end = false;
                    highlight = [ "Operator" "Label" "Normal" ];
                };
            };
        };
        
        ############################################################
        # cmp
        ############################################################
        plugins.cmp = {
            enable = true;
            settings = {
                snippet = {
                    expand = ''
                        function(args)
                            require('luasnip').lsp_expand(args.body)
                        end
                    '';
                };

                completion = {
                    completeopt = "menu,menuone,noinsert";
                };

                mapping = {
                    "<Tab>" = "cmp.mapping.select_next_item()";
                    "<S-Tab>" = "cmp.mapping.select_prev_item()";
                    "<Enter>" = "cmp.mapping.confirm { select =true }";
                };

                # Dependencies
                sources = [
                    { name = "luasnip"; }
                    { name = "nvim_lsp"; }
                    { name = "path"; }
                ];
            };
        };

        ############################################################
        # LSP
        ############################################################
        plugins.luasnip.enable = true;

        plugins.cmp-nvim-lsp = {
            enable = true;
        };

        plugins.fidget = {
            enable = true;
        };

        plugins.lsp = {
            enable = true;
            servers = {
                ts_ls.enable = true;
                nil_ls.enable = true;
                pyright.enable = true;
                gopls.enable = true;
                jsonls.enable = true;
                tailwindcss.enable = true;

                rust_analyzer = {
                    enable = true;
                    installCargo = false;
                    installRustc = false;
                };

                lua_ls = {
                    enable = true;
                    settings = {
                        completion = {
                            callSnippet = "Replace";
                        };
                    };
                };
            };
            
            keymaps = {
                diagnostic = {
                    "dK" = "setloclist"; # diagnostic quick fix
                    "[d" = "goto_next";
                    "]d" = "goto_prev";
                };
                lspBuf = {
                    "K" = "hover";
                    "gD" = "references";
                    "gd" = "definition";
                    "gi" = "implementation";
                    "gt" = "type_definition";
                };
            };
        };
    };
}
