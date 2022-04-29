local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("infinity - Prison Life", "Ocean")
local Tab = Window:NewTab("LocalPlayer")
local Tab2 = Window:NewTab("Misc")
local Section = Tab:NewSection("Movement")
local Section2 = Tab:NewSection("Other")
local Section3 = Tab2:NewSection("Main")
local Toggles = {
    ["SaveWalkSpeed"] = false,
    ["SaveJumpPower"] = false,
    ["RealisticClock"] = false,
    ["InstantRespawn"] = false,
    ["InfiniteStamina"] = false,
    ["NoClip"] = false
}
local Data = {
    ["WalkSpeed"] = LocalPlayer.Character.Humanoid.WalkSpeed,
    ["JumpPower"] = LocalPlayer.Character.Humanoid.JumpPower,
    ["Time"] = "LOADING..."
}
Section:NewTextBox("WalkSpeed", "16 = Default. 32 = Double. etc", function(txt)
    local Humanoid = LocalPlayer.Character.Humanoid
    local num = tonumber(txt)
    local currentspeed = Humanoid.WalkSpeed
    local speed = num or currentspeed
    Humanoid.WalkSpeed = speed
    Data.WalkSpeed = speed
    Toggles.SaveWalkSpeed = true
    Humanoid.Changed:connect(function()
        if Toggles.SaveWalkSpeed then
            Humanoid.WalkSpeed = Data.WalkSpeed
        end
    end)
end)
Section:NewTextBox("JumpPower", "50 = Default. 100 = Double. etc", function(txt)
    local Humanoid = LocalPlayer.Character.Humanoid
    local num = tonumber(txt)
    local currentjp = Humanoid.WalkSpeed
    local jp = num or currentjp
    Humanoid.JumpPower = jp
    Data.JumpPower = jp
    Toggles.SaveJumpPower = true
    Humanoid.Changed:connect(function()
        if Toggles.SaveJumpPower then
            Humanoid.JumpPower = Data.JumpPower
        end
    end)
end)
Section:NewButton("Reset WalkSpeed", "Sets your WalkSpeed to default.", function()
    Toggles.SaveWalkSpeed = false
    LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)
Section:NewButton("Reset JumpPower", "Sets your JumpPower to default.", function()
    Toggles.SaveJumpPower = false
    LocalPlayer.Character.Humanoid.JumpPower = 50
end)
Section3:NewDropdown("Give Gun", "Gives you a gun of your choice.", {"AK-47", "M4A1 (GAMEPASS)", "M9", "Remington 870"}, function(currentOption)
    local ItemHandler = workspace.Remote.ItemHandler
    local giver = workspace.Prison_ITEMS.giver
    local Gun = giver:FindFirstChild(currentOption)
    if currentOption:sub(#currentOption - 9, #currentOption) == "(GAMEPASS)" then
        local GunName = currentOption:sub(1, #currentOption - 11)
        Gun = giver[GunName]
    end
    ItemHandler:InvokeServer(Gun.ITEMPICKUP)
end)
Section3:NewToggle("Realistic Clock", "Changes the in game clock to your actual time.", function(state)
    Toggles.RealisticClock = state
end)
Section3:NewToggle("Instant Respawn", "Instantly respawns your character.", function(state)
    Toggles.InstantRespawn = state
end)
local function SetStamina(num)
    for i,v in next, getgc() do 
        if type(v) == "function" and getfenv(v).script and getfenv(v).script == LocalPlayer.Character:WaitForChild("ClientInputHandler") then 
            for i2,v2 in next, debug.getupvalues(v) do 
                if type(v2) == "number" then 
                    debug.setupvalue(v, i2, num)
                end
            end
        end
    end
end
Section2:NewToggle("NoClip", "Lets you walk through walls.", function(state)
    Toggles.NoClip = state
end)
Section2:NewToggle("Infinite Stamina", "Gives you infinite stamina (jumps).", function(state)
    Toggles.InfiniteStamina = state
    SetStamina((state and 999999) or (not state and 12))
    local tooltip = LocalPlayer.PlayerGui.Home.hud.AddedGui.tooltip
    if state then
        if tooltip.TextLabel.Text == "You don't have enough stamina!" then
            tooltip.Visible = false
        end
    end
end)
Section3:NewToggle("Remove Cell Doors", "Removes the Cell Doors.", function(state)
    for i,v in pairs(workspace.Prison_Cellblock.doors:GetChildren()) do
        v.CanCollide = not state
        v.Transparency = (state and 1) or (not state and 0)
    end
    local Door = workspace.Doors.door_v3_cellblock1.block
    if Door:FindFirstChild("hitbox") then
        Door.hitbox.CanCollide = state
        for i,v in pairs(Door.longitude:GetChildren()) do
            v.Transparency = (state and 1) or 0
        end
    end
end)
local function InstantRespawn(Humanoid)
    Humanoid.Changed:connect(function()
        if Humanoid.Health == 0 then
            if Toggles.InstantRespawn then
                workspace.Remote.loadchar:InvokeServer()
            end
        end
    end)
end
local function NoClip(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    while game:GetService("RunService").Stepped:wait() do
        if Toggles.NoClip then
            for i,v in pairs(Character:children()) do
                if v:IsA("BasePart") then
                    if Humanoid.Health ~= 0 then
                        v.CanCollide = false
                    end
                end
            end
        end
    end
end
InstantRespawn(LocalPlayer.Character.Humanoid)
spawn(function()
    NoClip(LocalPlayer.Character)
end)
LocalPlayer.CharacterAdded:connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    InstantRespawn(Humanoid)
    if Toggles.SaveWalkSpeed then
        Humanoid.WalkSpeed = Data.WalkSpeed
    end
    if Toggles.SaveJumpPower then
        Humanoid.JumpPower = Data.JumpPower
    end
    spawn(function()
        local state = Toggles.InfiniteStamina
        if state then
            SetStamina(999999)
        end
    end)
    Humanoid.Changed:connect(function()
        if Toggles.SaveWalkSpeed then
            Humanoid.WalkSpeed = Data.WalkSpeed
        end
        if Toggles.SaveJumpPower then
            Humanoid.JumpPower = Data.JumpPower
        end
    end)
    NoClip(LocalPlayer.Character)
end)
local Clock = LocalPlayer.PlayerGui.Home.hud.ClockFrame.tl
local function CalculateTime()
    local Time = "unknown"
    local Hour = os.date("%I")
    local Minute = os.date("%M")
    local am_or_pm = os.date("%p")
    local StrHour = tostring(Hour)
    if StrHour:sub(1,1) == "0" then
        Hour = StrHour:sub(2, #StrHour)
        Hour = tonumber(Hour)
    end
    Time = Hour .. ":" .. Minute .. " " .. am_or_pm:lower()
    return Time
end
Data.Time = CalculateTime()
Clock.Changed:connect(function()
    if Toggles.RealisticClock then
        Clock.Text = Data.Time
    end
end)
spawn(function()
    wait(60 - os.date("%S"))
    while true do
        Data.Time = CalculateTime()
        wait(60)
    end
end)