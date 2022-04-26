-- imports challenge progress from pdth challenges (https://modworkshop.net/mod/27854)
if not _G.WMA then
    dofile(ModPath .. "/lua/setup.lua")
end

local importprog = function()
    local prog = {}
    for _, v in pairs(managers.challenges:get_near_completion()) do
        -- only import stats we need to
        if v.count > 0 and string.find(v.id, "_crew_") == nil and string.find(v.id, "x_") == nil then
            local index =  string.find(v.id, "_vs_law")
            prog[string.sub(v.id, 0, index ~= nil and index-1 or 0)] = v.count
            log(v.count)
        end
    end
    for k, v in pairs(prog) do
        local weap = tweak_data.weapon[k]
        if weap then
            local category = weap.categories and (weap.categories[1] ~= "akimbo" and weap.categories[1] or weap.categories[2]) or "special"
            category = WMA.congregate[category] and WMA.congregate[category] or category
            local package = WMA.packages[category]
            if package then
                for i = 1, 4, 1 do
                    if package:HasAchievement("s_ach_" .. k .. "_" .. tostring(i)) then
                        package:Achievement("s_ach_" .. k .. "_" .. tostring(i)):IncreaseAmount(v)
                    end
                end
            end
        end
    end
end

local confirm_cblk = function()
    if not tweak_data.challenges then
        -- does not have mod installed, cannot port progress.
        QuickMenu:new(
            managers.localization:text("wma_import_pdth_fail_title"),
            managers.localization:text("wma_import_pdth_fail_desc"),
            {
                [1] = {
                    text = managers.localization:text("wma_import_pdth_fail_yes"),
                    --callback = function() os.execute("cmd /c start https://modworkshop.net/mod/14924") end
                    is_cancel_button = true
                }
            },
            true
        )
        return
    end
    importprog()
    QuickMenu:new(
            managers.localization:text("wma_import_pdth_complete_title"),
            managers.localization:text("wma_import_pdth_complete_desc"),
            {
                [1] = {
                    text = managers.localization:text("wma_import_pdth_complete_yes"),
                    is_cancel_button = true
                }
            },
            true
        )
end
QuickMenu:new(
    managers.localization:text("wma_import_pdth_confirm_title"),
    managers.localization:text("wma_import_pdth_confirm_desc"),
    {
        [1] = {
            text = managers.localization:text("wma_import_pdth_confirm_yes"),
            callback = confirm_cblk
        },
        [2] = {
            text = managers.localization:text("wma_import_pdth_confirm_no"),
            is_cancel_button = true
        }
    },
    true
)
