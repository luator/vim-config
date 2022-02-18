-- https://dev.to/psiho/vimwiki-how-to-automate-wikis-per-project-folder-neovim-3k72
--
--
-- configuration
local config = {
    projectsFolder = '/home/felixwidmaier/projects/', --full path without ~
    maxDepth = 3,
    ignoreFolders = { 'node_modules', '.git' },
    rootWikiFolder = '_wiki',
    wikiConfig = { syntax='markdown', ext='.md' }
}

-- store original vimwiki_list config, we will need it later
-- !!!make sure vimwiki plugin is loaded before running this!!!
if vim.g.vimwiki_list == nil then
    error('VimWiki not loaded yet! make sure VimWiki is initialized before my-projects-wiki')
else
    _G.vimwiki_list_orig = vim.fn.copy(vim.g.vimwiki_list) or {}
end

-- function to update g:vimwiki_list config item from list of subfolder names (append project wikis)
--   this way, orginal <Leader>ws will get new project wikis in the list and also keep ones from config
local function updateVimwikiList(folders)
    local new_list = vim.fn.copy(vimwiki_list_orig)
    for _, f in ipairs(folders) do
        local item = {
            path = config.projectsFolder..f,
            syntax = config.wikiConfig.syntax,
            ext = config.wikiConfig.ext
        }
        table.insert(new_list, item)
    end
    vim.g.vimwiki_list = new_list
    vim.api.nvim_call_function('vimwiki#vars#init',{})
end

-- function to search project folders for root wiki folders (returns system list)
local function searchForWikis()
    local command = 'find ' .. config.projectsFolder ..
        ' -maxdepth ' .. config.maxDepth
    if #config.ignoreFolders > 0 then command = command .. " \\(" end
    for _, f in ipairs(config.ignoreFolders) do
        command = command .. " -path '*/"..f.."/*' -prune"
        if next(config.ignoreFolders,_) == nil then
            command = command .. " \\) -o"
        else
            command = command .. " -o"
        end
    end
    command = command .. ' -type d -name ' .. config.rootWikiFolder
    command = command .. ' -print | '
    command = command .. ' sed s#' .. config.projectsFolder .. '##'
    local list = vim.api.nvim_call_function('systemlist', {command})
    return list
end

-- wrapper for Vimwiki's goto_index() to bypass :VimWikiUISelect and use FZF instead
-- if wiki is passed to the function, index page is opened directly, bypassing FZF
function _G.ProjectWikiOpen(name)
    -- show fzf wiki search if no wiki passed
    if not name then
        local wikis = searchForWikis()
        updateVimwikiList(searchForWikis())
        for _,f in ipairs(vimwiki_list_orig) do table.insert(wikis,f.path) end
        local options = {
            sink = function(selected) ProjectWikiOpen(selected) end,
            source = wikis,
            options = '--ansi --reverse --no-preview',
            window = {
                width = 0.3,
                height = 0.6,
                border = 'sharp'
            }
        }
        vim.fn.call('fzf#run', {options})
    else
        for i, v in ipairs(vim.g.vimwiki_list) do
            if v.path == name or v.path == config.projectsFolder..name then
                vim.fn.call('vimwiki#base#goto_index',{i})
                return
            end
        end
        print("Error. Selected project wiki not found")
    end
end


-- add commands
vim.api.nvim_command([[command! -nargs=? ProjectWikiOpen lua ProjectWikiOpen(<f-args>)]])

-- add keybindings
vim.api.nvim_set_keymap("n", "<Leader>wp", ":ProjectWikiOpen<CR>", { noremap=true })
