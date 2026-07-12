--- @type http
local http = require("http")
--- @type json
local json = require("json")

function PLUGIN:Available()
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
            local version = release.tag_name:match("^V(%d+%.%d+%.%d+)$")
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
