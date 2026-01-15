local addonName = ...
local SAdCore = LibStub("SAdCore-1")
local addon = SAdCore:GetAddon(addonName)

addon.savedVarsGlobalName = "SAdUI_Settings_Global"
addon.savedVarsPerCharName = "SAdUI_Settings_Char"
addon.compartmentFuncName = "SAdUI_Compartment_Func"

function addon:LoadConfig()
    self.config.version = "1.0"
    self.author = "Rôkk-Wyrmrest Accord"

    for _, zoneName in ipairs(addon.zones) do
        self.config.settings[zoneName] = {
            title = zoneName .. "Title",
            controls = {
                {
                    type = "checkbox",
                    name = "exampleCheckbox",
                    default = true,
                },
            }
        }
    end
end
