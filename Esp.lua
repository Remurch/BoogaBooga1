-- ESP sistem
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

-- activation ESP
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
