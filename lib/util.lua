local M = {}

--- Recursively converts value into a human-readable string.
---
--- @param value any The value to convert to string.
--- @param space? integer The indentation in spaces. Defaults to `4`.
--- @return string stringified A string representing the given value, or undefined.
function M.stringify(value, space)
    local indent = string.rep(" ", space or 4)

    local function serialize(val, level, seen)
        local t = type(val)

        if t == "string" then
            return string.format("%q", val)
        elseif t ~= "table" then
            return tostring(val)
        end

        if seen[val] then
            return "<cycle>"
        end

        seen[val] = true

        local lines = { "{" }
        local padding = string.rep(indent, level + 1)

        for k, v in pairs(val) do
            local key

            if type(k) == "string" then
                key = string.format("%q", k)
            else
                key = serialize(k, level + 1, seen)
            end

            table.insert(
                lines,
                string.format(
                    "%s[%s] = %s,",
                    padding,
                    key,
                    serialize(v, level + 1, seen)
                )
            )
        end

        table.insert(lines, string.rep(indent, level) .. "}")

        seen[val] = nil

        return table.concat(lines, "\n")
    end

    return serialize(value, 0, {})
end

--- Quotes a value for safe use as a single shell command argument.
---
--- Source: https://github.com/jdx/vfox-graalvm/blob/0a20281f1bfae678cb0d0238bfebb2f8cccc9eb0/lib/util.lua#L6
---
--- @param value string The string to quote.
--- @return string quoted The shell-escaped string.
function M.shell_quote(value)
    return "'" .. string.gsub(tostring(value), "'", "'\\''") .. "'"
end

--- Executes a shell command and raises an error if it fails.
---
--- Source: https://github.com/jdx/vfox-graalvm/blob/0a20281f1bfae678cb0d0238bfebb2f8cccc9eb0/lib/util.lua#L10
---
--- @param cmd string The shell command to execute.
--- @raise string If the command exits with a non-zero status or otherwise fails.
function M.run(cmd)
    local ok, reason, code = os.execute(cmd)
    if ok ~= true and ok ~= 0 then
        error("command failed (" .. tostring(code or reason) .. "): " .. cmd)
    end
end

return M
