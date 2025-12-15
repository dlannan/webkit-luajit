local sample = require("project.configs.sample")

local weblinks = {

    amiga = {
        title = "Amiga",
        url_start = "file:///index.html",
        global_path = "project/data/amiga",
    },

    editor_panel = {
        title = "Editor",
        url_start = "file:///layout.html",
        global_path = "project/data/gl",
    },

    seerview = {
        title = "SEER Viewer",
        url_start = "file:///seer-viewer.twig",
        global_path = "project/data/kakutai",
    },

    aspecttest = {
        title = "Aspect Test",
        url_start = "file:///index.html.twig",
        global_path = "project/data/aspect",
        site_args = {
            name = "Test Name"
        },
        twig = true,
    },

    webgltest = {
        title = "WebGL Test",
        url_start = "file:///highway/highway.html",
        global_path = "project/data/js-demo-fun",
        site_args = {
            name = "Test Name"
        },
        register = {
            init = sample.lj_init,
            func1 = { funcname = "call_luajit", func = sample.lj_func, args = nil },
        },
    },

    materialism = {
        title = "Materialism",
        url_start = "file:///index.html",
        global_path = "project/data/materialism",
        www_dir = "https://",
        site_args = {
            name = "Test Name"
        }
    },

    google = {
        title = "Web Page",
        url_start = "https://www.google.com",
        global_path = "project/data/kakutai",
    },

    seer = {
        title = "Scenarist",
        url_start = "http://localhost/project?projectid=2",
        --url_start = "http://localhost:8000/sim/carracer",
        global_path = "project/data/kakutai",
    },

    thirdi = {
        title = "3rdi",
        url_start = "https://localhost:8443/",
        global_path = "project/data/kakutai",
    },    
}

weblinks["seered"] = require("project/configs/seered")

return weblinks