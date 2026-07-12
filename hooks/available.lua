local plugin = require("plugin")

function PLUGIN:Available()
    return plugin.get_versions()
end
