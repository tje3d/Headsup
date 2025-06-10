-- Headsup Configuration Interface
-- Compatible with WotLK 3.3.5a
-- Scroll frame for spell list
local spellListFrame = nil
local spellListScrollFrame = nil
local spellListContent = nil
local spellButtons = {}

function Headsup:LOAD_INTERFACE()
    assert(self ~= nil, "ERROR: Headsup addon must be loaded first before trying to load the interface")

    --[[ Option table ]] --
    local optionsFrameModel = {
        name = "Headsup",
        handler = Headsup,
        type = "group",
        args = {
            credits = {
                type = "description",
                name = "Headsup - Displays important buffs in the middle of the screen\nCompatible with WotLK 3.3.5a",
                fontSize = "small",
                width = "full",
                order = 0
            },
            spacer = {
                type = "description",
                name = " ",
                fontSize = "medium",
                width = "full",
                order = 1
            },
            enable = {
                type = "toggle",
                name = "Enable Addon",
                desc = "Enable or disable the Headsup addon",
                get = "IsHeadsupEnabled",
                set = "ToggleEnable",
                width = "double",
                order = 2
            },
            iconSize = {
                type = "range",
                name = "Icon Size",
                desc = "Set the size of buff icons (8-128 pixels)",
                min = 8,
                max = 128,
                step = 1,
                get = "GetIconSize",
                set = "SetIconSize",
                width = "double",
                order = 3
            },
            spacing = {
                type = "range",
                name = "Icon Spacing",
                desc = "Set the spacing between buff icons (0-50 pixels)",
                min = 0,
                max = 50,
                step = 1,
                get = "GetSpacing",
                set = "SetSpacing",
                width = "double",
                order = 4
            },
            yOffset = {
                type = "range",
                name = "Vertical Position",
                desc = "Set the vertical position offset from screen center (-400 to 400 pixels)",
                min = -400,
                max = 400,
                step = 5,
                get = "GetYOffset",
                set = "SetYOffset",
                width = "double",
                order = 5
            },
            showSpellName = {
                type = "toggle",
                name = "Show Spell Names",
                desc = "Show spell names below the buff icons",
                get = "GetShowSpellName",
                set = "SetShowSpellName",
                width = "double",
                order = 6
            },
            timerFontSize = {
                type = "range",
                name = "Timer Font Size",
                desc = "Set the font size for timer text (6-24)",
                min = 6,
                max = 24,
                step = 1,
                get = "GetTimerFontSize",
                set = "SetTimerFontSize",
                width = "double",
                order = 7
            },
            spellNameFontSize = {
                type = "range",
                name = "Spell Name Font Size",
                desc = "Set the font size for spell name text (6-24)",
                min = 6,
                max = 24,
                step = 1,
                get = "GetSpellNameFontSize",
                set = "SetSpellNameFontSize",
                width = "double",
                order = 8
            },
            testButton = {
                type = "execute",
                name = "Test Display",
                desc = "Show test buffs to preview settings",
                func = "TestDisplay",
                width = "normal",
                order = 9
            },
            clearButton = {
                type = "execute",
                name = "Clear All",
                desc = "Clear all currently displayed buffs",
                func = "ClearAllBuffs",
                width = "normal",
                order = 10
            },
            spellManagementHeader = {
                type = "header",
                name = "Spell Management",
                order = 11
            },
            addSpellInput = {
                type = "input",
                name = "Add Spell ID",
                desc = "Enter a spell ID to track (you can find spell IDs on Wowhead)",
                get = "GetAddSpellInput",
                set = "SetAddSpellInput",
                width = "normal",
                order = 12
            },
            addSpellButton = {
                type = "execute",
                name = "Add Spell",
                desc = "Add the entered spell ID to tracking",
                func = "AddSpellFromInput",
                width = "normal",
                order = 13
            },
            showSpellListButton = {
                type = "execute",
                name = "Manage Tracked Spells",
                desc = "Open an interactive window to view and remove tracked spells",
                func = "ShowSpellListFrame",
                width = "full",
                order = 14
            },
            spacer2 = {
                type = "description",
                name = " ",
                fontSize = "medium",
                width = "full",
                order = 15.5
            },
            removeSpellInput = {
                type = "input",
                name = "Remove Spell ID",
                desc = "Enter a spell ID to remove from tracking",
                get = "GetRemoveSpellInput",
                set = "SetRemoveSpellInput",
                width = "normal",
                order = 16
            },
            removeSpellButton = {
                type = "execute",
                name = "Remove Spell",
                desc = "Remove the entered spell ID from tracking",
                func = "RemoveSpellFromInput",
                width = "normal",
                order = 17
            },
            resetSpellsButton = {
                type = "execute",
                name = "Reset to Defaults",
                desc = "Reset all spell tracking to default settings (removes custom spells and restores removed defaults)",
                func = "ResetSpellsToDefault",
                width = "double",
                order = 18
            },
            soundHeader = {
                type = "header",
                name = "Sound Settings",
                order = 19
            },
            enableSound = {
                type = "toggle",
                name = "Enable Sound",
                desc = "Play a sound when a tracked spell is applied (not when refreshed)",
                get = "GetEnableSound",
                set = "SetEnableSound",
                width = "double",
                order = 20
            },
            soundChoice = {
                type = "select",
                name = "Sound to Play",
                desc = "Choose which sound to play when a tracked spell is applied",
                values = {
                    ["Sound\\Spells\\ShaysBell.wav"] = "ShaysBell",
                    ["Sound\\Spells\\FluteRun.wav"] = "Flute",
                    ["Sound\\Spells\\NetherwindFocusImpact.wav"] = "Netherwind",
                    ["Sound\\Spells\\PolyMorphCow.wav"] = "PolyCow",
                    ["Sound\\Spells\\RockBiterImpact.wav"] = "Rockbiter",
                    ["Sound\\Spells\\YarrrrImpact.wav"] = "Yarrrr!",
                    ["Sound\\Spells\\valentines_brokenheart.wav"] = "Broken Heart",
                    ["Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Ready01.wav"] = "Millhouse 1!",
                    ["Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Pyro01.wav"] = "Millhouse 2!",
                    ["Sound\\Creature\\Satyre\\SatyrePissed4.wav"] = "Pissed Satyr",
                    ["Sound\\Creature\\Mortar Team\\MortarTeamPissed9.wav"] = "Pissed Dwarf"
                },
                get = "GetSoundChoice",
                set = "SetSoundChoice",
                width = "double",
                order = 21
            },
            testSoundButton = {
                type = "execute",
                name = "Test Sound",
                desc = "Play the selected sound to test it",
                func = "TestSound",
                width = "normal",
                order = 22
            },
            visualEffectsHeader = {
                type = "header",
                name = "Visual Effects",
                order = 23
            },

            enableFlashEffect = {
                type = "toggle",
                name = "Enable Flash Effect",
                desc = "Flash buff icons when they are about to expire",
                get = "GetEnableFlashEffect",
                set = "SetEnableFlashEffect",
                width = "double",
                order = 26
            },
            flashThreshold = {
                type = "range",
                name = "Flash Threshold",
                desc = "Start flashing when buff has this many seconds left (1-30)",
                min = 1,
                max = 30,
                step = 1,
                get = "GetFlashThreshold",
                set = "SetFlashThreshold",
                width = "double",
                order = 27
            },
            flashSpeed = {
                type = "range",
                name = "Flash Speed",
                desc = "How fast the flash effect cycles (0.1-2.0 seconds)",
                min = 0.1,
                max = 2.0,
                step = 0.1,
                get = "GetFlashSpeed",
                set = "SetFlashSpeed",
                width = "double",
                order = 28
            },

            testFlashButton = {
                type = "execute",
                name = "Test Flash Effect",
                desc = "Show a test buff with flash effect",
                func = "TestFlashEffect",
                width = "normal",
                order = 30
            }
        }
    }

    -- Loading Config Frame
    if LibStub then
        LibStub("AceConfig-3.0"):RegisterOptionsTable("Headsup", optionsFrameModel)
        self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Headsup")

        -- Store the options frame model for dynamic updates
        self.optionsFrameModel = optionsFrameModel

        -- Create the spell list frame
        self:CreateSpellListFrame()

        -- Initialize the spell list
        self:RefreshSpellsList()
    else
        print("Headsup: AceConfig library not found. GUI configuration not available.")
    end
end

-- Create the scrollable spell list frame
function Headsup:CreateSpellListFrame()
    if spellListFrame then
        return -- Already created
    end

    -- Main frame
    spellListFrame = CreateFrame("Frame", "HeadsupSpellListFrame", UIParent)
    spellListFrame:SetWidth(520)
    spellListFrame:SetHeight(500)
    spellListFrame:SetPoint("CENTER")
    spellListFrame:SetFrameStrata("DIALOG")
    spellListFrame:SetMovable(true)
    spellListFrame:EnableMouse(true)
    spellListFrame:RegisterForDrag("LeftButton")
    spellListFrame:SetScript("OnDragStart", spellListFrame.StartMoving)
    spellListFrame:SetScript("OnDragStop", spellListFrame.StopMovingOrSizing)
    spellListFrame:Hide()

    -- Background
    spellListFrame.bg = spellListFrame:CreateTexture(nil, "BACKGROUND")
    spellListFrame.bg:SetAllPoints()
    spellListFrame.bg:SetTexture(0, 0, 0, 0.8)

    -- Border
    spellListFrame.border = CreateFrame("Frame", nil, spellListFrame)
    spellListFrame.border:SetAllPoints()
    spellListFrame.border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })
    spellListFrame.border:SetBackdropBorderColor(1, 1, 1, 1)

    -- Title
    spellListFrame.title = spellListFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    spellListFrame.title:SetPoint("TOP", 0, -10)
    spellListFrame.title:SetText("Manage Tracked Spells")

    -- Close button
    spellListFrame.closeButton = CreateFrame("Button", nil, spellListFrame, "UIPanelCloseButton")
    spellListFrame.closeButton:SetPoint("TOPRIGHT", -5, -5)
    spellListFrame.closeButton:SetScript("OnClick", function()
        spellListFrame:Hide()
    end)

    -- Scroll frame
    spellListScrollFrame = CreateFrame("ScrollFrame", "HeadsupSpellListScrollFrame", spellListFrame,
        "UIPanelScrollFrameTemplate")
    spellListScrollFrame:SetPoint("TOPLEFT", 10, -35)
    spellListScrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

    -- Content container
    spellListContent = CreateFrame("Frame", "HeadsupSpellListContent", spellListScrollFrame)
    spellListContent:SetWidth(spellListScrollFrame:GetWidth() - 20)
    spellListContent:SetHeight(1) -- Will be updated dynamically

    spellListScrollFrame:SetScrollChild(spellListContent)

    -- Close button (bottom)
    spellListFrame.closeButtonBottom = CreateFrame("Button", nil, spellListFrame, "UIPanelButtonTemplate")
    spellListFrame.closeButtonBottom:SetWidth(100)
    spellListFrame.closeButtonBottom:SetHeight(22)
    spellListFrame.closeButtonBottom:SetPoint("BOTTOM", 0, 10)
    spellListFrame.closeButtonBottom:SetText("Close")
    spellListFrame.closeButtonBottom:SetScript("OnClick", function()
        spellListFrame:Hide()
    end)
end

-- Create individual spell row
function Headsup:CreateSpellRow(spellID, yOffset)
    local row = CreateFrame("Frame", nil, spellListContent)
    row:SetWidth(spellListContent:GetWidth())
    row:SetHeight(26)
    row:SetPoint("TOPLEFT", 0, yOffset)

    -- Background for hover effect
    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.bg:SetTexture(0.1, 0.1, 0.1, 0.5)
    row.bg:Hide()

    row:EnableMouse(true)
    row:SetScript("OnEnter", function()
        row.bg:Show()
    end)
    row:SetScript("OnLeave", function()
        row.bg:Hide()
    end)

    -- Spell icon and link with tooltip
    local spellName, _, spellIcon = GetSpellInfo(spellID)
    if spellName then
        -- Create spell icon
        row.spellIcon = row:CreateTexture(nil, "ARTWORK")
        row.spellIcon:SetWidth(20)
        row.spellIcon:SetHeight(20)
        row.spellIcon:SetPoint("LEFT", 5, 0)

        if spellIcon then
            row.spellIcon:SetTexture(spellIcon)
        else
            -- Default icon for spells without icons
            row.spellIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        -- Create a clickable frame for the spell link to enable tooltips
        row.spellLinkFrame = CreateFrame("Frame", nil, row)
        row.spellLinkFrame:SetWidth(195) -- Reduced width to account for icon
        row.spellLinkFrame:SetHeight(20)
        row.spellLinkFrame:SetPoint("LEFT", row.spellIcon, "RIGHT", 5, 0)
        row.spellLinkFrame:EnableMouse(true)

        row.spellLink = row.spellLinkFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        row.spellLink:SetAllPoints()
        local spellLink = GetSpellLink(spellID)
        if spellLink then
            row.spellLink:SetText(spellLink)
        else
            row.spellLink:SetText("|cff71d5ff[" .. spellName .. "]|r")
        end
        row.spellLink:SetJustifyH("LEFT")

        -- Add spell tooltip on hover
        row.spellLinkFrame:SetScript("OnEnter", function(self)
            row.bg:Show() -- Show row highlight
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

            -- Try multiple methods for WotLK compatibility
            local spellLink = GetSpellLink(spellID)
            if spellLink then
                -- Use the spell link for tooltip (most compatible)
                GameTooltip:SetHyperlink(spellLink)
            else
                -- Fallback to spell name and ID
                local spellName = GetSpellInfo(spellID)
                if spellName then
                    GameTooltip:AddLine(spellName, 1, 1, 1)
                    GameTooltip:AddLine("Spell ID: " .. spellID, 0.8, 0.8, 0.8)
                else
                    GameTooltip:AddLine("Unknown Spell", 1, 0.5, 0.5)
                    GameTooltip:AddLine("Spell ID: " .. spellID, 0.8, 0.8, 0.8)
                end
            end

            GameTooltip:Show()
        end)

        row.spellLinkFrame:SetScript("OnLeave", function(self)
            row.bg:Hide() -- Hide row highlight
            GameTooltip:Hide()
        end)

        -- Allow clicking on the spell link (standard WoW behavior)
        row.spellLinkFrame:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" and IsShiftKeyDown() then
                -- Shift-click to link in chat
                local spellLink = GetSpellLink(spellID)
                if spellLink and ChatEdit_GetActiveWindow() then
                    ChatEdit_InsertLink(spellLink)
                end
            end
        end)
    else
        -- Create question mark icon for unknown spells
        row.spellIcon = row:CreateTexture(nil, "ARTWORK")
        row.spellIcon:SetWidth(20)
        row.spellIcon:SetHeight(20)
        row.spellIcon:SetPoint("LEFT", 5, 0)
        row.spellIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

        row.spellLinkFrame = CreateFrame("Frame", nil, row)
        row.spellLinkFrame:SetWidth(195)
        row.spellLinkFrame:SetHeight(20)
        row.spellLinkFrame:SetPoint("LEFT", row.spellIcon, "RIGHT", 5, 0)

        row.spellLink = row.spellLinkFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        row.spellLink:SetAllPoints()
        row.spellLink:SetText("|cffff6b6b(Unknown Spell)|r")
        row.spellLink:SetJustifyH("LEFT")

        -- No tooltip for unknown spells, but show helpful message
        row.spellLinkFrame:EnableMouse(true)
        row.spellLinkFrame:SetScript("OnEnter", function(self)
            row.bg:Show()
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("Unknown Spell", 1, 0.5, 0.5)
            GameTooltip:AddLine("Spell ID: " .. spellID, 0.8, 0.8, 0.8)
            GameTooltip:AddLine("This spell may not exist or may be from a different game version.", 0.6, 0.6, 0.6, true)
            GameTooltip:Show()
        end)

        row.spellLinkFrame:SetScript("OnLeave", function(self)
            row.bg:Hide()
            GameTooltip:Hide()
        end)
    end

    -- Spell ID
    row.spellID = row:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    row.spellID:SetPoint("LEFT", row.spellLinkFrame, "RIGHT", 10, 0)
    row.spellID:SetText("|cff888888ID: " .. spellID .. "|r")
    row.spellID:SetJustifyH("LEFT")
    row.spellID:SetWidth(80)

    -- Spell type indicator
    local typeText = ""
    if HeadsupDB.customSpells and HeadsupDB.customSpells[spellID] then
        typeText = "|cff00ff00(Custom)|r"
    elseif TRACKED_SPELLS and TRACKED_SPELLS[spellID] then
        typeText = "|cff4f9eff(Default)|r"
    end

    row.spellType = row:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    row.spellType:SetPoint("LEFT", row.spellID, "RIGHT", 5, 0)
    row.spellType:SetText(typeText)
    row.spellType:SetJustifyH("LEFT")
    row.spellType:SetWidth(70)

    -- Remove button
    row.removeButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    row.removeButton:SetWidth(60)
    row.removeButton:SetHeight(20)
    row.removeButton:SetPoint("RIGHT", -5, 0)
    row.removeButton:SetText("Remove")
    row.removeButton:SetScript("OnClick", function()
        if Headsup.RemoveSpell then
            Headsup:RemoveSpell(spellID)
            Headsup:RefreshSpellsList()
        else
            print("Headsup: RemoveSpell function not available")
        end
    end)

    -- All spells use same "Remove" text since they're all actually removed from tracking
    -- Default spells can be restored via "Reset to Defaults" button

    return row
end

-- Show the spell list frame
function Headsup:ShowSpellListFrame()
    if not spellListFrame then
        self:CreateSpellListFrame()
    end

    self:RefreshSpellsList()
    spellListFrame:Show()
end

-- Getter and setter functions for the configuration interface
function Headsup:IsHeadsupEnabled()
    return HeadsupDB.enabled
end

function Headsup:ToggleEnable()
    HeadsupDB.enabled = not HeadsupDB.enabled
    if HeadsupDB.enabled then
        if mainFrame then
            mainFrame:Show()
        end
        print("Headsup: Enabled")
    else
        if mainFrame then
            mainFrame:Hide()
        end
        print("Headsup: Disabled")
    end
end

function Headsup:GetIconSize()
    return HeadsupDB.iconSize
end

function Headsup:SetIconSize(info, value)
    HeadsupDB.iconSize = value
    -- Update frame sizes if the UpdateFrameSizes function exists
    if UpdateFrameSizes then
        UpdateFrameSizes()
    end
end

function Headsup:GetSpacing()
    return HeadsupDB.spacing
end

function Headsup:SetSpacing(info, value)
    HeadsupDB.spacing = value
    -- Update positions if the PositionFrames function exists
    if PositionFrames then
        PositionFrames()
    end
end

function Headsup:GetYOffset()
    return HeadsupDB.yOffset
end

function Headsup:SetYOffset(info, value)
    HeadsupDB.yOffset = value
    -- Update main frame position if the UpdateMainFramePosition function exists
    if UpdateMainFramePosition then
        UpdateMainFramePosition()
    end
end

function Headsup:GetShowSpellName()
    return HeadsupDB.showSpellName
end

function Headsup:SetShowSpellName(info, value)
    HeadsupDB.showSpellName = value
    -- Update spell name visibility if the UpdateSpellNameVisibility function exists
    if UpdateSpellNameVisibility then
        UpdateSpellNameVisibility()
    end
    print("Headsup: Spell names " .. (value and "enabled" or "disabled"))
end

function Headsup:GetTimerFontSize()
    return HeadsupDB.timerFontSize
end

function Headsup:SetTimerFontSize(info, value)
    HeadsupDB.timerFontSize = value
    -- Update font sizes if the UpdateFontSizes function exists
    if UpdateFontSizes then
        UpdateFontSizes()
    end
    print("Headsup: Timer font size set to " .. value)
end

function Headsup:GetSpellNameFontSize()
    return HeadsupDB.spellNameFontSize
end

function Headsup:SetSpellNameFontSize(info, value)
    HeadsupDB.spellNameFontSize = value
    -- Update font sizes if the UpdateFontSizes function exists
    if UpdateFontSizes then
        UpdateFontSizes()
    end
    print("Headsup: Spell name font size set to " .. value)
end

function Headsup:TestDisplay()
    -- Test with some common spells
    if ShowBuff then
        ShowBuff(12536, 15) -- Arcane Concentration
        ShowBuff(48108, 20) -- Hot Streak
        
        -- Test stack count display with Maelstrom Weapon (which can stack)
        local testSpellID = 53817 -- Maelstrom Weapon
        local buffData = activeBuffs[testSpellID] or {}
        
        if not buffData.frame then
            buffData.frame = CreateSpellFrame(testSpellID)
        end
        
        -- Mock stack count for testing (Maelstrom Weapon can stack to 5)
        buffData.stackCount = 3
        buffData.expireTime = GetTime() + 30
        
        -- Update stack count display
        buffData.frame.stackCount:SetText(buffData.stackCount)
        buffData.frame.stackCount:Show()
        
        buffData.frame:Show()
        activeBuffs[testSpellID] = buffData
        
        if PositionFrames then
            PositionFrames()
        end
        
        print("Headsup: Test buffs displayed (including stacked buff)")
    else
        print("Headsup: ShowBuff function not available")
    end
end

function Headsup:ClearAllBuffs()
    if activeBuffs and HideBuff then
        for spellID in pairs(activeBuffs) do
            HideBuff(spellID)
        end
        print("Headsup: All buffs cleared")
    else
        print("Headsup: Clear function not available")
    end
end

-- Spell Management Functions
-- Variables to store input values
local addSpellInputValue = ""
local removeSpellInputValue = ""

function Headsup:GetAddSpellInput()
    return addSpellInputValue
end

function Headsup:SetAddSpellInput(info, value)
    addSpellInputValue = value or ""
end

function Headsup:GetRemoveSpellInput()
    return removeSpellInputValue
end

function Headsup:SetRemoveSpellInput(info, value)
    removeSpellInputValue = value or ""
end

function Headsup:AddSpellFromInput()
    local spellID = tonumber(addSpellInputValue)
    if spellID and spellID > 0 then
        if self.AddSpell then
            self:AddSpell(spellID)
            addSpellInputValue = "" -- Clear input after adding
            self:RefreshSpellsList() -- Update the list
        else
            print("Headsup: AddSpell function not available")
        end
    else
        print("Headsup: Please enter a valid spell ID (number)")
    end
end

function Headsup:RemoveSpellFromInput()
    local spellID = tonumber(removeSpellInputValue)
    if spellID and spellID > 0 then
        if self.RemoveSpell then
            self:RemoveSpell(spellID)
            removeSpellInputValue = "" -- Clear input after removing
            self:RefreshSpellsList() -- Update the list
        else
            print("Headsup: RemoveSpell function not available")
        end
    else
        print("Headsup: Please enter a valid spell ID (number)")
    end
end

function Headsup:RefreshSpellsList()
    if not spellListContent then
        return -- Frame not created yet
    end

    -- Clear existing buttons
    for _, button in pairs(spellButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    spellButtons = {}

    if GetAllTrackedSpells then
        local trackedSpells = GetAllTrackedSpells()
        local count = 0

        -- Convert to sorted array for better display
        local sortedSpells = {}
        for spellID in pairs(trackedSpells) do
            table.insert(sortedSpells, spellID)
        end
        table.sort(sortedSpells)

        -- Create rows for each spell
        local yOffset = 0
        for _, spellID in ipairs(sortedSpells) do
            local row = self:CreateSpellRow(spellID, yOffset)
            table.insert(spellButtons, row)
            yOffset = yOffset - 28 -- 26 height + 2 spacing
            count = count + 1
        end

        -- Update content height
        local totalHeight = math.max(count * 28, 100)
        spellListContent:SetHeight(totalHeight)

        -- Update title with count
        if spellListFrame and spellListFrame.title then
            if count == 0 then
                spellListFrame.title:SetText("No Spells Tracked")
            else
                spellListFrame.title:SetText("Manage Tracked Spells (" .. count .. ")")
            end
        end

        print("Headsup: Spell list refreshed - " .. count .. " spells tracked")
    else
        print("Headsup: GetAllTrackedSpells function not available")
    end
end

function Headsup:ResetSpellsToDefault()
    -- Clear custom and removed spell lists
    HeadsupDB.customSpells = {}
    HeadsupDB.removedSpells = {}

    -- Clear any currently displayed custom buffs
    if activeBuffs and HideBuff then
        for spellID in pairs(activeBuffs) do
            if not TRACKED_SPELLS[spellID] then
                HideBuff(spellID)
            end
        end
    end

    self:RefreshSpellsList()
    print("Headsup: Reset to default spell tracking")
end

-- Sound setting functions
function Headsup:GetEnableSound()
    return HeadsupDB.enableSound
end

function Headsup:SetEnableSound(info, value)
    HeadsupDB.enableSound = value
    print("Headsup: Sound " .. (value and "enabled" or "disabled"))
end

function Headsup:GetSoundChoice()
    return HeadsupDB.soundChoice
end

function Headsup:SetSoundChoice(info, value)
    HeadsupDB.soundChoice = value
    print("Headsup: Sound changed to " .. value)
end

function Headsup:TestSound()
    if HeadsupDB.soundChoice then
        PlaySoundFile(HeadsupDB.soundChoice)
        print("Headsup: Playing sound " .. HeadsupDB.soundChoice)
    else
        print("Headsup: No sound selected")
    end
end

-- Visual Effects getter/setter functions


function Headsup:GetEnableFlashEffect()
    return HeadsupDB.enableFlashEffect
end

function Headsup:SetEnableFlashEffect(info, value)
    HeadsupDB.enableFlashEffect = value
    print("Headsup: Flash effect " .. (value and "enabled" or "disabled"))
end

function Headsup:GetFlashThreshold()
    return HeadsupDB.flashThreshold
end

function Headsup:SetFlashThreshold(info, value)
    HeadsupDB.flashThreshold = value
end

function Headsup:GetFlashSpeed()
    return HeadsupDB.flashSpeed
end

function Headsup:SetFlashSpeed(info, value)
    HeadsupDB.flashSpeed = value
end



function Headsup:TestFlashEffect()
    -- Use the slash command implementation which has proper access to activeBuffs
    SlashCmdList["HEADSUP"]("testflash")
end

-- Load the interface when addon is ready
local function LoadGUI()
    if Headsup then
        Headsup:LOAD_INTERFACE()
    end
end

-- Hook into addon loading or call immediately if already loaded
if IsAddOnLoaded and IsAddOnLoaded("Headsup") then
    LoadGUI()
else
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, addonName)
        if addonName == "Headsup" then
            LoadGUI()
            frame:UnregisterEvent("ADDON_LOADED")
        end
    end)
end
