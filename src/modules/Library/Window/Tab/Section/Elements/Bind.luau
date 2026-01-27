-- Dependencies
local Trove = require("@pkgs/trove")

-- Services
local UserInputService = cloneref(game:GetService("UserInputService"))

--- A key/mouse bind picker.
local Bind = {}
Bind.__index = Bind

-- Types
export type BindData = {
    _trove: Trove.Trove,
    _callback: (Enum.KeyCode | string) -> (),
    _capturing: boolean,
    _bind: Enum.KeyCode | string?,
    root: TextButton,
    title: TextLabel,
    valueLabel: TextLabel,
}
export type Bind = setmetatable<BindData, typeof(Bind)>

-- Vars
local WhitelistedMouse = {
    [Enum.UserInputType.MouseButton1] = "M1",
    [Enum.UserInputType.MouseButton2] = "M2",
    [Enum.UserInputType.MouseButton3] = "M3",
}

local BlacklistedKeys = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Up,
    Enum.KeyCode.Left,
    Enum.KeyCode.Down,
    Enum.KeyCode.Right,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Tab,
    Enum.KeyCode.Backspace,
    Enum.KeyCode.Escape,
    Enum.KeyCode.RightShift,
}

local function isBlacklisted(code: Enum.KeyCode)
    for _, v in BlacklistedKeys do
        if v == code then
            return true
        end
    end
    return false
end

--- Create a new [`Bind`] object.
function Bind.new(
    container: GuiObject,
    text: string,
    preset: Enum.KeyCode | string?,
    callback: (Enum.KeyCode | string) -> ()
): Bind
    local root, title, valueLabel = Bind.InitialiseElements(container, text)

    local self: BindData = {
        _trove = Trove.new(),
        _callback = callback,
        _capturing = false,
        _bind = preset,
        root = root,
        title = title,
        valueLabel = valueLabel,
    }
    self = setmetatable(self, Bind)

    self:InitialiseConnections()
    if preset then
        self:Set(preset)
    end

    return self
end

--- Destroy this object and cleanup.
function Bind.Destroy(self: Bind)
    self._trove:Destroy()
end

--- Create the instances for a [`Bind`].
function Bind.InitialiseElements(container: GuiObject, text: string)
    local Root = Instance.new("TextButton")
    Root.Name = "Bind"
    Root.Parent = container
    Root.BackgroundTransparency = 1
    Root.Size = UDim2.new(1, 0, 0, 22)
    Root.AutoButtonColor = false
    Root.Text = ""

    local Title = Instance.new("TextLabel")
    Title.Parent = Root
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(6, 0)
    Title.Size = UDim2.fromScale(0, 1)
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 0.4
    Title.Text = text

    local Value = Instance.new("TextLabel")
    Value.Parent = Root
    Value.BackgroundTransparency = 1
    Value.Position = UDim2.new(1, -6, 0, 0)
    Value.Size = UDim2.fromScale(0, 1)
    Value.Font = Enum.Font.Code
    Value.TextColor3 = Color3.fromRGB(200, 200, 200)
    Value.TextSize = 14
    Value.TextXAlignment = Enum.TextXAlignment.Right

    return Root, Title, Value
end

--- Initialise all of the connections for a [`Bind`].
function Bind.InitialiseConnections(self: Bind)
    self._trove:Connect(self.root.MouseButton1Click, function()
        self._capturing = true
        self.valueLabel.Text = "..."
    end)

    self._trove:Connect(UserInputService.InputBegan, function(inputObject)
        if not self._capturing then
            return
        end
        self._capturing = false

        if inputObject.UserInputType == Enum.UserInputType.Keyboard then
            local code = inputObject.KeyCode
            if not isBlacklisted(code) then
                self:Set(code)
                pcall(self._callback, code)
            end
        elseif WhitelistedMouse[inputObject.UserInputType :: any] then
            local mouseBind = WhitelistedMouse[inputObject.UserInputType :: any]
            self:Set(mouseBind)
            pcall(self._callback, mouseBind)
        end
    end)
end

--- Set the keycode to use / listen to.
function Bind.Set(self: Bind, b: Enum.KeyCode | string)
    self._bind = b
    if typeof(b) == "EnumItem" then
        self.valueLabel.Text = tostring(b.Name)
    else
        self.valueLabel.Text = tostring(b)
    end
    self.title.TextTransparency = 0
end

--- Returns the current listening bind.
function Bind.Get(self: Bind): (Enum.KeyCode | string)?
    return self._bind
end

return Bind
