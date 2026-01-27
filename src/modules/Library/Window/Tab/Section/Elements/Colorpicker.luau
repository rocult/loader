-- Dependencies
local Trove = require("@pkgs/trove")
local LibraryData = require("@modules/Library/data")

-- Services
local UserInputService = cloneref(game:GetService("UserInputService"))

--- A simple color picker.
local Colorpicker = {}
Colorpicker.__index = Colorpicker

-- Types
export type ColorpickerData = {
    _trove: Trove.Trove,
    _callback: (Color3) -> (),
    _open: boolean,
    _color: Color3,
    header: TextButton,
    swatch: Frame,
    panel: Frame,
    hueBar: Frame,
    hueFill: Frame,
}
export type Colorpicker = setmetatable<ColorpickerData, typeof(Colorpicker)>

--- Create a new [`Colorpicker`] object.
function Colorpicker.new(container: GuiObject, text: string, preset: Color3, callback: (Color3) -> ()): Colorpicker
    -- Create the elements
    local header, swatch, panel, hueBar, hueFill = Colorpicker.InitialiseElements(container, text)

    -- Create the object
    local self: ColorpickerData = {
        _trove = Trove.new(),
        _callback = callback,
        _open = false,
        _color = preset or LibraryData.ACCENT_COLOUR,
        header = header,
        swatch = swatch,
        panel = panel,
        hueBar = hueBar,
        hueFill = hueFill,
    }
    self = setmetatable(self, Colorpicker)

    -- Initialise the connections
    self:InitialiseConnections()
    self:Set(self._color)

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Colorpicker.Destroy(self: Colorpicker)
    self._trove:Destroy()
end

--- Create the instances for a [`Colorpicker`].
function Colorpicker.InitialiseElements(container: GuiObject, text: string)
    local Root = Instance.new("Frame")
    Root.Name = "Colorpicker"
    Root.Parent = container
    Root.BackgroundTransparency = 1
    Root.Size = UDim2.new(1, 0, 0, 42)

    local Header = Instance.new("TextButton")
    Header.Parent = Root
    Header.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.AutoButtonColor = false
    Header.Text = ""

    local Outline1 = Instance.new("ImageLabel")
    Outline1.Parent = Header
    Outline1.BackgroundTransparency = 1
    Outline1.Size = UDim2.fromScale(1, 1)
    Outline1.Image = "rbxassetid://2592362371"
    Outline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    Outline1.ScaleType = Enum.ScaleType.Slice
    Outline1.SliceCenter = Rect.new(2, 2, 62, 62)

    local Outline2 = Instance.new("ImageLabel")
    Outline2.Parent = Header
    Outline2.BackgroundTransparency = 1
    Outline2.Position = UDim2.fromOffset(1, 1)
    Outline2.Size = UDim2.new(1, -2, 1, -2)
    Outline2.Image = "rbxassetid://2592362371"
    Outline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Outline2.ScaleType = Enum.ScaleType.Slice
    Outline2.SliceCenter = Rect.new(2, 2, 62, 62)

    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(6, 0)
    Title.Size = UDim2.fromScale(0, 1)
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Text = text

    local Swatch = Instance.new("Frame")
    Swatch.Parent = Header
    Swatch.AnchorPoint = Vector2.new(1, 0.5)
    Swatch.Position = UDim2.new(1, -6, 0.5, 0)
    Swatch.Size = UDim2.fromOffset(20, 12)
    Swatch.BorderSizePixel = 1
    Swatch.BorderColor3 = LibraryData.ACCENT_COLOUR

    local Panel = Instance.new("Frame")
    Panel.Parent = Root
    Panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Panel.BorderSizePixel = 0
    Panel.Position = UDim2.fromOffset(0, 22)
    Panel.Size = UDim2.new(1, 0, 0, 20)
    Panel.Visible = false

    local HueBar = Instance.new("Frame")
    HueBar.Parent = Panel
    HueBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    HueBar.BorderSizePixel = 0
    HueBar.Size = UDim2.new(1, 0, 0, 20)

    local HueFill = Instance.new("Frame")
    HueFill.Parent = HueBar
    HueFill.BackgroundColor3 = LibraryData.ACCENT_COLOUR
    HueFill.BorderSizePixel = 0
    HueFill.Size = UDim2.fromScale(0, 1)

    return Header, Swatch, Panel, HueBar, HueFill
end

--- Initialise all of the connections for a [`Colorpicker`].
function Colorpicker.InitialiseConnections(self: Colorpicker)
    self._trove:Connect(self.header.MouseButton1Click, function()
        if self._open then
            self:Close()
        else
            self:Open()
        end
    end)

    local dragging = false
    self._trove:Connect(self.hueBar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    self._trove:Connect(self.hueBar.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    self._trove:Connect(UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = self.hueBar.AbsolutePosition
            local absSize = self.hueBar.AbsoluteSize
            local rel = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
            self.hueFill.Size = UDim2.fromScale(rel, 1)
            -- Map rel [0,1] to a hue wheel, simple approximation using Color3.fromHSV
            local color = Color3.fromHSV(rel, 1, 1)
            self:Set(color)
            pcall(self._callback, self._color)
        end
    end)
end

--- Open the colour picker menu.
function Colorpicker.Open(self: Colorpicker)
    self._open = true
    self.panel.Visible = true
end

--- Close the colour picker menu.
function Colorpicker.Close(self: Colorpicker)
    self._open = false
    self.panel.Visible = false
end

--- Set the selected colour.
function Colorpicker.Set(self: Colorpicker, color: Color3)
    self._color = color
    self.swatch.BackgroundColor3 = color
end

--- Get the selected colour.
function Colorpicker.Get(self: Colorpicker): Color3
    return self._color
end

return Colorpicker
