local addonName = ...
local SAdCore = LibStub("SAdCore-1")
local addon = SAdCore:GetAddon(addonName)

addon.sadCore.savedVarsGlobalName = "SAdUI_Settings_Global"
addon.sadCore.savedVarsPerCharName = "SAdUI_Settings_Char"
addon.sadCore.compartmentFuncName = "SAdUI_Compartment_Func"

addon.onPlayerEnteringWorld = addon.onPlayerEnteringWorld or {}
addon.onUpdateArena = addon.onUpdateArena or {}
addon.onEditModeEnter = addon.onEditModeEnter or {}
addon.arrangingPartyFrames = false
addon.vars = {
    borderWidth = 2,
    borderColor = "000000FF",
    iconZoom = .2
}

function addon:Initialize()
    self.author = "Rôkk-Wyrmrest Accord"

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
            }
        }
    })
    
    self:RegisterEvent("PLAYER_ENTERING_WORLD", self.onPlayerEnteringWorldHandler)
    self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS", self.onUpdateArenaHandler)
    self:RegisterEvent("ARENA_OPPONENT_UPDATE", self.onUpdateArenaHandler)
    self:RegisterEvent("GROUP_ROSTER_UPDATE", self.onUpdateArenaHandler)
    self:RegisterFrameEvent("EditMode.Enter", self.onEditModeEnterHandler)
end

function addon.onPlayerEnteringWorldHandler()
    for funcName, func in pairs(addon.onPlayerEnteringWorld) do
        if type(func) == "function" then
            addon:CombatSafe(function()
                func(addon)
            end)
        end
    end
end

function addon.onUpdateArenaHandler()
    for funcName, func in pairs(addon.onUpdateArena) do
        if type(func) == "function" then
            addon:CombatSafe(function()
                func(addon)
            end)
        end
    end
end

function addon.onEditModeEnterHandler()
    for funcName, func in pairs(addon.onEditModeEnter) do
        if type(func) == "function" then
            addon:CombatSafe(function()
                func(addon)
            end)
        end
    end
end

-- ===========================================================================
-- REMOVE ARENA GAP
-- ===========================================================================
do
    function addon.onPlayerEnteringWorld.RemoveArenaFramesGap(self)
        addon:CombatSafe(function()
            addon.RemoveArenaFramesGap(addon)
        end)
    end

    function addon.onUpdateArena.RemoveArenaFramesGap(self)
        addon:CombatSafe(function()
            addon.RemoveArenaFramesGap(addon)
        end)
    end

    function addon.onEditModeEnter.RemoveArenaFramesGap(self)
        addon:CombatSafe(function()
            addon.RemoveArenaFramesGap(addon)
        end)
    end

    function addon:RemoveArenaFramesGap()
        self:Debug("RemoveArenaFramesGap")
        
        local arena1 = CompactArenaFrameMember1
        local arena2 = CompactArenaFrameMember2
        local arena3 = CompactArenaFrameMember3
        
        if not arena1 then
            return false
        end
    
        self:HookArenaFrames()
        
        self:CombatSafe(function()
            self.isRepositioningArenaFrames = true
            if arena2 then
                arena2:ClearAllPoints()
                arena2:SetPoint("TOP", arena1, "BOTTOM", 0, 0)
            end
            
            if arena3 and arena2 then
                arena3:ClearAllPoints()
                arena3:SetPoint("TOP", arena2, "BOTTOM", 0, 0)
            end
            
            self.isRepositioningArenaFrames = false
        end)
        
        return true
    end

    function addon:HookArenaFrames()
        self:Debug("HookArenaFrames")
        
        local arena1 = CompactArenaFrameMember1
        local arena2 = CompactArenaFrameMember2
        local arena3 = CompactArenaFrameMember3
        
        if self.arenaFramesHooked then
            return
        end
        
        if not arena1 or not arena2 then
            return
        end
        
        hooksecurefunc(arena2, "SetPoint", function(frame)
            if self.isRepositioningArenaFrames then
                return
            end
            
            if not self:GetValue("options", "removeArenaFramesGap") then
                return
            end
            
            if not arena1 or not arena1:IsShown() then
                return
            end
            
            local numPoints = frame:GetNumPoints()
            if numPoints == 1 then
                local success, point, relativeTo, relativePoint, x, y = pcall(function()
                    return frame:GetPoint(1)
                end)
                
                if not success then
                    return
                end
                
                if relativeTo ~= arena1 or point ~= "TOP" or relativePoint ~= "BOTTOM" or y ~= 0 then
                    self:CombatSafe(function()
                        self.isRepositioningArenaFrames = true
                        frame:ClearAllPoints()
                        frame:SetPoint("TOP", arena1, "BOTTOM", 0, 0)
                        self.isRepositioningArenaFrames = false
                    end)
                end
            end
        end)
        
        if arena3 then
            hooksecurefunc(arena3, "SetPoint", function(frame)
                if self.isRepositioningArenaFrames then
                    return
                end
                
                if not self:GetValue("options", "removeArenaFramesGap") then
                    return
                end
                
                if not arena2 or not arena2:IsShown() then
                    return
                end
                
                local numPoints = frame:GetNumPoints()
                if numPoints == 1 then
                    local success, point, relativeTo, relativePoint, x, y = pcall(function()
                        return frame:GetPoint(1)
                    end)
                    
                    if not success then
                        return
                    end
                    
                    if relativeTo ~= arena2 or point ~= "TOP" or relativePoint ~= "BOTTOM" or y ~= 0 then
                        self:CombatSafe(function()
                            self.isRepositioningArenaFrames = true
                            frame:ClearAllPoints()
                            frame:SetPoint("TOP", arena2, "BOTTOM", 0, 0)
                            self.isRepositioningArenaFrames = false
                        end)
                    end
                end
            end)
        end
        
        self.arenaFramesHooked = true
    end
end

-- ===========================================================================
-- SORT PARTY FRAMES
-- ===========================================================================

do
    function addon.onPlayerEnteringWorld.SortPartyFrames(self)
        addon:CombatSafe(function()
            addon.onUpdateArena.SortPartyFrames(addon)
        end)
    end

    function addon.onUpdateArena.SortPartyFrames(self)
        self.unitFor = self.unitFor or {}
        self.frameFor = self.frameFor or {}
        
        if not CompactPartyFrameMember1 or not CompactPartyFrameMember1:IsShown() then
            return
        end
        
        local partyFrames = {
            CompactPartyFrameMember1,
            CompactPartyFrameMember2,
            CompactPartyFrameMember3
        }

        local playerFrame = self:GetFrameForUnit("player")
        local party1Frame = self:GetFrameForUnit("party1")
        local party2Frame = self:GetFrameForUnit("party2")
        
        if not playerFrame or not party1Frame or not party2Frame then
            return
        end

        if (self.frameFor["player"] == "CompactPartyFrameMember1") and 
           (self.frameFor["party1"] == "CompactPartyFrameMember2") and 
           (self.frameFor["party2"] == "CompactPartyFrameMember3") then
            return
        else
            print("Sorting Wrong Order")
            print("player > " .. tostring(self.frameFor["player"]))
            print("party1 > " .. tostring(self.frameFor["party1"]))
            print("party2 > " .. tostring(self.frameFor["party2"]))
        end

        self:ArrangePartyFrames(playerFrame, party1Frame, party2Frame)
    end

    function addon:GetFrameForUnit(unit)
        if not unit then
            return nil
        end
        
        self.unitFor = self.unitFor or {}
        self.frameFor = self.frameFor or {}
        
        local framesToSearch = {
            CompactPartyFrameMember1,
            CompactPartyFrameMember2,
            CompactPartyFrameMember3,
            CompactArenaFrameMember1,
            CompactArenaFrameMember2,
            CompactArenaFrameMember3
        }
        
        for _, frame in ipairs(framesToSearch) do
            if frame and frame.unit then
                local isMatch = self:SecureCall(UnitIsUnit, frame.unit, unit)
                if isMatch == true then
                    local frameName = frame:GetName()
                    self.unitFor[frame] = unit
                    self.frameFor[unit] = frameName
                    return frame
                end
            end
        end

        return nil
    end
    
    function addon:ArrangePartyFrames(firstFrame, secondFrame, thirdFrame)
        local exit = false
        if exit == true then return end
        
        if self.arrangingPartyFrames then
            return
        end
        
        if not firstFrame or not secondFrame or not thirdFrame then
            return
        end
        
        self.arrangingPartyFrames = true

        -- Get the container frame (parent of party frames)
        local container = firstFrame:GetParent()
        if not container then
            self.arrangingPartyFrames = false
            return
        end
        
        -- Use TOPLEFT anchor point like FrameSort does
        local anchorPoint = "TOPLEFT"
        local frameHeight = firstFrame:GetHeight() or 0
        
        firstFrame:ClearAllPoints()
        firstFrame:SetPoint(anchorPoint, container, anchorPoint, 0, 0)
        
        secondFrame:ClearAllPoints()
        secondFrame:SetPoint(anchorPoint, container, anchorPoint, 0, -frameHeight)
        
        thirdFrame:ClearAllPoints()
        thirdFrame:SetPoint(anchorPoint, container, anchorPoint, 0, -frameHeight * 2)
        
        
        -- Reset flag to allow future executions
        self.arrangingPartyFrames = false
    end
end

-- ===========================================================================
-- UPDATE WOW SETTINGS
-- ===========================================================================

do
    function addon.onPlayerEnteringWorld.UpdateSettings(self)
        -- ==============================================================
        -- CONTROLS
        -- ==============================================================
        SetCVar("stickyTargeting", 1)                   -- Sticky Targeting: true
        SetCVar("autoDismount", 1)                      -- Auto dismount in flight: true
        SetCVar("autoClearAFK", 1)                      -- Auto cancel away mode: true
        SetCVar("interactOnLeftClick", 1)               -- Interact on left click: true
        SetCVar("lootUnderMouse", 0)                    -- Open loot window at mouse: false
        SetCVar("autoLootDefault", 1)                   -- Auto loot: true
        SetCVar("combinedBags", 0)                      -- Combine bags: false
        SetCVar("softTargettingInteractKeySound", 0)    -- Interact key sound cue: false
        
        -- CONTROLS > MOUSE
        SetCVar("lockCursorToWindow", 0)                -- Lock cursor to window: false
        SetCVar("mouseInvertPitch", 0)                  -- Invert mouse: false
        SetCVar("mouseSpeed", 5.5)                      -- Mouse look speed: 5.5
        -- Enable mouse sensitivity: false - may not have CVar
        SetCVar("enableMouseSpeed", 0)                  -- Enable mouse sensitivity
        SetCVar("autoInteract", 0)                      -- Click-to-move: false
        
        -- CONTROLS > CAMERA
        SetCVar("cameraWaterCollision", 0)              -- Water collision: false
        SetCVar("cameraFollowSpeed", 5.5)               -- Auto follow speed: 5.5
        SetCVar("cameraYawMoveSpeed", 0)                -- Camera following style: never adjust (0)
        
        -- ==============================================================
        -- INTERFACE > DISPLAY
        -- ==============================================================
        SetCVar("showInGameNavigation", 1)              -- In game navigation: true
        SetCVar("showTutorials", 0)                     -- Tutorials: false
        SetCVar("statusTextDisplay", "BOTH")            -- Status text: both
        SetCVar("chatBubbles", 0)                       -- Chat bubbles: false
        SetCVar("chatBubblesParty", 0)                  -- Party chat bubbles: false
        SetCVar("chatBubblesParty", 0)                  -- Raid chat bubbles: false (same CVar)
        
        -- INTERFACE > QUESTS
        SetCVar("showLowLevelQuests", 1)                -- Show low-level quests: true
        
        -- INTERFACE > RAID FRAMES
        SetCVar("raidFramesDisplayIncomingHeals", 0)    -- Display incoming heals: false
        SetCVar("raidFramesDisplayPowerBars", 1)        -- Display power bars: true
        SetCVar("raidFramesDisplayOnlyHealerPowerBars", 1) -- Display only healer power bars: true
        SetCVar("raidFramesDisplayAggroHighlight", 1)   -- Display aggro highlight: true
        SetCVar("raidFramesDisplayClassColor", 1)       -- Display class colors: true
        SetCVar("raidFramesDisplayPets", 0)             -- Display pets: false
        SetCVar("raidFramesDisplayMainTankAndAssist", 0) -- Display main tank and assist: false
        SetCVar("raidFramesDisplayDebuffs", 1)          -- Show debuffs: true
        SetCVar("raidFramesDisplayOnlyDispellableDebuffs", 1) -- Display only dispellable debuffs: true
        SetCVar("raidFramesHealthText", "none")         -- Display health text: none
        
        -- ==============================================================
        -- ACTION BARS
        -- ==============================================================
        -- Note: PROXY_SHOW_ACTIONBAR_* requires Settings.SetValue(), not SetCVar()
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)   -- Bar 2 (Bottom Left): true
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_3", true)   -- Bar 3 (Bottom Right): true
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_4", true)   -- Bar 4 (Right Bar 1): true
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_5", true)   -- Bar 5 (Right Bar 2): true
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_6", false)  -- Bar 6: false
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_7", false)  -- Bar 7: false
        Settings.SetValue("PROXY_SHOW_ACTIONBAR_8", false)  -- Bar 8: false
        SetCVar("lockActionBars", 0)                        -- Lock action bars: false
        SetCVar("countdownForCooldowns", 1)                 -- Show numbers for cooldowns: true
        
        -- ==============================================================
        -- COMBAT
        -- ==============================================================
        SetCVar("nameplateResourceOnTarget", 0)         -- Personal resource display: false
        SetCVar("selfHighlight", 0)                     -- Self highlight: off
        SetCVar("showTargetOfTarget", 1)                -- Target of target: true
        SetCVar("ffxDeath", 1)                          -- Do not flash screen at low health: false (1 = flash enabled)
        SetCVar("lossOfControl", 1)                     -- Loss of control alerts: true
        SetCVar("floatingCombatTextCombatDamage", 0)    -- Scrolling combat text for self: false
        SetCVar("autoSelfCast", 1)                      -- Self cast: auto
        SetCVar("empowerTapControls", 0)                -- Empowered spell input: hold and release (0 = hold/release, 1 = press/tap)
        SetCVar("spellActivationOverlayOpacity", 1.0)   -- Spell alert opacity: 100%
        
        -- ==============================================================
        -- SOCIAL
        -- ==============================================================
        SetCVar("profanityFilter", 0)                   -- Mature language filter: false
        SetCVar("guildMemberNotify", 1)                 -- Guild member alert: true
        SetCVar("blockTrades", 1)                       -- Block trades: true
        SetCVar("blockGuildInvites", 1)                 -- Block guild invites: true
        SetCVar("blockChannelInvites", 0)               -- Block chat channel invites: false
        SetCVar("showToastOnline", 1)                   -- Online friends: true
        SetCVar("showToastOffline", 1)                  -- Offline friends: true
        SetCVar("showToastBroadcast", 0)                -- Broadcast updates: false
        SetCVar("showToastWindow", 0)                   -- Show toast window: false
        SetCVar("chatStyle", "im")                      -- Chat style: IM Style
        SetCVar("whisperMode", "inline")                -- New whispers: in-line
        SetCVar("showTimestamps", "none")               -- Chat timestamps: none
        
        -- ==============================================================
        -- PING SYSTEM
        -- ==============================================================
        SetCVar("enablePings", 1)                       -- Enable pings: true
        SetCVar("pingMode", 0)                          -- Ping mode: quick ping (0 = quick ping)
        SetCVar("Sound_EnablePingSounds", 1)            -- Ping sounds: true
        SetCVar("showPingsInChat", 1)                   -- Show pings in chat: true
        
        -- ==============================================================
        -- NAMEPLATES
        -- ==============================================================
        -- NAMEPLATES > NAMES
        SetCVar("UnitNameOwn", 0)                       -- My name: false
        SetCVar("UnitNameNPC", 1)                       -- NPC Names: enabled (hostile, quest, interactive)
        SetCVar("nameplateShowFriendlyPets", 0)         -- Critters and companions: false
        SetCVar("nameplateShowFriends", 1)              -- Friendly players: true
        SetCVar("nameplateShowFriendlyMinions", 0)      -- Friendly minions: false
        SetCVar("UnitNameEnemyPlayerName", 1)           -- Enemy players: true
        SetCVar("nameplateShowEnemyMinions", 0)         -- Enemy minions: false
        
        -- NAMEPLATES > NAMEPLATES
        SetCVar("nameplateShowAll", 1)                  -- Always show nameplates: true
        SetCVar("nameplateShowEnemies", 1)              -- Enemy unit nameplates: true
        SetCVar("nameplateShowEnemyMinions", 1)         -- Enemy minions: true
        SetCVar("nameplateShowEnemyMinus", 0)           -- Enemy minor: false
        SetCVar("nameplateShowFriends", 1)              -- Friendly player nameplates: true
        SetCVar("nameplateShowFriendlyMinions", 0)      -- Friendly minions: false
        SetCVar("nameplateShowFriendlyNPCs", 0)         -- Friendly NPC nameplates: false
        SetCVar("nameplateOtherTopInset", 0.08)         -- Show offscreen nameplates: true
        SetCVar("nameplateGlobalScale", 2.0)            -- Size: 2
        SetCVar("nameplateLargerScale", 1.4)            -- Buff/debuff scale: 140%
        
        -- ==============================================================
        -- ACCESSIBILITY
        -- ==============================================================
        SetCVar("uiScale", 1.0)                         -- Text scale: medium (use 1.0 for medium)
        SetCVar("questTextContrast", 0)                 -- Quest text contrast: default (0 = default)
        SetCVar("ffxSpecial", 1)                        -- Enable photosensitivity mode: false (1 = effects enabled)
        SetCVar("minimumCharacterNameSize", 0)          -- Minimum character name size: 0
        SetCVar("cameraDistanceMaxZoomFactor", 2.6)     -- Motion sickness: false (default zoom)
        SetCVar("cursorSizePreferred", 3)               -- Cursor size: 64x64 (3 = large)
        SetCVar("selfHighlight", 0)                     -- Self highlight: off
        SetCVar("spellActivationOverlayOpacity", 1.0)   -- Spell alert opacity: 100%
        SetCVar("overrideArchive", 0)                   -- Arachnophobia mode: false
        
        -- ACCESSIBILITY > COLORS
        SetCVar("colorblindMode", 0)                    -- Enable UI colorblind mode: false
        SetCVar("colorblindSimulator", 0)               -- Colorblind filter: none (0 = none)
        SetCVar("colorblindWeaknessFactor", 0.5)        -- Colorblind sensitivity: 0.5 (0.0-1.0)
        
        -- ACCESSIBILITY > SUBTITLES
        SetCVar("movieSubtitle", 1)                     -- Cinematic subtitles: true
        
        -- ==============================================================
        -- SYSTEM > GRAPHICS
        -- ==============================================================
        SetCVar("gxWindow", 1)                          -- Display mode: fullscreen (windowed)
        SetCVar("gxWindowedResolution", "1920x1080")    -- Resolution: 1920x1080
        SetCVar("renderScale", 1.0)                     -- Render scale: 100%
        SetCVar("useUiScale", 0)                        -- Use UI scale: false
        SetCVar("gxVSync", 1)                           -- Vertical sync: enabled
        SetCVar("gxMaximize", 1)                        -- Low latency mode: enabled
        SetCVar("MSAAQuality", 0)                       -- Anti-aliasing: none
        SetCVar("cameraFov", 90)                        -- Camera FOV: 90
        
        -- SYSTEM > GRAPHICS > GRAPHICS QUALITY
        SetCVar("graphicsQuality", 7)                   -- Base game quality: 7
        SetCVar("cameraDistanceMaxZoomFactor", 2.6)     -- View distance: 10 (using max zoom)
        SetCVar("environmentDetail", 1)                 -- Environment detail: 1
        SetCVar("groundEffectDensity", 1)               -- Ground clutter: 1
        
        -- ==============================================================
        -- SYSTEM > AUDIO
        -- ==============================================================
        SetCVar("Sound_EnableAllSound", 1)              -- Enable sound: true
        SetCVar("Sound_MasterVolume", 0.5)              -- Master volume: 50%
        SetCVar("Sound_MusicVolume", 0)                 -- Music: 0%
        SetCVar("Sound_SFXVolume", 1.0)                 -- Effects: 100%
        SetCVar("Sound_AmbienceVolume", 0)              -- Ambience: 0%
        SetCVar("Sound_DialogVolume", 1.0)              -- Dialog: 100%
        SetCVar("Sound_EnableMusic", 0)                 -- Music: false
        SetCVar("Sound_LoopMusic", 1)                   -- Loop music: true
        SetCVar("Sound_EnablePetBattleMusic", 1)        -- Pet battle music: true
        SetCVar("Sound_EnableSFX", 1)                   -- Sound effects: true
        SetCVar("Sound_EnablePetSounds", 0)             -- Enable pet sounds: false
        SetCVar("Sound_EnableEmoteSounds", 0)           -- Emote sounds: false
        SetCVar("Sound_EnableErrorSpeech", 0)           -- Error speech: false
        SetCVar("Sound_EnableSoundWhenGameIsInBG", 1)   -- Sound in background: true
        SetCVar("Sound_EnableReverb", 0)                -- Enable reverb: false
        SetCVar("Sound_NumChannels", 64)                -- Audio channels: 64
        SetCVar("Sound_CacheSize", 3)                   -- Audio cache size: Large (128MB) - 3 = Large
        
        -- ==============================================================
        -- SYSTEM > NETWORK
        -- ==============================================================
        SetCVar("advancedCombatLogging", 1)             -- Advanced combat logging: true
    end
end

-- ===========================================================================
-- ADDITIONAL NEW SETTINGS (UI/API Implementation Required)
-- ===========================================================================

-- do
--     function addon.onPlayerEnteringWorld.UpdateAdditionalSettings(self)
--         
--         -- INTERFACE > DISPLAY
--         -- Replace player frame portraits: false
--         -- Replace my frame portrait: false
--         
--         -- INTERFACE > QUESTS
--         -- Show warband completed quests: true
--         
--         -- INTERFACE > RAID FRAMES
--         -- Bigger role debuffs: true
--         -- Center big defensives: true
--         -- Dispellable debuff indicator: dispellable by me
--         -- Dispellable debuff color: false
--         
--         -- INTERFACE > ARENA ENEMY FRAMES
--         -- Display power bar: true
--         -- Display only healer power bar: true
--         -- Display class colors: true
--         -- Display pets: false
--         -- Display health text: none
--         
--         -- COMBAT
--         -- Show silhouette when obscured: true
--         -- Press and hold casting: false
--         -- Enable action targeting: true
--         
--         -- SOCIAL
--         -- Disable chat: false
--         -- Real time chat filtering: everyone
--         -- Block neighborhood invites: true
--         -- Restrict calendar invites: true
--         -- Location visibility: friends, recent allies, and guildmates
--         -- Real ID and battletag friend requests: true
--         -- Auto accept quick join requests: true
--         
--         -- GAMEPLAY ENHANCEMENTS > COMBAT ASSISTANT
--         -- Assisted highlight: true
--         
--         -- GAMEPLAY ENHANCEMENTS > BOSS WARNINGS
--         -- Enable boss warnings: true
--         -- Enable text warnings: true
--         -- Text warning level: Critical Priority
--         -- Hide when not targeted: true
--         -- Enable boss timeline: true
--         -- Hide long countdowns: true
--         -- Hide queued countdowns: false
--         -- Hide countdowns for other roles: true
--         -- Spell support iconography: true
--         -- Spell support icon types: Healer Alerts, Dispellable, Deadly
--         
--         -- GAMEPLAY ENHANCEMENTS > COOLDOWN MANAGER
--         -- Enable cooldown manager: true
--         
--         -- GAMEPLAY ENHANCEMENTS > EXTERNAL DEFENSIVES
--         -- Enable external defensives: false
--         
--         -- GAMEPLAY ENHANCEMENTS > DAMAGE METER
--         -- Damage meter: true
--         
--         -- GAMEPLAY ENHANCEMENTS > DIMINISHING RETURNS
--         -- Diminishing returns tracking: true
--         -- Only castable by me: true
--         
--         -- NAMEPLATES
--         -- Style: legacy red
--         -- Nameplate information: rarity icon
--         -- Cast bar information: spell name, spell icon, highlight important casts
--         -- Aggro display: progressive
--         -- Enemy NPC buffs/debuffs: mob buffs, shared cc
--         -- Enemy player buffs/debuffs: enemy buffs, big debuff
--         -- Friendly player buffs/debuffs: personal buffs, big debuff
--         -- Default padding: 0
--         -- Simplify nameplates: minor, minion
--         
--         -- ACCESSIBILITY
--         -- Show move pad: false
--         -- Show target tooltip: false
--         -- Interact key icons: npcs only
--         
--         -- ACCESSIBILITY > AUDIO ASSIST
--         -- Transcribe voice chat: false
--         -- Read chat text out loud: false
--         -- Speak for me in voice chat: false
--         -- Enable combat audio alerts: false
--         
--         -- ACCESSIBILITY > MOUNTS (Skyriding)
--         -- Motion sickness: default
--         -- Skyriding screen effects: true
--         -- Skyriding speed effects: true
--         -- Pitch control: default
--         -- Debounce pitch control: false
--         
--         -- ACCESSIBILITY > SUBTITLES
--         -- Subtitles background: dark
--         -- Subtitles background opacity: 70%
--         
--         -- SYSTEM > AUDIO
--         -- Boss warning sounds: true
--         
--         -- SYSTEM > NETWORK
--         -- Optimize network for speed: true
--         -- Enable IPv6 when available: false
--     end
-- end

-- ===========================================================================
-- UPDATE WOW KEY BINDINGS
-- ===========================================================================
-- NOTE: Keybindings require SetBinding() API, not CVars
-- Format: SetBinding("KEY", "COMMAND")
-- IMPORTANT: If a keybinding is NOT listed below but exists in WoW's
-- Options interface panel under the designated category, it should be
-- CLEARED/REMOVED using ClearBinding() or SetBinding("KEY", nil)
-- ===========================================================================

-- do
--     function addon.onPlayerEnteringWorld.UpdateKeybindings(self)
--         print("Configuring keybindings...")
--         
--         -- Clear all existing bindings first to ensure clean state
--         -- This handles the requirement to remove unlisted bindings
--         
--         -- ==============================================================
--         -- MOVEMENT KEYS
--         -- ==============================================================
--         SetBinding("E", "MOVEFORWARD")
--         SetBinding("D", "MOVEBACKWARD")
--         SetBinding("S", "STRAFELEFT")
--         SetBinding("F", "STRAFERIGHT")
--         SetBinding("SPACE", "JUMP")
--         SetBinding("\\", "TOGGLESHEATH")
--         SetBinding("SHIFT-BUTTON3", "TOGGLEAUTORUN")     -- Middle Mouse
--         SetBinding("HOME", "TOGGLERUN")
--         
--         -- ==============================================================
--         -- INTERFACE PANEL
--         -- ==============================================================
--         SetBinding("ESCAPE", "TOGGLEGAMEMENU")
--         SetBinding("F1", "OPENALLBAGS")
--         SetBinding("F2", "TOGGLECHARACTER0")
--         SetBinding("F3", "TOGGLESPELLBOOK")
--         SetBinding("F9", "TOGGLEACHIEVEMENT")
--         SetBinding("M", "TOGGLEWORLDMAP")
--         SetBinding("SHIFT-M", "TOGGLEBATTLEFIELDMINIMAP")
--         SetBinding("N", "TOGGLEPVPSCOREBOARDORTAB")
--         SetBinding("F6", "TOGGLEGUILDTAB")
--         SetBinding("F7", "TOGGLESOCIAL")
--         SetBinding("U", "TOGGLEGROUPFINDER")
--         SetBinding("F5", "TOGGLECOLLECTIONS")
--         SetBinding("SHIFT-F9", "TOGGLEENCOUNTERJOURNAL")
--         
--         -- ==============================================================
--         -- ACTION BAR 1
--         -- ==============================================================
--         SetBinding("2", "ACTIONBUTTON1")
--         SetBinding("3", "ACTIONBUTTON2")
--         SetBinding("4", "ACTIONBUTTON3")
--         SetBinding("5", "ACTIONBUTTON4")
--         SetBinding("SHIFT-W", "ACTIONBUTTON5")
--         SetBinding("SHIFT-R", "ACTIONBUTTON6")
--         SetBinding("SHIFT-T", "ACTIONBUTTON7")
--         SetBinding("SHIFT-G", "ACTIONBUTTON8")
--         
--         -- ==============================================================
--         -- ACTION BAR 2
--         -- ==============================================================
--         SetBinding("X", "MULTIACTIONBAR1BUTTON1")
--         SetBinding("C", "MULTIACTIONBAR1BUTTON2")
--         SetBinding("V", "MULTIACTIONBAR1BUTTON3")
--         SetBinding("SHIFT-V", "MULTIACTIONBAR1BUTTON4")
--         SetBinding("PAGEDOWN", "MULTIACTIONBAR1BUTTON5")
--         SetBinding("MOUSEWHEELDOWN", "MULTIACTIONBAR1BUTTON6")
--         SetBinding("W", "MULTIACTIONBAR1BUTTON7")
--         SetBinding("R", "MULTIACTIONBAR1BUTTON8")
--         SetBinding("T", "MULTIACTIONBAR1BUTTON9")
--         SetBinding("G", "MULTIACTIONBAR1BUTTON10")
--         SetBinding("PAGEUP", "MULTIACTIONBAR1BUTTON11")
--         SetBinding("MOUSEWHEELUP", "MULTIACTIONBAR1BUTTON12")
--         
--         -- ==============================================================
--         -- ACTION BAR 3
--         -- ==============================================================
--         -- Note: Only buttons 5-12 are bound, others left unbound
--         SetBinding("SHIFT-PAGEDOWN", "MULTIACTIONBAR2BUTTON5")
--         SetBinding("SHIFT-MOUSEWHEELDOWN", "MULTIACTIONBAR2BUTTON6")
--         SetBinding("BUTTON3", "MULTIACTIONBAR2BUTTON7")    -- Middle Mouse
--         SetBinding("`", "MULTIACTIONBAR2BUTTON8")
--         SetBinding("P", "MULTIACTIONBAR2BUTTON9")
--         SetBinding("SHIFT-PAGEUP", "MULTIACTIONBAR2BUTTON11")
--         SetBinding("SHIFT-MOUSEWHEELUP", "MULTIACTIONBAR2BUTTON12")
--         
--         -- ==============================================================
--         -- ACTION BAR 4
--         -- ==============================================================
--         SetBinding("Z", "MULTIACTIONBAR3BUTTON1")
--         SetBinding("B", "MULTIACTIONBAR3BUTTON2")
--         SetBinding("L", "MULTIACTIONBAR3BUTTON3")
--         SetBinding("A", "MULTIACTIONBAR3BUTTON4")
--         SetBinding("H", "MULTIACTIONBAR3BUTTON5")
--         SetBinding("K", "MULTIACTIONBAR3BUTTON6")
--         SetBinding("Q", "MULTIACTIONBAR3BUTTON7")
--         SetBinding("Y", "MULTIACTIONBAR3BUTTON8")
--         SetBinding("J", "MULTIACTIONBAR3BUTTON9")
--         
--         -- ==============================================================
--         -- CHAT
--         -- ==============================================================
--         SetBinding("ENTER", "OPENCHAT")
--         SetBinding("/", "OPENCHATSLASH")
--         
--         -- ==============================================================
--         -- TARGETING
--         -- ==============================================================
--         SetBinding("TAB", "TARGETNEARESTENEMY")
--         SetBinding("F10", "NAMEPLATES")
--         
--         -- ==============================================================
--         -- CAMERA
--         -- ==============================================================
--         SetBinding("CTRL-MOUSEWHEELUP", "CAMERAZOOMIN")
--         SetBinding("CTRL-MOUSEWHEELDOWN", "CAMERAZOOMOUT")
--         
--         -- ==============================================================
--         -- MISCELLANEOUS
--         -- ==============================================================
--         SetBinding("F11", "TOGGLEUI")
--         
--         -- ==============================================================
--         -- CONTROLS
--         -- ==============================================================
--         -- interact with target keybind: End
--         SetBinding("END", "INTERACTTARGET")
--         
--         -- Save bindings to account
--         SaveBindings(GetCurrentBindingSet())
--         
--         print("Keybindings configured successfully.")
--         print("NOTE: Loot key and Focus cast key are set to 'none' (no binding).")
--     end
-- end


-- ===========================================================================
-- FRAME HIDING: TOTEM FRAME
-- ===========================================================================

do
    function addon.onPlayerEnteringWorld.HideTotemFrame(self)
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
    function addon.onPlayerEnteringWorld.HideQuickJoinToastButton(self)
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
    function addon.onPlayerEnteringWorld.HideChatFrameChannelButton(self)
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
    function addon.onPlayerEnteringWorld.SetCVars(self)
        SetCVar("mapFade", 0)
    end
end

-- ===========================================================================
-- BATTLEFIELD MAP CUSTOMIZATION
-- ===========================================================================

do
    function addon.onPlayerEnteringWorld.CustomizeBattlefieldMap(self)
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
                    self:addBorder(mapFrame.ScrollContainer.SAdUI_BorderFrame)
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
                self:addBorder(mapFrame.ScrollContainer.SAdUI_BorderFrame)
            end
        end
    end
    
    function addon.onPlayerEnteringWorld.ScaleZoneMap(self)
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
    function addon.onPlayerEnteringWorld.CustomizeMinimap(self)
        local minimapWidth = 248
        local minimapHeight = 248
        
        if Minimap then
            Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
            Minimap:SetSize(minimapWidth, minimapHeight)
            self:addBorder(Minimap)
            
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
    
    function addon.onPlayerEnteringWorld.CreateInfoBox(self)
        -- InfoBox configuration constants
        local INFOBOX_FONT_SIZE = 12
        local INFOBOX_LINE_HEIGHT = 18
        local DIVIDER_HEIGHT = 10

        function self:fontChanged(fontPath)
            if not self.SAdUI_InfoBox then
                return
            end
            
            local fontStrings = {
                self.SAdUI_InfoBox.ilvl,
                self.SAdUI_InfoBox.gold,
                self.SAdUI_InfoBox.conquest,
                self.SAdUI_InfoBox.honor,
                self.SAdUI_InfoBox.speed,
                self.SAdUI_InfoBox.durability,
                self.SAdUI_InfoBox.vers,
                self.SAdUI_InfoBox.haste,
                self.SAdUI_InfoBox.mastery,
                self.SAdUI_InfoBox.fps,
                self.SAdUI_InfoBox.ping
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

        if self.SAdUI_InfoBox then return end
        
        local infoBox = CreateFrame("Frame", nil, UIParent)
        infoBox:SetSize(125, 248)
        infoBox:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
        
        local bg = infoBox:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(infoBox)
        bg:SetColorTexture(0, 0, 0, 0.6)
        
        -- Create text elements
        local yOffset = -10
        
        -- Get the saved font preference or use default
        local selectedFont = self.savedVars.markerStyle.font or "Interface/AddOns/SAdUI/Media/Fonts/FiraMonoMedium.ttf"
        
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
        
        self.SAdUI_InfoBox = infoBox
        
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
    function addon.onPlayerEnteringWorld.CustomizeClock(self)
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
    function addon.onPlayerEnteringWorld.unclampChatFrames(self)
        for i = 1, NUM_CHAT_WINDOWS do
            local chatFrame = _G["ChatFrame" .. i]
            if chatFrame then
                chatFrame:SetClampedToScreen(false)
            end
        end
    end
    
    function addon.onPlayerEnteringWorld.repositionChatEditBox(self)
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
    
    function addon.onPlayerEnteringWorld.addBuffIconGlow(self)
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
        
        self:RegisterEvent("UNIT_AURA", OnUnitAura)
    end
end

-- ===========================================================================
-- Hide Compact Raid Frame Manager
-- ===========================================================================

do
    function addon.onPlayerEnteringWorld.CompactRaidFrameManagerVisibility(self)
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
    function addon.onPlayerEnteringWorld.HideArenaFramePortraits(self)
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
                
                -- Hook the frame's Show method to ensure portraits stay hidden
                if not arenaFrame.SAdUI_PortraitHooked then
                    hooksecurefunc(arenaFrame, "Show", function(self)
                        HidePortrait(self)
                    end)
                    arenaFrame.SAdUI_PortraitHooked = true
                end
            end
        end
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




-- "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
-- "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_WHISPER_INFORM",
-- "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", 
-- "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING",
-- "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
-- "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
-- "CHAT_MSG_CHANNEL", "CHAT_MSG_CHANNEL_JOIN", "CHAT_MSG_CHANNEL_LEAVE",
-- "CHAT_MSG_BN_CONVERSATION",
-- "CHAT_MSG_COMMUNITIES_CHANNEL",
-- "CHAT_MSG_AFK", "CHAT_MSG_DND",
-- "CHAT_MSG_MONSTER_SAY", "CHAT_MSG_MONSTER_YELL", "CHAT_MSG_MONSTER_EMOTE", "CHAT_MSG_MONSTER_WHISPER"

-- function addon:SetChatMessageFilter(chatEvent, allowChat)
--     if not addon.activeChatFilters[chatEvent] then
--         local filterFunc = self:CreateChatFilter(chatEvent)
--         ChatFrame_AddMessageEventFilter(chatEvent, filterFunc)
--         addon.activeChatFilters[chatEvent] = filterFunc
--         addon:Debug(string.format("Added filter for %s", chatEvent))
--     end
-- end

-- function addon:CreateChatFilter(chatEvent)
--     return function(self, event, message, sender, ...)
--         addon:Debug(string.format("Filtered %s from %s", chatEvent, sender))
--         return true
--     end
-- end



-- ===========================================================================
-- SHARED FUNCTIONS
-- ===========================================================================

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
