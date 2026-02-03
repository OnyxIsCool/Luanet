--// Loader
local AllowedPlaceIds = {
    [286090429] = "https://raw.githubusercontent.com/OnyxIsCool/Luanet/refs/heads/main/APIs/GengarArsenal_Script.lua"
}

local CurrentPlaceId = game.PlaceId
local ScriptURL = AllowedPlaceIds[CurrentPlaceId]

if not ScriptURL then
    warn("Game Invalid!")
    return
end

--// Services
local UIS = game:GetService("UserInputService")
local UserInputService = UIS

--// PandaAuth
local PandaAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnyxIsCool/Luanet/refs/heads/main/Key/PandaAuth.lua"))()
local auth = PandaAuth.new("claire")

local KEY_FILE = "claire_key.txt"

-- Instances
local CLI = {}

CLI.ScreenGui = Instance.new("ScreenGui")
CLI.ScreenGui.Parent = gethui()
CLI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

CLI.Frame = Instance.new("Frame", CLI.ScreenGui)
CLI.Frame.BorderSizePixel = 0
CLI.Frame.BackgroundColor3 = Color3.fromRGB(44,44,44)
CLI.Frame.Size = UDim2.new(0.48301,0,0.67906,0)
CLI.Frame.Position = UDim2.new(0.24751,0,0.08488,0)
Instance.new("UICorner", CLI.Frame)

CLI.Close = Instance.new("TextButton", CLI.Frame)
CLI.Close.Text = "X"
CLI.Close.Size = UDim2.new(0.13433,0,0.2,0)
CLI.Close.Position = UDim2.new(0.88557,0,-0.05833,0)
CLI.Close.BackgroundTransparency = 1
CLI.Close.TextColor3 = Color3.fromRGB(255,255,255)

CLI.Status = Instance.new("TextLabel", CLI.Frame)
CLI.Status.Text = ""
CLI.Status.BackgroundTransparency = 1
CLI.Status.TextColor3 = Color3.fromRGB(255,255,255)
CLI.Status.Size = UDim2.new(0.38308,0,0.14167,0)
CLI.Status.Position = UDim2.new(0.29353,0,0.26667,0)

CLI.Title = Instance.new("TextLabel", CLI.Frame)
CLI.Title.Text = "CLAIRE"
CLI.Title.BackgroundTransparency = 1
CLI.Title.TextColor3 = Color3.fromRGB(255,255,255)
CLI.Title.Size = UDim2.new(0.48259,0,0.21667,0)
CLI.Title.Position = UDim2.new(-0.1393,0,-0.06667,0)

CLI.Info = Instance.new("TextLabel", CLI.Frame)
CLI.Info.Text = "COMPLETE THE KEY SYSTEM TO ACCESS THE SCRIPT"
CLI.Info.BackgroundTransparency = 1
CLI.Info.TextColor3 = Color3.fromRGB(255,255,255)
CLI.Info.Size = UDim2.new(0.87065,0,0.08333,0)
CLI.Info.Position = UDim2.new(0.06468,0,0.21667,0)

CLI.Min = Instance.new("TextButton", CLI.Frame)
CLI.Min.Text = "-"
CLI.Min.BackgroundTransparency = 1
CLI.Min.TextColor3 = Color3.fromRGB(255,255,255)
CLI.Min.Size = UDim2.new(0.2,0,0.3,0)
CLI.Min.Position = UDim2.new(0.78607,0,-0.11667,0)

CLI.Box = Instance.new("TextBox", CLI.Frame)
CLI.Box.PlaceholderText = "-- Your key here"
CLI.Box.Text = ""
CLI.Box.Size = UDim2.new(0.71642,0,0.15,0)
CLI.Box.Position = UDim2.new(0.1393,0,0.46667,0)
CLI.Box.BackgroundColor3 = Color3.fromRGB(66,66,66)
CLI.Box.TextColor3 = Color3.fromRGB(255,255,255)
CLI.Box.TextWrapped = true
Instance.new("UICorner", CLI.Box)

CLI.GetKey = Instance.new("TextButton", CLI.Frame)
CLI.GetKey.Text = "Get Key"
CLI.GetKey.Size = UDim2.new(0.31343,0,0.19167,0)
CLI.GetKey.Position = UDim2.new(0.15423,0,0.68333,0)
CLI.GetKey.BackgroundColor3 = Color3.fromRGB(82,82,82)
CLI.GetKey.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CLI.GetKey)

CLI.Check = Instance.new("TextButton", CLI.Frame)
CLI.Check.Text = "Check Key"
CLI.Check.Size = UDim2.new(0.31343,0,0.19167,0)
CLI.Check.Position = UDim2.new(0.54726,0,0.68333,0)
CLI.Check.BackgroundColor3 = Color3.fromRGB(83,83,83)
CLI.Check.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CLI.Check)

Instance.new("UIAspectRatioConstraint", CLI.Frame).AspectRatio = 1.675

--// Toggle GUI
local MobileGui = Instance.new("ScreenGui", gethui())
MobileGui.Name = "MobileToggle"

local button = Instance.new("ImageButton", MobileGui)
button.Size = UDim2.fromOffset(42,42)
button.Position = UDim2.fromScale(0.5,0.5)
button.AnchorPoint = Vector2.new(0.5,0.5)
button.Image = "rbxassetid://7734091286"
button.Visible = true
button.BackgroundColor3 = Color3.fromRGB(20,20,20)
button.AutoButtonColor = false
Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)

local function ToggleKeySystem()
    CLI.ScreenGui.Enabled = not CLI.ScreenGui.Enabled
    MobileGui.Enabled = not CLI.ScreenGui.Enabled
end

button.MouseButton1Click:Connect(ToggleKeySystem)

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        ToggleKeySystem()
    end
end)

--// Draggable
local function MakeDraggable(gui)
    local dragging,startPos,dragStart
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)

    gui.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function()
        dragging = false
    end)
end

MakeDraggable(CLI.Frame)
MakeDraggable(button)

--// Check Key
CLI.Check.MouseButton1Click:Connect(function()
    local key = CLI.Box.Text
    if key == "" then
        CLI.Status.Text = "NO KEY!"
        return
    end

    CLI.Status.Text = "CHECKING..."
    local success,message = auth:validate(key)

    if success then
        if writefile then writefile(KEY_FILE,key) end
        CLI.Status.Text = "KEY VALID!"
        CLI.ScreenGui:Destroy()
        loadstring(game:HttpGet(ScriptURL))()
    else
        CLI.Status.Text = "INVALID KEY!"
        warn(message)
    end
end)

--// Get Key
CLI.GetKey.MouseButton1Click:Connect(function()
    local url = auth:copyKeyUrl()
    if url then
        CLI.Box.Text = url
        CLI.Status.Text = "LINK COPIED!"
    else
        CLI.Status.Text = "FAILED!"
    end
end)

--// Saved key
if isfile and not isfile(KEY_FILE) then
    writefile(KEY_FILE,"")
end

if isfile and readfile(KEY_FILE) ~= "" then
    local saved = readfile(KEY_FILE)
    local success = auth:validate(saved)
    if success then
        loadstring(game:HttpGet(ScriptURL))()
        CLI.ScreenGui:Destroy()
    end
end

CLI.Close.MouseButton1Click:Connect(function()
    CLI.ScreenGui:Destroy()
end)

CLI.Min.MouseButton1Click:Connect(ToggleKeySystem)


