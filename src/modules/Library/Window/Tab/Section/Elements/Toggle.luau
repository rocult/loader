-- Dependencies
local Trove = require("@pkgs/trove")
local LibraryData = require("@modules/Library/data")

--- A toggle.
local Toggle = {}
Toggle.__index = Toggle

-- Types
export type ToggleData = {
    _trove: Trove.Trove,
    _callback: (boolean) -> (),
    _toggled: boolean,
    root: TextButton,
    frame: Frame,
    title: TextLabel,
}
export type Toggle = setmetatable<ToggleData, typeof(Toggle)>

--- Create a new [`Toggle`] object.
function Toggle.new(container: GuiObject, text: string, def: boolean, callback: (boolean) -> ()): Toggle
    -- Create the elements
    local root, frame, title = Toggle.InitialiseElements(container, text)

    -- Create the object
    local self: ToggleData = {
        _trove = Trove.new(),
        _callback = callback,
        _toggled = def == true,
        root = root,
        frame = frame,
        title = title,
    }
    self = setmetatable(self, Toggle)

    -- Initialise the connections
    self:InitialiseConnections()
    self:Set(self._toggled)

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Toggle.Destroy(self: Toggle)
    self._trove:Destroy()
end

--- Create the instances for a [`Toggle`].
function Toggle.InitialiseElements(container: GuiObject, text: string): (TextButton, Frame, TextLabel)
    local ToggleElement = Instance.new("TextButton")
    local ToggleFrame = Instance.new("Frame")
    local ToggleOutline1 = Instance.new("ImageLabel")
    local ToggleOutline2 = Instance.new("ImageLabel")
    local ToggleTitle = Instance.new("TextLabel")

    ToggleElement.Name = text
    ToggleElement.Parent = container
    ToggleElement.BackgroundTransparency = 1
    ToggleElement.Size = UDim2.new(1, 0, 0, 22)
    ToggleElement.AutoButtonColor = false
    ToggleElement.Text = ""

    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Parent = ToggleElement
    ToggleFrame.AnchorPoint = Vector2.new(0, 0.5)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    ToggleFrame.BorderColor3 = LibraryData.ACCENT_COLOUR
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Position = UDim2.fromScale(0, 0.5)
    ToggleFrame.Size = UDim2.fromOffset(14, 14)

    ToggleOutline1.Name = "ToggleOutline1"
    ToggleOutline1.Parent = ToggleFrame
    ToggleOutline1.BackgroundTransparency = 1
    ToggleOutline1.Size = UDim2.fromScale(1, 1)
    ToggleOutline1.Image = "rbxassetid://2592362371"
    ToggleOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    ToggleOutline1.ScaleType = Enum.ScaleType.Slice
    ToggleOutline1.SliceCenter = Rect.new(2, 2, 62, 62)

    ToggleOutline2.Name = "ToggleOutline2"
    ToggleOutline2.Parent = ToggleFrame
    ToggleOutline2.BackgroundTransparency = 1
    ToggleOutline2.Position = UDim2.fromOffset(1, 1)
    ToggleOutline2.Size = UDim2.new(1, -2, 1, -2)
    ToggleOutline2.Image = "rbxassetid://2592362371"
    ToggleOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ToggleOutline2.ScaleType = Enum.ScaleType.Slice
    ToggleOutline2.SliceCenter = Rect.new(2, 2, 62, 62)

    ToggleTitle.Name = "ToggleTitle"
    ToggleTitle.Parent = ToggleElement
    ToggleTitle.BackgroundTransparency = 1
    ToggleTitle.Position = UDim2.fromOffset(19, 0)
    ToggleTitle.Size = UDim2.fromScale(0, 1)
    ToggleTitle.Font = Enum.Font.Code
    ToggleTitle.Text = text
    ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleTitle.TextSize = 14
    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleTitle.TextTransparency = 0.4

    return ToggleElement, ToggleFrame, ToggleTitle
end

--- Initialise all of the connections for a [`Toggle`].
function Toggle.InitialiseConnections(self: Toggle)
    self._trove:Connect(self.root.MouseEnter, function()
        self.frame.BorderSizePixel = 1
    end)

    self._trove:Connect(self.root.MouseLeave, function()
        self.frame.BorderSizePixel = 0
    end)

    self._trove:Connect(self.root.MouseButton1Click, function()
        self:Set(not self._toggled)
        pcall(self._callback, self._toggled)
    end)
end

--- Programmatically set the toggle state.
function Toggle.Set(self: Toggle, on: boolean)
    self._toggled = on == true
    if self._toggled then
        self.frame.BackgroundColor3 = LibraryData.ACCENT_COLOUR
        self.title.TextTransparency = 0
    else
        self.frame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        self.title.TextTransparency = 0.4
    end
end

--- Get the current toggle state.
function Toggle.Get(self: Toggle): boolean
    return self._toggled
end

return Toggle
