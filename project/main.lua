
package.path = package.path..";lua/?.lua;lua/?/init.lua"
package.path = package.path..";ffi/?.lua;ffi/?/init.lua"
package.path = package.path..";deps/?.lua;deps/?/init.lua"
package.path = package.path..";project/?.lua"
package.path = package.path..";project/scripts/?.lua"
package.path = package.path..";project/scripts/?/init.lua"

-----------------------------------------------------------------------------------------------
local ffi = require 'ffi'
local ffiext = require 'ffi-extensions'
local utils = require 'utils'

local p = require('pprint').prettyPrint

local stp = require('scripts.stacktraceplus')
debug.traceback = stp.stacktrace

if(ffi.os == "Windows") then 

    ffi.cdef([[
        void Sleep(uint32_t ms);
    ]])
end

-----------------------------------------------------------------------------------------------
-- Must be declared before uv-ffi if using http-parser
-- local httpp = require "http_parser_ffi"

-- local loop = require 'uv-ffi'
-- local lutem = require 'lutem'

local b64 = require 'base64'
local utf8 = require 'utf8string'

-----------------------------------------------------------------------------------------------
-- X11 has some sleep functions if needed.
-- local x11 = require 'x11'
local wv = require 'webview'

-----------------------------------------------------------------------------------------------

local shr, band = bit.rshift, bit.band
local hlpr = require 'helpers'
-- local hlpr = require 'helpers', cef

-----------------------------------------------------------------------------------------------

local progname = ... or (arg and arg[0]) or "README"

local configs = require('project.configs.main')

-----------------------------------------------------------------------------------------------
-- CHANGE HERE: 
local www = configs.editor_panel
local www = require("project.configs.seered") --configs.editor_panel

local fh = execute("cd")
local apppath = fh:read("*l").."/"..www.global_path
fh:close()
print("App path: "..apppath)

if( www["www_dir"] == nil ) then www.www_dir = "file:///" end

local fpool = require 'scripts/file_pool'
fpool.init( www )

local wvobj = wv.webview_create(1, nil)

-----------------------------------------------------------------------------------------------
-- Register scheme callback - change scheme above for your own scheme.

local function fpool_readfile( filename, dataptr, sizeptr )

    -- print("Custom request: ", ffi.string(filename), dataptr)
    local data, datacount = fpool.pool_loadfile( filename, apppath, sizeptr )
    ffi.copy( dataptr, data, datacount )
    return 0
end

-----------------------------------------------------------------------------------------------
-- Main stuff

wv.webview_set_title( wvobj, www.title )
wv.webview_set_size( wvobj, 1280, 900, 3 )

wv.webview_handle_scheme( wvobj, "file", fpool_readfile )
wv.webview_install_handlers( wvobj )


if( www.register ~= nil ) then 
    if(www.register.init) then www.register.init( wv, wvobj ) end
    for k, v in pairs( www.register ) do
        if( k ~= "init" ) then
            wv.webview_bind( wvobj, v.funcname, v.func, v.args )
        end
    end
end


-- NOTE: Enable this to view debug at start. This can be put in JS callbacks too. 
print("Creating Hostname mapping...")
-- wv.webview_set_virtual_hostname( wvobj, "custom", apppath )

if(www.twig) then 
    local dataptr = ffi.new("char *[1]")
    local sizeptr = ffi.new("int[1]")
    local data, datacount = fpool.pool_loadfile( www.url_start, apppath, sizeptr )
    wv.webview_set_html( wvobj, ffi.string(data, datacount))
else
    wv.webview_navigate( wvobj, www.url_start )
end

--local wvhwnd = wv.webview_get_window( wvobj )

-- wv.webview_run( wvobj )
print("Starting WebView...")
local running = true 
while(running) do
    
    local res = wv.webview_poll( wvobj )
    if(res == -1) then print("Exiting..") running = false end
    ffi.C.Sleep(1)
end

wv.webview_destroy( wvobj )

-----------------------------------------------------------------------------------------------