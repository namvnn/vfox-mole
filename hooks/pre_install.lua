function PLUGIN:PreInstall(ctx)
    local version = ctx.version

    return {
        version = version,
        url = "https://github.com/tw93/Mole/archive/refs/tags/V"
            .. version
            .. ".tar.gz",
    }
end
