local addonName = ...
local SAdCore = LibStub("SAdCore-1")
local addon = SAdCore:GetAddon(addonName)

addon.savedVarsGlobalName = "SAdUI_Settings_Global"
addon.savedVarsPerCharName = "SAdUI_Settings_Char"
addon.compartmentFuncName = "SAdUI_Compartment_Func"

function addon:LoadConfig()
    self.config.version = "1.0"
    self.author = "Rôkk-Wyrmrest Accord"

    self.config.settings.frameStyle = {
        title = "frameStyle",
        controls = {
            {
                type = "color",
                name = "borderColor",
                default = "ffffffff",
            },
        }
    }

    self.config.settings.markerStyle = {
        title = "uiOptions",
        controls = {
            {
                type = "checkbox",
                name = "exampleCheckbox",
                default = true,
            },
        }
    }

    addon:RegisterEvent("PLAYER_ENTERING_WORLD", addon.OnPlayerEnteringWorld)
end

addon.updateUI = {}
addon.vars = {
    borderWidth = 2,
    borderColor = "000000FF",
    iconZoom = .2
}

-- Comprehensive list of all action bar button prefixes
addon.actionBarPrefixes = {
    "ActionButton",              -- Main action bar (1-12)
    "MultiBarBottomLeftButton",  -- Bottom left bar (1-12)
    "MultiBarBottomRightButton", -- Bottom right bar (1-12)
    "MultiBarRightButton",       -- Right bar (1-12)
    "MultiBarLeftButton",        -- Right bar 2 (1-12)
    "MultiBar5Button",           -- Additional bar 5 (1-12)
    "MultiBar6Button",           -- Additional bar 6 (1-12)
    "MultiBar7Button",           -- Additional bar 7 (1-12)
}

-- Helper function to iterate over all action buttons
function addon:IterateActionButtons(callback)
    if type(callback) ~= "function" then
        addon:debug("ERROR: IterateActionButtons requires a callback function")
        return
    end
    
    for _, prefix in ipairs(addon.actionBarPrefixes) do
        for i = 1, 12 do
            local buttonName = prefix .. i
            local button = _G[buttonName]
            if button then
                callback(button, buttonName)
            end
        end
    end
end

function addon.updateUI.exampleOne()
    addon:debug("exampleOne fired!")
end

function addon.updateUI.hideSpellCastAnimFrame()
    addon:debug("Hiding spell cast animation frames on action buttons")
    
    local function hideButtonGlow(button)
        if button and button.SpellCastAnimFrame then
            -- Permanently hide the entire frame
            button.SpellCastAnimFrame:SetAlpha(0)
            button.SpellCastAnimFrame:Hide()
            
            -- Hook the Show function to prevent it from ever showing
            button.SpellCastAnimFrame.Show = function() end
            button.SpellCastAnimFrame.SetAlpha = function() end
            
            -- Hide all child textures and frames
            if button.SpellCastAnimFrame.Fill then
                button.SpellCastAnimFrame.Fill:SetAlpha(0)
                button.SpellCastAnimFrame.Fill:Hide()
                button.SpellCastAnimFrame.Fill.Show = function() end
            end
            if button.SpellCastAnimFrame.InnerGlow then
                button.SpellCastAnimFrame.InnerGlow:SetAlpha(0)
                button.SpellCastAnimFrame.InnerGlow:Hide()
                button.SpellCastAnimFrame.InnerGlow.Show = function() end
            end
            if button.SpellCastAnimFrame.FillMask then
                button.SpellCastAnimFrame.FillMask:SetAlpha(0)
                button.SpellCastAnimFrame.FillMask:Hide()
                button.SpellCastAnimFrame.FillMask.Show = function() end
            end
            if button.SpellCastAnimFrame.Ants then
                button.SpellCastAnimFrame.Ants:SetAlpha(0)
                button.SpellCastAnimFrame.Ants:Hide()
                button.SpellCastAnimFrame.Ants.Show = function() end
            end
            if button.SpellCastAnimFrame.Spark then
                button.SpellCastAnimFrame.Spark:SetAlpha(0)
                button.SpellCastAnimFrame.Spark:Hide()
                button.SpellCastAnimFrame.Spark.Show = function() end
            end
        end
        
        -- Hide interrupt display
        if button and button.InterruptDisplay then
            button.InterruptDisplay:SetAlpha(0)
            button.InterruptDisplay:Hide()
            button.InterruptDisplay.Show = function() end
            if button.InterruptDisplay.Base then
                button.InterruptDisplay.Base:SetAlpha(0)
                button.InterruptDisplay.Base:Hide()
            end
            if button.InterruptDisplay.Highlight then
                button.InterruptDisplay.Highlight:SetAlpha(0)
                button.InterruptDisplay.Highlight:Hide()
            end
        end
        
        -- Hide CheckedTexture (inner glow when casting)
        if button then
            local checkedTexture = button:GetCheckedTexture()
            if checkedTexture then
                checkedTexture:SetAlpha(0)
                checkedTexture:Hide()
            end
            -- Disable the checked state
            hooksecurefunc(button, "SetChecked", function(self)
                if self:GetChecked() then
                    local tex = self:GetCheckedTexture()
                    if tex then
                        tex:SetAlpha(0)
                        tex:Hide()
                    end
                end
            end)
        end
    end
    
    -- Iterate over all action buttons using the shared helper
    addon:IterateActionButtons(function(button, buttonName)
        hideButtonGlow(button)
    end)
    
    addon:debug("Finished hiding spell cast animation frames")
end

function addon.updateUI.hideMacroText()
    addon:debug("Hiding macro text on action buttons")
    
    local function hideButtonMacroText(button, buttonName)
        if button and button.Name then
            button.Name:SetAlpha(0)
            button.Name:Hide()
            button.Name.Show = function() end
            button.Name.SetAlpha = function() end
            addon:debug("Hid macro text for: " .. buttonName)
        end
    end
    
    -- Iterate over all action buttons using the shared helper
    addon:IterateActionButtons(hideButtonMacroText)
    
    addon:debug("Finished hiding macro text")
end

function addon.updateUI.hideKeybindText()
    addon:debug("Hiding keybind text on action buttons")
    
    local function hideButtonKeybind(button, buttonName)
        if button and button.HotKey then
            button.HotKey:SetAlpha(0)
            button.HotKey:Hide()
            button.HotKey.Show = function() end
            button.HotKey.SetAlpha = function() end
            addon:debug("Hid keybind text for: " .. buttonName)
        end
    end
    
    -- Iterate over all action buttons using the shared helper
    addon:IterateActionButtons(hideButtonKeybind)
    
    addon:debug("Finished hiding keybind text")
end

function addon.updateUI.setCVars()
    addon:debug("Setting CVars")
    
    SetCVar("mapFade", 0)
    addon:debug("Set mapFade to 0")
    
    addon:debug("Finished setting CVars")
end

function addon.updateUI.addActionButtonBorders()
    addon:debug("Adding borders to action buttons")
    
    local function addButtonBorder(button, buttonName)
        if button then
            -- Hide the default rounded border texture
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetAlpha(0)
                normalTexture:Hide()
            end
            
            -- Also hide the NormalTexture2 if it exists
            if button.NormalTexture then
                button.NormalTexture:SetAlpha(0)
                button.NormalTexture:Hide()
            end
            
            addon:addBorder(button)
            addon:debug("Added border to: " .. buttonName)
        end
    end
    
    -- Iterate over all action buttons using the shared helper
    addon:IterateActionButtons(addButtonBorder)
    
    addon:debug("Finished adding borders to action buttons")
end

function addon.updateUI.setButtonPadding()
    addon:debug("Setting button padding on action bars")
    
    local padding = addon.vars.buttonPadding
    
    -- Map button prefixes to their parent bar frames
    local barMap = {
        ActionButton = MainMenuBar,
        MultiBarBottomLeftButton = MultiBarBottomLeft,
        MultiBarBottomRightButton = MultiBarBottomRight,
        MultiBarRightButton = MultiBarRight,
        MultiBarLeftButton = MultiBarLeft,
        MultiBar5Button = MultiBar5,
        MultiBar6Button = MultiBar6,
        MultiBar7Button = MultiBar7,
    }
    
    -- Set spacing on each bar's layout system
    for prefix, bar in pairs(barMap) do
        if bar then
            -- Set the button spacing attribute that Blizzard's layout system uses
            if bar.SetAttribute then
                bar:SetAttribute("buttonSpacing", padding)
                addon:debug("Set buttonSpacing for: " .. (bar:GetName() or prefix))
            end
            
            -- Hook the bar's layout refresh to apply our spacing
            if bar.UpdateGridLayout then
                hooksecurefunc(bar, "UpdateGridLayout", function(self)
                    if self.SetAttribute then
                        self:SetAttribute("buttonSpacing", padding)
                    end
                end)
            end
            
            -- Trigger a layout update to apply changes immediately
            if bar.UpdateGridLayout then
                bar:UpdateGridLayout()
            elseif bar.Layout then
                bar:Layout()
            end
        end
    end
    
    addon:debug("Finished setting button padding (Blizzard layout system will handle positioning)")
end

function addon.updateUI.zoomButtonIcons()
    addon:debug("Zooming button icons on action bars")
    
    local zoom = addon.vars.iconZoom
    local inset = zoom / 2
    
    local function zoomButtonIcon(button, buttonName)
        if button and button.icon then
            -- Crop the texture edges to create a zoom effect
            button.icon:SetTexCoord(inset, 1 - inset, inset, 1 - inset)
            addon:debug("Zoomed icon for: " .. buttonName .. " by " .. (zoom * 100) .. "%")
        end
    end
    
    -- Iterate over all action buttons using the shared helper
    addon:IterateActionButtons(zoomButtonIcon)
    
    addon:debug("Finished zooming button icons")
end

function addon:addBorder(bar)
    if not bar then return end
    
    local size = self.vars.borderWidth
    local colorHex = self.vars.borderColor
    local r, g, b, a = self:hexToRGB(colorHex)
    
    local borders = bar.SAdUnitFrames_Borders
    
    if borders then
        borders.top:SetColorTexture(r, g, b, a)
        borders.top:SetHeight(size)
        
        borders.bottom:SetColorTexture(r, g, b, a)
        borders.bottom:SetHeight(size)
        
        borders.left:SetColorTexture(r, g, b, a)
        borders.left:SetWidth(size)
        
        borders.right:SetColorTexture(r, g, b, a)
        borders.right:SetWidth(size)
    else
        borders = {}
        
        borders.top = bar:CreateTexture(nil, "OVERLAY")
        borders.top:SetColorTexture(r, g, b, a)
        borders.top:SetHeight(size)
        borders.top:ClearAllPoints()
        borders.top:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
        borders.top:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
        
        borders.bottom = bar:CreateTexture(nil, "OVERLAY")
        borders.bottom:SetColorTexture(r, g, b, a)
        borders.bottom:SetHeight(size)
        borders.bottom:ClearAllPoints()
        borders.bottom:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
        borders.bottom:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
        
        borders.left = bar:CreateTexture(nil, "OVERLAY")
        borders.left:SetColorTexture(r, g, b, a)
        borders.left:SetWidth(size)
        borders.left:ClearAllPoints()
        borders.left:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
        borders.left:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
        
        borders.right = bar:CreateTexture(nil, "OVERLAY")
        borders.right:SetColorTexture(r, g, b, a)
        borders.right:SetWidth(size)
        borders.right:ClearAllPoints()
        borders.right:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
        borders.right:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
        
        bar.SAdUnitFrames_Borders = borders
    end
end

function addon:OnPlayerEnteringWorld()
    addon:debug("PLAYER_ENTERING_WORLD event fired - Running all updateUI functions")
    for funcName, func in pairs(addon.updateUI) do
        addon:debug("Found updateUI entry: " .. funcName .. " (type: " .. type(func) .. ")")
        if type(func) == "function" then
            addon:debug("Running updateUI." .. funcName)
            func()
            addon:debug("Completed updateUI." .. funcName)
        end
    end
    addon:debug("Finished running all updateUI functions")
end
