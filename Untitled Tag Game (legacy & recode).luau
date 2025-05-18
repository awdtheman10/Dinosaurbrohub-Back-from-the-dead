-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
UserInputService.MouseIconEnabled = true
mouse.Icon = ""
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Untitled Tag Game",
   LoadingTitle = "Dinosaurbrohub",
   LoadingSubtitle = "by awdtheman11",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "dh"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})
local unsafeRoles = {
    "FFATagger",
    "Dead",
    "Infected",
    "Peasant",
    "Freezer"
}
local TagTab = Window:CreateTab("Tagging", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local constantWalkspeed = false
local lastWalkspeed = 16
local Slider = PlayerTab:CreateSlider({
    Name = "Walkspeed",
    Range = {16, 50},
    Increment = 2,
    Suffix = " Walkspeed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        lastWalkspeed = Value
        if not constantWalkspeed then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end,
})
local Toggle = PlayerTab:CreateToggle({
    Name = "Constant Walkspeed",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        constantWalkspeed = Value
    end,
})
RunService.RenderStepped:Connect(function()
    if constantWalkspeed then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= lastWalkspeed then
            humanoid.WalkSpeed = lastWalkspeed
        end
    end
end)
local TagAllButton = TagTab:CreateButton({
    Name = "Tag all",
    Callback = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local originalCFrame = hrp.CFrame
        local role = LocalPlayer:FindFirstChild("PlayerRole")
        if not role or not table.find(unsafeRoles, role.Value) then
            warn("Must be a tagger to use tag all.")
            return
        end
        local function simulateClick()
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait()
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetRole = target:FindFirstChild("PlayerRole")
                if targetRole and targetRole:IsA("StringValue") and table.find(unsafeRoles, targetRole.Value) then
                    continue
                end
                local targetHRP = target.Character.HumanoidRootPart
                local followTime = 1.7
                local startTime = tick()
                while tick() - startTime < followTime do
                    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
                        break
                    end
                    local currentTargetHRP = target.Character.HumanoidRootPart
                    local newPos = currentTargetHRP.Position + Vector3.new(0, 2, 0)
                    local faceDirection = Vector3.new(currentTargetHRP.Position.X, hrp.Position.Y, hrp.Position.Z)
                    hrp.CFrame = CFrame.new(newPos, faceDirection)
                    task.wait()
                end
                task.wait(0.5)
                simulateClick()
                for _, d in ipairs(target.Character:GetDescendants()) do
                    if d:IsA("ClickDetector") then
                        fireclickdetector(d)
                        break
                    end
                end
            end
        end

        hrp.CFrame = originalCFrame
    end,
})


local SnagCrownButton = TagTab:CreateButton({
    Name = "Snag crown (CROWN GAMEMODE ONLY)",
    Callback = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local originalCFrame = hrp.CFrame
        local function simulateClick()
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait()
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        local function createPlatformAndNotify()
            local platform = Instance.new("Part")
            platform.Size = Vector3.new(500, 1, 500)
            platform.Anchored = true
            platform.CanCollide = true
            platform.Transparency = 0.75
            platform.Position = hrp.Position + Vector3.new(0, 250, 0)
            platform.Name = "CrownSafePlatform"
            platform.Parent = workspace
            hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 5, 0))
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Name = "CrownMessage"
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Size = UDim2.new(0.6, 0, 0.1, 0)
            TextLabel.Position = UDim2.new(0.2, 0, 0.45, 0)
            TextLabel.BackgroundTransparency = 0.3
            TextLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextScaled = true
            TextLabel.Text = "Stay up here."
            TextLabel.Parent = ScreenGui
            wait(3)
            TextLabel:Destroy()
        end
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local role = target:FindFirstChild("PlayerRole")
                if role and role:IsA("StringValue") and role.Value == "Crown" then
                    local targetHRP = target.Character.HumanoidRootPart
                    local followTime = 1.8
                    local startTime = tick()
                    while tick() - startTime < followTime do
                        if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
                            break
                        end
                        local currentTargetHRP = target.Character.HumanoidRootPart
                        local newPos = currentTargetHRP.Position + Vector3.new(0, 2, 0)
                        local faceDirection = Vector3.new(currentTargetHRP.Position.X, hrp.Position.Y, hrp.Position.Z)
                        hrp.CFrame = CFrame.new(newPos, faceDirection)
                        task.wait()
                    end
                    task.wait(0.5)
                    simulateClick()
                    createPlatformAndNotify()
                    return
                end
            end
        end
        hrp.CFrame = originalCFrame
    end,
})
