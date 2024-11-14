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
                bg = "#000000";
            };
        };

        ############################################################
        # Sets
        ############################################################
        opts = {
            number = true;
            relativenumber = true;
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

            cmdheight = 0;

            # :h conceallevel
            conceallevel = 2;

            # Decrease update time
            # updatetime = 10;

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

            { mode = "i"; key = "<C-h>"; action = "<C-w>"; options = { noremap = true; }; }
            { mode = "i"; key = "<C-BS>"; action = "<C-w>"; options = { noremap = true; }; }
            
            # Split navigation
            { mode = "n"; key = "<A-h>"; action = "<C-w>h"; }
            { mode = "n"; key = "<A-j>"; action = "<C-w>j"; }
            { mode = "n"; key = "<A-k>"; action = "<C-w>k"; }
            { mode = "n"; key = "<A-l>"; action = "<C-w>l"; }
            
            # Move selected lines up and down
            { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
            { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }
            
            # Keep cursor centered
            { mode = "n"; key = "j"; action = "jzz"; }
            { mode = "n"; key = "k"; action = "kzz"; }
            { mode = "n"; key = "G"; action = "Gzz"; }
            { mode = "n"; key = "gg"; action = "ggzz"; }
            
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
            
            # Navigate between files with Shift+H (previous file) and Shift+L (next file)
            { mode = "n"; key = "H"; action = ":bp<CR>"; }
            { mode = "n"; key = "L"; action = ":bn<CR>"; }
            
            # Gitsigns
            {
                mode = "n";
                key = "<leader>gb";
                action = ":Gitsigns toggle_current_line_blame<CR>";
            }
        ];

        ############################################################
        # Filetypes
        ############################################################
        extraConfigLua = ''
            vim.filetype.add({
                extension = {
                    mdx = "markdown"
                }
            })
        '';

        autoGroups = {
            markdown_settings = {
                clear = true;
            };
        };

        autoCmd = [
            {
                event = ["BufRead" "BufNewFile"];
                pattern = ["*.mdx"];
                group = "markdown_settings";
                command = "set filetype=markdown";
            }
            {
                event = ["BufRead" "BufNewFile"];
                pattern = ["*.md" "*.mdx"];
                group = "markdown_settings";
                command = "setlocal textwidth=80";
            }
            {
                event = ["BufRead" "BufNewFile"];
                pattern = ["*.md" "*.mdx"];
                group = "markdown_settings";
                command = "setlocal formatoptions+=t";
            }
            {
                event = ["BufRead" "BufNewFile"];
                pattern = ["*.md" "*.mdx"];
                group = "markdown_settings";
                command = "setlocal wrap";
            }
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
        
        plugins.web-devicons.enable = true;

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

        ############################################################
        # Obsidian
        ############################################################
        plugins.obsidian = {
            enable = true;
            settings = {
                workspaces = [
                    {
                        name = "vault";
                        path = "~/vault";
                    }
                ];
            };
        };

        ############################################################
        # File browsing (harpoon, telescope)
        ############################################################
        plugins.telescope = {
            enable = true;

            keymaps = {
                "<leader>ff" = "find_files";
                "<leader>fg" = "live_grep";
                "<leader>b" = "buffers";
                "<leader>fh" = "help_tags";
                "<leader>fd" = "diagnostics";

                "<C-p>" = "git_files";
                "<leader>p" = "oldfiles";
                "<C-f>" = "live_grep";
            };

            settings.defaults = {
                file_ignore_patterns = [
                    "^.git/"
                    "^.mypy_cache/"
                    "^__pycache__/"
                    "^output/"
                    "^data/"
                    "%.ipynb"
                ];

                set_env.COLORTERM = "truecolor";
            };
        };

        plugins.harpoon = {
            enable = true;
            enableTelescope = true;
            keymapsSilent = true;

            keymaps = {
                addFile = "<leader>a";
                toggleQuickMenu = "<leader>h";
                navFile = {
                    "1" = "<A-1>";
                    "2" = "<A-2>";
                    "3" = "<A-3>";
                    "4" = "<A-4>";
                    "5" = "<A-5>";
                };
            };
        };

        ############################################################
        # Lualine
        ############################################################
        plugins.lualine = {
            enable = true;
            luaConfig.post = ''
                -- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/gruvbox_dark.lua
                local custom_gruvbox = require'lualine.themes.gruvbox'

                local colors = {
                    bg           = "#000000",
                    bg_light     = "#111111",
                    bg_lightest  = "#222222",
                    fg           = "#ebdbb2",
                    fg_light     = "#a89984",

                    red          = "#fb4934",
                    green        = "#b8bb26",
                    blue         = "#83a598",
                    yellow       = "#fe8019",
                }

                custom_gruvbox.normal = {
                    a = { bg = colors.bg_lightest, fg = colors.fg, gui = "bold" },
                    b = { bg = colors.bg_light, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                }

                custom_gruvbox.insert = {
                    a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg_light, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                }

                custom_gruvbox.visual = {
                    a = { bg = colors.yellow , fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg_light, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                }

                custom_gruvbox.replace = {
                    a = { bg = colors.red, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg_light, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                }

                custom_gruvbox.command = {
                    a = { bg = colors.green, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg_light, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                }

                custom_gruvbox.inactive = {
                    a = { bg = colors.bg_lightest, fg = colors.fg_light, gui = "bold" },
                    b = { bg = colors.bg_lightest, fg = colors.fg_light },
                    c = { bg = colors.bg_lightest, fg = colors.fg_light },
                }

                require('lualine').setup {
                  options = { theme  = custom_gruvbox },
                }
            '';
        };

        ############################################################
        # Git stuff
        ############################################################
        plugins.fugitive.enable = true;

        plugins.gitsigns = {
            enable = true;
            settings = {
                current_line_blame = true;
                current_line_blame_opts.delay = 0;
            };
        };
    };
}
