local http = require("http")
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
    local result = {}

    for _, release in ipairs(releases) do
        if not release.draft then
            local tag = release.tag_name
            local version = tag
            local rolling = false

            -- Ignore duplicated Windows release
            if not tag:find("windows") then
                if tag == "nightly" or tag == "stable" then
                    rolling = true
                else
                    version = tag:gsub("^V", "")
                end

                table.insert(result, {
                    version = version,
                    note = release.name or "",
                    rolling = rolling,
                })
            end
        end
    end

    return result
end
