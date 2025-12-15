
require("table_utils")
local ffi = require("ffi")

local assimp = require 'assimp'

local eps = ffi.new("uint32_t[1]", assimp.ai_epsilon)
local epsf = ffi.new("float[1]", ffi.cast("float *", eps)[0])

local json = require("json")

local tinsert = table.insert
local tconcat = table.concat
-----------------------------------------------------------------------------------------------

local wv = nil
local wvobj = nil  

local function init( _wv, _wvobj )
    wv = _wv 
    wvobj = _wvobj 
end

-----------------------------------------------------------------------------------------------
local modelCache    = {}
local currentModel  = nil


local function lj_import3dmodel( filepath )

    if(modelCache[filepath] == nil) then 
        local flags = 0
        modelCache[filepath] = assimp.aiImportFileEx( filepath, flags )
    end
    -- modelCache[filepath] now contains the current loaded model
    -- Only support one at a time, initially
    currentModel = modelCache[filepath]
end

-----------------------------------------------------------------------------------------------
-- This does nothing, but can be used for return data if needed.
local function lj_done( data )

    print("lj_done: ", done)
end

-----------------------------------------------------------------------------------------------

local MODEL_PATH    = "project/data/kakutai/database/models"
local MODEL_URL     = "/database/models"
-- Note zip is a special file format for Automation exports.
local ALLOWED_TYPES = ".obj .3ds gltf .fbx .dae .zip"

-----------------------------------------------------------------------------------------------

function checktable(tbl, str)
    for i,v in ipairs(tbl) do
        if v == str then
            return i
        end
    end
    return nil
end

local function buildfrompath(dir_stack, dir_cnt, rootpath, modelpath, line)
    
    local fullpath = string.gsub(rootpath.."\\"..modelpath, "[^%w%_\\%.]" ,"")
    line = string.gsub(line, "[^%w%_\\%.]" ,"")
    local relative = string.gsub(line, fullpath, "", 1)

    local folders = {}
    for token in string.gmatch(relative, "[^\\]+") do
        table.insert(folders, token)
    end
    
    -- The last on the table is a file. Check it, then add it to the dir_stack if its something we care about
    local last = folders[#folders]
    
    -- Only add 3dmodels we support 
    local ext = string.sub(last, -4, -1)
    if(ext) then ext = ext:lower() end

    if( string.find(ALLOWED_TYPES, ext) ~= nil ) then
    --print("-------------> ", line, relative, rootpath.."\\"..modelpath)

        local mpath = dir_stack
        -- make the dir stack from other folder entries.
        for k,v in ipairs(folders) do
            if (k < #folders) then
                local pos = checktable(mpath, v)
                if(pos == nil) then 
                    local newfolder = { name = v, children = {}, id = dir_cnt }
                    tinsert(mpath, newfolder)
                    mpath = newfolder.children
                else 
                    mpath = mpath[pos].children
                end
            end 
        end

        local newchild = { name = last, id = dir_cnt }
        tinsert(mpath, newchild)
    end

    return dir_cnt
end

local getfiles_script = ""

-----------------------------------------------------------------------------------------------
-- Get file list from database folder
local function lj_getfiles( seq, req, arg )

    local cmd = "ls -1R "..MODEL_PATH
    local rootpath = ""
    if ffi.os == "Windows" then 
        MODEL_PATH = string.gsub(MODEL_PATH, "/", "\\")
        cmd = "dir /A-D /S /B "..MODEL_PATH
        local cmd = io.popen("cd", "r")
        local data = cmd:read("*a")
        rootpath = string.match(data, "(.-)\n")
        cmd:close()
    end
    local ph = assert(io.popen(cmd, "r"))

    if(ph) then
        local dir = ph:read("*a")
        ph:close()

        local lines = {}
        for k, v in string.gmatch(dir, "(.-)\n") do
            if(k == "") then k = "EOL" end
            tinsert(lines, k)
        end

        local id = 1
        local dir_stack = {}
                
        for i, line in ipairs(lines) do
            -- build the folder structure from the path
            buildfrompath(dir_stack, i, rootpath, MODEL_PATH, line)
        end
        --print(table_tostring(dir_stack))

        local folder_data_json = json.encode(dir_stack)
        getfiles_script = [[
            var folder_data = ]]..folder_data_json..[[;
        ]]
        local jsonobj = '{"data": '..folder_data_json..'}'
print("==>>                                                                   ")
print(jsonobj)
print("<<==                                                                   ")
        wv.webview_return(wvobj, seq, 0, jsonobj)
    end
end

-----------------------------------------------------------------------------------------------

seered = {
    title = "SEER Editor",
    url_start = "file:///seer-editor.html.twig",
    global_path = "project/data/kakutai",

}

seered.register = {
    init = init,
    func1 = { funcname = "sed_import3dmodel", func = lj_import3dmodel, args = nil },
    func2 = { funcname = "sed_getfiles", func = lj_getfiles, args = nil },
}

-----------------------------------------------------------------------------------------------

return seered

-----------------------------------------------------------------------------------------------
