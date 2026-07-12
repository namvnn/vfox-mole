local plugin = require("plugin")

function PLUGIN:PostInstall(ctx)
    plugin.post_install(ctx.rootPath)
end
