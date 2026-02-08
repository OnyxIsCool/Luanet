-- thanks nullfire for this esp lib
-- improved by me
wait(100000000)
game.Players.LocalPlayer:Kick("Outdated ESP Library, Please Use The New One!")
--[[
    local env = getfenv()
    if typeof(env.getgenv) == "function" then
        local genv = env.getgenv()
        if typeof(genv) == "table" then
            return genv
        end
    end
    return _G
end

if getGlobalTable().ESPLib then
    return getGlobalTable().ESPLib
end

local RunService = game:GetService("RunService")

local ESPChange = Instance.new("BindableEvent")
local cons = {}
local speed = 24

local espLib = {
    Values = {},
    ESPApplied = {}
}

espLib.ESPValues = setmetatable({}, {
    __index = function(_, name)
        return not not espLib.Values[name]
    end,
    __newindex = function(_, name, value)
        if espLib.Values[name] == value then return end
        espLib.Values[name] = value
        ESPChange:Fire()
    end
})

local function GetRGBValue()
    local t = os.clock() * speed
    return Color3.new(
        math.sin(t) * 0.5 + 0.5,
        math.sin(t + 2) * 0.5 + 0.5,
        math.sin(t + 4) * 0.5 + 0.5
    )
end

local function resolveModel(obj)
    if not obj then return end
    if obj:IsA("Model") then return obj end
    return obj:FindFirstAncestorOfClass("Model") or obj
end

local function createESP(obj, settings)
    local folder = Instance.new("Folder")
    folder.Name = "ESPFolder"
    folder.Parent = obj

    local highlight = Instance.new("Highlight")
    highlight.Parent = folder
    highlight.Adornee = obj
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0.5

    local bg = Instance.new("BillboardGui")
    bg.Parent = folder
    bg.Adornee = obj
    bg.AlwaysOnTop = true
    bg.Size = UDim2.fromOffset(250,200)
    bg.MaxDistance = math.huge

    local dot = Instance.new("Frame")
    dot.Parent = bg
    dot.AnchorPoint = Vector2.new(0.5,0.5)
    dot.Position = UDim2.fromScale(0.5,0.5)
    dot.Size = UDim2.fromOffset(10,10)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = dot

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2.5
    stroke.Parent = dot

    local label = Instance.new("TextLabel")
    label.Parent = bg
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.Code
    label.RichText = true
    label.Position = UDim2.new(0,0,0.5,10)
    label.Size = UDim2.new(1,0,0,20)

    local labelStroke = Instance.new("UIStroke")
    labelStroke.Thickness = 2.5
    labelStroke.Parent = label

    return folder, highlight, bg, dot, label
end

local function updateESP(obj, data)
    local enabled = espLib.ESPValues[data.ESPName]
    local color = data.Color

    data.Highlight.Enabled = enabled
    data.Highlight.FillColor = color
    data.Highlight.OutlineColor = color

    data.Gui.Enabled = enabled
    data.Dot.BackgroundColor3 = color
    data.Label.TextColor3 = color
    data.Label.Text = data.Text
end

function espLib.ApplyESP(obj, settings)
    obj = resolveModel(obj)
    if not obj then return end

    settings = settings or {}
    settings.Color = settings.Color or Color3.new(1,1,1)
    settings.Text = settings.Text or obj.Name
    settings.ESPName = settings.ESPName or obj.Name

    if obj:FindFirstChild("ESPFolder") then
        obj.ESPFolder:Destroy()
    end

    local folder, highlight, gui, dot, label = createESP(obj, settings)

    local data = {
        Color = settings.Color,
        Text = settings.Text,
        ESPName = settings.ESPName,
        Highlight = highlight,
        Gui = gui,
        Dot = dot,
        Label = label
    }

    table.insert(espLib.ESPApplied, obj)

    local rgbCon

    local function refresh()
        if espLib.ESPValues.RGBESP then
            data.Color = GetRGBValue()
        else
            data.Color = settings.Color
        end
        updateESP(obj, data)
    end

    refresh()

    local con1 = ESPChange.Event:Connect(refresh)

    local con2 = RunService.RenderStepped:Connect(function()
        if espLib.ESPValues.RGBESP then
            data.Color = GetRGBValue()
            updateESP(obj, data)
        end
    end)

    local con3 = obj.Destroying:Connect(function()
        espLib.DeapplyESP(obj)
    end)

    cons[obj] = {con1, con2, con3}
end

function espLib.DeapplyESP(obj)
    obj = resolveModel(obj)
    if not obj then return end

    local found = table.find(espLib.ESPApplied, obj)
    if found then
        table.remove(espLib.ESPApplied, found)
    end

    if cons[obj] then
        for _,v in ipairs(cons[obj]) do
            if v then v:Disconnect() end
        end
        cons[obj] = nil
    end

    if obj:FindFirstChild("ESPFolder") then
        obj.ESPFolder:Destroy()
    end
end

getGlobalTable().ESPLib = espLib
return espLib
]]--
