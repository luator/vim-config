--vim.lsp.set_log_level("debug")

--home=os.getenv("HOME")

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Mappings.
        local function km_set(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf })
        end
        km_set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
        km_set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
        km_set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        km_set('n', '<space>f', '<cmd>lua vim.lsp.buf.format{async=true}<CR>')
        km_set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
        km_set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
        km_set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
        km_set('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

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

        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                callback = vim.lsp.buf.clear_references,
            })
        end
    end
})

require("lsp_signature").setup({
    doc_lines = 0,
    hint_enable = false,
    --floating_window_above_cur_line = false,
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

-- Check if pylsp_black (package python-lsp-black) is installed.  This is later used to
-- decide if ruff formatting should be enabled or not.
local has_pylsp_black = vim.system(
    { "python3", "-c", "import importlib.util as u; import sys; sys.exit(0 if u.find_spec('pylsp_black') else 1)" }
):wait()["code"] == 0

if vim.lsp then
    vim.lsp.config('pylsp', {
        --on_attach = on_attach,
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
                        formatEnabled = not has_pylsp_black,
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
    })
    vim.lsp.enable('pylsp')

    if vim.fn.executable("pyright-langserver") == 1 then
        vim.lsp.enable('pyright')
    end

    --
    -- clangd
    --
    -- Search for an Apptainer image "clangd.sif", starting from the current
    -- directory upwards.  If found, use it to run clangd, otherwise run clangd
    -- without container.
    --
    -- The idea is that at the root of each container-based project, the
    -- corresponding container can be symlinked with name `clangd.sif`.  Then
    -- the same config should work for all projects.
    local function find_clangd_container()
        -- The name of the current buffer
        local bufname = vim.api.nvim_buf_get_name(0)

        -- Turned into a filename
        local filename = vim.fn.isabsolutepath(bufname) and bufname or vim.fs.joinpath(vim.loop.cwd(), bufname)

        local dir = vim.fn.fnamemodify(filename, ':p:h')

        -- search for clangd.sif from current directory upwards
        local container_file = dir .. "/clangd.sif"
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
            return { "apptainer", "exec", "-e", container, unpack(clangd_cmd) }
        else
            return clangd_cmd
        end
    end

    -- colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1
    -- for f in build/*/compile_commands.json; do ln -s $(realpath $f) $(echo $f | sed 's/build/src/'); done
    vim.lsp.config('clangd', {
        capabilities = capabilities,
        cmd = construct_clangd_command(),
    })
    vim.lsp.enable('clangd')

    -- latex
    vim.lsp.enable('texlab')

    -- rust
    vim.lsp.enable('rust_analyzer')

    -- sphinx
    vim.lsp.enable('esbonio')

    -- lua
    vim.lsp.enable('lua_ls')

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

    -- Add border to diagnostic float panels
    vim.diagnostic.config {
        float = { border = "rounded" },
    }
end
