-- AUTO FARMING | OASISUI
-- Tabs: MAIN, PLAYER, PVP, VISUAL, MISC, COMBAT
-- Combat controls are UI-only practice settings for NPC training.
-- No player-targeting silent-aim/network hooks are included.

local OasisUI = loadstring(game:HttpGet(
    "https://github.com/Mold53/OasisUI/releases/download/v1.6.0/OasisUI.lua"
))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Window = OasisUI:CreateWindow({
    Title = "DRev",
    Subtitle = "free script",
    Folder = "🫩",
    Theme = "Midnight",
    Size = UDim2.fromOffset(760, 520),
    ToggleKey = Enum.KeyCode.RightShift,
    Search = true,
    Settings = true,
    AutoSave = true,
    DefaultConfig = "default",
    GuiName = "AutoFarming"
})

-- MAIN
local Main = Window:Tab({
    Title = "MAIN",
    Icon = "house",
    Columns = 2
})

local Dashboard = Main:Module({
    Title = "Dashboard",
    Icon = "layout-dashboard",
    Default = true
})

Dashboard:Label({
    Text = "✅",
    Value = "ONLINE"
})

Dashboard:Paragraph({
    Title = "Welcome",
    Content = "Bienvenido a el script w."
})

Dashboard:Button({
    Title = "Resetear",
    Icon = "refresh-cw",
    Callback = function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end
})

-- PLAYER
local PlayerTab = Window:Tab({
    Title = "PLAYER",
    Icon = "user",
    Columns = 2
})

local Movement = PlayerTab:Module({
    Title = "Movement",
    Icon = "footprints"
})

Movement:Slider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        local humanoid = LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

Movement:Slider({
    Title = "JumpPower",
    Min = 50,
    Max = 150,
    Default = 50,
    Callback = function(value)
        local humanoid = LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end
})

-- PVP
local PVP = Window:Tab({
    Title = "PVP",
    Icon = "swords",
    Columns = 2
})

local CombatPractice = PVP:Module({
    Title = "Combat Practice",
    Icon = "crosshair"
})

CombatPractice:Button({
    Title = "Practice Shoot",
    Icon = "target",
    Callback = function()
        local character = LocalPlayer.Character
        local tool = character and character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
})

CombatPractice:Paragraph({
    Title = "Training",
    Content = "Practica tu punteria en zonas de entrenamiento."
})

-- VISUAL: Ground Item ESP (ported from the Ground ESP approach in Vodex)
local Visual = Window:Tab({
    Title = "VISUAL",
    Icon = "eye",
    Columns = 2
})

local VisualSettings = {
    Enabled = false,
    ShowGuns = true,
    ShowAmmo = true,
    ShowMisc = true,
    ShowDistance = true,
    Common = true,
    Uncommon = true,
    Rare = true,
    Epic = true,
    Legendary = true,
    Mythic = true,
    Exotic = true,
    MaxDistance = 1000
}

local VisualModule = Visual:Module({
    Title = "GROUND ITEM ESP",
    Icon = "eye"
})

VisualModule:Paragraph({
    Title = "OPPS Ground ESP",
    Content = "Muestra armas, munición y objetos tirados en Dropped.Visual. El dinero se excluye."
})

VisualModule:Toggle({
    Title = "Enable Ground ESP",
    Default = false,
    Flag = "GroundESP",
    Callback = function(value) VisualSettings.Enabled = value end
})

VisualModule:Toggle({Title = "Guns", Default = true, Callback = function(v) VisualSettings.ShowGuns = v end})
VisualModule:Toggle({Title = "Ammo", Default = true, Callback = function(v) VisualSettings.ShowAmmo = v end})
VisualModule:Toggle({Title = "Misc Items", Default = true, Callback = function(v) VisualSettings.ShowMisc = v end})
VisualModule:Toggle({Title = "Show Distance", Default = true, Callback = function(v) VisualSettings.ShowDistance = v end})

VisualModule:Toggle({Title = "Common", Default = true, Callback = function(v) VisualSettings.Common = v end})
VisualModule:Toggle({Title = "Uncommon", Default = true, Callback = function(v) VisualSettings.Uncommon = v end})
VisualModule:Toggle({Title = "Rare", Default = true, Callback = function(v) VisualSettings.Rare = v end})
VisualModule:Toggle({Title = "Epic", Default = true, Callback = function(v) VisualSettings.Epic = v end})
VisualModule:Toggle({Title = "Legendary", Default = true, Callback = function(v) VisualSettings.Legendary = v end})
VisualModule:Toggle({Title = "Mythic", Default = true, Callback = function(v) VisualSettings.Mythic = v end})
VisualModule:Toggle({Title = "Exotic", Default = true, Callback = function(v) VisualSettings.Exotic = v end})

VisualModule:Slider({
    Title = "Ground ESP Range",
    Min = 50,
    Max = 5000,
    Default = 1000,
    Step = 50,
    Flag = "GroundESPRange",
    Callback = function(value) VisualSettings.MaxDistance = value end
})

local GroundColors = {
    Guns = Color3.fromRGB(255, 190, 45),
    Ammo = Color3.fromRGB(235, 205, 95),
    Misc = Color3.fromRGB(190, 170, 255)
}

local GroundGunWords = {
    "rpg", "mp5", "ak47", "ak74", "akm", "ar15", "m4", "m16", "m249",
    "spaz", "spas", "remington", "anaconda", "glock", "pistol", "rifle",
    "shotgun", "sniper", "uzi", "mac10", "mac11", "tec9", "draco",
    "deagle", "revolver", "smg", "lmg", "carbine", "scar", "famas", "aug",
    "p90", "vector", "beretta", "colt", "magnum", "barrett", "awp",
    "mossberg", "kriss", "g17", "g18", "g19", "minigun", "launcher", "musket", "raygun"
}

local function isMoneyName(name)
    local n = tostring(name):lower()
    return n:find("cash", 1, true) or n:find("money", 1, true)
        or n:find("dollar", 1, true) or n:find("$", 1, true)
end

local function getGroundCategory(item)
    local name = item.Name:lower()
    if name:find("ammo", 1, true) then return "Ammo" end
    local compact = name:gsub("[^%w]", "")
    for _, word in ipairs(GroundGunWords) do
        if compact:find(word, 1, true) then return "Guns" end
    end
    for _, child in ipairs(item:GetDescendants()) do
        local n = child.Name:lower()
        if n:find("muzzle", 1, true) or n:find("barrel", 1, true)
            or n:find("firepoint", 1, true) or n:find("magazine", 1, true) then
            return "Guns"
        end
    end
    return "Misc"
end

local function getGroundRarity(item)
    -- The AWP is Legendary in OPPS. Other items use their in-game rarity metadata.
    if item.Name:lower():find("awp", 1, true) then return "Legendary" end
    for _, key in ipairs({"Rarity", "rarity", "ItemRarity", "Tier"}) do
        local attr = item:GetAttribute(key)
        if attr ~= nil then return tostring(attr) end
        local value = item:FindFirstChild(key, true)
        if value and (value:IsA("StringValue") or value:IsA("IntValue")) then
            return tostring(value.Value)
        end
    end
    return "Unknown"
end

local function rarityAllowed(rarity)
    local key = tostring(rarity):lower():gsub("[^%w]", "")
    if key == "common" then return VisualSettings.Common end
    if key == "uncommon" then return VisualSettings.Uncommon end
    if key == "rare" then return VisualSettings.Rare end
    if key == "epic" then return VisualSettings.Epic end
    if key == "legendary" then return VisualSettings.Legendary end
    if key == "mythic" or key == "mythical" then return VisualSettings.Mythic end
    if key == "exotic" then return VisualSettings.Exotic end
    return true -- Unknown rarity remains visible instead of hiding valid drops.
end

local function getGroundPosition(item)
    if item:IsA("BasePart") then return item.Position end
    local handle = item:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then return handle.Position end
    if item:IsA("Model") then
        local ok, pivot = pcall(function() return item:GetPivot() end)
        if ok then return pivot.Position end
    end
    local part = item:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position or nil
end

local GroundGui = Instance.new("ScreenGui")
GroundGui.Name = "OasisGroundItemESP"
GroundGui.ResetOnSpawn = false
GroundGui.IgnoreGuiInset = true
GroundGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local GroundLabels = {}
local function getGroundLabel(item)
    if GroundLabels[item] and GroundLabels[item].Parent then return GroundLabels[item] end
    local label = Instance.new("TextLabel")
    label.Name = "GroundItemLabel"
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Size = UDim2.fromOffset(220, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Visible = false
    label.Parent = GroundGui
    GroundLabels[item] = label
    return label
end

local function getAmount(item)
    for _, key in ipairs({"Amount", "Value", "Count", "Quantity"}) do
        local attr = item:GetAttribute(key)
        if type(attr) == "number" then return attr end
        local obj = item:FindFirstChild(key)
        if obj and (obj:IsA("IntValue") or obj:IsA("NumberValue")) then return obj.Value end
    end
end

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    local dropped = workspace:FindFirstChild("Dropped")
    local visualFolder = dropped and dropped:FindFirstChild("Visual")
    if not VisualSettings.Enabled or not camera or not visualFolder then
        for item, label in pairs(GroundLabels) do
            label.Visible = false
            if not item.Parent then label:Destroy() GroundLabels[item] = nil end
        end
        return
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local myPosition = root and root.Position or camera.CFrame.Position
    local seen = {}

    for _, item in ipairs(visualFolder:GetChildren()) do
        seen[item] = true
        local category = getGroundCategory(item)
        local categoryEnabled = (category == "Guns" and VisualSettings.ShowGuns)
            or (category == "Ammo" and VisualSettings.ShowAmmo)
            or (category == "Misc" and VisualSettings.ShowMisc)
        local position = getGroundPosition(item)
        local rarity = getGroundRarity(item)
        local allowed = categoryEnabled and not isMoneyName(item.Name) and rarityAllowed(rarity)

        if allowed and position then
            local distance = (position - myPosition).Magnitude
            local screenPosition, onScreen = camera:WorldToViewportPoint(position)
            if onScreen and distance <= VisualSettings.MaxDistance then
                local label = getGroundLabel(item)
                local amount = (category == "Ammo") and getAmount(item) or nil
                local text = "[" .. item.Name .. (amount and (" x" .. math.floor(amount)) or "") .. "]"
                if VisualSettings.ShowDistance then text ..= " {" .. math.floor(distance) .. "}" end
                label.Text = text
                label.TextColor3 = GroundColors[category] or Color3.new(1, 1, 1)
                label.Position = UDim2.fromOffset(screenPosition.X, screenPosition.Y)
                label.Visible = true
            elseif GroundLabels[item] then
                GroundLabels[item].Visible = false
            end
        elseif GroundLabels[item] then
            GroundLabels[item].Visible = false
        end
    end

    for item, label in pairs(GroundLabels) do
        if not seen[item] or not item.Parent then
            label:Destroy()
            GroundLabels[item] = nil
        end
    end
end)

-- CAR
local CarTab = Window:Tab({
    Title = "CAR",
    Icon = "car",
    Columns = 2
})

local CarSettings = {
    DriveStable = false,
    StableSpeed = 1,
    KeepFOV = true
}

local CarModule = CarTab:Module({
    Title = "Vehicle Control",
    Icon = "car-front"
})

CarModule:Paragraph({
    Title = "OPPS CAR",
    Content = "Opciones de estabilidad y cámara para conducir."
})

CarModule:Toggle({
    Title = "Drive Stable",
    Description = "Reduce la inclinación del vehículo",
    Default = false,
    Flag = "DriveStable",
    Callback = function(value)
        CarSettings.DriveStable = value
    end
})

CarModule:Slider({
    Title = "Stable Speed",
    Min = 0.5,
    Max = 2,
    Default = 1,
    Step = 0.05,
    Flag = "StableCarSpeed",
    Callback = function(value)
        CarSettings.StableSpeed = value
    end
})

CarModule:Toggle({
    Title = "Keep FOV Normal",
    Description = "Mantiene el FOV en 70 al conducir",
    Default = true,
    Flag = "KeepCarFOV",
    Callback = function(value)
        CarSettings.KeepFOV = value
    end
})

local OriginalCarSpeeds = {}
local OriginalFOV = nil

RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local seat = humanoid and humanoid.SeatPart
    local driving = seat and seat:IsA("VehicleSeat")

    -- Stable Speed
    for oldSeat, oldSpeed in pairs(OriginalCarSpeeds) do
        if not oldSeat.Parent or oldSeat ~= seat then
            pcall(function()
                oldSeat.MaxSpeed = oldSpeed
            end)
            OriginalCarSpeeds[oldSeat] = nil
        end
    end

    if driving then
        if OriginalCarSpeeds[seat] == nil then
            OriginalCarSpeeds[seat] = seat.MaxSpeed
        end

        pcall(function()
            seat.MaxSpeed = OriginalCarSpeeds[seat] * CarSettings.StableSpeed
        end)

        -- Drive Stable
        if CarSettings.DriveStable then
            local root = seat.AssemblyRootPart or seat
            local angular = root.AssemblyAngularVelocity

            root.AssemblyAngularVelocity = Vector3.new(
                0,
                angular.Y,
                0
            )
        end
    end

    -- Keep FOV Normal
    local camera = workspace.CurrentCamera

    if camera then
        if CarSettings.KeepFOV and driving then
            if OriginalFOV == nil then
                OriginalFOV = camera.FieldOfView
            end

            camera.FieldOfView = 70
        elseif OriginalFOV ~= nil then
            camera.FieldOfView = OriginalFOV
            OriginalFOV = nil
        end
    end
end)

-- MISC
local Misc = Window:Tab({
    Title = "MISC",
    Icon = "package",
    Columns = 2
})

local MiscModule = Misc:Module({
    Title = "Extra",
    Icon = "layers"
})

MiscModule:Button({
    Title = "Reset Character",
    Icon = "refresh-cw",
    Confirm = true,
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            character:BreakJoints()
        end
    end
})

MiscModule:Paragraph({
    Title = "Information",
    Content = "AUTO FARMING | OASIS UI"
})

-- COMBAT
-- These controls store practice preferences only. They do not hook
-- weapon/network calls or redirect shots toward real players.
local CombatTab = Window:Tab({
    Title = "COMBAT",
    Icon = "crosshair",
    Columns = 2
})

local CombatSettings = {
    NPCAimAssist = false,
    FOV = 120,
    ShowFOV = false,
    AimPart = "Head",
    Prediction = false,
    Smoothness = 75
}

local AimModule = CombatTab:Module({
    Title = "Combat Practice",
    Description = "Practice settings for NPC training targets",
    Icon = "target"
})

AimModule:Toggle({
    Title = "NPC Aim Assist",
    Description = "Practice preference toggle for NPC targets",
    Default = false,
    Flag = "NPCAimAssist",
    Callback = function(value)
        CombatSettings.NPCAimAssist = value
    end
})

AimModule:Slider({
    Title = "FOV",
    Min = 20,
    Max = 800,
    Default = 120,
    Step = 1,
    Flag = "CombatFOV",
    Callback = function(value)
        CombatSettings.FOV = value
    end
})

AimModule:Toggle({
    Title = "Show FOV",
    Default = false,
    Flag = "ShowCombatFOV",
    Callback = function(value)
        CombatSettings.ShowFOV = value
    end
})

AimModule:Dropdown({
    Title = "Aim Part",
    Values = {"Head", "Body"},
    Default = "Head",
    Multi = false,
    Flag = "CombatAimPart",
    Callback = function(value)
        CombatSettings.AimPart = value
    end
})

local ExtraCombat = CombatTab:Module({
    Title = "Advanced Practice",
    Description = "Additional NPC training preferences",
    Icon = "settings-2"
})

ExtraCombat:Toggle({
    Title = "Prediction",
    Default = false,
    Flag = "CombatPrediction",
    Callback = function(value)
        CombatSettings.Prediction = value
    end
})

ExtraCombat:Slider({
    Title = "Smoothness",
    Min = 1,
    Max = 100,
    Default = 75,
    Step = 1,
    Flag = "CombatSmoothness",
    Callback = function(value)
        CombatSettings.Smoothness = value
    end
})

-- SETTINGS is supplied by OasisUI when Settings = true.
OasisUI:SetAccent(Color3.fromRGB(35, 130, 255))
Window:SetWatermark("AUTO FARMING | PREMIUM")
Window:SelectTab(Main)
