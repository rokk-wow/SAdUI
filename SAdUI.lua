-- ===========================================================================
-- SADCORE FRAMEWORK INITIALIZATION (REQUIRED - DO NOT MODIFY)
-- ===========================================================================
-- This section is required by the SAdCore framework and must remain at the top.
-- The Initialize function is called by SAdCore during addon initialization.
-- ===========================================================================

local addonName = ...
local SAdCore = LibStub("SAdCore-1")
local addon = SAdCore:GetAddon(addonName)

addon.sadCore.savedVarsGlobalName = "SAdUI_Settings_Global"
addon.sadCore.savedVarsPerCharName = "SAdUI_Settings_Char"
addon.sadCore.compartmentFuncName = "SAdUI_Compartment_Func"

function addon:Initialize()
    self.sadCore.version = "1.0"
    self.author = "Rôkk-Wyrmrest Accord"

    -- Add Settings Panel using new AddSettingsPanel method (v1.13+)
    self:AddSettingsPanel("markerStyle", {
        title = "options",
        controls = {
            {
                type = "dropdown",
                name = "font",
                label = "Font",
                default = "Interface/AddOns/SAdUI/Media/Fonts/FiraMonoMedium.ttf",
                options = {
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/Quicksand.ttf", label = "Quicksand"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/PTSansNarrow.ttf", label = "PT Sans Narrow"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/Oswald.ttf", label = "Oswald"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/LiberationSans.ttf", label = "Liberation Sans"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/Impact.ttf", label = "Impact"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/Hack.ttf", label = "Hack"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/GothamUltra.ttf", label = "Gotham Ultra"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/FuturaPTBold.ttf", label = "Futura PT Bold"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/FORCEDSQUARE.ttf", label = "Forced Square"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/DorisPP.ttf", label = "Doris PP"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/DejaVuLGCSerif.ttf", label = "DejaVu LGC Serif"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/ContinuumMedium.ttf", label = "Continuum Medium"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/Collegiate.ttf", label = "Collegiate"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/BorisBlackBloxxDirty.ttf", label = "Boris Black Bloxx Dirty"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/BlenderProHeavy.ttf", label = "Blender Pro Heavy"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/AvantGardeLTBold.ttf", label = "Avant Garde LT Bold"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/AvantGardeLTMedium.ttf", label = "Avant Garde LT Medium"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/AccidentalPresidency.ttf", label = "Accidental Presidency"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/FritzQuadrata.ttf", label = "Fritz Quadrata"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/FiraMonoMedium.ttf", label = "Fira Mono Medium"},
                    {value = "Interface/AddOns/SAdUI/Media/Fonts/Micro.ttf", label = "Micro"}
                },
                onValueChange = self.fontChanged
            },
            {
                type = "checkbox",
                name = "hideActionBar8",
                label = "Hide Action Bar 8",
                default = true,
                onValueChange = self.actionBar8Changed
            }
        }
    })
    
    -- Event registration must be at the end of Initialize
    addon:RegisterEvent("PLAYER_ENTERING_WORLD", addon.OnPlayerEnteringWorld)
end

-- InfoBox configuration constants
local INFOBOX_FONT_SIZE = 12
local INFOBOX_LINE_HEIGHT = 18
local DIVIDER_HEIGHT = 10

function addon:fontChanged(fontPath)
    if not addon.SAdUI_InfoBox then
        return
    end
    
    local fontStrings = {
        addon.SAdUI_InfoBox.ilvl,
        addon.SAdUI_InfoBox.gold,
        addon.SAdUI_InfoBox.conquest,
        addon.SAdUI_InfoBox.honor,
        addon.SAdUI_InfoBox.speed,
        addon.SAdUI_InfoBox.durability,
        addon.SAdUI_InfoBox.vers,
        addon.SAdUI_InfoBox.haste,
        addon.SAdUI_InfoBox.mastery,
        addon.SAdUI_InfoBox.fps,
        addon.SAdUI_InfoBox.ping
    }
    
    for i, fontString in ipairs(fontStrings) do
        if fontString then
            local currentText = fontString:GetText()
            fontString:SetFont(fontPath, INFOBOX_FONT_SIZE, "OUTLINE")
            if currentText then
                fontString:SetText("")
                fontString:SetText(currentText)
            end
        end
    end
end

function addon.OnPlayerEnteringWorld()
    for funcName, func in pairs(addon.updateUI) do
        if type(func) == "function" then
            func()
        end
    end
end

addon.vars = {
    borderWidth = 2,
    borderColor = "000000FF",
    iconZoom = .2
}

addon.updateUI = {}

do -- Shared functions
    function addon:addBorder(bar, borderWidth, borderColor)
        if not bar then return end
        
        local size = borderWidth or self.vars.borderWidth
        local colorHex = borderColor or self.vars.borderColor
        local r, g, b, a = self:HexToRGB(colorHex)
        
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
end

-- ===========================================================================
-- ACTION BAR 8 OPACITY
-- ===========================================================================

do
    function addon.updateUI.SetActionBar8Opacity()
        if MultiBar7 then
            local shouldHide = addon.savedVars.markerStyle.hideActionBar8
            if shouldHide == nil then
                shouldHide = true -- default to hidden
            end
            MultiBar7:SetAlpha(shouldHide and 0 or 1)
        end
    end
    
    function addon:actionBar8Changed(isChecked)
        addon.updateUI.SetActionBar8Opacity()
    end
end

-- ===========================================================================
-- FRAME HIDING: TOTEM FRAME
-- ===========================================================================

do
    function addon.updateUI.HideTotemFrame()
        if TotemFrame then
            TotemFrame:Hide()
            TotemFrame:SetAlpha(0)
            
            hooksecurefunc(TotemFrame, "Show", function(self)
                self:Hide()
                self:SetAlpha(0)
            end)
        end
    end
end

-- ===========================================================================
-- FRAME HIDING: QUICK JOIN TOAST BUTTON
-- ===========================================================================

do
    function addon.updateUI.HideQuickJoinToastButton()
        if QuickJoinToastButton then
            QuickJoinToastButton:Hide()
            QuickJoinToastButton:SetAlpha(0)
            
            hooksecurefunc(QuickJoinToastButton, "Show", function(self)
                self:Hide()
                self:SetAlpha(0)
            end)
        end
    end
end

-- ===========================================================================
-- FRAME HIDING: CHAT FRAME CHANNEL BUTTON
-- ===========================================================================

do
    function addon.updateUI.HideChatFrameChannelButton()
        if ChatFrameChannelButton then
            ChatFrameChannelButton:Hide()
            ChatFrameChannelButton:SetAlpha(0)
            
            hooksecurefunc(ChatFrameChannelButton, "Show", function(self)
                self:Hide()
                self:SetAlpha(0)
            end)
        end
    end
end

-- ===========================================================================
-- CVAR SETTINGS
-- ===========================================================================

do
    function addon.updateUI.SetCVars()
        SetCVar("mapFade", 0)
    end
end

-- ===========================================================================
-- BATTLEFIELD MAP CUSTOMIZATION
-- ===========================================================================

do
    function addon.updateUI.CustomizeBattlefieldMap()
        local mapFrame = BattlefieldMapFrame
        if mapFrame then
            hooksecurefunc(mapFrame, "Show", function()
                if mapFrame.BorderFrame then
                    mapFrame.BorderFrame:Hide()
                    mapFrame.BorderFrame:SetAlpha(0)
                end
                
                if mapFrame.ScrollContainer then
                    if not mapFrame.ScrollContainer.SAdUI_BorderFrame then
                        local borderFrame = CreateFrame("Frame", nil, mapFrame.ScrollContainer)
                        borderFrame:SetAllPoints(mapFrame.ScrollContainer)
                        mapFrame.ScrollContainer.SAdUI_BorderFrame = borderFrame
                    end
                    addon:addBorder(mapFrame.ScrollContainer.SAdUI_BorderFrame)
                end
            end)
            
            if mapFrame:IsShown() and mapFrame.ScrollContainer then
                if mapFrame.BorderFrame then
                    mapFrame.BorderFrame:Hide()
                    mapFrame.BorderFrame:SetAlpha(0)
                end
                
                if not mapFrame.ScrollContainer.SAdUI_BorderFrame then
                    local borderFrame = CreateFrame("Frame", nil, mapFrame.ScrollContainer)
                    borderFrame:SetAllPoints(mapFrame.ScrollContainer)
                    mapFrame.ScrollContainer.SAdUI_BorderFrame = borderFrame
                end
                addon:addBorder(mapFrame.ScrollContainer.SAdUI_BorderFrame)
            end
        end
    end
    
    function addon.updateUI.ScaleZoneMap()
        local scale = 1.25
        local mapFrame = BattlefieldMapFrame
        if mapFrame then
            mapFrame:SetScale(scale)
        end
    end
end

-- ===========================================================================
-- MINIMAP CUSTOMIZATION
-- ===========================================================================

do
    function addon.updateUI.CustomizeMinimap()
        local minimapWidth = 248
        local minimapHeight = 248
        
        if Minimap then
            Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
            Minimap:SetSize(minimapWidth, minimapHeight)
            addon:addBorder(Minimap)
            
            -- Adjust zoom to compensate for rectangular aspect ratio
            -- Zooming out helps reduce the vertical distortion
            C_Timer.After(0.2, function()
                if Minimap then
                    local currentZoom = Minimap:GetZoom()
                    -- Zoom out one level to reduce vertical coordinate distortion
                    if currentZoom > 0 then
                        Minimap:SetZoom(currentZoom - 1)
                    end
                end
            end)
        end
        
        if MinimapBackdrop then
            MinimapBackdrop:Hide()
            MinimapBackdrop:SetAlpha(0)
        end
        
        if MinimapCluster and MinimapCluster.BorderTop then
            MinimapCluster.BorderTop:Hide()
            MinimapCluster.BorderTop:SetAlpha(0)
        end
        
        if MinimapCluster and MinimapCluster.Tracking then
            if MinimapCluster.Tracking.Button then
                MinimapCluster.Tracking.Button:Hide()
                MinimapCluster.Tracking.Button:SetAlpha(0)
            end
            if MinimapCluster.Tracking.Background then
                MinimapCluster.Tracking.Background:Hide()
                MinimapCluster.Tracking.Background:SetAlpha(0)
            end
        end
        
        if MinimapCluster and MinimapCluster.ZoneTextButton then
            MinimapCluster.ZoneTextButton:Hide()
            MinimapCluster.ZoneTextButton:SetAlpha(0)
            
            for i = 1, MinimapCluster.ZoneTextButton:GetNumRegions() do
                local region = select(i, MinimapCluster.ZoneTextButton:GetRegions())
                if region then
                    region:Hide()
                    region:SetAlpha(0)
                end
            end
        end
        
        if GameTimeFrame then
            GameTimeFrame:Hide()
            GameTimeFrame:SetAlpha(0)
        end
        
        if Minimap then
            if Minimap.ZoomIn then
                Minimap.ZoomIn:Hide()
                Minimap.ZoomIn:SetAlpha(0)
            end
            if Minimap.ZoomOut then
                Minimap.ZoomOut:Hide()
                Minimap.ZoomOut:SetAlpha(0)
            end
        end
        
        if MinimapZoomIn then
            MinimapZoomIn:Hide()
            MinimapZoomIn:SetAlpha(0)
        end
        if MinimapZoomOut then
            MinimapZoomOut:Hide()
            MinimapZoomOut:SetAlpha(0)
        end
        
        if Minimap then
            C_Timer.After(0.1, function()
                local currentZoom = Minimap:GetZoom()
                if currentZoom < Minimap:GetZoomLevels() then
                    Minimap:SetZoom(currentZoom + 1)
                else
                    Minimap:SetZoom(currentZoom - 1)
                end
                C_Timer.After(0.05, function()
                    Minimap:SetZoom(currentZoom)
                end)
            end)
        end
    end
end

-- ===========================================================================
-- INFO BOX
-- ===========================================================================

do
    local function UpdateInfoBox(frame)
        if not frame or not frame:IsShown() then return end
        
        -- Item Level
        local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel()
        
        -- PvP Item Level (only show if different and higher)
        local pvpilvl = ""
        if avgItemLevelPvp and avgItemLevelPvp > 0 and avgItemLevelPvp > avgItemLevelEquipped then
            pvpilvl = string.format("/%.0f", avgItemLevelPvp)
        end
        
        frame.ilvl:SetText(string.format("iLvl:  %.0f%s", avgItemLevelEquipped, pvpilvl))
       
        -- Total Gold
        local gold = GetMoney() / 10000
        local goldFormatted = tostring(math.floor(gold)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        frame.gold:SetText(string.format("Gold:  %s", goldFormatted))
        
        -- Conquest
        local conquestInfo = C_CurrencyInfo.GetCurrencyInfo(1602)
        local conquest = conquestInfo and conquestInfo.quantity or 0
        frame.conquest:SetText(string.format("Conq:  %d", conquest))
        
        -- Honor
        local honorInfo = C_CurrencyInfo.GetCurrencyInfo(1792)
        local honor = honorInfo and honorInfo.quantity or 0
        frame.honor:SetText(string.format("Honor: %d", honor))
        
        -- Movement Speed
        local speed = GetUnitSpeed("player") / 7 * 100
        frame.speed:SetText(string.format("Speed: %.0f%%", speed))
        
        -- Durability
        local totalDur, maxDur = 0, 0
        for i = 1, 18 do
            local curDur, maxDurSlot = GetInventoryItemDurability(i)
            if curDur and maxDurSlot then
                totalDur = totalDur + curDur
                maxDur = maxDur + maxDurSlot
            end
        end
        local durPercent = maxDur > 0 and (totalDur / maxDur * 100) or 100
        frame.durability:SetText(string.format("Repairs:  %.0f%%", durPercent))
        
        -- Secondary Stats
        local vers = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
        local haste = GetHaste()
        local mastery = GetMasteryEffect()
        frame.vers:SetText(string.format("Vers:    %.1f%%", vers))
        frame.haste:SetText(string.format("Haste:   %.1f%%", haste))
        frame.mastery:SetText(string.format("Mastery: %.1f%%", mastery))
        
        -- FPS and Latency
        local fps = GetFramerate()
        local _, _, latencyHome, latencyWorld = GetNetStats()
        frame.fps:SetText(string.format("FPS:   %.0f", fps))
        frame.ping:SetText(string.format("Ping:  %d/%d", latencyHome, latencyWorld))
    end
    
    function addon.updateUI.CreateInfoBox()
        if addon.SAdUI_InfoBox then return end
        
        local infoBox = CreateFrame("Frame", nil, UIParent)
        infoBox:SetSize(125, 248)
        infoBox:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
        
        local bg = infoBox:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(infoBox)
        bg:SetColorTexture(0, 0, 0, 0.6)
        
        -- Create text elements
        local yOffset = -10
        
        -- Get the saved font preference or use default
        local selectedFont = addon.savedVars.markerStyle.font or "Interface/AddOns/SAdUI/Media/Fonts/FiraMonoMedium.ttf"
        
        infoBox.ilvl = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.ilvl:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.ilvl:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.ilvl:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT - DIVIDER_HEIGHT
        
        
        infoBox.gold = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.gold:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.gold:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.gold:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT
        
        infoBox.conquest = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.conquest:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.conquest:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.conquest:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT
        
        infoBox.honor = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.honor:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.honor:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.honor:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT
        
        infoBox.durability = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.durability:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.durability:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.durability:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT - DIVIDER_HEIGHT
        
        infoBox.vers = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.vers:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.vers:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.vers:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT
        
        infoBox.haste = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.haste:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.haste:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.haste:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT
        
        infoBox.mastery = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.mastery:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.mastery:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.mastery:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT - DIVIDER_HEIGHT
        
        infoBox.speed = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.speed:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.speed:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.speed:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT

        infoBox.fps = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.fps:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.fps:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.fps:SetJustifyH("LEFT")
        yOffset = yOffset - INFOBOX_LINE_HEIGHT
        
        infoBox.ping = infoBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        infoBox.ping:SetPoint("TOPLEFT", infoBox, "TOPLEFT", 5, yOffset)
        infoBox.ping:SetFont(selectedFont, INFOBOX_FONT_SIZE, "OUTLINE")
        infoBox.ping:SetJustifyH("LEFT")
        
        addon.SAdUI_InfoBox = infoBox
        
        -- Update every 0.5 seconds
        C_Timer.NewTicker(0.5, function()
            UpdateInfoBox(infoBox)
        end)
        
        -- Initial update
        UpdateInfoBox(infoBox)
    end
end

-- ===========================================================================
-- CLOCK CUSTOMIZATION
-- ===========================================================================

do
    function addon.updateUI.CustomizeClock()
        local clockButton = TimeManagerClockButton
        if clockButton then
            clockButton:ClearAllPoints()
            clockButton:SetPoint("TOP", UIParent, "TOP", 0, -10)
            
            local ticker = TimeManagerClockTicker
            if ticker then
                ticker:SetFont(ticker:GetFont(), 18, "OUTLINE")
                ticker:SetJustifyH("CENTER")
            end
        end
        
        if AddonCompartmentFrame and clockButton then
            AddonCompartmentFrame:ClearAllPoints()
            AddonCompartmentFrame:SetPoint("LEFT", clockButton, "RIGHT", 15, 0)
        end
    end
end

-- ===========================================================================
-- CHAT FRAME CUSTOMIZATIONS
-- ===========================================================================

do
    function addon.updateUI.unclampChatFrames()
        for i = 1, NUM_CHAT_WINDOWS do
            local chatFrame = _G["ChatFrame" .. i]
            if chatFrame then
                chatFrame:SetClampedToScreen(false)
            end
        end
    end
    
    function addon.updateUI.repositionChatEditBox()
        for i = 1, NUM_CHAT_WINDOWS do
            local editBox = _G["ChatFrame" .. i .. "EditBox"]
            if editBox then
                editBox:ClearAllPoints()
                editBox:SetPoint("TOPLEFT", _G["ChatFrame" .. i], "BOTTOMLEFT", 0, 25)
                editBox:SetPoint("TOPRIGHT", _G["ChatFrame" .. i], "BOTTOMRIGHT", 0, 0)
                
                for j = 1, editBox:GetNumRegions() do
                    local region = select(j, editBox:GetRegions())
                    if region and region:GetObjectType() == "Texture" then
                        region:SetAlpha(0)
                        region:Hide()
                    end
                end
                
                if not editBox.SAdUI_Background then
                    editBox.SAdUI_Background = editBox:CreateTexture(nil, "BACKGROUND")
                    editBox.SAdUI_Background:SetAllPoints(editBox)
                    editBox.SAdUI_Background:SetColorTexture(0, 0, 0, 1)
                    
                    hooksecurefunc(editBox, "SetShown", function(self, shown)
                        if self.SAdUI_Background then
                            self.SAdUI_Background:SetShown(shown)
                        end
                    end)
                    
                    hooksecurefunc(editBox, "SetAlpha", function(self, alpha)
                        if self.SAdUI_Background then
                            self.SAdUI_Background:SetAlpha(alpha)
                        end
                    end)
                end
                
                if editBox.SAdUI_Background then
                    editBox.SAdUI_Background:SetShown(editBox:IsShown())
                    editBox.SAdUI_Background:SetAlpha(editBox:GetAlpha())
                end
            end
        end
    end
end

-- ===========================================================================
-- BUFF ICON GLOW (GREEN PROC GLOW)
-- ===========================================================================

do
    local function CreateProcGlow(parent, r, g, b)
        local procGlow = CreateFrame("Frame", nil, parent)
        procGlow:SetSize(parent:GetWidth() * 1.4, parent:GetHeight() * 1.4)
        procGlow:SetPoint("CENTER")
        
        local procLoop = procGlow:CreateTexture(nil, "ARTWORK")
        procLoop:SetAtlas("UI-HUD-ActionBar-Proc-Loop-Flipbook")
        procLoop:SetAllPoints(procGlow)
        procLoop:SetAlpha(0)
        
        if r ~= nil and g ~= nil and b ~= nil then
            procLoop:SetDesaturated(true)
            procLoop:SetVertexColor(r, g, b)
        end
        
        procGlow.ProcLoopFlipbook = procLoop
        
        local procLoopAnim = procGlow:CreateAnimationGroup()
        procLoopAnim:SetLooping("REPEAT")
        
        local alpha = procLoopAnim:CreateAnimation("Alpha")
        alpha:SetChildKey("ProcLoopFlipbook")
        alpha:SetDuration(0.001)
        alpha:SetOrder(0)
        alpha:SetFromAlpha(1)
        alpha:SetToAlpha(1)
        
        local flip = procLoopAnim:CreateAnimation("FlipBook")
        flip:SetChildKey("ProcLoopFlipbook")
        flip:SetDuration(1)
        flip:SetOrder(0)
        flip:SetFlipBookRows(6)
        flip:SetFlipBookColumns(5)
        flip:SetFlipBookFrames(30)
        
        procGlow.ProcLoop = procLoopAnim
        
        return procGlow
    end
    
    function addon.updateUI.addBuffIconGlow()
        local function OnUnitAura(event, unit)
            if unit ~= "player" then return end
            
            if BuffIconCooldownViewer then
                for _, child in pairs({BuffIconCooldownViewer:GetChildren()}) do
                    if child.Icon and not child.SAdUI_ProcGlow then
                        local procGlow = CreateProcGlow(child, 0, 1.0, 0.596)
                        procGlow.ProcLoop:Play()
                        child.SAdUI_ProcGlow = procGlow
                    end
                end
            end
        end
        
        addon:RegisterEvent("UNIT_AURA", OnUnitAura)
    end
end

-- ===========================================================================
-- Hide Compact Raid Frame Manager
-- ===========================================================================

do
    function addon.updateUI.CompactRaidFrameManagerVisibility()
        if CompactRaidFrameManager then
            CompactRaidFrameManager:Hide()
            CompactRaidFrameManager:SetAlpha(0)
            
            hooksecurefunc(CompactRaidFrameManager, "Show", function(self)
                self:Hide()
                self:SetAlpha(0)
            end)
        end
        
        if CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank then
            CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank:Hide()
            CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank:SetAlpha(0)
        end
        
        if CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer then
            CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer:Hide()
            CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer:SetAlpha(0)
        end
        
        if CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager then
            CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager:Hide()
            CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager:SetAlpha(0)
        end
    end
end

-- ===========================================================================
-- ARENA FRAME PORTRAITS: HIDE PORTRAITS
-- ===========================================================================

do
    function addon.updateUI.HideArenaFramePortraits()
        local function HidePortrait(frame)
            if frame and frame.Portrait then
                frame.Portrait:Hide()
                frame.Portrait:SetAlpha(0)
            end
        end
        
        -- Hide portraits for all 5 arena frames
        for i = 1, 5 do
            local arenaFrame = _G["ArenaEnemyMatchFrame" .. i]
            if arenaFrame then
                HidePortrait(arenaFrame)
            end
        end
        
        -- Hook to hide portraits when frames are shown
        hooksecurefunc("ArenaEnemyFrame_UpdatePlayer", function(frame)
            HidePortrait(frame)
        end)
    end
end

-- ===========================================================================
-- ESSENTIAL COOLDOWN VIEWER: COOLDOWN OVERLAY COLOR
-- ===========================================================================

-- do
--     function addon.customizeEssentialCooldowns()
--         local function ApplyCooldownColor(cooldownFrame)
--             if cooldownFrame and cooldownFrame.SetSwipeColor then
--                 cooldownFrame:SetSwipeColor(0, 0, 0, 1)
--             end
--         end
        
--         local function CustomizeChargeCount(child)
--             if not child or not child.ChargeCount then return end
            
--             local chargeCount = child.ChargeCount
            
--             -- ChargeCount might be a frame with a Current child fontstring
--             local textRegion = nil
            
--             if chargeCount.Current then
--                 textRegion = chargeCount.Current
--             elseif chargeCount:GetObjectType() == "FontString" then
--                 textRegion = chargeCount
--             else
--                 -- Search for fontstring child
--                 for i = 1, chargeCount:GetNumRegions() do
--                     local region = select(i, chargeCount:GetRegions())
--                     if region and region:GetObjectType() == "FontString" then
--                         textRegion = region
--                         break
--                     end
--                 end
--             end
            
--             if textRegion and textRegion:GetObjectType() == "FontString" then
--                 -- Raise frame strata
--                 if chargeCount.SetFrameStrata then
--                     chargeCount:SetFrameStrata("HIGH")
--                 end
                
--                 -- Add black background with soft edges if it doesn't exist
--                 if not chargeCount.SAdUI_Background then
--                     -- Try different textures (uncomment one):
                    
--                     local bg = chargeCount:CreateTexture(nil, "BACKGROUND")
--                     bg:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
--                     bg:SetVertexColor(0, 0, 0, 1)
--                     bg:SetPoint("CENTER", textRegion, "CENTER", 0, 0)
--                     bg:SetSize(30, 30)
--                     chargeCount.SAdUI_Background = bg
                    
--                 end
                
--                 -- Make it larger and set color to #FFBB00 (orange/gold)
--                 local fontPath, _, fontFlags = textRegion:GetFont()
--                 if fontPath then
--                     textRegion:SetFont(fontPath, 20, fontFlags)
--                 end
                
--                 -- -- Set color to #FFBB00
--                 -- textRegion:SetTextColor(1.0, 0.733, 0.0)  -- RGB for #FFBB00
                
--                 -- Position at the top of the parent frame
--                 textRegion:ClearAllPoints()
--                 textRegion:SetPoint("CENTER", child, "CENTER", 0, 0)
--                 textRegion:SetJustifyH("CENTER")
--                 textRegion:SetJustifyV("TOP")
--             end
--         end
        
--         local function SetupCooldownHooks()
--             if not EssentialCooldownViewer then
--                 return
--             end
            
--             for _, child in pairs({EssentialCooldownViewer:GetChildren()}) do
--                 if child.Cooldown and not child.cooldownHooked then
--                     hooksecurefunc(child.Cooldown, "SetCooldown", function(self)
--                         ApplyCooldownColor(self)
--                     end)
                    
--                     ApplyCooldownColor(child.Cooldown)
                    
--                     child.cooldownHooked = true
--                 end
                
--                 -- Customize charge count for this child
--                 if not child.chargeCountHooked then
--                     CustomizeChargeCount(child)
--                     child.chargeCountHooked = true
--                 end
--             end
--         end
        
--         C_Timer.After(1, SetupCooldownHooks)
--         C_Timer.NewTicker(5, SetupCooldownHooks)
--     end
-- end

-- ===========================================================================
-- ESSENTIAL COOLDOWN VIEWER: FLASH ANIMATION CUSTOMIZATION
-- ===========================================================================
-- Replace the default tiny flash with more visible WoW action bar animations.
-- Options: Proc Start (burst), Interrupt Display (animated ring), or Spell Fill (pulsing).
-- ===========================================================================

-- do
--     function addon.customizeEssentialCooldownFlash()
--         if not EssentialCooldownViewer then
--             return
--         end
        
--         for i, child in pairs({EssentialCooldownViewer:GetChildren()}) do
--             if child.CooldownFlash and child.CooldownFlash.Flipbook then
--                 local fb = child.CooldownFlash.Flipbook
                
--                 -- Hook CooldownFlash Show to modify the dynamically created animation
--                 if not child.CooldownFlash.SAdUI_ShowHooked then
--                     child.CooldownFlash.SAdUI_ShowHooked = true
--                     hooksecurefunc(child.CooldownFlash, "Show", function()
-- -- Available Methods on Flipbook Texture Object:
-- -- TEXTURE METHODS:
-- --   SetAtlas, GetAtlas, SetTexture, GetTexture, SetColorTexture
-- --   GetTextureSliceMode, SetTextureSliceMode, GetTextureFilePath, GetTextureFileID
-- --   ClearTextureSlice, SetDesaturated, GetDesaturation, IsDesaturated
-- --



-- -- SIZE & POSITION:
-- --   SetSize, GetSize, SetWidth, GetWidth, SetHeight, GetHeight
-- --   SetScale, GetScale, GetScaledRect, SetPoint, GetPoint, ClearPoint
-- --   ClearAllPoints, SetAllPoints, GetCenter, GetLeft, GetRight, GetTop, GetBottom
-- --   SetPointsOffset, AdjustPointsOffset, ClearPointsOffset
-- --
-- -- COLOR & APPEARANCE:
-- --   SetVertexColor, GetVertexColor, SetVertexColorFromBoolean
-- --   SetBlendMode, GetBlendMode, SetAlpha, GetAlpha, SetAlphaFromBoolean
-- --   SetGradient, SetDrawLayer, GetDrawLayer
-- --
-- -- ANIMATION:
-- --   CreateAnimationGroup, GetAnimationGroups, StopAnimating
-- --
-- -- VISIBILITY & INTERACTION:
-- --   Show, Hide, IsVisible, SetShown, IsRectValid
-- --   IsMouseMotionFocus, IsMouseClickEnabled, SetMouseClickEnabled
-- --   IsMouseOver, IsMouseEnabled, EnableMouse, IsMouseMotionEnabled, SetMouseMotionEnabled
-- --   IsMouseWheelEnabled, EnableMouseWheel
-- --
-- -- RENDERING:
-- --   SetSnapToPixelGrid, IsSnappingToPixelGrid, SetTexelSnappingBias, GetTexelSnappingBias
-- --   SetHorizTile, GetHorizTile, GetRotation, SetRotation
-- --   AddMaskTexture, RemoveMaskTexture, GetMaskTexture, GetNumMaskTextures
-- --   SetIgnoreParentScale, IsIgnoringParentScale, SetIgnoreParentAlpha, IsIgnoringParentAlpha
-- --
-- -- PARENTING & HIERARCHY:
-- --   SetParent, GetParent, SetParentKey, GetParentKey, ClearParentKey
-- --   IsProtected, IsForbidden, SetForbidden, CanChangeProtectedState
-- --
-- -- MISC:
-- --   GetObjectType, IsObjectType, GetDebugName, GetName
-- --   HookScript, SetScript, HasScript, GetScript
-- --   SetPropagateMouseClicks, CanPropagateMouseClicks, SetPropagateMouseMotion
-- --   ShouldButtonPassThrough, SetPassThroughButtons
-- --   IsPreventingSecretValues, SetPreventSecretValues, HasSecretValues
-- --   CollapseLayout, SetCollapseLayout, IsCollapsed
-- --   IsAnchoringRestricted, IsObjectLoaded, GetSourceLocation
-- --   SetTexCoord, GetTexCoord, ResetTexCoord, SetSpriteSheetCell
-- --   IsDragging, IsSnappingToGrid, SetBlockingLoadsRequested, IsBlockingLoadRequested
-- --
-- -- VERTEX OFFSETS:
-- --   GetVertexOffset, SetVertexOffset, ClearVertexOffsets
                        
--                         -- Purple Square
--                         fb:SetDesaturated(true)
--                         fb:SetVertexColor(1.0, 0.0, 1.0)
--                         fb:SetBlendMode("DISABLE")                         

--                         -- Rotated
--                         -- fb:SetDesaturated(true)
--                         -- fb:SetVertexColor(1.0, 1.0, 0.0)
--                         -- fb:SetRotation(math.rad(45))                        
--                         -- fb:SetBlendMode("BLEND")
                        

--                     end)
--                 end
--             end
--         end
--     end
    
--     C_Timer.After(1, addon.customizeEssentialCooldownFlash)
--     C_Timer.NewTicker(5, addon.customizeEssentialCooldownFlash)
-- end

-- Run debug after 5 seconds
-- C_Timer.After(5, debugFlashStructure)

-- We're detecting a Flipbook that exists before ability use, which is likely
-- a TEMPLATE. EssentialCooldownViewer may be using this pattern:
--   1. Create a base/template Flipbook with default settings
--   2. Clone/copy it when abilities are used (JIT creation)
--   3. The clones are what we see in fstack during the 8-second window

-- NEXT STEPS TO INVESTIGATE:
--   - Hook frame creation methods (CreateFrame, CreateTexture) on CooldownFlash parent
--   - Watch for texture/frame cloning operations
--   - Monitor SetTexture or SetAtlas calls to catch when GCD atlas switches to Proc atlas
--   - Hook the template's animation creation to catch when animations are added
--   - Look for CooldownFlash:Show() as trigger point to inspect what changed
-- ===========================================================================

-- do
--     local seenFlipbooks = {}  -- Track which flipbooks we've logged
    
--     -- Recursive function to scan all children
--     local function recursiveScan(frame, depth, path)
--         if not frame then return end
--         if depth > 10 then return end  -- Prevent infinite recursion
        
--         -- Check if this object has flipbook-like methods (SetAtlas, GetAnimationGroups)
--         local hasFlipbookMethods = frame.SetAtlas and frame.GetAnimationGroups
        
--         if hasFlipbookMethods then
--             local fbAddr = tostring(frame)
            
--             if not seenFlipbooks[fbAddr] then
--                 seenFlipbooks[fbAddr] = true
                
--                 local objType = "unknown"
--                 if frame.GetObjectType then
--                     objType = frame:GetObjectType()
--                 end
                
--                 local animGroups = {frame:GetAnimationGroups()}
--                 local atlas = frame:GetAtlas() or "none"
                
--                 print("=== FLIPBOOK-LIKE OBJECT ===")
--                 print("  Path:", path)
--                 print("  Type:", objType)
--                 print("  Address:", fbAddr)
--                 print("  Atlas:", atlas)
--                 print("  AnimationGroups:", #animGroups)
                
--                 -- INSPECT EACH ANIMATION GROUP IN DETAIL
--                 for j, ag in ipairs(animGroups) do
--                     local agAddr = tostring(ag)
--                     print("  AnimGroup", j, ":", agAddr)
                    
--                     local anims = {ag:GetAnimations()}
--                     print("    Animations:", #anims)
                    
--                     for k, anim in ipairs(anims) do
--                         local animType = "unknown"
--                         if anim.GetObjectType then
--                             animType = anim:GetObjectType()
--                         end
--                         local animAddr = tostring(anim)
--                         print("      Anim", k, "Type:", animType, "Addr:", animAddr)
                        
--                         if animType == "FlipBook" and anim.GetFlipBookRows then
--                             print("        Rows:", anim:GetFlipBookRows())
--                             print("        Cols:", anim:GetFlipBookColumns())
--                             print("        Frames:", anim:GetFlipBookFrames())
--                             print("        Duration:", anim:GetDuration())
--                         end
--                     end
--                 end
                
--                 -- Modify atlas
--                 frame:SetAtlas("UI-HUD-ActionBar-Proc-Start-Flipbook")
                
--                 -- Hook Play to modify animations
--                 for _, ag in ipairs(animGroups) do
--                     if not ag.SAdUI_PlayHooked then
--                         ag.SAdUI_PlayHooked = true
--                         hooksecurefunc(ag, "Play", function()
--                             local anims = {ag:GetAnimations()}
--                             for _, anim in ipairs(anims) do
--                                 if anim.GetObjectType and anim:GetObjectType() == "FlipBook" then
--                                     anim:SetFlipBookRows(6)
--                                     anim:SetFlipBookColumns(5)
--                                     anim:SetFlipBookFrames(30)
--                                     anim:SetDuration(0.702)
--                                     print(">>> FIXED ANIMATION ON PLAY:", path)
--                                 end
--                             end
--                         end)
--                     end
--                 end
--             end
--         end
        
--         -- Recurse into children
--         if frame.GetChildren then
--             for i, child in pairs({frame:GetChildren()}) do
--                 local childPath = path .. " > child" .. i
--                 recursiveScan(child, depth + 1, childPath)
--             end
--         end
        
--         -- ALSO check regions (not just children!)
--         if frame.GetRegions then
--             for i, region in pairs({frame:GetRegions()}) do
--                 local regionPath = path .. " > region" .. i
--                 recursiveScan(region, depth + 1, regionPath)
--             end
--         end
        
--         -- Check common properties
--         if frame.Flipbook then
--             recursiveScan(frame.Flipbook, depth + 1, path .. " > Flipbook")
--         end
--         if frame.flipbook then
--             recursiveScan(frame.flipbook, depth + 1, path .. " > flipbook")
--         end
--         if frame.CooldownFlash then
--             recursiveScan(frame.CooldownFlash, depth + 1, path .. " > CooldownFlash")
--         end
--     end
    
--     function addon.customizeEssentialCooldownFlash()
--         if not EssentialCooldownViewer then
--             return
--         end
        
--         -- Scan every 1 second - only new flipbooks will be logged
--         C_Timer.NewTicker(1, function()
--             recursiveScan(UIParent, 0, "UIParent")
--         end)
--     end
    
--     C_Timer.After(1, addon.customizeEssentialCooldownFlash)
--     C_Timer.NewTicker(5, addon.customizeEssentialCooldownFlash)
-- end

-- ===========================================================================
-- ANIMATION EXPLORATION GRID (TESTING TOOL)
-- ===========================================================================

-- do
--     function addon.exploreAnimations()
--         if addon.SAdUI_AnimationGrid then
--             return -- Already created
--         end
        
--         -- Create test frame
--         local testFrame = CreateFrame("Frame", nil, UIParent)
--         testFrame:SetSize(64, 64)
--         testFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
--         addon.SAdUI_AnimationGrid = testFrame
        
--         -- Black background
--         local bg = testFrame:CreateTexture(nil, "BACKGROUND")
--         bg:SetAllPoints()
--         bg:SetColorTexture(0, 0, 0, 1)
        
--         -- Label
--         local label = testFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--         label:SetPoint("TOP", testFrame, "BOTTOM", 0, -2)
--         label:SetText("Modern Blizzard Proc (ABE code)")
        
--         -- Create the texture (matching ABE's ProcStartFlipbook)
--         local texture = testFrame:CreateTexture(nil, "OVERLAY")
--         texture:SetAtlas("UI-HUD-ActionBar-Proc-Start-Flipbook")
--         texture:ClearAllPoints()
--         texture:SetSize(64, 64) -- Match button size
--         texture:SetPoint("CENTER", testFrame, "CENTER", 0, 0)
--         texture:SetVertexColor(1.0, 1.0, 1.0) -- No color change
--         texture:SetBlendMode("ADD")
        
--         -- Create AnimationGroup with FlipBook (matching ABE's startProc animation)
--         local animGroup = texture:CreateAnimationGroup()
--         local flipBook = animGroup:CreateAnimation("FlipBook")
--         flipBook:SetFlipBookRows(6)         -- procAnim.rows or 6
--         flipBook:SetFlipBookColumns(5)      -- procAnim.columns or 5
--         flipBook:SetFlipBookFrames(30)      -- procAnim.frames or 30
--         flipBook:SetDuration(0.702)         -- procAnim.duration or 0.702
--         flipBook:SetFlipBookFrameWidth(0.0) -- procAnim.frameW or 0.0
--         flipBook:SetFlipBookFrameHeight(0.0)-- procAnim.frameH or 0.0
        
--         -- Play animation once to test
--         texture:Show()
--         animGroup:Play()
        
--         -- Auto-replay every 3 seconds for testing
--         C_Timer.NewTicker(3, function()
--             animGroup:Play()
--         end)
--     end


-- ===========================================================================
-- POC: ZZZ Animation Frame (Like MotionSicknessFrame)
-- ===========================================================================
-- This creates a frame in the center of the screen that displays the same
-- ZZZ animation that Blizzard uses for the MotionSicknessFrame (AFK indicator)
-- ===========================================================================

-- function addon:CreateZZZAnimationPOC()
--     -- Create the main container frame
--     local frame = CreateFrame("Frame", "SAdUI_ZZZ_POC", UIParent)
--     frame:SetSize(200, 200)
--     frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    
--     -- Make it movable for testing
--     frame:SetMovable(true)
--     frame:EnableMouse(true)
--     frame:RegisterForDrag("LeftButton")
--     frame:SetScript("OnDragStart", frame.StartMoving)
--     frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
--     -- Add a background so we can see the frame
--     local bg = frame:CreateTexture(nil, "BACKGROUND")
--     bg:SetAllPoints()
--     bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)
    
--     -- Try using a Model frame instead of ModelScene
--     local model = CreateFrame("Model", nil, frame)
--     model:SetSize(150, 150)
--     model:SetPoint("CENTER")
    
--     -- Set the model file directly
--     model:SetModel(4542227)
    
--     -- Adjust camera and positioning
--     model:SetCamera(0)
--     model:SetPosition(0, 0, 0)
--     model:SetFacing(0)
    
--     -- Try different scale values
--     model:SetModelScale(3.0)
    
--     model:Show()
    
--     -- Store for debugging
--     frame.model = model
    
--     -- Add a title text
--     local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
--     title:SetPoint("TOP", frame, "TOP", 0, -10)
--     title:SetText("ZZZ Animation POC")
--     title:SetTextColor(1, 1, 1, 1)
    
--     -- Add instruction text
--     local instructions = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     instructions:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
--     instructions:SetText("Drag to move")
--     instructions:SetTextColor(0.7, 0.7, 0.7, 1)
    
--     -- Store the frame for later access
--     addon.ZZZ_POC_Frame = frame
    
--     -- Show the frame
--     frame:Show()
    
--     print("|cFF00FF00SAdUI:|r ZZZ Animation POC created! Frame is in the center of the screen.")
-- end
-- -- end

