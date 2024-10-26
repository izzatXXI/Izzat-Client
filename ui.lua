local ui = {}

local uis = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()

local buttonColors = {
    ["true"] = Color3.new(0,0.7,0);
    ['false'] = Color3.new(0.4,0,1)
}

function ui:new(parent)
    local gui = setmetatable({},{})
    gui.__index = gui
    gui.MAIN = Instance.new("ScreenGui",parent)
    gui.frames = 0

    function gui:section(name)
        local section = setmetatable({},{})
        local title = Instance.new("TextLabel",self.MAIN)
        title.InputBegan:Connect(function(k)
            if k.UserInputType == Enum.UserInputType.MouseButton1 then
                while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    title.Position = UDim2.fromOffset(mouse.X,mouse.Y)
                    task.wait()
                end
            end
        end)
        local s = Instance.new("Frame",title)
        section.frame = s
        section.title = title
        title.Size = UDim2.fromScale(0.133,0.08)
        title.Position = UDim2.fromOffset(60 + (self.frames * 280),80)
        self.frames+= 1
        title.BackgroundColor3 = Color3.fromRGB(65, 47, 116)
        title.TextColor3 = Color3.new(0,0,0)
        title.Text = name
        title.TextSize = 20
        title.BorderSizePixel = 3
        s.Size = UDim2.fromScale(1,0.3)
        s.BackgroundColor3 = Color3.fromRGB(65, 47, 116)
        s.BorderSizePixel = 3
        title.BorderColor3 = Color3.new(0,0,0)
        s.BorderColor3 = Color3.new(0,0,0)
        s.Position = UDim2.fromScale(0,1)
        Instance.new("UIListLayout",s).Padding = UDim.new(0,15)
        Instance.new("UIPadding",s).PaddingTop = UDim.new(0,15)

        function section:button(name,callback,keybind)
            local buttonmm = setmetatable({},{})
            local button = Instance.new("TextButton",gui.MAIN)
            button.Text = name
            button.MouseButton1Click:Connect(function()
                callback()
                buttonmm.value = not buttonmm.value
                buttonmm.btn.BackgroundColor3 = buttonColors[tostring(buttonmm.value)]
            end)
            uis.InputBegan:Connect(function(k,g)
                if g then return end
                if k.KeyCode == keybind then
                    callback()
                    buttonmm.value = not buttonmm.value
                    buttonmm.btn.BackgroundColor3 = buttonColors[tostring(buttonmm.value)]
                end
            end)
            local f = self.frame
            f.Size = f.Size + UDim2.fromOffset(0,65)
            button.Size = UDim2.new(UDim.new(1,0),UDim.new(0,50))
            button.Position = UDim2.fromScale(1,0)
            button.Parent = self.frame
            buttonmm.btn = button
            buttonmm.value = false
            button.BackgroundColor3 = buttonColors[tostring(buttonmm.value)]
            buttonmm.keybind = keybind or nil
            return buttonmm
        end
        return section
    end
    uis.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.RightShift then
            gui.MAIN.Enabled = not gui.MAIN.Enabled
        end
    end)
    return gui
end
