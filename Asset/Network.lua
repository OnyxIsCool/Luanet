-- thanks to nullfire for this
-- improved by me
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getGlobal()
    local env = getfenv()
    return typeof(env.getgenv) == "function" and env.getgenv() or _G
end

local Global = getGlobal()
if Global._NETWORK then
    return Global._NETWORK
end

local sethiddenproperty = getfenv().sethiddenproperty or getfenv().sethiddenprop
local setsimulationradius = getfenv().setsimulationradius
local fireTouchInterestNative = getfenv().firetouchinterest
local fireProximityPromptNative = getfenv().fireproximityprompt
local isnetworkowner = getfenv().isnetworkowner
local gethiddenproperty = getfenv().gethiddenproperty

local Active = false
local Cooldown = {}

local function safeSet(obj, prop, value)
    pcall(function()
        obj[prop] = value
    end)
end

local function renderFrames(frames)
    frames = math.max(tonumber(frames) or 1, 1)
    local dt = 0
    for i = 1, frames do
        dt += RunService.RenderStepped:Wait()
    end
    return dt / frames
end

local function renderWait(seconds)
    seconds = tonumber(seconds) or 0
    local half = seconds / 2
    task.wait(half - renderFrames(1))
    task.wait(half - renderFrames(1))
    renderFrames(1)
end

RunService.RenderStepped:Connect(function()
    if not Active then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            safeSet(player, "MaximumSimulationRadius", 0)
            if sethiddenproperty then
                pcall(sethiddenproperty, player, "MaxSimulationRadius", 0)
                pcall(sethiddenproperty, player, "SimulationRadius", 0)
            end
        end
    end

    settings().Physics.AllowSleep = false
    LocalPlayer.ReplicationFocus = workspace

    if sethiddenproperty then
        pcall(sethiddenproperty, LocalPlayer, "MaxSimulationRadius", math.huge)
        pcall(sethiddenproperty, LocalPlayer, "SimulationRadius", math.huge)
    end

    if setsimulationradius then
        pcall(setsimulationradius, 9e8, 9e9)
    end

    safeSet(LocalPlayer, "MaximumSimulationRadius", math.huge)
end)

local FireTouchAvailable = false

task.spawn(function()
    if not fireTouchInterestNative then return end

    local part = Instance.new("Part", workspace)
    part.Position = Vector3.new(0, 100, 0)
    part.Anchored = false
    part.CanCollide = false
    part.Transparency = 1

    part.Touched:Connect(function()
        part:Destroy()
        FireTouchAvailable = true
    end)

    task.wait(0.1)
    repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    fireTouchInterestNative(part, LocalPlayer.Character.HumanoidRootPart, 0)
    fireTouchInterestNative(LocalPlayer.Character.HumanoidRootPart, part, 0)
    task.wait()
    fireTouchInterestNative(part, LocalPlayer.Character.HumanoidRootPart, 1)
    fireTouchInterestNative(LocalPlayer.Character.HumanoidRootPart, part, 1)
end)

local function fireTouchInterest(partA, partB, touching)
    if FireTouchAvailable then
        return fireTouchInterestNative(partA, partB, touching)
    end

    if Cooldown[partA] or Cooldown[partB] then return end
    if partA:IsDescendantOf(LocalPlayer.Character) and partB:IsDescendantOf(LocalPlayer.Character) then return end

    if partB:IsDescendantOf(LocalPlayer.Character) then
        partA, partB = partB, partA
    end

    Cooldown[partA] = true
    Cooldown[partB] = true

    if touching ~= 0 then
        local oldPivot = partB:GetPivot()
        local t,c,a = partB.Transparency, partB.CanCollide, partB.Anchored

        partB:PivotTo(partA:GetPivot())
        partB.Transparency = 1
        partB.CanCollide = false
        partB.Anchored = false
        partB.Velocity += Vector3.new(0,1)

        partA.Touched:Wait()

        partB.Transparency = t
        partB.CanCollide = c
        partB.Anchored = a
        partB:PivotTo(oldPivot)
    else
        local ct = partB.CanTouch
        partB.CanTouch = false
        task.wait(0.015)
        partB.CanTouch = ct
    end

    task.wait()
    Cooldown[partA] = nil
    Cooldown[partB] = nil
end

local ProximityNativeReady = false

task.spawn(function()
    if not fireProximityPromptNative then return end

    local pp = Instance.new("ProximityPrompt", LocalPlayer.Character)
    local con
    con = pp.Triggered:Connect(function()
        ProximityNativeReady = true
        con:Disconnect()
        pp:Destroy()
    end)

    task.wait(0.1)
    fireProximityPromptNative(pp)
    task.wait(1.5)

    if pp and pp.Parent then
        con:Disconnect()
        pp:Destroy()
    end
end)

local function getPivot(obj)
    if not obj or not obj.Parent or obj == workspace then return CFrame.new() end
    if obj:IsA("BasePart") or obj:IsA("Model") then return obj:GetPivot() end
    if obj:IsA("Attachment") then return obj.WorldCFrame end
    return getPivot(obj:FindFirstAncestorWhichIsA("BasePart") or obj:FindFirstAncestorWhichIsA("Model"))
end

local function fireProximityPrompt(prompt, distanceCheck)
    if distanceCheck == nil then distanceCheck = true end
    if typeof(prompt) ~= "Instance" or not prompt:IsA("ProximityPrompt") or Cooldown[prompt] then return false end

    if not distanceCheck then
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if (getPivot(prompt.Parent).Position - char:GetPivot().Position).Magnitude > prompt.MaxActivationDistance then
            return false
        end
    end

    if ProximityNativeReady then
        task.spawn(fireProximityPromptNative, prompt)
        return true
    end

    Cooldown[prompt] = true

    local a,b,c,d,e = prompt.MaxActivationDistance, prompt.Enabled, prompt.Parent, prompt.HoldDuration, prompt.RequiresLineOfSight

    local proxy = Instance.new("Part", workspace)
    proxy.Transparency = 1
    proxy.CanCollide = false
    proxy.Size = Vector3.new(0.1,0.1,0.1)
    proxy.Anchored = true

    prompt.Parent = proxy
    prompt.MaxActivationDistance = math.huge
    prompt.Enabled = true
    prompt.HoldDuration = 0
    prompt.RequiresLineOfSight = false

    proxy:PivotTo(workspace.CurrentCamera.CFrame + workspace.CurrentCamera.CFrame.LookVector/5)

    renderFrames(1)
    prompt:InputHoldBegin()
    renderFrames(1)
    prompt:InputHoldEnd()
    renderFrames(1)

    if prompt.Parent == proxy then
        prompt.Parent = c
        prompt.MaxActivationDistance = a
        prompt.Enabled = b
        prompt.HoldDuration = d
        prompt.RequiresLineOfSight = e
    end

    proxy:Destroy()
    Cooldown[prompt] = nil
    return true
end

local Network = setmetatable({
    Active = Active,

    SetActive = function(self, state)
        return self(state)
    end,

    IsNetworkOwner = function(self, part, customCheck)
        if isnetworkowner and not customCheck then
            return isnetworkowner(part)
        end

        local owner = gethiddenproperty and gethiddenproperty(part, "NetworkOwnerV3")
        return (typeof(owner) == "number" and owner > 2 or part.ReceiveAge == 0) and not part.Anchored
    end,

    Other = table.freeze({
        TouchInterest = function(_, ...)
            return fireTouchInterest(...)
        end,

        FireTouchInterest = function(_, ...)
            return fireTouchInterest(...)
        end,

        ProximityPrompt = function(_, ...)
            return fireProximityPrompt(...)
        end,

        FireProximityPrompt = function(_, ...)
            return fireProximityPrompt(...)
        end,

        Touch = function(self, target, instant)
            if not LocalPlayer.Character or not target then return end

            local parts = {}
            for _,v in ipairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    table.insert(parts,v)
                end
            end

            if #parts == 0 then return end
            local part = parts[math.random(1,#parts)]

            self:TouchInterest(part,target,0)
            if not instant then renderWait() end
            self:TouchInterest(part,target,1)
        end,

        Sit = function(self, seat)
            if not seat or not LocalPlayer.Character then return end
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hum or seat.Occupant then return end

            local old = seat:GetPivot()
            seat:PivotTo(LocalPlayer.Character.HumanoidRootPart:GetPivot())
            self:Touch(seat,false)
            seat:PivotTo(old)
        end
    })
},{
    __call = function(self, state)
        Active = state
        self.Active = state

        settings().Physics.AllowSleep = not state
        LocalPlayer.ReplicationFocus = state and workspace or nil

        if not state then
            for _,player in ipairs(Players:GetPlayers()) do
                safeSet(player,"MaximumSimulationRadius",20)
                if sethiddenproperty then
                    pcall(sethiddenproperty, player, "MaxSimulationRadius",20)
                    pcall(sethiddenproperty, player, "SimulationRadius",40)
                end
            end
            if setsimulationradius then
                pcall(setsimulationradius,0,30)
            end
        end
    end
})

Network.__index = Network
Global._NETWORK = Network
return Network
