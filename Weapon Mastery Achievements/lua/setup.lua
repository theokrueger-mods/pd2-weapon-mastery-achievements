_G.WMA = _G.WMA or {}

WMA.settings = {}

-- /shrug
WMA.package_id = "_achievement_package"

-- packages
WMA.packages = {
	["assault_rifle"] = CustomAchievementPackage:new("assault_rifle" .. WMA.package_id),
	["lmg"] = CustomAchievementPackage:new("lmg" .. WMA.package_id),
	["pistol"] = CustomAchievementPackage:new("pistol" .. WMA.package_id),
	["shotgun"] = CustomAchievementPackage:new("shotgun" .. WMA.package_id),
	["snp"] = CustomAchievementPackage:new("snp" .. WMA.package_id),
	["smg"] = CustomAchievementPackage:new("smg" .. WMA.package_id),
	["special"] = CustomAchievementPackage:new("special" .. WMA.package_id)
}

-- category overrides
WMA.congregate = {
	["crossbow"] = "special",
	["flamethrower"] = "special",
	["grenade_launcher"] = "special",
	["minigun"] = "special",
	["saw"] = "special"
}

-- # of kills per tier of achiev
WMA.killamounts = {
	100,
	500,
	2000,
	5000
}

WMA.rewardamount = {
	18,
	500000,
	36,
	1500000
}

WMA.rewardtype = {
	"cc",
	"xp",
	"cc",
	"xp"
}

-- things i cannot easily auto filter out (unlike crew npc and akimbo weapons)
WMA.blacklist = {
    ["debug_sentry_gun"] = true,
    ["contraband_m203"] = true,
    ["groza_underbarrel"] = true,
	["saw_secondary"] = true,
	["aa_turret_module"] = true,
	["crate_turret_module"] = true,
	["ceiling_turret_module_no_idle"] = true,
	["ceiling_turret_module_longer_range"] = true,
	["ceiling_turret_module"] = true,
	["swat_van_turret_module"] = true,
	["sentry_gun"] = true,
    ["new_raging_bull"] = true
}

-- for some reason these weapons have different weapon id and localisation strings
WMA.forceloc = {
	["new_mp5"] = "bm_w_mp5",
	["g17"] = "bm_w_glock_17",
	["rage"] = "bm_w_raging_bull",
	["g18c"] = "bm_w_glock_18c",
	["2006m"] = "bm_w_mateba",
	["1911"] = "bm_w_colt_1911",
	["new_m4"] = "bm_w_m4",
	["new_m14"] = "bm_w_m14",
	["flint"] = "bm_w_ak12",
	["g26"] = "bm_wp_pis_g26"
}

WMA.locfile = ModPath.."/loc/achievements/achievs.json"

WMA.langpath = ModPath.."/loc/"

WMA.menupath = ModPath.."/menu/options.json"

WMA.scriptpath = ModPath.."/scripts/"


-- create achievs
for k, v in pairs(tweak_data.weapon) do
    local name_id = v.name_id
    if name_id and not WMA.blacklist[k] and string.find(k, "x_") == nil then
        local category = v.categories and (v.categories[1] ~= "akimbo" and v.categories[1] or v.categories[2]) or "special"
        category = WMA.congregate[category] and WMA.congregate[category] or category
        for i = 1, 4, 1 do
            -- create achievements
            local config = {
                ["hidden_achievement"] = false,
                ["icon"] = "guis/mastery_achievement_package/achievement_icon_" .. tostring(i),
                ["id"] = "s_ach_" .. k .. "_" .. tostring(i),
                ["reward_type"] = WMA.rewardtype[i],
                ["reward_amount"] = WMA.rewardamount[i],
                ["rank"] = i,
                ["obj_id"] = "s_ach_" .. k .. "_" .. tostring(i) .. "_objective",
                ["amount"] = WMA.killamounts[i],
                -- ["desc_id"] = "s_ach_"..k.."_"..tostring(i).."_desc",
                ["desc_id"] = "s_ach_dummy",
                ["name_id"] = "s_ach_" .. k .. "_" .. tostring(i) .. "_name"
            }
            if tweak_data and tweak_data.achievement and
                tweak_data.achievement.custom_achievements[category .. WMA.package_id] then
                tweak_data.achievement.custom_achievements[category .. WMA.package_id]["s_ach_" .. k .. "_" .. tostring(i)] = config
            end
        end
    end
end
BeardLib.Managers.Achievement:SetupAchievements()
