if not _G.WMA then
    dofile(ModPath .. "/lua/setup.lua")
end

-- add localisation
Hooks:PostHook(LocalizationManager, "init", "mastery_achievement_package_loc", function(self, data)

    -- load menu language
	for _, filename in pairs(file.GetFiles(WMA.langpath)) do
		local str = filename:match('^(.*).json$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			self:load_localization_file(WMA.langpath .. filename)
			break
		end
	end
	self:load_localization_file(WMA.langpath .. "english.json", false)

    if io.open(WMA.locfile,"r") then return end
    -- manual locale
    local mastery_achievement_package_loc = {
        ["s_ach_dummy"] = "",
        ["assault_rifle"..WMA.package_id.."_name"] = "Assault Rifle Mastery",
        ["lmg"..WMA.package_id.."_name"] = "Light Machine Gun Mastery",
        ["snp"..WMA.package_id.."_name"] = "Sniper Rifle Mastery",
        ["pistol"..WMA.package_id.."_name"] = "Pistol Mastery",
        ["shotgun"..WMA.package_id.."_name"] = "Shotgun Mastery",
        ["smg"..WMA.package_id.."_name"] = "Submachine Gun Mastery",
        ["special"..WMA.package_id.."_name"] = "Special Weapons Mastery",
        ["total"..WMA.package_id.."_name"] = "Weapons Mastery"
    }
    -- automatic locale, saves it to a file for reasons i wish i could explain
    for k, v in pairs(tweak_data.weapon) do
        local name_id = v.name_id
        if name_id and not WMA.blacklist[name_id] and string.find(k, "x_") == nil then
            local wname = self:text(WMA.forceloc[k] and WMA.forceloc[k] or "bm_w_" .. k)
            for i = 1, 4, 1 do
                mastery_achievement_package_loc["s_ach_" .. k .. "_" .. tostring(i) .. "_name"] = wname .. self:text("wma_mastery"..tostring(i))
                -- mastery_achievement_package_loc["s_ach_"..k.."_"..tostring(i).."_desc"] = ""
                mastery_achievement_package_loc["s_ach_" .. k .. "_" .. tostring(i) .. "_objective"] = self:text("wma_aobj_start") .. WMA.killamounts[i] .. self:text("wma_aobj_mid") .. wname .. self:text("wma_aobj_end")
            end
        end
    end
    -- write this to a json file to save some runtime
    local names = io.open(WMA.locfile, "w+")
	if names then
		names:write(json.encode(mastery_achievement_package_loc))
		names:close()
	end
    -- add the new strings
    LocalizationManager:add_localized_strings(mastery_achievement_package_loc)
end)
