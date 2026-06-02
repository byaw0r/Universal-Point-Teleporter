local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TopViewMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainButton = Instance.new("TextButton")
MainButton.Name = "MainButton"
MainButton.Parent = ScreenGui
MainButton.Size = UDim2.new(0, 50, 0, 50)
MainButton.Position = UDim2.new(0, 20, 0, 20)
MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainButton.BorderSizePixel = 0
MainButton.Text = ""
MainButton.AutoButtonColor = false
MainButton.ZIndex = 10

local MainButtonCorner = Instance.new("UICorner")
MainButtonCorner.CornerRadius = UDim.new(0, 8)
MainButtonCorner.Parent = MainButton

MainButton.MouseEnter:Connect(function()
    TweenService:Create(MainButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    }):Play()
end)

MainButton.MouseLeave:Connect(function()
    TweenService:Create(MainButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

local NoclipButton = Instance.new("TextButton")
NoclipButton.Name = "NoclipButton"
NoclipButton.Parent = ScreenGui
NoclipButton.Size = UDim2.new(0, 160, 0, 40)
NoclipButton.Position = UDim2.new(1, -180, 0.5, -90)
NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
NoclipButton.BorderSizePixel = 0
NoclipButton.Text = "Сквозь объекты: ВЫКЛ"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.TextSize = 14
NoclipButton.Font = Enum.Font.GothamBold
NoclipButton.AutoButtonColor = false
NoclipButton.Visible = false
NoclipButton.ZIndex = 10

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 8)
NoclipCorner.Parent = NoclipButton

local HeightFrame = Instance.new("Frame")
HeightFrame.Name = "HeightFrame"
HeightFrame.Parent = ScreenGui
HeightFrame.Size = UDim2.new(0, 160, 0, 40)
HeightFrame.Position = UDim2.new(1, -180, 0.5, -140)
HeightFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HeightFrame.BorderSizePixel = 0
HeightFrame.Visible = false
HeightFrame.ZIndex = 10

local HeightCorner = Instance.new("UICorner")
HeightCorner.CornerRadius = UDim.new(0, 8)
HeightCorner.Parent = HeightFrame

local HeightLabel = Instance.new("TextLabel")
HeightLabel.Name = "HeightLabel"
HeightLabel.Parent = HeightFrame
HeightLabel.Size = UDim2.new(0.55, 0, 1, 0)
HeightLabel.Position = UDim2.new(0, 8, 0, 0)
HeightLabel.BackgroundTransparency = 1
HeightLabel.Text = "Высота:"
HeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightLabel.TextSize = 14
HeightLabel.Font = Enum.Font.GothamBold
HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
HeightLabel.ZIndex = 11

local HeightInput = Instance.new("TextBox")
HeightInput.Name = "HeightInput"
HeightInput.Parent = HeightFrame
HeightInput.Size = UDim2.new(0.35, 0, 0.7, 0)
HeightInput.Position = UDim2.new(0.58, 0, 0.15, 0)
HeightInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
HeightInput.BorderSizePixel = 0
HeightInput.Text = "50"
HeightInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightInput.TextSize = 14
HeightInput.Font = Enum.Font.GothamBold
HeightInput.PlaceholderText = "50"
HeightInput.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
HeightInput.ZIndex = 11

local HeightInputCorner = Instance.new("UICorner")
HeightInputCorner.CornerRadius = UDim.new(0, 4)
HeightInputCorner.Parent = HeightInput

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = ScreenGui
TeleportBtn.Size = UDim2.new(0, 80, 0, 40)
TeleportBtn.Position = UDim2.new(1, -100, 0.5, -20)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Text = ""
TeleportBtn.AutoButtonColor = false
TeleportBtn.Visible = false
TeleportBtn.ZIndex = 10

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 10)
TeleportCorner.Parent = TeleportBtn

local TeleportIcon = Instance.new("TextLabel")
TeleportIcon.Name = "TeleportIcon"
TeleportIcon.Parent = TeleportBtn
TeleportIcon.Size = UDim2.new(1, 0, 1, 0)
TeleportIcon.BackgroundTransparency = 1
TeleportIcon.Text = "⬇"
TeleportIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportIcon.TextSize = 24
TeleportIcon.Font = Enum.Font.GothamBold
TeleportIcon.ZIndex = 11

local BeamVertical = nil
local BeamHorizontal = nil
local GlowPart = nil

local isTopView = false
local MIN_HEIGHT = 50
local cameraOffset = Vector3.new(0, MIN_HEIGHT, 0)
local targetPosition = nil
local noclipEnabled = false

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function createBeam()
    if BeamVertical then
        BeamVertical:Destroy()
        BeamVertical = nil
    end
    if BeamHorizontal then
        BeamHorizontal:Destroy()
        BeamHorizontal = nil
    end
    if GlowPart then
        GlowPart:Destroy()
        GlowPart = nil
    end
    
    BeamVertical = Instance.new("Part")
    BeamVertical.Name = "TeleportBeamVertical"
    BeamVertical.Shape = Enum.PartType.Cylinder
    BeamVertical.Size = Vector3.new(0.3, 100, 0.3)
    BeamVertical.Material = Enum.Material.Neon
    BeamVertical.BrickColor = BrickColor.new("Really red")
    BeamVertical.Transparency = 0.3
    BeamVertical.Anchored = true
    BeamVertical.CanCollide = false
    BeamVertical.Parent = Workspace
    
    BeamHorizontal = Instance.new("Part")
    BeamHorizontal.Name = "TeleportBeamHorizontal"
    BeamHorizontal.Shape = Enum.PartType.Cylinder
    BeamHorizontal.Size = Vector3.new(4, 0.3, 0.3)
    BeamHorizontal.Material = Enum.Material.Neon
    BeamHorizontal.BrickColor = BrickColor.new("Really red")
    BeamHorizontal.Transparency = 0.3
    BeamHorizontal.Anchored = true
    BeamHorizontal.CanCollide = false
    BeamHorizontal.Parent = Workspace
    
    GlowPart = Instance.new("Part")
    GlowPart.Name = "TeleportGlow"
    GlowPart.Shape = Enum.PartType.Cylinder
    GlowPart.Size = Vector3.new(6, 0.1, 6)
    GlowPart.Material = Enum.Material.Neon
    GlowPart.BrickColor = BrickColor.new("Really red")
    GlowPart.Transparency = 0.4
    GlowPart.Anchored = true
    GlowPart.CanCollide = false
    GlowPart.Parent = Workspace
end

local function updateBeamPosition()
    if not BeamVertical or not BeamHorizontal or not GlowPart then return end
    if not targetPosition then return end
    
    local camera = Workspace.CurrentCamera
    if not camera then return end
    
    local rayOrigin = targetPosition + Vector3.new(0, 500, 0)
    local rayDirection = Vector3.new(0, -1000, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {BeamVertical, BeamHorizontal, GlowPart}
    
    if noclipEnabled then
        raycastParams.FilterType = Enum.RaycastFilterType.Include
        raycastParams.FilterDescendantsInstances = {}
    end
    
    local success, raycastResult = pcall(function()
        return Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    end)
    
    local groundY = 0
    
    if success and raycastResult then
        groundY = raycastResult.Position.Y
    end
    
    local groundPosition = Vector3.new(targetPosition.X, groundY, targetPosition.Z)
    
    local beamHeight = 100
    local beamCenterY = groundY + beamHeight / 2
    
    BeamVertical.Size = Vector3.new(0.3, beamHeight, 0.3)
    BeamVertical.CFrame = CFrame.new(groundPosition.X, beamCenterY, groundPosition.Z)
    
    local crossHeight = groundY + 40
    BeamHorizontal.CFrame = CFrame.new(groundPosition.X, crossHeight, groundPosition.Z) * CFrame.Angles(0, 0, math.rad(90))
    
    GlowPart.CFrame = CFrame.new(groundPosition.X, groundY + 0.05, groundPosition.Z)
end

local function updateCamera()
    if not isTopView then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    if not targetPosition then
        targetPosition = character.HumanoidRootPart.Position
    end
    
    local camera = Workspace.CurrentCamera
    if camera then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(targetPosition + cameraOffset, targetPosition)
    end
    
    updateBeamPosition()
end

local function getWorldPosition(screenPosition)
    local camera = Workspace.CurrentCamera
    if not camera then return nil end
    
    local camPos = camera.CFrame.Position
    local ray = camera:ViewportPointToRay(screenPosition.X, screenPosition.Y)
    
    local character = player.Character
    local planeY = 0
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPos = character.HumanoidRootPart.Position
        
        local groundRayOrigin = rootPos + Vector3.new(0, 50, 0)
        local groundRayDirection = Vector3.new(0, -100, 0)
        local groundRaycastParams = RaycastParams.new()
        groundRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
        groundRaycastParams.FilterDescendantsInstances = {character}
        
        local success, groundResult = pcall(function()
            return Workspace:Raycast(groundRayOrigin, groundRayDirection, groundRaycastParams)
        end)
        
        if success and groundResult then
            planeY = groundResult.Position.Y
        end
    end
    
    local planeNormal = Vector3.new(0, 1, 0)
    local planePoint = Vector3.new(0, planeY, 0)
    
    local denom = ray.Direction:Dot(planeNormal)
    
    if math.abs(denom) < 0.0001 then
        return nil
    end
    
    local t = (planePoint - ray.Origin):Dot(planeNormal) / denom
    
    if t < 0 then
        return nil
    end
    
    local worldPos = ray.Origin + ray.Direction * t
    
    return Vector3.new(worldPos.X, planeY, worldPos.Z)
end

local function enableTopView()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    isTopView = true
    targetPosition = character.HumanoidRootPart.Position
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    
    createBeam()
    
    TeleportBtn.Visible = true
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    NoclipButton.Visible = true
    HeightFrame.Visible = true
    
    MainButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    updateCamera()
end

local function disableTopView()
    isTopView = false
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    
    TeleportBtn.Visible = false
    NoclipButton.Visible = false
    HeightFrame.Visible = false
    
    if BeamVertical then
        BeamVertical:Destroy()
        BeamVertical = nil
    end
    if BeamHorizontal then
        BeamHorizontal:Destroy()
        BeamHorizontal = nil
    end
    if GlowPart then
        GlowPart:Destroy()
        GlowPart = nil
    end
    
    MainButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local camera = Workspace.CurrentCamera
    if camera then
        camera.CameraType = Enum.CameraType.Custom
    end
    
    targetPosition = nil
end

mouse.Button1Down:Connect(function()
    if not isTopView then return end
    
    if mouse.Target and mouse.Target:IsDescendantOf(ScreenGui) then
        return
    end
    
    local worldPos = getWorldPosition(Vector2.new(mouse.X, mouse.Y))
    if worldPos then
        targetPosition = worldPos
    end
end)

UserInputService.TouchStarted:Connect(function(input, gameProcessed)
    if not isTopView or not isMobile then return end
    
    local guiObjects = game.CoreGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
    for _, obj in ipairs(guiObjects) do
        if obj:IsDescendantOf(ScreenGui) and obj ~= ScreenGui then
            return
        end
    end
    
    local worldPos = getWorldPosition(input.Position)
    if worldPos then
        targetPosition = worldPos
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        NoclipButton.Text = "Сквозь объекты: ВКЛ"
    else
        NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        NoclipButton.Text = "Сквозь объекты: ВЫКЛ"
    end
    
    updateBeamPosition()
end)

HeightInput.FocusLost:Connect(function(enterPressed)
    local newHeight = tonumber(HeightInput.Text)
    if newHeight then
        if newHeight < MIN_HEIGHT then
            cameraOffset = Vector3.new(0, MIN_HEIGHT, 0)
            HeightInput.Text = tostring(MIN_HEIGHT)
        else
            cameraOffset = Vector3.new(0, newHeight, 0)
            HeightInput.Text = tostring(newHeight)
        end
    else
        HeightInput.Text = tostring(cameraOffset.Y)
    end
end)

MainButton.MouseButton1Click:Connect(function()
    if isTopView then
        disableTopView()
    else
        enableTopView()
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if isTopView and targetPosition then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rayOrigin = targetPosition + Vector3.new(0, 100, 0)
            local rayDirection = Vector3.new(0, -200, 0)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = {character}
            
            if noclipEnabled then
                raycastParams.FilterType = Enum.RaycastFilterType.Include
                raycastParams.FilterDescendantsInstances = {}
            end
            
            local success, raycastResult = pcall(function()
                return Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            end)
            
            if success and raycastResult then
                character.HumanoidRootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
            else
                character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
            end
        end
        
        disableTopView()
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    if isTopView then
        updateCamera()
    end
end)

player.CharacterAdded:Connect(function(character)
    if isTopView then
        disableTopView()
    end
end)
