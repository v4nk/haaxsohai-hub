-- [[ SYSTEM & SERVICES ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LP = Players.LocalPlayer

-- [[ CONFIG ]] --
_G.Config = { 
    GoldEnabled = false,
    DiamondEnabled = false,
}

local goldWaypoints = {
    Vector3.new(41.32, 504.59, 51.67),
    Vector3.new(-64.23, 504.59, 47.03),
    Vector3.new(-48.08, 560.59, 14.17),
    Vector3.new(49.07, 560.59, 0.25),
    Vector3.new(-47.81, 621.59, -63.48),
    Vector3.new(64.43, 637.59, -64.91),
    Vector3.new(48.08, 702.59, 12.47)
}

local diamondWaypoints = {
    Vector3.new(0.02, 130.59, 0.65),
    Vector3.new(-49.21, 261.59, -37.39),
    Vector3.new(-48.52, 458.59, 48.13),
    Vector3.new(47.74, 621.59, -48.47)
}

local eggPositions = {
    Noob   = Vector3.new(43.76, 1.70, -17.58),
    Bacon  = Vector3.new(43.26, 1.70, -1.28),
    Party  = Vector3.new(43.65, 1.70, 14.96),
    Hacker = Vector3.new(-13.76, 503.69, 76.01)
}

local goldDelay = 0.25
local goldWait = 15
local diamondDelay = 0.25
local diamondWait = 905

local goldIndex = 1
local diamondIndex = 1

-- Biến kiểm soát mạnh
local goldThread = nil
local diamondThread = nil

-- [[ UI ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HaaxsohaiHub"

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "HX"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Font = Enum.Font.LuckiestGuy
ToggleBtn.TextSize = 23
ToggleBtn.Draggable = true
ToggleBtn.Active = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 255, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Position = UDim2.new(0.12, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

local MenuTitle = Instance.new("TextLabel", MainFrame)
MenuTitle.Size = UDim2.new(1, 0, 0, 40)
MenuTitle.Text = "HAAXSOHAI HUB"
MenuTitle.TextColor3 = Color3.new(1, 1, 1)
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.TextSize = 15
MenuTitle.BackgroundTransparency = 1

local CreditLabel = Instance.new("TextLabel", MainFrame)
CreditLabel.Size = UDim2.new(1, 0, 0, 18)
CreditLabel.Position = UDim2.new(0, 0, 1, -22)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by haaxsohai"
CreditLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
CreditLabel.Font = Enum.Font.SourceSansItalic
CreditLabel.TextSize = 12
CreditLabel.TextTransparency = 0.4

local function Resize(w, h) MainFrame.Size = UDim2.new(0, w, 0, h) end

local Menus = {}
local function CreateFrame(name)
    local f = Instance.new("Frame", MainFrame)
    f.Size = UDim2.new(1, 0, 1, -65)
    f.Position = UDim2.new(0, 0, 0, 45)
    f.BackgroundTransparency = 1
    f.Visible = false
    Menus[name] = f
    return f
end

local function ShowMenu(name)
    for k, v in pairs(Menus) do v.Visible = (k == name) end
    if name == "Main" then Resize(280, 190)
    elseif name == "Farm" then Resize(280, 195)
    elseif name == "Egg" then Resize(280, 200) end
end

local MainM = CreateFrame("Main")
local FarmM = CreateFrame("Farm")
local EggM  = CreateFrame("Egg")

local function ApplyGrid(p, x, y)
    local g = Instance.new("UIGridLayout", p)
    g.CellSize = UDim2.new(0, x, 0, y)
    g.CellPadding = UDim2.new(0, 8, 0, 10)
    g.HorizontalAlignment = Enum.HorizontalAlignment.Center
end

ApplyGrid(MainM, 120, 38)
ApplyGrid(FarmM, 110, 35)
ApplyGrid(EggM, 85, 40)

local function MakeButton(parent, label, clr, cb)
    local b = Instance.new("TextButton", parent)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = clr or Color3.fromRGB(35, 35, 35)
    b.Text = label
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(60, 60, 60)

    b.MouseButton1Click:Connect(function()
        if cb then cb(b) end
    end)
    return b
end

-- Main Menu
MakeButton(MainM, "FARM MENU", Color3.fromRGB(0, 102, 204), function() ShowMenu("Farm") end)
MakeButton(MainM, "PET EGG", Color3.fromRGB(255, 140, 0), function() ShowMenu("Egg") end)

-- Farm Menu
local GoldBtn = MakeButton(FarmM, "GOLD FARM : OFF", Color3.fromRGB(200, 40, 40))
local DiamondBtn = MakeButton(FarmM, "DIAMOND FARM : OFF", Color3.fromRGB(200, 40, 40))
MakeButton(FarmM, "BACK", Color3.fromRGB(120, 30, 30), function() ShowMenu("Main") end)

-- Pet Egg Menu
local function teleportTo(pos)
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y + 4, pos.Z)
    end
end

MakeButton(EggM, "EGG NOOB", Color3.fromRGB(100, 100, 100), function() teleportTo(eggPositions.Noob) end)
MakeButton(EggM, "EGG BACON", Color3.fromRGB(180, 100, 50), function() teleportTo(eggPositions.Bacon) end)
MakeButton(EggM, "EGG PARTY", Color3.fromRGB(255, 100, 200), function() teleportTo(eggPositions.Party) end)
MakeButton(EggM, "EGG HACKER", Color3.fromRGB(0, 200, 100), function() teleportTo(eggPositions.Hacker) end)
MakeButton(EggM, "BACK", Color3.fromRGB(120, 30, 30), function() ShowMenu("Main") end)

-- ================== GOLD LOOP ==================
local function goldLoop()
    while _G.Config.GoldEnabled do
        for i = 1, #goldWaypoints do
            if not _G.Config.GoldEnabled then break end
            teleportTo(goldWaypoints[goldIndex])
            goldIndex = goldIndex + 1
            if goldIndex > #goldWaypoints then goldIndex = 1 end
            task.wait(goldDelay)
        end
        if _G.Config.GoldEnabled then
            task.wait(goldWait)
        else
            break
        end
    end
end

-- ================== DIAMOND LOOP ==================
local function diamondLoop()
    while _G.Config.DiamondEnabled do
        for i = 1, #diamondWaypoints do
            if not _G.Config.DiamondEnabled then break end
            teleportTo(diamondWaypoints[diamondIndex])
            diamondIndex = diamondIndex + 1
            if diamondIndex > #diamondWaypoints then diamondIndex = 1 end
            task.wait(diamondDelay)
        end
        if _G.Config.DiamondEnabled then
            task.wait(diamondWait)
        else
            break
        end
    end
end

-- ================== TOGGLE GOLD (Phiên bản mạnh) ==================
GoldBtn.MouseButton1Click:Connect(function()
    _G.Config.GoldEnabled = not _G.Config.GoldEnabled

    if _G.Config.GoldEnabled then
        goldIndex = 1
        GoldBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        GoldBtn.Text = "GOLD FARM : ON"
        
        -- Dừng thread cũ nếu có
        if goldThread then 
            pcall(function() coroutine.close(goldThread) end) 
        end
        
        goldThread = coroutine.create(goldLoop)
        coroutine.resume(goldThread)
    else
        GoldBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        GoldBtn.Text = "GOLD FARM : OFF"
        
        if goldThread then 
            pcall(function() coroutine.close(goldThread) end) 
            goldThread = nil 
        end
    end
end)

-- ================== TOGGLE DIAMOND (Phiên bản mạnh) ==================
DiamondBtn.MouseButton1Click:Connect(function()
    _G.Config.DiamondEnabled = not _G.Config.DiamondEnabled

    if _G.Config.DiamondEnabled then
        diamondIndex = 1
        DiamondBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        DiamondBtn.Text = "DIAMOND FARM : ON"
        
        if diamondThread then 
            pcall(function() coroutine.close(diamondThread) end) 
        end
        
        diamondThread = coroutine.create(diamondLoop)
        coroutine.resume(diamondThread)
    else
        DiamondBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        DiamondBtn.Text = "DIAMOND FARM : OFF"
        
        if diamondThread then 
            pcall(function() coroutine.close(diamondThread) end) 
            diamondThread = nil 
        end
    end
end)

-- Mở menu
ToggleBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
    if MainFrame.Visible then ShowMenu("Main") end
end)

print("✅ HAAXSOHAI HUB loaded - Fix mạnh lỗi tele loạn khi ấn nhiều lần")
