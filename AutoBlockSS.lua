local animIDs = {
    ["RightSwing"] = 12625839385,
    ["OverheadSwing"] = 12625841878,
    ["LeftSwing"] = 12625843823,
    ["BackLeftSwing"] = 12625846167,
    ["FrontRightSwing"] = 12625848489,
    ["BackRightSwing"] = 12625851115,
    ["FrontLeftSwing"] = 12625853257,
    ["RightBlock"] = 12625856098,
    ["LeftBlock"] = 12625858434,
    ["FrontLeftBlock"] = 12625860439,
    ["FrontRightBlock"] = 12625862519,
    ["FrontBlock"] = 12625864413,
    ["BackLeftBlock"] = 12625866538,
    ["BackRightBlock"] = 12625868684,
    ["Grab"] = 12625870437,
    ["Slap"] = 12625891544,
    ["SlappedLegs"] = 12671715182,
    ["SlappedArms"] = 12625896358,
    ["KickUp"] = 12625897944,
    ["KickBack"] = 12625899752,
    ["LeftRoll"] = 12625901874,
    ["RightRoll"] = 12625904322,
    ["Aerial"] = 12625908201,
    ["Idle"] = 13956175510,
    ["Throw"] = 12626569448,
    ["ForcePush"] = 12645928786,
    ["CrouchWalkRight"] = 12699256551,
    ["CrouchWalkLeft"] = 12699989478,
    ["CrouchWalkBack"] = 12699390244,
    ["CrouchWalkForward"] = 12699464592,
    ["FrontRoll"] = 12708915962,
    ["RightCrouchRoll"] = 12713661639,
    ["LeftCrouchRoll"] = 12713663289,
    ["Kata"] = 12735531097,
    ["Choking"] = 12814275189,
    ["Choke"] = 12815930160,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LightsaberRemotes = ReplicatedStorage:WaitForChild("LightsaberRemotes")
local BlockRemote = LightsaberRemotes:WaitForChild("Block")
local UnblockRemote = LightsaberRemotes:WaitForChild("Unblock")

local ESP_COLOR = Color3.new(1, 0, 0)
local OUTLINE_THICKNESS = 3

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Saber Showdown GUI",
    LoadingTitle = "Saber Showdown Auto Block",
    LoadingSubtitle = "Created By xenon9012",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SaberShowdownConfig",
        FileName = "Config"
    },
    KeySystem = false,
})

local ESPTab = Window:CreateTab("ESP Settings", 4483362458)
local AutoBlockTab = Window:CreateTab("Auto Block", 4483362458)
local AutoCounterTab = Window:CreateTab("Auto Counter", 4483362458)
local HitboxExtenderTab = Window:CreateTab("Hitbox Extender", 4483362458)
local creditsTab = Window:CreateTab("Credits", 4483362458)

local Section = ESPTab:CreateSection("ESP Config")

local espEnabled = true
local autoBlockEnabled = true
local autoCounterEnabled = false
local autoHalfSwingEnabled = false
local hitboxExtenderEnabled = false
local espOutlineColor = Color3.new(1, 1, 1)
local espNameColor = Color3.new(1, 0, 0)
local espDistance = 100
local blockDistance = 20
local autoSlapDistance = 10
local rainbowESPEnabled = false
local highlightThickness = 0.5
local slapTimerEnabled = true
local slapTimerColor = Color3.new(0, 1, 0)
local autoHalfSwingDelay = 0.3
local headSize = Vector3.new(1, 1, 1)
local humanoidRootPartSize = Vector3.new(8, 8, 8)

local function updateESPColors()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local espObjects = player.Character:FindFirstChild("ESPObjects")
            if espObjects then
                local highlight = espObjects:FindFirstChild("Highlight")
                local nameESP = espObjects:FindFirstChild("NameESP")
                if highlight then
                    highlight.OutlineColor = espOutlineColor
                    highlight.OutlineTransparency = 1 - highlightThickness
                end
                if nameESP then
                    nameESP.Color = espNameColor
                end
            end
        end
    end
end

local Toggle = ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = espEnabled,
    Flag = "ESPToggle",
    Callback = function(Value)
        espEnabled = Value
    end,
})

local RainbowToggle = ESPTab:CreateToggle({
    Name = "Rainbow Outline ESP",
    CurrentValue = rainbowESPEnabled,
    Flag = "RainbowESPToggle",
    Callback = function(Value)
        rainbowESPEnabled = Value
    end,
})

local SlapTimerToggle = ESPTab:CreateToggle({
    Name = "Enable Slap Timer",
    CurrentValue = slapTimerEnabled,
    Flag = "SlapTimerToggle",
    Callback = function(Value)
        slapTimerEnabled = Value
    end,
})

local ColorPicker1 = ESPTab:CreateColorPicker({
    Name = "ESP Outline Color",
    Color = espOutlineColor,
    Flag = "ESPOutlineColor",
    Callback = function(Value)
        espOutlineColor = Value
        updateESPColors()
    end,
})

local ColorPicker2 = ESPTab:CreateColorPicker({
    Name = "ESP Name Color",
    Color = espNameColor,
    Flag = "ESPNameColor",
    Callback = function(Value)
        espNameColor = Value
        updateESPColors()
    end,
})

local Slider1 = ESPTab:CreateSlider({
    Name = "ESP Distance",
    Range = {0, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = espDistance,
    Flag = "ESPDistance",
    Callback = function(Value)
        espDistance = Value
    end,
})

local Slider3 = ESPTab:CreateSlider({
    Name = "Highlight Thickness",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = highlightThickness,
    Flag = "HighlightThickness",
    Callback = function(Value)
        highlightThickness = Value
        updateESPColors()
    end,
})

local SlapTimerColorPicker = ESPTab:CreateColorPicker({
    Name = "Slap Timer Color",
    Color = slapTimerColor,
    Flag = "SlapTimerColor",
    Callback = function(Value)
        slapTimerColor = Value
    end,
})

local Toggle2 = AutoBlockTab:CreateToggle({
    Name = "Enable Auto Block",
    CurrentValue = autoBlockEnabled,
    Flag = "AutoBlockToggle",
    Callback = function(Value)
        autoBlockEnabled = Value
    end,
})

local Slider2 = AutoBlockTab:CreateSlider({
    Name = "Block Distance",
    Range = {0, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = blockDistance,
    Flag = "BlockDistance",
    Callback = function(Value)
        blockDistance = Value
    end,
})

local AutoCounterToggle = AutoCounterTab:CreateToggle({
    Name = "Enable Auto Slap",
    CurrentValue = autoCounterEnabled,
    Flag = "AutoCounterToggle",
    Callback = function(Value)
        autoCounterEnabled = Value
    end,
})

local AutoHalfSwingToggle = AutoCounterTab:CreateToggle({
    Name = "Auto Half Swing",
    CurrentValue = autoHalfSwingEnabled,
    Flag = "AutoHalfSwingToggle",
    Callback = function(Value)
        autoHalfSwingEnabled = Value
    end,
})

local AutoHalfSwingSlider = AutoCounterTab:CreateSlider({
    Name = "Auto Half Swing Delay",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "secs",
    CurrentValue = autoHalfSwingDelay,
    Flag = "AutoHalfSwingDelay",
    Callback = function(Value)
        autoHalfSwingDelay = Value
    end,
})

local AutoSlapDistanceSlider = AutoCounterTab:CreateSlider({
    Name = "Auto Slap Distance",
    Range = {0, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = autoSlapDistance,
    Flag = "AutoSlapDistance",
    Callback = function(Value)
        autoSlapDistance = Value
    end,
})

local HitboxExtenderToggle = HitboxExtenderTab:CreateToggle({
    Name = "Enable Hitbox Extender",
    CurrentValue = hitboxExtenderEnabled,
    Flag = "HitboxExtenderToggle",
    Callback = function(Value)
        hitboxExtenderEnabled = Value
    end,
})

local HeadSizeSlider = HitboxExtenderTab:CreateSlider({
    Name = "Head Size (CURRENTLY BROKEN)",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = headSize.X,
    Flag = "HeadSize",
    Callback = function(Value)
        headSize = Vector3.new(Value, Value, Value)
    end,
})

local HumanoidRootPartSizeSlider = HitboxExtenderTab:CreateSlider({
    Name = "HumanoidRootPart Size",
    Range = {1, 20},
    Increment = 1,
    Suffix = "",
    CurrentValue = humanoidRootPartSize.X,
    Flag = "HumanoidRootPartSize",
    Callback = function(Value)
        humanoidRootPartSize = Vector3.new(Value, Value, Value)
    end,
})

local function createPlayerESP(player)
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESPObjects"
    espFolder.Parent = player.Character

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = espOutlineColor
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 1 - highlightThickness
    highlight.Adornee = player.Character
    highlight.Parent = espFolder

    local nameESP = Drawing.new("Text")
    nameESP.Visible = false
    nameESP.Center = true
    nameESP.Outline = true
    nameESP.Font = 2
    nameESP.Size = 13
    nameESP.Color = espNameColor

    local healthBar = Drawing.new("Line")
    healthBar.Visible = false
    healthBar.Thickness = 2
    healthBar.Color = Color3.new(0, 1, 0)

    local slapTimerESP = Drawing.new("Text")
    slapTimerESP.Visible = false
    slapTimerESP.Center = true
    slapTimerESP.Outline = true
    slapTimerESP.Font = 2
    slapTimerESP.Size = 13
    slapTimerESP.Color = slapTimerColor

    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local rootPart = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            local distance = (rootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
            
            if onScreen and distance <= espDistance and espEnabled then
                nameESP.Text = string.format("%s [%.1f]", player.Name, distance)
                nameESP.Position = Vector2.new(vector.X, vector.Y - 40)
                nameESP.Visible = true

                local healthPercentage = humanoid.Health / humanoid.MaxHealth
                healthBar.From = Vector2.new(vector.X + 50, vector.Y - 20)
                healthBar.To = Vector2.new(vector.X + 50, vector.Y - 20 + 40 * healthPercentage)
                healthBar.Color = Color3.new(1 - healthPercentage, healthPercentage, 0)
                healthBar.Visible = true

                highlight.Enabled = true

                if rainbowESPEnabled then
                    local hue = (tick() % 5) / 5
                    local rainbowColor = Color3.fromHSV(hue, 1, 1)
                    highlight.OutlineColor = rainbowColor
                    nameESP.Color = rainbowColor
                else
                    highlight.OutlineColor = espOutlineColor
                    nameESP.Color = espNameColor
                end
                highlight.OutlineTransparency = 1 - highlightThickness

                if slapTimerEnabled then
                    slapTimerESP.Position = Vector2.new(vector.X, vector.Y + 20)
                    slapTimerESP.Visible = true
                else
                    slapTimerESP.Visible = false
                end
            else
                nameESP.Visible = false
                healthBar.Visible = false
                highlight.Enabled = false
                slapTimerESP.Visible = false
            end
        else
            nameESP.Visible = false
            healthBar.Visible = false
            highlight.Enabled = false
            slapTimerESP.Visible = false
        end
    end)

    return {nameESP, healthBar, highlight, slapTimerESP}
end

local function scaleHitbox(character)
    if character then
        local head = character:FindFirstChild("Head")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if head then
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(headSize.X / head.Size.X, headSize.Y / head.Size.Y, headSize.Z / head.Size.Z)
            else
                local newMesh = Instance.new("SpecialMesh", head)
                newMesh.Scale = Vector3.new(headSize.X / head.Size.X, headSize.Y / head.Size.Y, headSize.Z / head.Size.Z)
            end
            head.Size = headSize
            head.CanCollide = false
        end

        if humanoidRootPart then
            humanoidRootPart.Size = humanoidRootPartSize
            humanoidRootPart.Transparency = 0.7
            humanoidRootPart.BrickColor = BrickColor.new("Really blue")
            humanoidRootPart.Material = "Neon"
            humanoidRootPart.CanCollide = false
        end
    end
end

local function resetHitbox(character)
    if character then
        local head = character:FindFirstChild("Head")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if head then
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh:Destroy()
            end
            head.Size = Vector3.new(2, 1, 1) -- Default head size
            head.CanCollide = true
        end

        if humanoidRootPart then
            humanoidRootPart.Size = Vector3.new(2, 2, 1) -- Default HumanoidRootPart size
            humanoidRootPart.Transparency = 0
            humanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
            humanoidRootPart.Material = "Plastic"
            humanoidRootPart.CanCollide = true
        end
    end
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    local player = Players:GetPlayerFromCharacter(character)
    
    local espObjects = createPlayerESP(player)
    local slapTimerESP = espObjects[4]
    local canSlap = true
    
    humanoid.AnimationPlayed:Connect(function(animTrack)
        for animName, animId in pairs(animIDs) do
            if animTrack.Animation.AnimationId == "rbxassetid://" .. animId then
                print(player.Name .. " used animation: " .. animName)
                
                if animName == "Slap" and slapTimerEnabled then
                    canSlap = false
                    local startTime = tick()
                    
                    task.spawn(function()
                        while tick() - startTime < 3 and slapTimerEnabled do
                            local timeLeft = math.ceil(3 - (tick() - startTime))
                            slapTimerESP.Text = string.format("%d cannot slap", timeLeft)
                            slapTimerESP.Color = slapTimerColor
                            slapTimerESP.Visible = true
                            task.wait(0.1)
                        end
                        
                        canSlap = true
                        slapTimerESP.Text = "Can slap"
                        slapTimerESP.Color = Color3.new(1, 0, 0)
                        slapTimerESP.Visible = true
                    end)
                end
                
                if (animName:find("Swing") or animName == "Slap") and autoBlockEnabled then
                    local localPlayer = Players.LocalPlayer
                    local localCharacter = localPlayer.Character
                    if localCharacter then
                        local localPosition = localCharacter.PrimaryPart.Position
                        local playerPosition = player.Character.PrimaryPart.Position
                        local distance = (playerPosition - localPosition).Magnitude
                        
                        if distance < blockDistance then 
                            BlockRemote:FireServer()
                            
                            task.wait(animTrack.Length)
                            
                            UnblockRemote:FireServer()
                            
                            if autoCounterEnabled and animName == "Slap" then
                                if distance < autoSlapDistance then
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    task.wait(0.1)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                end
                            end
                        end
                    end
                end
                
                if animName:find("Swing") and player == Players.LocalPlayer and autoHalfSwingEnabled then
                    task.delay(autoHalfSwingDelay, function()
                        mouse1click()
                    end)
                end
                
                break
            end
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        if player.Character then
            onCharacterAdded(player.Character)
        end
        player.CharacterAdded:Connect(onCharacterAdded)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        player.CharacterAdded:Connect(onCharacterAdded)
    end
end)

local creditsSection = creditsTab:CreateSection("Credits")

local creditsText = {
    "Created by xenon90 on discord",
    "If any other comissions are needed then feel free to contact me",
    "Most of my scripts are free that i make due to it being for experience",
    "Whoever made the hitbox expander please contact me so i can give you a credit"
}

for _, text in ipairs(creditsText) do
    creditsTab:CreateLabel(text)
end

Rayfield:LoadConfiguration()

-- Implementing Hitbox Extender
_G.HeadSize = headSize -- Adjust this value as needed
_G.HumanoidRootPartSize = humanoidRootPartSize -- Adjust this value as needed
_G.Disabled = false

local localPlayer = game:GetService('Players').LocalPlayer

local function resizeParts(character)
    local head = character:FindFirstChild("Head")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if not head then
        -- Create a new head if it doesn't exist
        local newHead = Instance.new("Part")
        newHead.Name = "Head"
        newHead.Size = _G.HeadSize
        newHead.Parent = character
    else
        head.Size = _G.HeadSize
        head.CanCollide = false -- Disable collision for the head
    end

    if humanoidRootPart then
        humanoidRootPart.Size = _G.HumanoidRootPartSize
    end
end

local function onCharacterAddedExtended(character)
    -- Call the original onCharacterAdded function
    onCharacterAdded(character)

    -- Resize parts
    resizeParts(character)

    -- Connect to Humanoid's Died event to handle respawn
    character:WaitForChild("Humanoid").Died:Connect(function()
        -- Wait for the character to respawn
        character:WaitForChild("Humanoid").Died:Wait()

        -- Resize parts again after respawn
        resizeParts(character)
    end)
end

local function onPlayerAdded(player)
    -- Check if the player is not the local player
    if player ~= localPlayer then
        -- Connect to the CharacterAdded event
        player.CharacterAdded:Connect(onCharacterAddedExtended)

        -- Apply resizing if the character already exists
        if player.Character then
            onCharacterAddedExtended(player.Character)
        end
    end
end

-- Connect to the PlayerAdded event to handle players joining the game
game:GetService('Players').PlayerAdded:Connect(onPlayerAdded)

-- Apply resizing to all current players
for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
    onPlayerAdded(player)
end

-- Continuous loop to ensure hitboxes remain scaled
game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then
        for _, player in pairs(game:GetService('Players'):GetPlayers()) do
            if player ~= localPlayer then
                pcall(function() 
                    if hitboxExtenderEnabled then
                        scaleHitbox(player.Character)
                        -- Ensure head size is maintained
                        if player.Character and player.Character:FindFirstChild("Head") then
                            player.Character.Head.Size = _G.HeadSize
                            player.Character.Head.CanCollide = false -- Disable collision for the head
                        end
                    else
                        resetHitbox(player.Character)
                    end
                end)
            end
        end
    end
end)

-- Disable collision with the local player's character
local function disableCollision(character)
    character.ChildAdded:Connect(function(part)
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end)
end

localPlayer.CharacterAdded:Connect(disableCollision)

if localPlayer.Character then
    disableCollision(localPlayer.Character)
end
