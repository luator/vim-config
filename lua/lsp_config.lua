--vim.lsp.set_log_level("debug")

home=os.getenv("HOME")

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
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format{async=true}<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Highlight references on hovering
  -- This expects highlight groups LspReference{Text,Read,Write} to be defined
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  require'lsp_signature'.on_attach()
end

require("lsp_signature").setup({
    doc_lines=0,
    hint_enable=false,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- for ufo-nvim (folding), see folding.lua
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

-- seems to be needed for clangd when used in combination with other LSPs (e.g. Copilot)
-- fixes "multiple different client offset_encodings detected for buffer"-warning
capabilities.offsetEncoding = { "utf-16" }


if vim.lsp then
    lspconfig.pylsp.setup{
        on_attach = on_attach,
        capabilities = capabilities,
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
                    pyflakes = {
                        enabled = false
                    },
                    flake8 = {
                        enabled = false
                    },
                    ruff = {
                        enabled = true,
                        -- do not configure here, rely on .config/ruff/ruff.toml
                        -- for defaults
                    },

                    ["pylsp-mypy"] = {
                        -- disable live_mode as it is not aware of the file path
                        -- and thus causes false alerts on relative imports
                        live_mode = false,
                        dmypy = true,
                    },
                }
            }
        }
    }

    if vim.fn.executable("pyright-langserver") == 1 then
        lspconfig.pyright.setup{}
    end

    --
    -- clangd
    --

    -- this is the old implementation of lspconfig.utils.is_absolute
    -- can be replaced with vim.fn.isabsolutepath in nvim 0.11
    -- see https://github.com/neovim/nvim-lspconfig/pull/3511
    local function is_absolute(filename)
        if iswin then
            return filename:match '^%a:' or filename:match '^\\\\'
        else
            return filename:match '^/'
        end
    end
    -- find a clangd container (clangd.sif) in the current directory or upwards
    local function find_clangd_container()
        -- The name of the current buffer
        local bufname = vim.api.nvim_buf_get_name(0)

        -- Turned into a filename
        local filename = is_absolute(bufname) and bufname or vim.fs.joinpath(vim.loop.cwd(), bufname)

        local dir = vim.fn.fnamemodify(filename, ':p:h')

        -- search for clangd.sif from current directory upwards
        local container_file = dir .. "/clangd.sif"
        print(dir ~= "/")
        while vim.fn.filereadable(container_file) == 0 and dir ~= "/" do
            dir = vim.fn.fnamemodify(dir, ":h")
            container_file = dir .. "/clangd.sif"
        end

        if vim.fn.filereadable(container_file) == 1 then
            return container_file
        end
        return false
    end

    local function construct_clangd_command()
        -- arguments are for improved performance
        local clangd_cmd = {
            "clangd", "--background-index", "-j=4", "--malloc-trim",
            "--pch-storage=memory"
        }

        local container = find_clangd_container()
        if container then
            return {"apptainer", "exec", "-e", container, unpack(clangd_cmd)}
        else
            return clangd_cmd
        end
    end

    -- colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1
    -- for f in build/*/compile_commands.json; do ln -s $(realpath $f) $(echo $f | sed 's/build/src/'); done
    lspconfig.clangd.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = construct_clangd_command(),
    }

    --Enable (broadcasting) snippet capability for completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

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

    -- Add boarder to diagnostic float panels
    vim.diagnostic.config {
        float = { border = "rounded" },
    }
end
