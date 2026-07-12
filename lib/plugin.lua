--- @type http
local http = require("http")
--- @type json
local json = require("json")
local util = require("util")

local M = {}

function M.get_versions()
    local resp, err = http.get({
        url = "https://api.github.com/repos/tw93/Mole/releases",
        headers = {
            ["Accept"] = "application/vnd.github+json",
        },
    })

    if err ~= nil then
        error("Failed to fetch releases: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to fetch releases: HTTP " .. resp.status_code)
    end

    local releases = json.decode(resp.body)
    local versions = {}

    for _, release in ipairs(releases) do
        if not release.draft then
            local version = string.match(release.tag_name, "^V(%d+%.%d+%.%d+)$")
            local note = release.name or ""

            if version then
                table.insert(versions, {
                    version = version,
                    note = note,
                })
            end
        end
    end

    return versions
end

function M.post_install(root)
    local root_path = util.shell_quote(root)

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

return M
