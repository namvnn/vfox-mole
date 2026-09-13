local util = require("util")

function PLUGIN:PostInstall(ctx)
    local root_path = util.shell_quote(ctx.rootPath)

    util.run(
        "cd "
            .. root_path
            .. " && make build"
            .. " && mkdir temp/"
            .. " && mv ./mo ./mole ./bin/ ./lib/ temp/"
            .. " && mv temp/ bin/"
            .. " && find . -not -name bin -depth 1 -exec rm -rf {} '+'"
    )
end
