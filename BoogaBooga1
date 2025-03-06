-- Адаптивное мод-меню для сенсорных устройств
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Создание GUI
local ModMenu = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Drag = Instance.new("TextButton")
local ESPBtn = Instance.new("TextButton")
local KillauraBtn = Instance.new("TextButton")
local HighJumpBtn = Instance.new("TextButton")

ModMenu.Name = "DipSikModMenu"
ModMenu.Parent = CoreGui

Frame.Size = UDim2.new(0.35, 0, 0.65, 0)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Parent = ModMenu

-- Сглаживание углов фрейма
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = Frame

-- Функции сворачивания/разворачивания
local isMinimized = false
local originalSize = Frame.Size
local minimizedSize = UDim2.new(0.1, 0, 0.12, 0)
local lastTapTime = 0

local function ToggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        Frame.Size = minimizedSize
        Frame.BackgroundTransparency = 1
        ESPBtn.Visible = false
        KillauraBtn.Visible = false
        HighJumpBtn.Visible = false
        Drag.Text = "▼MiniPisa▼"
        Drag.Size = UDim2.new(1, 0, 2, 0)  -- Узкая кнопка в свёрнутом состоянии
        Drag.Position = UDim2.new(0.1, 0, 0, 0)  -- Центрирование
    else
        Frame.Size = originalSize
        Frame.BackgroundTransparency = 0
        ESPBtn.Visible = true
        KillauraBtn.Visible = true
        HighJumpBtn.Visible = true
        Drag.Text = "▲BigJopka▲"
        Drag.Size = UDim2.new(0.475, 0, 0.12, 0)  -- Ширина уменьшена в 2 раза
        Drag.Position = UDim2.new(0.2625, 0, 0, 0)  -- Новое позиционирование
    end
end

-- Обработка двойного тапа
Drag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        if (currentTime - lastTapTime) < 0.3 then
            ToggleMinimize()
        end
        lastTapTime = currentTime
    end
end)

-- Кнопка перетаскивания
Drag.Text = "▲ DipSik ▲"
Drag.TextColor3 = Color3.new(1, 0.5, 0)
Drag.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Drag.TextSize = 14
Drag.Size = UDim2.new(0.475, 0, 0.12, 0)  -- Исходный размер уменьшен в 2 раза
Drag.Position = UDim2.new(0.2625, 0, 0, 0)  -- Центрирование (0.5 - 0.475/2)
Drag.Parent = Frame

-- Сглаживание кнопки
local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 40)
dragCorner.Parent = Drag

-- Функция перетаскивания
local dragging = false
local dragInput, startPos

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch) then
        Frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + (input.Position.X - dragInput.X),
            startPos.Y.Scale, 
            startPos.Y.Offset + (input.Position.Y - dragInput.Y)
        )
    end
end)

Drag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragInput = input.Position
        startPos = Frame.Position
    end
end)

Drag.InputEnded:Connect(function()
    dragging = false
end)

-- ESP система (без изменений)
local espData = {}
local espConnections = {}

local function CleanupESP(player)
    if espData[player] then
        for _, drawing in pairs(espData[player]) do
            drawing.Visible = false
            drawing:Remove()
        end
        espData[player] = nil
    end
end

local function CreateESP(player)
    if espData[player] then return end
    
    local drawings = {
        Line = Drawing.new("Line"),
        Box = Drawing.new("Quad"),
        NameLabel = Drawing.new("Text")
    }
    
    for _, v in pairs(drawings) do
        v.Visible = false
        v.Color = Color3.new(1, 0.5, 0)
        v.Thickness = 1
    end
    
    drawings.NameLabel.Size = 18
    drawings.NameLabel.Center = true
    drawings.NameLabel.Outline = true
    
    espData[player] = drawings
    
    local function Update()
        if not player.Character then return end
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local position, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
        
        if onScreen then
            drawings.Line.From = Vector2.new(position.X, position.Y)
            drawings.Line.To = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, 0)
            
            local cf = rootPart.CFrame
            local size = rootPart.Size * 2
            local points = {
                cf * Vector3.new( size.X,  size.Y, 0),
                cf * Vector3.new(-size.X,  size.Y, 0),
                cf * Vector3.new(-size.X, -size.Y, 0),
                cf * Vector3.new( size.X, -size.Y, 0)
            }
            
            local screenPoints = {}
            for i = 1, 4 do
                local screenPos = workspace.CurrentCamera:WorldToViewportPoint(points[i])
                screenPoints[i] = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            drawings.Box.PointA = screenPoints[1]
            drawings.Box.PointB = screenPoints[2]
            drawings.Box.PointC = screenPoints[3]
            drawings.Box.PointD = screenPoints[4]
            
            drawings.NameLabel.Position = Vector2.new(position.X, position.Y - 40)
            drawings.NameLabel.Text = player.Name
            
            for _, v in pairs(drawings) do
                v.Visible = true
            end
        else
            for _, v in pairs(drawings) do
                v.Visible = false
            end
        end
    end
    
    local connection
    connection = RunService.RenderStepped:Connect(Update)
    
    table.insert(espConnections, connection)
    table.insert(espConnections, player.CharacterRemoving:Connect(function()
        CleanupESP(player)
        connection:Disconnect()
    end))
end

-- Активация ESP
ESPBtn.Size = UDim2.new(0.45, 0, 0.45, 0)
ESPBtn.Position = UDim2.new(0.03, 0, 0.15, 0)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.BackgroundColor3 = Color3.new(0.4, 0, 0)
ESPBtn.Parent = Frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = ESPBtn

local espActive = false

local function ToggleESP()
    espActive = not espActive
    ESPBtn.Text = "ESP: " .. (espActive and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = espActive and Color3.new(0, 0.5, 0) or Color3.new(0.4, 0, 0)
    
    if espActive then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end
        table.insert(espConnections, Players.PlayerAdded:Connect(CreateESP))
        table.insert(espConnections, Players.PlayerRemoving:Connect(CleanupESP))
    else
        for _, connection in ipairs(espConnections) do
            connection:Disconnect()
        end
        espConnections = {}
        
        for player in pairs(espData) do
            CleanupESP(player)
        end
    end
end

ESPBtn.Activated:Connect(ToggleESP)

-- Killaura функция
KillauraBtn.Size = UDim2.new(0.9, 0, 0.33, 0)
KillauraBtn.Position = UDim2.new(0.05, 0, 0.63, 0)
KillauraBtn.Text = "Killaura: OFF"
KillauraBtn.TextColor3 = Color3.new(1,1,1)
KillauraBtn.BackgroundColor3 = Color3.new(0.4, 0, 0)
KillauraBtn.Parent = Frame

local killauraCorner = btnCorner:Clone()
killauraCorner.Parent = KillauraBtn

local killauraActive = false
local killauraConnection

local function ToggleKillaura()
    killauraActive = not killauraActive
    KillauraBtn.Text = "Killaura: " .. (killauraActive and "ON" or "OFF")
    KillauraBtn.BackgroundColor3 = killauraActive and Color3.new(0, 0.5, 0) or Color3.new(0.4, 0, 0)
    
    if killauraActive then
        killauraConnection = RunService.Heartbeat:Connect(function()
            local myCharacter = LocalPlayer.Character
            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
            
            if myRoot then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local targetCharacter = player.Character
                        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                        local targetHumanoid = targetCharacter and targetCharacter:FindFirstChild("Humanoid")
                        
                        if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                            local distance = (myRoot.Position - targetRoot.Position).Magnitude
                            if distance < 20 then
                                myRoot.CFrame = targetRoot.CFrame
                            end
                        end
                    end
                end
            end
        end)
    else
        if killauraConnection then
            killauraConnection:Disconnect()
            killauraConnection = nil
        end
    end
end

KillauraBtn.Activated:Connect(ToggleKillaura)

-- High Jump функция
HighJumpBtn.Size = UDim2.new(0.45, 0, 0.45, 0)
HighJumpBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
HighJumpBtn.Text = "High Jump: OFF"
HighJumpBtn.TextColor3 = Color3.new(1,1,1)
HighJumpBtn.BackgroundColor3 = Color3.new(0.4, 0, 0)
HighJumpBtn.Parent = Frame

local jumpCorner = btnCorner:Clone()
jumpCorner.Parent = HighJumpBtn

local highJumpActive = false
local originalGravity = workspace.Gravity
local GRAVITY_MODIFIER = 0.4

local function ToggleHighJump()
    highJumpActive = not highJumpActive
    HighJumpBtn.Text = "High Jump: " .. (highJumpActive and "ON" or "OFF")
    HighJumpBtn.BackgroundColor3 = highJumpActive and Color3.new(0, 0.5, 0) or Color3.new(0.4, 0, 0)
    
    if highJumpActive then
        workspace.Gravity = originalGravity * GRAVITY_MODIFIER
    else
        workspace.Gravity = originalGravity
    end
end

HighJumpBtn.Activated:Connect(ToggleHighJump)

-- Автоматическое восстановление гравитации при удалении GUI
ModMenu.Destroying:Connect(function()
    workspace.Gravity = originalGravity
end)
