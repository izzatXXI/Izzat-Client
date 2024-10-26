local plrs = game:GetService("Players")
local vm = game:GetService("VirtualInputManager")
local uis = game:GetService("UserInputService")
local debris = game:GetService("Debris")

local plr = game.Players.LocalPlayer

local char = plr.Character
local cam = workspace.CurrentCamera
local mos = plr:GetMouse()

local CROSSHAIR_C = Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)

local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/izzatXXI/Izzat-Client/refs/heads/main/ui.lua'))()

local function _getSword()
    local a = nil
    for i,v in pairs(char:GetChildren()) do
        if string.find(v.Name,"Sword") then
            a = v
        else
            continue
        end
    end
    return a
end

local function _attackPlayer(player : Player)
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(player.Character,true,_getSword().Name)
end

local function _breakBlock(block : Part)
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("BreakBlock"):InvokeServer(block.Position)
end

local function _placeBlock(position : Vector3)
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(position)
end

local function _getClose(cc) 
    local d = math.huge
    local p = nil
    if not cc then
        for i,v in pairs(plrs:GetChildren()) do
            if v == plr then continue end
            if (v.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude < d then
                d = (v.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude
                p = v
            end
        end
    else
        for i,v in pairs(plrs:GetChildren()) do
            if v == plr then continue end
            local _SCREENPOINT = cam:WorldToScreenPoint(v.Character.HumanoidRootPart)
            local pos = Vector2.new(_SCREENPOINT.X,_SCREENPOINT.Y)
            if (pos - CROSSHAIR_C).magnitude < d and (pos - CROSSHAIR_C).magnitude < _G.fov then
                d = (pos - CROSSHAIR_C).magnitude
                p = v
            end
        end
    end
    return p
end

local function click(pressed)
    if pressed then  
        vm:SendMouseButtonEvent(CROSSHAIR_C.X,CROSSHAIR_C.Y,0,true,nil,0)
    else
        vm:SendMouseButtonEvent(CROSSHAIR_C.X,CROSSHAIR_C.Y,0,false,nil,0)
    end
end

local function _highjump(power,t)
    local f = Instance.new("BodyVelocity")
    f.P = 125000
    f.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    f.Name = "hj"
    f.Parent = char.HumanoidRootPart
    task.spawn(function()
        while char.HumanoidRootPart:FindFirstChild("hj") do
            f.Velocity = Vector3.new(char.Humanoid.MoveDirection.X * (power*7.5),7.5 * power,char.Humanoid.MoveDirection.Z * (power*7.5))
            task.wait()
        end
    end)
    debris:AddItem(f,t)
end

_G.autoclicker = false
_G.killaura = false
_G.clicking = false
_G.nokb = false
_G.cspeed = false
_G.chams = false
_G.scaffold = false
_G.flight = false
_G.antivoid = false
_G.bhop = false
_G.noclip = false
_G.infjump = false
_G.nuker = false
_G.speed = 3
_G.distance = 20
_G.fov = 300
_G.a = false

uis.InputBegan:Connect(function(k)
    if _G.autoclicker then
        if k.UserInputType == Enum.UserInputType.MouseButton1 then
            _G.clicking = true
        end
    end
end)
uis.InputEnded:Connect(function(k)
    if k.UserInputType == Enum.UserInputType.MouseButton1 then
        if _G.clicking then
            _G.clicking = false
            vm:SendMouseButtonEvent(mos.X,mos.Y,0,false,nil,1)
        end
    end
end)
task.spawn(function()
    while task.wait() do
        if _G.clicking then
            click(true)
        end
    end
end)
task.spawn(function()
    while task.wait() do
        if _G.killaura then
            _G.clickaura = false
            pcall(function()
                for i,v in pairs(plrs:GetChildren()) do
                    if v == plr then continue end
                    if not v.Character then continue end
                    if (v.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude < _G.distance then
                        _attackPlayer(v)
                        continue
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    while task.wait() do
        if _G.cspeed then
            if not _G.bhop then _G.speed = 0.4 end
            local hum = char.Humanoid
            if hum.MoveDirection.magnitude > 0 then
                char.HumanoidRootPart.CFrame = (char.HumanoidRootPart.CFrame + (hum.MoveDirection/10)*_G.speed)
            end
        elseif _G.flight then
            _G.speed = 2
            local b
            if not char.HumanoidRootPart:FindFirstChild("ffl") then
                local f = Instance.new("BodyVelocity")
                f.P = 125000
                f.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                f.Name = "ffl"
                f.Parent = char.HumanoidRootPart
                b = f
            end
            b = char.HumanoidRootPart:FindFirstChild("ffl")
            local hum = char.Humanoid
            b.Velocity = ((hum.MoveDirection * 15)*_G.speed)
            
            if (uis:IsKeyDown(Enum.KeyCode.Space)) then
                while uis:IsKeyDown(Enum.KeyCode.Space) do b.Velocity = Vector3.new(b.Velocity.X,16,b.Velocity.Z) task.wait() end
            end
            if (uis:IsKeyDown(Enum.KeyCode.Q)) then
                while uis:IsKeyDown(Enum.KeyCode.Q) do b.Velocity = Vector3.new(b.Velocity.X,-16,b.Velocity.Z) task.wait() end
            end
        end
    end
end)

plr.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid").StateChanged:Connect(function(_,state)
        local hum = c:WaitForChild("Humanoid")
        if _G.bhop then
            if state == Enum.HumanoidStateType.Jumping then
                _G.speed = 0.45
                _G.cspeed = true
                repeat task.wait() until hum:GetState() == Enum.HumanoidStateType.Landed
                _G.cspeed = false
                _G.speed = 1
                task.wait(.05)
                if _G.autojump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
    end)
end)

char:WaitForChild("Humanoid").StateChanged:Connect(function(_,state)
    if _G.bhop then
        if state == Enum.HumanoidStateType.Jumping then
            local hum = char:WaitForChild("Humanoid")
            _G.cspeed = true
            _G.speed = 0.55
            repeat task.wait() until hum:GetState() == Enum.HumanoidStateType.Landed
            _G.cspeed = false
            _G.speed = 1
            task.wait(.05)
            if _G.autojump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

task.spawn(function()
    local ijd = false
    uis.JumpRequest:Connect(function()
        if _G.infjump then
            if not ijd then
                ijd = true
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(.1)
                ijd = false
            end
        end
    end)
end)
task.spawn(function()
    while task.wait() do
        if _G.noclip then
            for i,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        else
            for i,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait() do
        if _G.chams then
            pcall(function()
                for i,v in pairs(plrs:GetChildren()) do
                    if not v.Character:FindFirstChild("esp") then
                        if v == plr then continue end
                        if not v.Character then continue end
                        local e = Instance.new("Highlight",v.Character)
                        e.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        e.Enabled = true
                        e.FillColor = Color3.new(0,.7,0)
                        e.FillTransparency = 0.6
                        e.Name = 'esp'
                    end
                end
            end)
        else
            pcall(function()
                for i,v in pairs(plrs:GetChildren()) do
                    if v.Character:FindFirstChild("esp") then
                        v.Character:FindFirstChild("esp"):Destroy()
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    local bb = false
    while task.wait() do
        if _G.nuker and not bb then
            for i,v in pairs(workspace.Map:GetChildren()) do
                if v.Name == "Block" then
                    if (v.Position - char.HumanoidRootPart.Position).magnitude < _G.distance then
                        bb = true
                        _breakBlock(v)
                        task.wait()
                        bb = false
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    local ss = false
    while task.wait() do
        if _G.scaffold and not ss then
            ss = true
            local _,p = workspace:FindPartOnRayWithWhitelist(Ray.new(char.HumanoidRootPart.Position --[[+ char.Humanoid.MoveDirection * 1.25]], Vector3.new(0,-3,0)),{workspace.Map})

            local position = Vector3.new(math.round(p.X/3)*3,(math.round(p.Y/3)*3),math.round(p.Z/3)*3)
            _placeBlock(position)
            task.wait()
            ss = false
        end
    end
end)
task.spawn(function()
    while task.wait() do
        if _G.antivoid then
            if not workspace:FindFirstChild("avs") then
                local av = Instance.new("Part")
                av.Name = 'avs'
                av.Size = Vector3.new(9999,50,9999)
                av.Position = Vector3.new(0,-30,0)
                av.Parent = char.Parent
                av.Transparency = .8
                av.Anchored = true
                local c
                c = av.Touched:Connect(function(h)
                    if h.Parent then
                        if h.Parent:FindFirstChild("HumanoidRootPart") then
                            _highjump(2,3)
                        end
                    end
                end)
            end
        else
            if workspace:FindFirstChild("avs") then
                workspace:FindFirstChild("avs"):Destroy()
            end
        end
    end
end)

local function loadui()
    local UI_MAIN = UI:new(game:GetService("CoreGui"))
    local combat = UI_MAIN:section("Combat")
    local blatant = UI_MAIN:section("Blatant")
    local world = UI_MAIN:section("World")
    local render = UI_MAIN:section("Render")

    --COMBAT BUTTONS
    combat:button("Autoclicker",function()
        _G.autoclicker = not _G.autoclicker
    end)
    combat:button("No KB",function()
        if game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE:FindFirstChild("KnockBackApplied") then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE:FindFirstChild("KnockBackApplied"):Destroy()
        end
    end)

    -- BLATANT BUTTONS
    blatant:button("Block Nuker : M", function()
        _G.nuker = not _G.nuker
    end,Enum.KeyCode.M)
    blatant:button("BHop : B",function()
        _G.bhop = not _G.bhop
    end,Enum.KeyCode.B)
    blatant:button("Speed : N",function()
        _G.cspeed = not _G.cspeed
    end,Enum.KeyCode.N)
    blatant:button("Scaffold : X",function()
        _G.scaffold = not _G.scaffold
    end,Enum.KeyCode.X)
    blatant:button("Flight : F",function()
        if char.HumanoidRootPart:FindFirstChild("ffl") then
            char.HumanoidRootPart:FindFirstChild("ffl"):Destroy()
        end
        _G.flight = not _G.flight
    end,Enum.KeyCode.F)
    blatant:button("Killaura : V",function()
        _G.killaura = not _G.killaura
    end,Enum.KeyCode.V)
    blatant:button("Infinite Jump : J",function()
        _G.infjump = not _G.infjump
    end,Enum.KeyCode.J)

    -- WORLD BUTTONS
    world:button("Antivoid : P",function()
        _G.antivoid = not _G.antivoid
    end,Enum.KeyCode.P)
    world:button("Noclip",function()
        _G.noclip = not _G.noclip
    end)

    -- RENDER BUTTONS
    render:button("Chams",function()
        _G.chams = not _G.chams
    end)
end

loadui()
