local ui = {}

function ui.new()
    local gui = setmetatable({},{})
    gui.__index = gui
    gui.MAIN = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
    function gui:button(self,name,callback)
        local button = Instance.new("TextButton",gui.MAIN)
        button.Text = name
        button.MouseButton1Click:Connect(callback)
        button.Parent = self.MAIN
    end
    return gui
end

return ui
