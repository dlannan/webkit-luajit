local ffi = require 'ffi'
local dbg = require 'scripts.debugger'

local twig = require 'scripts/twig'

local tinsert = table.insert
local tremove = table.remove

ffi.cdef[[

    typedef struct lj_fpool_finfo {

        char        id[32];
        char        fname[1024];
        char        ext[8];
        void *      data;
        char *      body;
    
        char        mime_type[32];
        int         index;
        int         state;
        int         size;
        int         remaining;
    
    } lj_fpool_finfo;  


    void * calloc( size_t count, size_t esize );
]]

-- Namespace caching is faster
local fpool_cef = ffi.C 

-----------------------------------------------------------------------------------------------

local unescape = function(url)
    return url:gsub("%%20", " ")
end

-----------------------------------------------------------------------------------------------
-- File pool for loading multiple files

local max_htmlsize      = 2 * 1024 * 1024
local mime_types = {}
mime_types["adf"]       = "application/octet-stream"
mime_types["bin"]       = "application/octet-stream"
mime_types["css"]       = "text/css"
mime_types["gif"]       = "image/gif"
mime_types["gltf"]      = "model/gltf+json"
mime_types["glsl"]      = "text/plain"
mime_types["html"]      = "text/html"
mime_types["jpeg"]      = "image/jpeg"
mime_types["jpg"]       = "image/jpeg"
mime_types["js"]        = "text/javascript"
mime_types["json"]      = "application/json"
mime_types["mjs"]       = "text/javascript"
mime_types["mpeg"]      = "video/mpeg"
mime_types["obj"]       = "text/plain"
mime_types["png"]       = "image/png"
mime_types["svg"]       = "image/svg+xml"
mime_types["tif"]       = "image/tiff"
mime_types["tiff"]      = "image/tiff"
mime_types["txt"]       = "text/plain"
mime_types["weba"]      = "audio/webm"
mime_types["webm"]      = "video/webm"
mime_types["webp"]      = "image/webp"
mime_types["woff"]      = "font/woff"
mime_types["woff2"]     = "font/woff2"
mime_types["xml"]       = "text/xml"

mime_types["twig"]      = "text/html"

local fpool                 = {}
local fpool_scheme          = "custom"

-----------------------------------------------------------------------------------------------

local function init( www_paths )

    twig.init( www_paths )    
end    

-----------------------------------------------------------------------------------------------
local function pool_loadfile( filename_uri, path_in, size_out )

    -- local mime_type_out = data_in[0].mime_type
    -- local path_in       = data_in[0].path
    -- replace back slashes in path_in
    
    -- full_uri is incoming
    local filename_in = tostring(ffi.string(filename_uri):match("file:///(.+)"))

    path_in = path_in:gsub( "\\", "/").."/"

    local finfo         = nil
    local id            = filename_in

    -- if(fpool[id] == nil) then 

    finfo           = ffi.new("struct lj_fpool_finfo[1]")
    local filename  = filename_in
    local pathname  = unescape(path_in)

    -- filename = string.sub( filename, #fpool_scheme + 4, -1 )
    filename        = string.match(filename, "([^%?]+)")

    ffi.fill(finfo[0].fname, 1024 )
    ffi.copy(finfo[0].fname, ffi.string(filename, #filename), #filename)

    local ext = string.match(filename, "^.+%.(.+)")
    -- print(ext, filename)
    ffi.fill(finfo[0].ext, #fpool_scheme + 3 )
    ffi.copy(finfo[0].ext, ffi.string(ext), #ext)

    local mimet = mime_types[ext]
    if(mimet == nil) then mimet = "text/html" end
    local mime_type = ffi.string(mimet, #mimet)

    ffi.fill(finfo[0].mime_type, 32)
    ffi.copy(finfo[0].mime_type, mime_type, #mime_type)
    -- print( newfile.mime_type, ext, fname )

    local data      = nil
    local dsize     = 0

    local filename  = unescape(ffi.string(finfo[0].fname))
    local ext       = ffi.string(finfo[0].ext)

    if(ext == "twig") then 
        -- print("File Twig Load: ", filename)
        data, dsize = twig.parse(filename)
    else 
        -- print("File Load: ", filename)
        -- Sometimes the filename is added as a "hostname". Usually because its a 
        --  relative file path from the document. Rebuild path if so.
        if( pathname:sub(-1, -1) ~= "/" ) then
        if(#pathname > 0) then filename = pathname end
        end
        data, dsize = twig.readfile(filename)
    end 

    finfo[0].remaining     = dsize or 0
    -- finfo[0].state         = fpool_cef.FR_PENDINGFILE
    finfo[0].size          = dsize or 0

    -- fpool_cef.ljq_datanew( finfo[0].data,  dsize );
    -- local rawdata           = ffi.new("char[?]", dsize)

    local filedata         = ffi.cast("char *", ffi.string(data, dsize))
    finfo[0].body          = ffi.new("char[?]", dsize)
    ffi.copy( finfo[0].body, filedata, dsize)

    fpool[id] = finfo
    -- else 
    --     finfo = fpool[id]
    -- end
    size_out[0]= finfo[0].size

    finfo = fpool[id]
    return finfo[0].body, size_out[0], mimet
end


-----------------------------------------------------------------------------------------------

return {
    init = init,
    pool_loadfile   = pool_loadfile,
}