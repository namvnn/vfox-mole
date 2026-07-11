function PLUGIN:PostInstall(ctx)
    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    local path = sdkInfo.path

    local build_status_code = os.execute("cd " .. path .. " && make build")
    if build_status_code ~= 0 then
        error("Failed to build mole with status code " .. build_status_code)
    end

    local mkdir_temp_status_code = os.execute("cd " .. path .. " && mkdir temp")
    if mkdir_temp_status_code ~= 0 then
        error(
            "Failed to create temp/ with status code "
                .. mkdir_temp_status_code
        )
    end

    local mv_to_temp_status_code =
        os.execute("cd " .. path .. " && mv ./mo ./mole ./bin/ ./lib/ temp/")
    if mv_to_temp_status_code ~= 0 then
        error(
            "Failed to move files to temp/ with status code "
                .. mv_to_temp_status_code
        )
    end

    local rename_temp_to_bin_status_code =
        os.execute("cd " .. path .. " && mv temp/ bin/")
    if rename_temp_to_bin_status_code ~= 0 then
        error(
            "Failed to rename temp/ to bin/ with status code "
                .. rename_temp_to_bin_status_code
        )
    end

    local delete_unnecessary_files = os.execute(
        "cd "
            .. path
            .. " && find . -not -name bin -depth 1 -exec rm -rf {} '+'"
    )
    if delete_unnecessary_files ~= 0 then
        error(
            "Failed to delete unnecessary files with status code "
                .. delete_unnecessary_files
        )
    end
end
