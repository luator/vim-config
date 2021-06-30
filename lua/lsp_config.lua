--vim.lsp.set_log_level("debug")

local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- automatically close preview window after auto-complete
  vim.api.nvim_command('autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  --if client.resolved_capabilities.document_highlight then
  --  vim.api.nvim_exec([[
  --    hi LspReferenceRead ctermbg=blue ctermfg=black
  --    hi LspReferenceText ctermbg=blue ctermfg=black
  --    hi LspReferenceWrite ctermbg=blue ctermfg=black
  --    augroup lsp_document_highlight
  --      autocmd! * <buffer>
  --      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --    augroup END
  --  ]], false)
  --end

  -- TODO not working so well at the moment, try out again in a while
  -- require'lsp_signature'.on_attach()
end


if vim.lsp then
    lspconfig.pylsp.setup{
        on_attach = on_attach,
        settings = {
            pylsp = {
                configurationSources = { "flake8" },
                plugins = {
                    -- disable formatters to ensure they don't mess with black
                    autopep8 = {
                        enabled = false
                    },
                    yapf = {
                        enabled = false
                    },

                    ["mypy-ls"] = {
                        -- disable live_mode as it is not aware of the file path
                        -- and thus causes false alerts on relative imports
                        live_mode = false,
                    },
                }
            }
        }
    }

    -- colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1
    -- for f in build/*/compile_commands.json; do ln -s $(realpath $f) $(echo $f | sed 's/build/src/'); done
    lspconfig.clangd.setup{
        on_attach = on_attach,
        cmd = { "clangd-10", "--background-index" },
    }

    -- Settings for displaying LSP diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- This will disable virtual text, like doing:
        -- let g:diagnostic_enable_virtual_text = 0
        virtual_text = false,

        -- This is similar to:
        -- let g:diagnostic_show_sign = 1
        -- To configure sign display,
        --  see: ":help vim.lsp.diagnostic.set_signs()"
        signs = true,

        -- This is similar to:
        -- "let g:diagnostic_insert_delay = 1"
        update_in_insert = false,
    }
    )
end
