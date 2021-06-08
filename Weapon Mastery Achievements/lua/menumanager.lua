if not _G.WMA then
    dofile(ModPath .. "/lua/setup.lua")
end

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_WMA", function(menu)
	MenuCallbackHandler.wma_reload_loc_cblk = function(self, item)
		os.remove(WMA.locfile)
        managers.localization = LocalizationManager:new()
	end
    MenuCallbackHandler.wma_import_pdth_cblk = function(self, item)
		dofile(WMA.scriptpath .. "wma_import_pdth.lua")
	end
    MenuHelper:LoadFromJsonFile(WMA.menupath, WMA, WMA.settings)
end)