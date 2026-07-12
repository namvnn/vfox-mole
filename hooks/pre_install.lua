function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local url = "https://github.com/tw93/Mole/archive/refs/tags/V"
        .. version
        .. ".tar.gz"

    return {
        version = version,
        url = url,
    }
end
