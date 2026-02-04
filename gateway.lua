--// Loader
local AllowedPlaceIds = {
    [286090429] = "https://raw.githubusercontent.com/OnyxIsCool/Luanet/refs/heads/main/APIs/GengarArsenal_Script.lua", -- Arsenal
	[6403373529] = "https://raw.githubusercontent.com/OnyxIsCool/Luanet/refs/heads/main/APIs/Gengar_ScriptSB.lua" -- Slap Battles
}

local CurrentPlaceId = game.PlaceId
local ScriptURL = AllowedPlaceIds[CurrentPlaceId]

if not ScriptURL then
    warn("Game Invalid!")
    return
end

--// Services
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = UIS

--// PandaAuth
local PandaAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnyxIsCool/Luanet/refs/heads/main/Key/PandaAuth.lua"))()
local auth = PandaAuth.new("claire")

local KEY_FILE = "claire_key.txt"

-- Instances
local CLI = {}

CLI["ScreenGui_1"] = Instance.new("ScreenGui")
CLI["ScreenGui_1"].Parent = PlayerGui
CLI["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

CLI["Frame_2"] = Instance.new("Frame", CLI["ScreenGui_1"])
CLI["Frame_2"].BorderSizePixel = 0
CLI["Frame_2"].BackgroundColor3 = Color3.fromRGB(44,44,44)
CLI["Frame_2"].Size = UDim2.new(0.48301,0,0.67906,0)
CLI["Frame_2"].Position = UDim2.new(0.24751,0,0.08488,0)

Instance.new("UICorner", CLI["Frame_2"])

CLI["TextButton2_4"] = Instance.new("TextButton", CLI["Frame_2"])
CLI["TextButton2_4"].Text = "X"
CLI["TextButton2_4"].Size = UDim2.new(0.13433,0,0.2,0)
CLI["TextButton2_4"].Position = UDim2.new(0.88557,0,-0.05833,0)
CLI["TextButton2_4"].BackgroundTransparency = 1
CLI["TextButton2_4"].TextColor3 = Color3.fromRGB(255,255,255)

CLI["TextLabel4_5"] = Instance.new("TextLabel", CLI["Frame_2"])
CLI["TextLabel4_5"].Text = ""
CLI["TextLabel4_5"].BackgroundTransparency = 1
CLI["TextLabel4_5"].TextColor3 = Color3.fromRGB(255,255,255)
CLI["TextLabel4_5"].Size = UDim2.new(0.38308,0,0.14167,0)
CLI["TextLabel4_5"].Position = UDim2.new(0.29353,0,0.26667,0)

CLI["TextLabel_6"] = Instance.new("TextLabel", CLI["Frame_2"])
CLI["TextLabel_6"].Text = "CLAIRE"
CLI["TextLabel_6"].BackgroundTransparency = 1
CLI["TextLabel_6"].TextColor3 = Color3.fromRGB(255,255,255)
CLI["TextLabel_6"].Size = UDim2.new(0.48259,0,0.21667,0)
CLI["TextLabel_6"].Position = UDim2.new(-0.1393,0,-0.06667,0)

CLI["TextLabel3_7"] = Instance.new("TextLabel", CLI["Frame_2"])
CLI["TextLabel3_7"].Text = "COMPLETE THE KEY SYSTEM TO ACCESS THE SCRIPT"
CLI["TextLabel3_7"].BackgroundTransparency = 1
CLI["TextLabel3_7"].TextColor3 = Color3.fromRGB(255,255,255)
CLI["TextLabel3_7"].Size = UDim2.new(0.87065,0,0.08333,0)
CLI["TextLabel3_7"].Position = UDim2.new(0.06468,0,0.21667,0)

CLI["TextButton_8"] = Instance.new("TextButton", CLI["Frame_2"])
CLI["TextButton_8"].Text = "-"
CLI["TextButton_8"].BackgroundTransparency = 1
CLI["TextButton_8"].TextColor3 = Color3.fromRGB(255,255,255)
CLI["TextButton_8"].Size = UDim2.new(0.2,0,0.3,0)
CLI["TextButton_8"].Position = UDim2.new(0.78607,0,-0.11667,0)

CLI["TextBox_9"] = Instance.new("TextBox", CLI["Frame_2"])
CLI["TextBox_9"].PlaceholderText = "-- Your key here"
CLI["TextBox_9"].Text = ""
CLI["TextBox_9"].Size = UDim2.new(0.71642,0,0.15,0)
CLI["TextBox_9"].Position = UDim2.new(0.1393,0,0.46667,0)
CLI["TextBox_9"].BackgroundColor3 = Color3.fromRGB(66,66,66)
CLI["TextBox_9"].TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CLI["TextBox_9"])

CLI["TextButton_b"] = Instance.new("TextButton", CLI["Frame_2"])
CLI["TextButton_b"].Text = "Get Key"
CLI["TextButton_b"].Size = UDim2.new(0.31343,0,0.19167,0)
CLI["TextButton_b"].Position = UDim2.new(0.15423,0,0.68333,0)
CLI["TextButton_b"].BackgroundColor3 = Color3.fromRGB(82,82,82)
CLI["TextButton_b"].TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CLI["TextButton_b"])

CLI["TextButton_d"] = Instance.new("TextButton", CLI["Frame_2"])
CLI["TextButton_d"].Text = "Check Key"
CLI["TextButton_d"].Size = UDim2.new(0.31343,0,0.19167,0)
CLI["TextButton_d"].Position = UDim2.new(0.54726,0,0.68333,0)
CLI["TextButton_d"].BackgroundColor3 = Color3.fromRGB(83,83,83)
CLI["TextButton_d"].TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CLI["TextButton_d"])

Instance.new("UIAspectRatioConstraint", CLI["Frame_2"]).AspectRatio = 1.675

--// Toggle GUI
local MobileGui = Instance.new("ScreenGui", PlayerGui)
MobileGui.Name = "MobileToggle"

local button = Instance.new("ImageButton", MobileGui)
button.Size = UDim2.fromOffset(42,42)
button.Position = UDim2.fromScale(0.5,0.5)
button.AnchorPoint = Vector2.new(0.5,0.5)
button.Image = "rbxassetid://7734091286"
button.Visible = false
button.BackgroundColor3 = Color3.fromRGB(20,20,20)
button.AutoButtonColor = false

Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", button).Color = Color3.fromRGB(40,40,40)

--// Toggle function
local function ToggleKeySystem()
	CLI["ScreenGui_1"].Enabled = not CLI["ScreenGui_1"].Enabled
	MobileGui.Enabled = not CLI["ScreenGui_1"].Enabled
end

button.MouseButton1Click:Connect(ToggleKeySystem)

UserInputService.InputBegan:Connect(function(input,gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.K then
		ToggleKeySystem()
	end
end)

--// Draggable
local function MakeDraggable(guiObject)
	local dragging=false
	local dragStart,startPos

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			dragStart=input.Position
			startPos=guiObject.Position
		end
	end)

	guiObject.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-dragStart
			guiObject.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function()
		dragging=false
	end)
end

MakeDraggable(CLI["Frame_2"])
MakeDraggable(button)

--// Button Functions
CLI["TextButton_d"].MouseButton1Click:Connect(function()
    local key = CLI["TextBox_9"].Text

    if key == "" then
        CLI["TextLabel4_5"].Text = "NO KEY!"
        return
    end

    CLI["TextLabel4_5"].Text = "CHECKING..."

    local success, message = auth.validate(key)

    if success then
        writefile(KEY_FILE, key)
        CLI["TextLabel4_5"].Text = "KEY VALID & SAVED!"
        print("[PandaAuth]", message)
        CLI["ScreenGui_1"]:Destroy()
        loadstring(game:HttpGet(ScriptURL))()
        print("Working")
    else
        CLI["TextLabel4_5"].Text = "INVALID KEY!"
        warn("[PandaAuth]", message)
    end
end)

CLI["TextButton_b"].MouseButton1Click:Connect(function()
    local url = auth.copyKeyUrl()

    if url then
        CLI["TextLabel4_5"].Text = "LINK COPIED!"
        CLI["TextBox_9"].Text = url
        print("Get your key here:", url)
    else
        CLI["TextLabel4_5"].Text = "FAILED!"
    end
end)

--// Save Key System
if not isfile(KEY_FILE) then
    writefile(KEY_FILE, "")
end

local savedKey = readfile(KEY_FILE)

if savedKey ~= "" then
    CLI["TextBox_9"].Text = savedKey
    CLI["TextLabel4_5"].Text = "CHECKING SAVED KEY..."

    local success, message = auth.validate(savedKey)

    if success then
        CLI["TextLabel4_5"].Text = "KEY VALID (SAVED)!"
        loadstring(game:HttpGet(ScriptURL))()
        CLI["ScreenGui_1"]:Destroy()
        print("Working")
    else
        CLI["TextLabel4_5"].Text = "SAVED KEY INVALID!"
    end
end

--// Close button
CLI["TextButton2_4"].MouseButton1Click:Connect(function()
	CLI["ScreenGui_1"]:Destroy()
end)

CLI["TextButton_8"].MouseButton1Click:Connect(ToggleKeySystem)

