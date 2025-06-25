-- Headsup: Displays important buffs in the middle of the screen
-- Compatible with WotLK 3.3.5a
-- Initialize addon namespace
Headsup = {}
local addon = Headsup

-- Spell IDs to track (you can modify this list)
-- Make this accessible globally for GUI management
TRACKED_SPELLS = {
    -- Death Knight
    [51124] = true, -- Killing Machine
    [59052] = true, -- Rime (Freezing Fog)
    [53386] = true, -- Cinderglacier (Runeforge)
    [66803] = true, -- Desolation
    [67383] = true, -- Unholy Force
    [53365] = true, -- Unholy strength

    -- Druid
    [48517] = true, -- Eclipse (Solar)
    [48518] = true, -- Eclipse (Lunar)
    [16886] = true, -- Nature's Grace
    [69369] = true, -- Predator's Swiftness
    [16870] = true, -- Omen of Clarity
    [48391] = true, -- Owlkin Frenzy
    [46833] = true, -- Wrath of Elune (PvP Set Bonus)
    [64823] = true, -- Elune's Wrath (Tier 8 Set Bonus)

    -- Hunter
    [53220] = true, -- Improved Steady Shot
    [56453] = true, -- Lock and Load
    [35098] = true, -- Rapid Killing
    [35099] = true, -- Rapid Killing

    -- Mage
    [12536] = true, -- Arcane Concentration (Clearcasting)
    [31643] = true, -- Blazing Speed
    [57761] = true, -- Brain Freeze
    [44544] = true, -- Fingers of Frost
    [74396] = true, -- Fingers of Frost
    [44543] = true, -- Fingers of Frost
    [44545] = true, -- Fingers of Frost
    [54741] = true, -- Firestarter
    [48108] = true, -- Hot Streak
    [64343] = true, -- Impact
    [44401] = true, -- Missile Barrage

    -- Paladin
    [53489] = true, -- Art of War
    [59578] = true, -- Art of War
    [53672] = true, -- Infusion of Light
    [54149] = true, -- Infusion of Light
    [31834] = true, -- Light's Grace
    [58597] = true, -- Sacred Shield

    -- Priest
    [59887] = true, -- Borrowed Time
    [59888] = true, -- Borrowed Time
    [59889] = true, -- Borrowed Time
    [59890] = true, -- Borrowed Time
    [59891] = true, -- Borrowed Time
    [34754] = true, -- Holy Concentration
    [63724] = true, -- Holy Concentration
    [63725] = true, -- Holy Concentration
    [14743] = true, -- Martyrdom
    [27828] = true, -- Martyrdom
    [63731] = true, -- Serendipity
    [63734] = true, -- Serendipity
    [63735] = true, -- Serendipity
    [33151] = true, -- Surge of Light

    -- Shaman
    [16246] = true, -- Elemental Focus
    [53817] = true, -- Maelstrom Weapon (Fifth stack)
    [53390] = true, -- Tidal Waves

    -- Warlock
    [54274] = true, -- Backdraft
    [54276] = true, -- Backdraft
    [54277] = true, -- Backdraft
    [34936] = true, -- Backlash
    [63165] = true, -- Decimation
    [63167] = true, -- Decimation
    [47283] = true, -- Empowered Imp
    [64368] = true, -- Eradication
    [64370] = true, -- Eradication
    [64371] = true, -- Eradication
    [47383] = true, -- Molten Core
    [71162] = true, -- Molten Core
    [71165] = true, -- Molten Core
    [17941] = true, -- Nightfall
    [18093] = true, -- Pyroclasm
    [63243] = true, -- Pyroclasm
    [63244] = true, -- Pyroclasm
    [63321] = true, -- Glyph of Life Tap

    -- Warrior
    [46916] = true, -- Bloodsurge
    [52437] = true, -- Sudden Death
    [50227] = true, -- Sword and Board
    [60503] = true, -- Taste for Blood
    [58363] = true, -- Glyph of Revenge

    -- Other/Trinkets
    [37706] = true, -- Healing Trance
    [37721] = true, -- Healing Trance
    [37722] = true, -- Healing Trance
    [37723] = true, -- Healing Trance
    [60512] = true, -- Healing Trance
    [60513] = true, -- Healing Trance
    [60514] = true, -- Healing Trance
    [60515] = true, -- Healing Trance
    [33370] = true, -- Quagmirran's Eye (Spell Haste)
    [71396] = true, -- Rage of the Fallen
    [72412] = true, -- Frostforged Champion
    [67708] = true, -- Death's Choice Normal
    [67773] = true, -- Death's Choice Heroic (Paragon)
    [75456] = true, -- Mark of the Fallen Champion
    [71905] = true, -- Soul Fragment (Shadowmourne)
    [73422] = true, -- Chaos Bane (Shadowmourne)
    [71561] = true, -- Strength of the Taunka (Deathbringer's Will Heroic)
    [71560] = true, -- Speed of the Vrykul (Deathbringer's Will Heroic)
    [71559] = true, -- Aim of the Iron Dwarves (Deathbringer's Will Heroic)
    [71486] = true, -- Power of the Taunka (Deathbringer's Will Normal)
    [71558] = true, -- Power of the Taunka (Deathbringer's Will Heroic)
}

-- Default settings
local defaults = {
    enabled = true,
    iconSize = 26,
    spacing = 4,
    yOffset = -50,
    showSpellName = false,
    timerFontSize = 12,
    spellNameFontSize = 9,
    customSpells = {}, -- Store custom added spells
    removedSpells = {}, -- Store removed default spells
    enableSound = false, -- Enable/disable sound on spell application
    soundChoice = "Sound\\Spells\\ShaysBell.wav", -- Default sound to play
    -- Flash effect settings
    enableFlashEffect = true, -- Enable flash effect when buffs are about to expire
    flashThreshold = 3, -- Start flashing when buff has X seconds left
    flashSpeed = 0.5 -- Flash interval in seconds
}

-- Active buffs table
local activeBuffs = {}

-- Saved variables
HeadsupDB = HeadsupDB or {}

-- Function to check if a spell is tracked (considering custom additions/removals)
function IsSpellTracked(spellID)
    -- If it's in removed spells, don't track it
    if HeadsupDB.removedSpells and HeadsupDB.removedSpells[spellID] then
        return false
    end

    -- Check if it's in default spells or custom spells
    return TRACKED_SPELLS[spellID] or (HeadsupDB.customSpells and HeadsupDB.customSpells[spellID])
end

-- Function to get all currently tracked spells
function GetAllTrackedSpells()
    local allSpells = {}

    -- Add default spells that aren't removed
    for spellID in pairs(TRACKED_SPELLS) do
        if not HeadsupDB.removedSpells or not HeadsupDB.removedSpells[spellID] then
            allSpells[spellID] = true
        end
    end

    -- Add custom spells
    if HeadsupDB.customSpells then
        for spellID in pairs(HeadsupDB.customSpells) do
            allSpells[spellID] = true
        end
    end

    return allSpells
end

-- Position all active frames
function PositionFrames()
    local activeFrames = {}

    -- Collect all visible frames
    for spellID, buffData in pairs(activeBuffs) do
        if buffData.frame and buffData.frame:IsShown() then
            table.insert(activeFrames, buffData.frame)
        end
    end

    -- Position frames horizontally
    local totalWidth = #activeFrames * HeadsupDB.iconSize + (#activeFrames - 1) * HeadsupDB.spacing
    local startX = -totalWidth / 2 + HeadsupDB.iconSize / 2

    for i, frame in ipairs(activeFrames) do
        local x = startX + (i - 1) * (HeadsupDB.iconSize + HeadsupDB.spacing)
        frame:SetPoint("CENTER", mainFrame, "CENTER", x, 0)
    end
end

-- Update frame sizes for all active frames (moved up to fix nil value error)
function UpdateFrameSizes()
    for spellID, buffData in pairs(activeBuffs) do
        if buffData.frame then
            buffData.frame:SetWidth(HeadsupDB.iconSize)
            buffData.frame:SetHeight(HeadsupDB.iconSize)
        end
    end
    PositionFrames()
end

-- Update main frame position
function UpdateMainFramePosition()
    if mainFrame then
        mainFrame:ClearAllPoints()
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, HeadsupDB.yOffset)
    end
end

-- Update font sizes for all active frames
function UpdateFontSizes()
    for spellID, buffData in pairs(activeBuffs) do
        if buffData.frame then
            if buffData.frame.timer then
                buffData.frame.timer:SetFont("Fonts\\FRIZQT__.TTF", HeadsupDB.timerFontSize, "OUTLINE")
            end
            if buffData.frame.spellName then
                buffData.frame.spellName:SetFont("Fonts\\FRIZQT__.TTF", HeadsupDB.spellNameFontSize, "OUTLINE")
            end
            if buffData.frame.stackCount then
                buffData.frame.stackCount:SetFont("Fonts\\FRIZQT__.TTF", HeadsupDB.timerFontSize, "OUTLINE")
            end
        end
    end
end

-- Update spell name visibility for all active frames
function UpdateSpellNameVisibility()
    for spellID, buffData in pairs(activeBuffs) do
        if buffData.frame and buffData.frame.spellName then
            if HeadsupDB.showSpellName then
                buffData.frame.spellName:Show()
            else
                buffData.frame.spellName:Hide()
            end
        end
    end
end

-- Main frame (make it global so GUI can access it)
mainFrame = CreateFrame("Frame", "HeadsupMainFrame", UIParent)

-- Event frame
local eventFrame = CreateFrame("Frame")

-- Create display frame for a spell
local function CreateSpellFrame(spellID)
    local frameName = "HeadsupFrame_" .. spellID
    local frame = CreateFrame("Frame", frameName, mainFrame)

    frame:SetWidth(HeadsupDB.iconSize)
    frame:SetHeight(HeadsupDB.iconSize) -- Square frame
    frame:SetFrameStrata("HIGH")

    -- Get spell icon using GetSpellInfo like EventAlert does
    local spellName, _, spellIcon = GetSpellInfo(spellID)

    -- Create texture for the icon instead of backdrop for better scaling
    frame.icon = frame:CreateTexture(nil, "BACKGROUND")
    frame.icon:SetAllPoints(frame)
    if spellIcon then
        frame.icon:SetTexture(spellIcon)
    end
    
    -- Initialize animation variables
    frame.flashStartTime = nil
    frame.lastFlashState = false
    frame.originalAlpha = 1.0

    -- Timer text
    frame.timer = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.timer:SetPoint("TOP", frame, "TOP", 0, 10)
    frame.timer:SetTextColor(1, 1, 0) -- Yellow
    frame.timer:SetFont("Fonts\\FRIZQT__.TTF", HeadsupDB.timerFontSize, "OUTLINE")

    -- Stack count text (bottom-right corner)
    frame.stackCount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.stackCount:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
    frame.stackCount:SetTextColor(1, 1, 1) -- White
    frame.stackCount:SetFont("Fonts\\FRIZQT__.TTF", HeadsupDB.timerFontSize, "OUTLINE")
    frame.stackCount:Hide() -- Hidden by default, shown only when stacks > 1

    -- Spell name text (configurable)
    frame.spellName = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.spellName:SetPoint("TOP", frame, "BOTTOM", 0, -1)
    frame.spellName:SetTextColor(1, 1, 1) -- White
    frame.spellName:SetFont("Fonts\\FRIZQT__.TTF", HeadsupDB.spellNameFontSize, "OUTLINE")

    if spellName then
        frame.spellName:SetText(spellName)
    end

    -- Show/hide spell name based on setting
    if HeadsupDB.showSpellName then
        frame.spellName:Show()
    else
        frame.spellName:Hide()
    end

    frame:Hide()
    return frame
end

-- Update timer display and handle fade/flash effects
local function UpdateTimer(frame, timeLeft)
    if timeLeft > 60 then
        frame.timer:SetText(string.format("%.0fm", timeLeft / 60))
    elseif timeLeft > 0 then
        frame.timer:SetText(string.format("%.1f", timeLeft))
    else
        frame.timer:SetText("")
    end
    
    -- Reset alpha to full opacity
    frame:SetAlpha(1.0)
    
    -- Handle flash effect
    if HeadsupDB.enableFlashEffect and timeLeft <= HeadsupDB.flashThreshold then
        if not frame.flashStartTime then
            frame.flashStartTime = GetTime()
        end
        
        local currentTime = GetTime()
        local flashCycle = math.fmod(currentTime - frame.flashStartTime, HeadsupDB.flashSpeed * 2)
        local shouldFlash = flashCycle < HeadsupDB.flashSpeed
        
        if shouldFlash ~= frame.lastFlashState then
            frame.lastFlashState = shouldFlash
            if shouldFlash then
                -- Flash on - make it more visible
                frame.icon:SetVertexColor(1.5, 1.5, 1.5) -- Brighten the icon
                frame.timer:SetTextColor(1, 0.2, 0.2) -- Red timer text
            else
                -- Flash off - normal appearance
                frame.icon:SetVertexColor(1, 1, 1) -- Normal icon color
                frame.timer:SetTextColor(1, 1, 0) -- Yellow timer text
            end
        end
    else
        -- Reset flash effect
        frame.flashStartTime = nil
        frame.lastFlashState = false
        frame.icon:SetVertexColor(1, 1, 1) -- Normal icon color
        frame.timer:SetTextColor(1, 1, 0) -- Yellow timer text
    end
end

-- Scan existing buffs on player
local function ScanExistingBuffs()
    local index = 1
    while true do
        local name, _, _, count, _, _, expirationTime, _, _, _, spellID = UnitAura("player", index, "HELPFUL")

        if not name then
            break -- No more buffs
        end

        if spellID and IsSpellTracked(spellID) then
            local buffData = activeBuffs[spellID] or {}

            -- Create frame if it doesn't exist
            if not buffData.frame then
                buffData.frame = CreateSpellFrame(spellID)
            end

            -- Set the real expiration time and stack count
            buffData.expireTime = expirationTime or (GetTime() + 30)
            buffData.stackCount = count or 1
            
            -- Update stack count display
            if buffData.stackCount > 1 then
                buffData.frame.stackCount:SetText(buffData.stackCount)
                buffData.frame.stackCount:Show()
            else
                buffData.frame.stackCount:Hide()
            end
            
            buffData.frame:Show()
            activeBuffs[spellID] = buffData
        end

        index = index + 1
    end

    -- Position all found buffs
    if next(activeBuffs) then
        PositionFrames()
    end
end

-- Initialize function
function addon:Initialize()
    -- Merge defaults with saved variables
    for key, value in pairs(defaults) do
        if HeadsupDB[key] == nil then
            HeadsupDB[key] = value
        end
    end

    -- Setup main frame (moved to bottom as requested)
    mainFrame:SetWidth(400)
    mainFrame:SetHeight(100)
    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, HeadsupDB.yOffset)
    mainFrame:SetFrameStrata("MEDIUM")

    -- Check for existing buffs on the player
    ScanExistingBuffs()

    print("Headsup: Loaded and ready to track buffs!")
end

-- Show buff
function ShowBuff(spellID, duration)
    if not IsSpellTracked(spellID) then
        return
    end

    -- Check if this is a new buff (not currently active)
    local isNewBuff = not activeBuffs[spellID] or not activeBuffs[spellID].frame or
                          not activeBuffs[spellID].frame:IsShown()

    local buffData = activeBuffs[spellID] or {}

    -- Create frame if it doesn't exist
    if not buffData.frame then
        buffData.frame = CreateSpellFrame(spellID)
    end

    -- Always get fresh buff duration and stack count from UnitAura (handles refreshes)
    local spellName = GetSpellInfo(spellID)
    local newExpirationTime = nil
    local stackCount = 1

    if spellName then
        local _, _, _, count, _, _, expirationTime = UnitAura("player", spellName)
        if expirationTime then
            newExpirationTime = expirationTime
        end
        if count then
            stackCount = count
        end
    end

    -- Update expiration time and stack count (always, even for existing buffs)
    if newExpirationTime then
        buffData.expireTime = newExpirationTime
    else
        -- Fallback if we can't get the real time
        buffData.expireTime = GetTime() + (duration or 30)
    end
    
    buffData.stackCount = stackCount
    
    -- Update stack count display
    if buffData.stackCount > 1 then
        buffData.frame.stackCount:SetText(buffData.stackCount)
        buffData.frame.stackCount:Show()
    else
        buffData.frame.stackCount:Hide()
    end

    -- Show the frame and update position
    buffData.frame:Show()
    activeBuffs[spellID] = buffData
    PositionFrames()

    -- Play sound only for newly applied buffs (not refreshes)
    if isNewBuff and HeadsupDB.enableSound and HeadsupDB.soundChoice then
        PlaySoundFile(HeadsupDB.soundChoice)
    end
end

-- Hide buff
function HideBuff(spellID)
    local buffData = activeBuffs[spellID]
    if buffData and buffData.frame then
        buffData.frame:Hide()
        activeBuffs[spellID] = nil
        PositionFrames()
    end
end

-- Update all timers
local function UpdateAllTimers()
    local currentTime = GetTime()

    for spellID, buffData in pairs(activeBuffs) do
        if buffData.expireTime then
            local timeLeft = buffData.expireTime - currentTime

            if timeLeft <= 0 then
                HideBuff(spellID)
            else
                UpdateTimer(buffData.frame, timeLeft)
            end
        end
    end
end

-- Event handlers
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "Headsup" then
            addon:Initialize()
            eventFrame:UnregisterEvent("ADDON_LOADED")
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local eventType = arg2

        if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_APPLIED_DOSE" or eventType ==
            "SPELL_AURA_REFRESH" then
            -- arg7 = destName (target), arg9 = spellID
            if arg7 == UnitName("player") then
                if IsSpellTracked(arg9) then
                    -- Always refresh the buff timer when reapplied
                    ShowBuff(arg9, 300) -- 5 minute default
                end
            end

        elseif eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_REMOVED_DOSE" then
            -- arg7 = destName (target), arg9 = spellID
            if arg7 == UnitName("player") then
                if IsSpellTracked(arg9) then
                    HideBuff(arg9)
                end
            end
        end
    end
end

-- Update timer
local function OnUpdate(self, elapsed)
    UpdateAllTimers()
end

-- Register events
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:SetScript("OnEvent", OnEvent)

-- Start timer updates
local timerFrame = CreateFrame("Frame")
timerFrame:SetScript("OnUpdate", OnUpdate)

-- Slash commands
SLASH_HEADSUP1 = "/headsup"
SLASH_HEADSUP2 = "/hu"
SlashCmdList["HEADSUP"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = string.lower(cmd or "")

    if cmd == "config" or cmd == "gui" then
        -- Open configuration interface
        if addon.optionsFrame then
            InterfaceOptionsFrame_OpenToCategory(addon.optionsFrame)
        else
            print("Headsup: Configuration interface not available. Make sure AceConfig is loaded.")
        end
    elseif cmd == "test" then
        -- Test with Arcane Concentration
        ShowBuff(12536, 15)
        ShowBuff(48108, 20)
        print("Headsup: Test buff displayed")
    elseif cmd == "teststack" then
        -- Test stack count display with mock data
        local testSpellID = 12536 -- Arcane Concentration
        local buffData = activeBuffs[testSpellID] or {}
        
        if not buffData.frame then
            buffData.frame = CreateSpellFrame(testSpellID)
        end
        
        -- Mock stack count for testing
        buffData.stackCount = 5
        buffData.expireTime = GetTime() + 30
        
        -- Update stack count display
        buffData.frame.stackCount:SetText(buffData.stackCount)
        buffData.frame.stackCount:Show()
        
        buffData.frame:Show()
        activeBuffs[testSpellID] = buffData
        PositionFrames()
        
        print("Headsup: Test buff with 5 stacks displayed")

    elseif cmd == "testflash" then
        -- Test flash effect with a very short duration buff
        local testSpellID = 48108 -- Hot Streak
        local buffData = activeBuffs[testSpellID] or {}
        
        if not buffData.frame then
            buffData.frame = CreateSpellFrame(testSpellID)
        end
        
        -- Set expiration time to trigger flash effect
        buffData.expireTime = GetTime() + HeadsupDB.flashThreshold
        buffData.stackCount = 1
        
        buffData.frame:Show()
        activeBuffs[testSpellID] = buffData
        PositionFrames()
        
        print("Headsup: Test flash effect displayed (" .. HeadsupDB.flashThreshold .. " seconds)")
    elseif cmd == "clear" then
        for spellID in pairs(activeBuffs) do
            HideBuff(spellID)
        end
        print("Headsup: All buffs cleared")
    elseif cmd == "toggle" then
        HeadsupDB.enabled = not HeadsupDB.enabled
        if HeadsupDB.enabled then
            mainFrame:Show()
            print("Headsup: Enabled")
        else
            mainFrame:Hide()
            print("Headsup: Disabled")
        end
    elseif cmd == "size" or cmd == "iconsize" then
        local size = tonumber(arg)
        if size and size >= 8 and size <= 128 then
            HeadsupDB.iconSize = size
            UpdateFrameSizes()
            print("Headsup: Icon size set to " .. size)
        else
            print("Headsup: Current icon size is " .. HeadsupDB.iconSize)
            print("Usage: /headsup size <number> (8-128)")
        end
    elseif cmd == "spacing" then
        local spacing = tonumber(arg)
        if spacing and spacing >= 0 and spacing <= 50 then
            HeadsupDB.spacing = spacing
            PositionFrames()
            print("Headsup: Spacing set to " .. spacing)
        else
            print("Headsup: Current spacing is " .. HeadsupDB.spacing)
            print("Usage: /headsup spacing <number> (0-50)")
        end
    elseif cmd == "yoffset" or cmd == "offset" then
        local offset = tonumber(arg)
        if offset and offset >= -400 and offset <= 400 then
            HeadsupDB.yOffset = offset
            UpdateMainFramePosition()
            print("Headsup: Y offset set to " .. offset)
        else
            print("Headsup: Current Y offset is " .. HeadsupDB.yOffset)
            print("Usage: /headsup yoffset <number> (-400 to 400)")
        end
    elseif cmd == "spellname" or cmd == "showname" then
        HeadsupDB.showSpellName = not HeadsupDB.showSpellName
        UpdateSpellNameVisibility()
        print("Headsup: Spell names " .. (HeadsupDB.showSpellName and "enabled" or "disabled"))
    elseif cmd == "timerfont" then
        local size = tonumber(arg)
        if size and size >= 6 and size <= 24 then
            HeadsupDB.timerFontSize = size
            UpdateFontSizes()
            print("Headsup: Timer font size set to " .. size)
        else
            print("Headsup: Current timer font size is " .. HeadsupDB.timerFontSize)
            print("Usage: /headsup timerfont <number> (6-24)")
        end
    elseif cmd == "namefont" then
        local size = tonumber(arg)
        if size and size >= 6 and size <= 24 then
            HeadsupDB.spellNameFontSize = size
            UpdateFontSizes()
            print("Headsup: Spell name font size set to " .. size)
        else
            print("Headsup: Current spell name font size is " .. HeadsupDB.spellNameFontSize)
            print("Usage: /headsup namefont <number> (6-24)")
        end
    elseif cmd == "addspell" then
        local spellID = tonumber(arg)
        if spellID and spellID > 0 then
            addon:AddSpell(spellID)
        else
            print("Headsup: Usage: /headsup addspell <spellID>")
            print("Example: /headsup addspell 12345")
        end
    elseif cmd == "removespell" then
        local spellID = tonumber(arg)
        if spellID and spellID > 0 then
            addon:RemoveSpell(spellID)
        else
            print("Headsup: Usage: /headsup removespell <spellID>")
            print("Example: /headsup removespell 12345")
        end
    elseif cmd == "listspells" then
        local trackedSpells = GetAllTrackedSpells()
        local count = 0
        print("Headsup: Currently tracked spells:")

        -- Convert to sorted array
        local sortedSpells = {}
        for spellID in pairs(trackedSpells) do
            table.insert(sortedSpells, spellID)
        end
        table.sort(sortedSpells)

        for _, spellID in ipairs(sortedSpells) do
            local spellName = GetSpellInfo(spellID)
            local spellInfo = spellName or "(Unknown spell)"

            -- Add type indicator
            local typeIndicator = ""
            if HeadsupDB.customSpells and HeadsupDB.customSpells[spellID] then
                typeIndicator = " (Custom)"
            elseif TRACKED_SPELLS[spellID] then
                typeIndicator = " (Default)"
            end

            print("  " .. spellID .. " - " .. spellInfo .. typeIndicator)
            count = count + 1

            -- Limit output to prevent spam
            if count >= 20 then
                print("  ... and " .. (table.getn(sortedSpells) - 20) .. " more (use GUI for full list)")
                break
            end
        end

        if count == 0 then
            print("  No spells currently tracked")
        else
            print("Total: " .. table.getn(sortedSpells) .. " spells tracked")
        end
    elseif cmd == "resetspells" then
        HeadsupDB.customSpells = {}
        HeadsupDB.removedSpells = {}

        -- Clear any currently displayed custom buffs
        for spellID in pairs(activeBuffs) do
            if not TRACKED_SPELLS[spellID] then
                HideBuff(spellID)
            end
        end

        print("Headsup: Reset to default spell tracking")
    elseif cmd == "sound" then
        HeadsupDB.enableSound = not HeadsupDB.enableSound
        print("Headsup: Sound " .. (HeadsupDB.enableSound and "enabled" or "disabled"))
    elseif cmd == "setsound" then
        if arg and arg ~= "" then
            HeadsupDB.soundChoice = arg
            print("Headsup: Sound set to " .. arg)
        else
            print("Headsup: Current sound is " .. HeadsupDB.soundChoice)
            print("Usage: /headsup setsound <sound_file>")
            print("Available sounds: ShaysBell, Flute, Netherwind, PolyCow, Rockbiter, Yarrrr, BrokenHeart, etc.")
        end
    elseif cmd == "testsound" then
        if HeadsupDB.soundChoice then
            PlaySoundFile(HeadsupDB.soundChoice)
            print("Headsup: Playing sound " .. HeadsupDB.soundChoice)
        else
            print("Headsup: No sound selected")
        end
    elseif cmd == "flash" then
        HeadsupDB.enableFlashEffect = not HeadsupDB.enableFlashEffect
        print("Headsup: Flash effect " .. (HeadsupDB.enableFlashEffect and "enabled" or "disabled"))
    elseif cmd == "flashtime" then
        local time = tonumber(arg)
        if time and time >= 1 and time <= 30 then
            HeadsupDB.flashThreshold = time
            print("Headsup: Flash threshold set to " .. time .. " seconds")
        else
            print("Headsup: Current flash threshold is " .. HeadsupDB.flashThreshold .. " seconds")
            print("Usage: /headsup flashtime <number> (1-30)")
        end
    elseif cmd == "flashspeed" then
        local speed = tonumber(arg)
        if speed and speed >= 0.1 and speed <= 2.0 then
            HeadsupDB.flashSpeed = speed
            print("Headsup: Flash speed set to " .. speed .. " seconds")
        else
            print("Headsup: Current flash speed is " .. HeadsupDB.flashSpeed .. " seconds")
            print("Usage: /headsup flashspeed <number> (0.1-2.0)")
        end
    else
        print("Headsup commands:")
        print("/headsup config - Open configuration interface")
        print("/headsup test - Show test buff")
        print("/headsup teststack - Show test buff with stack count")

        print("/headsup testflash - Test flash effect")
        print("/headsup clear - Clear all buffs")
        print("/headsup toggle - Enable/disable addon")
        print("/headsup size <number> - Set icon size (8-128)")
        print("/headsup spacing <number> - Set icon spacing (0-50)")
        print("/headsup yoffset <number> - Set Y position offset (-400 to 400)")
        print("/headsup spellname - Toggle spell name display")
        print("/headsup timerfont <number> - Set timer font size (6-24)")
        print("/headsup namefont <number> - Set spell name font size (6-24)")
        print("/headsup addspell <spellID> - Add spell to tracking")
        print("/headsup removespell <spellID> - Remove spell from tracking")
        print("/headsup listspells - List currently tracked spells")
        print("/headsup resetspells - Reset spell tracking to defaults")
        print("/headsup sound - Toggle sound on/off")
        print("/headsup setsound <sound> - Set sound to play")
        print("/headsup testsound - Test current sound")
        print("/headsup flash - Toggle flash effect")
        print("/headsup flashtime <number> - Set flash threshold (1-30 seconds)")
        print("/headsup flashspeed <number> - Set flash speed (0.1-2.0 seconds)")
    end
end

-- Function to add/remove spells from tracking (for easy customization)
function addon:AddSpell(spellID)
    -- Initialize if needed
    if not HeadsupDB.customSpells then
        HeadsupDB.customSpells = {}
    end
    if not HeadsupDB.removedSpells then
        HeadsupDB.removedSpells = {}
    end

    -- If it was a removed default spell, restore it
    if TRACKED_SPELLS[spellID] then
        HeadsupDB.removedSpells[spellID] = nil
        print("Headsup: Restored default spell ID " .. spellID .. " to tracking")
    else
        -- Add as custom spell
        HeadsupDB.customSpells[spellID] = true
        print("Headsup: Added custom spell ID " .. spellID .. " to tracking")
    end
end

function addon:RemoveSpell(spellID)
    -- Initialize if needed
    if not HeadsupDB.customSpells then
        HeadsupDB.customSpells = {}
    end
    if not HeadsupDB.removedSpells then
        HeadsupDB.removedSpells = {}
    end

    -- If it's a default spell, mark as removed
    if TRACKED_SPELLS[spellID] then
        HeadsupDB.removedSpells[spellID] = true
        print("Headsup: Removed default spell ID " .. spellID .. " from tracking")
    else
        -- Remove from custom spells
        HeadsupDB.customSpells[spellID] = nil
        print("Headsup: Removed custom spell ID " .. spellID .. " from tracking")
    end

    -- Hide the buff if currently shown
    HideBuff(spellID)
end
