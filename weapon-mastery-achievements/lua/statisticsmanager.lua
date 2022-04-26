if not _G.WMA then
    dofile(ModPath .. "/lua/setup.lua")
end

-- count kills
Hooks:PostHook(StatisticsManager, "killed", "weapon_mastery_achievement", function(self, data)
    for k, _ in pairs(self._global.session.killed_by_weapon) do
        -- fix for explosives
        if data.variant == "explosion" then k = data.weapon_unit and data.weapon_unit:base().get_name_id and data.weapon_unit:base():get_name_id() end

        k = string.find(k, "x_") ~= nil and string.sub(k, 3) or k -- remove akimbo prefix
        if tweak_data.weapon[k] then
            local v = tweak_data.weapon[k]
            local category = v.categories and (v.categories[1] ~= "akimbo" and v.categories[1] or v.categories[2]) or "special"
            category = WMA.congregate[category] and WMA.congregate[category] or category
            local package = WMA.packages[category]
            if self._global.session.killed_by_weapon[k] ~= nil then
                for i = 1, 4, 1 do
                    if package:HasAchievement("s_ach_" .. k .. "_" .. tostring(i)) then
                        package:Achievement("s_ach_" .. k .. "_" .. tostring(i)):IncreaseAmount(1)
                    end
                end
            end
        end
    end
    self._global.session.killed_by_weapon = {}
end)
