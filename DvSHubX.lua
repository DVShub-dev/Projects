-- Load Fluent UI and Addons
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

Button_Icon = "rbxassetid://13541537436"

-- Create Fluent Window
local Window = Fluent:CreateWindow({
    Title = "DvS Hub ",
    SubTitle = "Grow A Garden",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 340),
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {}
Tabs.News = Window:AddTab({ Title = "News", Icon = "newspaper" })
Tabs.Updates = Window:AddTab({ Title = "Updates", Icon = "bell" })
Window:AddTab({ Title = " ", Icon = "" })
Tabs.Main = Window:AddTab({ Title = "Main", Icon = "home" })
Tabs.Farm = Window:AddTab({ Title = "Farm", Icon = "apple"})
Tabs.Events = Window:AddTab({ Title = "Events", Icon = "party-popper"})
Tabs.Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart"})
Tabs.Pets = Window:AddTab({ Title = "Pets", Icon = "bone"})
Tabs.Misc = Window:AddTab({ Title = "Misc", Icon = "shopping-cart"})
Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Options = Fluent.Options

-- NEWS SECTION
Tabs.News:AddSection("Social Links")
Tabs.News:AddButton({
    Title = "Copy Discord Link",
    Description = "Hello " .. LocalPlayer.DisplayName .. ", Welcome to Dv-HUB!",
    Callback = function()
        setclipboard("https://discord.gg/yourlink")
    end
})

-- UPDATES SECTION
Tabs.Updates:AddSection("Changelog")
Tabs.Updates:AddButton({
    Title = "Send Feedback",
    Description = "Send Suggestions On What to Add",
    Callback = function()
        print("hello it be good lol")
    end
})

Tabs.Updates:AddParagraph({
    Title = "DvS-HUB v3.0.0",
    Content = 
        "[+] Added Auto Farm and Auto Collect\n" ..
        "[+] Updated Honey Event Shop\n" ..
        "[+] Auto Collect Pollinated Fruits\n" ..
        "[+] Auto Buy Honey Shop\n" ..
        "[+] Auto Give Pollinated Fruits\n" ..
        "[-] Removed Moonlit and Bloodlit"
})

Tabs.Updates:AddParagraph({
    Title = "DvS-HUB v2.0.0",
    Content = 
        "[-] Removed Auto-Buy Eggs (fixing)\n" ..
        "[+] Added Optimization\n" ..
        "[+] Auto-Buy for Seeds and Gears added"
})

Tabs.Updates:AddParagraph({
    Title = "DvS-HUB v1.0.0",
    Content = 
        "[+] Initial Release\n" ..
        "[+] Added Support for Grow A Garden"
})

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- MAIN TAB FEATURES
local noclip = false
local noclipConn
Tabs.Main:AddSection("Player Modifications")
Tabs.Main:AddToggle("NoclipToggle", {
    Title = "NoClip",
    Default = false,
    Callback = function(state)
        noclip = state
        if noclip and not noclipConn then
            noclipConn = game:GetService("RunService").Stepped:Connect(function()
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        elseif not noclip and noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
})

-- INF JUMP TOGGLE
local infJumpEnabled = false
local infJumpConn

Tabs.Main:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
        if infJumpEnabled then
            infJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

-- Noclip toggle (unchanged from ur code)

-- Jump Height and Reset Button
local baseSliderValue = 50 -- slider val that equals OG jump height 7.2
local baseJumpHeight = 7.2 -- Roblox OG jump height

local jumpSlider = Tabs.Main:AddSlider("JumpHeight", {
    Title = "Jump Height",
    Description = "Change ur jump height",
    Default = baseSliderValue,
    Min = 0,
    Max = 120,
    Rounding = 0,
    Callback = function(val)
        if val < 1 then val = 1 end
        local newJump = (val / baseSliderValue) * baseJumpHeight
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = newJump
        end
    end
})

Tabs.Main:AddButton({
    Title = "Reset Jump Height",
    Description = "Set jump height back to default",
    Callback = function()
        Fluent.Options.JumpHeight:SetValue(baseSliderValue)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = baseJumpHeight
        end
    end
})

-- Walk Speed and Reset Button
Tabs.Main:AddSlider("SpeedSlider", {
    Title = "Walk Speed",
    Description = "Change ur speed",
    Default = 16,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Callback = function(val)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end
})

Tabs.Main:AddButton({
    Title = "Reset Walk Speed",
    Description = "Set walk speed back to default",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
        Fluent.Options.SpeedSlider:SetValue(16)
    end
})

--Farm Section
Tabs.Farm:AddSection("Auto Farm")
Tabs.Farm:AddSection("AFK Farm")


local antiAFKConnection
local RunService = game:GetService("RunService")
Tabs.Farm:AddToggle("AntiAFK", {
    Title = "Anti-AFK",
    Default = false,
    Callback = function(state)
        if state then
            antiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new(0, 0))
            end)
        else
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end
        end
    end
})

--Shop Section
Tabs.Shop:AddSection("Auto-Buy")

local seedNames = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn",
    "Daffodil", "Watermelon", "Pumpkin", "Bamboo", "Cactus", "Dragon Fruit",
    "Coconut", "Mango", "Pepper", "Mushroom", "Grape", "Cacao", "Beanstalk", "Ember Lily"
}

local gearNames = {
    "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Lightning Rod", "Master Sprinkler",
    "Favorite Tool", "Harvest Tool"
}

local eggNames = {
    "Common Egg",
    "Uncommon Egg",
    "Rare Egg",
    "Legendary Egg",
    "Mythical Egg",
    "Bug Egg",
}

local selectedSeeds = {}
local selectedGears = {}
local selectedEggs = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local petEggService = GameEvents:WaitForChild("PetEggService")

-- ?? FUNCTIONS
local function BuySeed(seed)
    GameEvents.BuySeedStock:FireServer(seed)
end

local function BuyGear(gear)
    GameEvents.BuyGearStock:FireServer(gear)
end

-- 📍 GET EGG ROW #
local function GetEggRowNumber(eggName)
    local eggLocations = workspace:WaitForChild("NPCS"):WaitForChild("Pet Stand"):WaitForChild("EggLocations")
    eggName = eggName:lower()

    local eggRowIndex = 0

    for i = 1, 6 do
        local row = eggLocations:FindFirstChild("Row" .. i)
        if row and i >= 4 then -- only Row4, Row5, Row6 for eggs
            eggRowIndex += 1
            for _, obj in ipairs(row:GetChildren()) do
                if obj.Name:lower():find("egg") and obj.Name:lower() == eggName then
                    return eggRowIndex -- maps Row4=1, Row5=2, Row6=3
                end
            end
        end
    end

    return nil -- not found
end

local function BuyEgg(eggName)
    local row = GetEggRowNumber(eggName)
    if row then
        GameEvents.BuyPetEgg:FireServer(row)
    end
end

-- UI SETUP
Tabs.Shop:AddSection("Auto Buy Selection")

-- 🌱 SEEDS DROPDOWN
Tabs.Shop:AddDropdown("SeedDropdown", {
    Title = "Select Seeds",
    Description = "Choose seeds to auto-buy",
    Values = seedNames,
    Multi = true,
    Default = {},
}):OnChanged(function(val)
    selectedSeeds = {}
    for seed, selected in pairs(val) do
        if selected then table.insert(selectedSeeds, seed) end
    end
end)

-- ⚙️ GEARS DROPDOWN
Tabs.Shop:AddDropdown("GearDropdown", {
    Title = "Select Gears",
    Description = "Choose gears to auto-buy",
    Values = gearNames,
    Multi = true,
    Default = {},
}):OnChanged(function(val)
    selectedGears = {}
    for gear, selected in pairs(val) do
        if selected then table.insert(selectedGears, gear) end
    end
end)

-- 🥚 EGGS DROPDOWN
Tabs.Shop:AddDropdown("EggDropdown", {
    Title = "Select Eggs",
    Description = "Choose eggs to auto-buy",
    Values = eggNames,
    Multi = true,
    Default = {},
}):OnChanged(function(val)
    selectedEggs = {}
    for eggName, selected in pairs(val) do
        if selected then
            table.insert(selectedEggs, eggName)
        end
    end
end)

-- ♻️ AUTO BUY TOGGLES
Tabs.Shop:AddSection("Auto Buy All")

-- 🔁 AUTO BUY SEEDS + GEARS
local autoBuyConnection
Tabs.Shop:AddToggle("AutoBuySeedsGears", {
    Title = "Auto Buy Seeds + Gears",
    Default = false,
    Callback = function(state)
        if state then
            autoBuyConnection = RunService.Heartbeat:Connect(function()
                for _, seed in pairs(selectedSeeds) do BuySeed(seed) end
                for _, gear in pairs(selectedGears) do BuyGear(gear) end
                task.wait(0.1)
            end)
        else
            if autoBuyConnection then
                autoBuyConnection:Disconnect()
                autoBuyConnection = nil
            end
        end
    end
})

-- 🐣 AUTO BUY EGGS
local autoBuyEggConnection
Tabs.Shop:AddToggle("AutoBuyEggs", {
    Title = "Auto Buy Eggs",
    Default = false,
    Callback = function(state)
        if state then
            autoBuyEggConnection = RunService.Heartbeat:Connect(function()
                for _, eggName in pairs(selectedEggs) do
                    BuyEgg(eggName)
                end
                task.wait(0.1)
            end)
        else
            if autoBuyEggConnection then
                autoBuyEggConnection:Disconnect()
                autoBuyEggConnection = nil
            end
        end
    end
})


local RunService = game:GetService("RunService")

local petEggService = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService")

local autoHatch = false

Tabs.Farm:AddToggle("AutoHatch", {
    Title = "Auto Hatch Eggs",
    Default = false,
    Callback = function(state)
        autoHatch = state
    end
})

RunService.RenderStepped:Connect(function()
    if autoHatch then
        local args = {
            "HatchPet",
            workspace:WaitForChild("Farm"):WaitForChild("Farm"):WaitForChild("Important"):WaitForChild("Objects_Physical"):WaitForChild("PetEgg")
        }
        petEggService:FireServer(unpack(args))
    end
end)

-- SHOP UI BUTTONS 🔓
Tabs.Shop:AddSection("Open Menus")
Tabs.Shop:AddButton({
    Title = "Open Seed Shop",
    Description = "Click to Open/Close",
    Callback = function()
        local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local gui = PlayerGui:FindFirstChild("Seed_Shop")
        if gui then
            gui.Enabled = not gui.Enabled
        else
            print("Seed_Shop not found")
        end
    end
})

Tabs.Shop:AddButton({
    Title = "Open Gear Shop",
    Description = "Click to Open/Close",
    Callback = function()
        local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local gui = PlayerGui:FindFirstChild("Gear_Shop")
        if gui then
            gui.Enabled = not gui.Enabled
        else
            print("Gear_Shop not found")
        end
    end
})

Tabs.Shop:AddButton({
    Title = "Open Daily Quests",
    Description = "Click to Open/Close",
    Callback = function()
        local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local gui = PlayerGui:FindFirstChild("DailyQuests_UI")
        if gui then
            gui.Enabled = not gui.Enabled
        else
            print("UI not found")
        end
    end
})

Tabs.Shop:AddButton({
    Title = "Open Honey Shop",
    Description = "Click to Open/Close",
    Callback = function()
        local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local gui = PlayerGui:FindFirstChild("NightEventShop_UI")
        if gui then
            gui.Enabled = not gui.Enabled
        else
            print("HoneyEventShop_UI not found")
        end
    end
})

Tabs.Pets:AddSection("Automatic")

Tabs.Misc:AddSection("Miscellaneous")

local showUI = false

Tabs.Misc:AddToggle("ShowInterface", {
    Title = "Show Gear and Pets UI",
    Default = true,
    Callback = function(state)
        showUI = state

        local player = game.Players.LocalPlayer
        local gui = player:WaitForChild("PlayerGui"):WaitForChild("Teleport_UI")
        local frame = gui:WaitForChild("Frame")

        local gearBtn = frame:WaitForChild("Gear")
        local petsBtn = frame:WaitForChild("Pets")

        gearBtn.Active = state
        gearBtn.Visible = state

        petsBtn.Active = state
        petsBtn.Visible = state
    end
})

-- Save Manager Setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(2)
SaveManager:LoadAutoloadConfig()-- Load Fluent UI and Addons 
