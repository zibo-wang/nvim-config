return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    -- "hrsh7th/cmp-path", -- source for file system paths
    -- "L3MON4D3/LuaSnip", -- snippet engine
    -- "saadparwaiz1/cmp_luasnip", -- for autocompletion
    -- "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
    -- "jmbuhr/cmp-pandoc-references",
    -- "jalvesaq/cmp-zotcite"
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end
        }
      }
    },
    'saadparwaiz1/cmp_luasnip',
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-emoji',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp-signature-help'
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    local check_back_space = function()
      local col = vim.fn.col(".") - 1
      if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
      else
        return false
      end
    end
    require("luasnip.loaders.from_vscode").lazy_load({})
    require("luasnip.loaders.from_vscode").lazy_load(
      {
        paths = "./my-snippets"
      }
    )
    require("luasnip.loaders.from_lua").lazy_load(
      {
        paths = "./lua-snippets"
      }
    )
    require("luasnip").config.setup(
      {
        store_selection_keys = "<C-s>"
      }
    )
    vim.api.nvim_set_keymap(
      "i", "<C-u>", '<cmd>lua require("luasnip.extras.select_choice")()<CR>', {
        noremap = true
      }
    )
    luasnip.filetype_extend(
      "quarto", {
        "markdown"
      }
    )
    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and
               vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                 "^%s*$"
               ) == nil
    end
    cmp.setup(
      {
        completion = {
          completeopt = "menu,menuone,preview,noselect"
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert(
          {
            ["<Tab>"] = vim.schedule_wrap(
              function(fallback)
                if cmp.visible() and has_words_before() then
                  cmp.select_next_item(
                    {
                      behavior = cmp.SelectBehavior.Select
                    }
                  )
                else
                  fallback()
                end
              end
            ),
            ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
            ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
            ["<C-e>"] = cmp.mapping.abort(), -- close completion window
            ["<CR>"] = cmp.mapping.confirm(
              {
                select = false
              }
            ),
            -- ["<Tab>"] = cmp.mapping(function(fallback)
            -- 	if cmp.visible() then
            -- 		cmp.confirm({ select = true })
            -- 	elseif luasnip.jumpable(1) then
            -- 		luasnip.jump(1)
            -- 	elseif check_back_space() then
            -- 		fallback()
            -- 	else
            -- 		cmp.complete()
            -- 	end
            -- end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(
              function()
                luasnip.jump(-1)
              end, {
                "i",
                "s"
              }
            )
          }
        ),
        vim.keymap.set(
          {
            "i",
            "s"
          }, "<C-s>", function()
            if luasnip.expandable() then
              luasnip.expand({})
            end
          end
        ),
        -- sources for autocompletion
        sources = cmp.config.sources(
          {
            {
              name = "copilot",
              group_index = 2
            },
            {
              name = "luasnip",
              group_index = 2

            }, -- snippets
            {
              name = "nvim_lsp"
            },
            {
              name = "buffer"
            }, -- text within current buffer
            {
              name = "path"
            }, -- file system paths
            {
              name = "cmp_zotcite"
            },
            {
              name = "pandoc_references"
            },
            {
              name = "supermaven"
            }
          }
        ),
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order
          }
        },
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format(
            {
              mode = 'symbol', -- show only symbol annotations
              maxwidth = {
                -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                -- can also be a function to dynamically calculate max width such as
                -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                menu = 50, -- leading text (labelDetails)
                abbr = 50 -- actual suggestion item
              },
              ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
              show_labelDetails = true -- show labelDetails in menu. Disabled by default
            }
          )
        }
      }
    )
  end
}
