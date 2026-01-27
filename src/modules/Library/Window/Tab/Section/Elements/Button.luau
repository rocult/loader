-- Dependencies
local Trove = require("@pkgs/trove")
local LibraryData = require("@modules/Library/data")

--- A button.
local Button = {}
Button.__index = Button

-- Types
export type ButtonData = {
    _trove: Trove.Trove,
    _callback: () -> (),
    button: GuiObject,
}
export type Button = setmetatable<ButtonData, typeof(Button)>

--- Create a new [`Button`] object.
function Button.new(container: GuiObject, text: string, callback: () -> ()): Button
    -- Create the elements
    local ButtonElement = Button.InitialiseElements(container, text)

    -- Create the object
    local self: ButtonData = {
        _trove = Trove.new(),
        _callback = callback,
        button = ButtonElement,
    }
    self = setmetatable(self, Button)

    -- Initialise the connections
    self:InitialiseConnections(ButtonElement)

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Button.Destroy(self: Button)
    self._trove:Destroy()
end

--- Create the instances for a [`Button`].
function Button.InitialiseElements(container: GuiObject, text: string)
    local ButtonElement = Instance.new("TextButton")
    local ButtonOutline1 = Instance.new("ImageLabel")
    local ButtonOutline2 = Instance.new("ImageLabel")

    ButtonElement.Name = "Button"
    ButtonElement.Parent = container
    ButtonElement.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    ButtonElement.BorderColor3 = LibraryData.ACCENT_COLOUR
    ButtonElement.BorderSizePixel = 0
    ButtonElement.Size = UDim2.new(1, 0, 0, 20)
    ButtonElement.AutoButtonColor = false
    ButtonElement.Font = Enum.Font.Code
    ButtonElement.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonElement.TextSize = 14.000
    ButtonElement.Text = text

    ButtonOutline1.Name = "ButtonOutline1"
    ButtonOutline1.Parent = ButtonElement
    ButtonOutline1.BackgroundTransparency = 1.000
    ButtonOutline1.Size = UDim2.fromScale(1, 1)
    ButtonOutline1.Image = "rbxassetid://2592362371"
    ButtonOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    ButtonOutline1.ScaleType = Enum.ScaleType.Slice
    ButtonOutline1.SliceCenter = Rect.new(2, 2, 62, 62)

    ButtonOutline2.Name = "ButtonOutline2"
    ButtonOutline2.Parent = ButtonElement
    ButtonOutline2.BackgroundTransparency = 1.000
    ButtonOutline2.Position = UDim2.fromOffset(1, 1)
    ButtonOutline2.Size = UDim2.new(1, -2, 1, -2)
    ButtonOutline2.Image = "rbxassetid://2592362371"
    ButtonOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ButtonOutline2.ScaleType = Enum.ScaleType.Slice
    ButtonOutline2.SliceCenter = Rect.new(2, 2, 62, 62)

    return ButtonElement
end

--- Initialise all of the connections for a [`Button`].
function Button.InitialiseConnections(self: Button, ButtonElement: TextButton)
    self._trove:Connect(ButtonElement.MouseButton1Click, function()
        pcall(self._callback)
    end)

    self._trove:Connect(ButtonElement.MouseLeave, function()
        Button.BorderSizePixel = 0
    end)

    self._trove:Connect(ButtonElement.MouseEnter, function()
        Button.BorderSizePixel = 1
    end)
end

return Button
