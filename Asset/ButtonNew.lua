local Button = {}
Button.__index = Button

local UIS = game:GetService("UserInputService")

function Button.new()
    local self = setmetatable({}, Button)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = gethui()
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local ImageButton = Instance.new("ImageButton")
    ImageButton.Parent = ScreenGui
    ImageButton.BorderSizePixel = 0
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.Image = "rbxassetid://86292354128398"
    ImageButton.Size = UDim2.new(0.06488, 0, 0.14147, 0)
    ImageButton.Position = UDim2.new(0.14658, 0, 0.0962, 0)
    ImageButton.Active = true
    ImageButton.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = ImageButton
    UICorner.CornerRadius = UDim.new(0, 8)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Parent = ImageButton
    UIAspectRatioConstraint.AspectRatio = 1.08

    self.Gui = ScreenGui
    self.Button = ImageButton
    self.Visible = true
    self.Toggle = false
    self.MinKey = Enum.KeyCode.LeftControl

    ImageButton.MouseButton1Click:Connect(function()
        self.Toggle = not self.Toggle
        print("Toggle:", self.Toggle)
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self.MinKey then
            self.Visible = not self.Visible
            ImageButton.Visible = self.Visible
        end
    end)

    return self
end

function Button:MinimizeKey(key)
    if typeof(key) == "string" then
        self.MinKey = Enum.KeyCode[key]
    elseif typeof(key) == "EnumItem" then
        self.MinKey = key
    end
end

return Button