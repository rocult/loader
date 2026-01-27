-- Dependencies
local Trove = require("@pkgs/trove")
local LibraryData = require("@modules/Library/data")

-- Services
local UserInputService = cloneref(game:GetService("UserInputService"))

--- A slider.
local Slider = {}
Slider.__index = Slider

-- Types
export type SliderSettings = { min: number, max: number, default: number?, step: number? }
export type SliderData = {
    _trove: Trove.Trove,
    _callback: (number) -> (),
    _dragging: boolean,
    _settings: SliderSettings,
    _value: number,
    bar: Frame,
    fill: Frame,
    valueLabel: TextLabel,
}
export type Slider = setmetatable<SliderData, typeof(Slider)>

--- Create a new [`Slider`] object.
function Slider.new(container: GuiObject, text: string, settings: SliderSettings, callback: (number) -> ()): Slider
    -- Create the elements
    local bar, fill, valueLabel = Slider.InitialiseElements(container, text, settings)

    -- Create the object
    local default = settings.default or settings.min
    local self: SliderData = {
        _trove = Trove.new(),
        _callback = callback,
        _dragging = false,
        _settings = settings,
        _value = default,
        bar = bar,
        fill = fill,
        valueLabel = valueLabel,
    }
    self = setmetatable(self, Slider)

    -- Initialise the connections
    self:InitialiseConnections()
    self:Set(default)

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Slider.Destroy(self: Slider)
    self._trove:Destroy()
end

--- Create the instances for a [`Slider`].
function Slider.InitialiseElements(container: GuiObject, text: string, settings: SliderSettings)
    local SliderElement = Instance.new("Frame")
    local SliderTitle = Instance.new("TextLabel")
    local SliderFrame = Instance.new("Frame")
    local SliderCurrentFrame = Instance.new("Frame")
    local SliderOutline1 = Instance.new("ImageLabel")
    local SliderOutline2 = Instance.new("ImageLabel")
    local SliderVal = Instance.new("TextLabel")

    SliderElement.Name = "Slider"
    SliderElement.Parent = container
    SliderElement.BackgroundTransparency = 1
    SliderElement.Size = UDim2.new(1, 0, 0, 37)

    SliderTitle.Name = "SliderTitle"
    SliderTitle.Parent = SliderElement
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Size = UDim2.fromOffset(0, 13)
    SliderTitle.Font = Enum.Font.Code
    SliderTitle.Text = text
    SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.TextSize = 14
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

    SliderFrame.Name = "SliderFrame"
    SliderFrame.Parent = SliderElement
    SliderFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Position = UDim2.new(0, 0, 1, -20)
    SliderFrame.Size = UDim2.new(1, 0, 0, 20)

    SliderCurrentFrame.Name = "SliderCurrentFrame"
    SliderCurrentFrame.Parent = SliderFrame
    SliderCurrentFrame.BackgroundColor3 = LibraryData.ACCENT_COLOUR
    SliderCurrentFrame.BorderSizePixel = 0
    SliderCurrentFrame.Size = UDim2.fromScale(0, 1)

    SliderOutline1.Name = "SliderOutline1"
    SliderOutline1.Parent = SliderFrame
    SliderOutline1.BackgroundTransparency = 1
    SliderOutline1.Size = UDim2.fromScale(1, 1)
    SliderOutline1.Image = "rbxassetid://2592362371"
    SliderOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    SliderOutline1.ScaleType = Enum.ScaleType.Slice
    SliderOutline1.SliceCenter = Rect.new(2, 2, 62, 62)

    SliderOutline2.Name = "SliderOutline2"
    SliderOutline2.Parent = SliderFrame
    SliderOutline2.BackgroundTransparency = 1
    SliderOutline2.Position = UDim2.fromOffset(1, 1)
    SliderOutline2.Size = UDim2.new(1, -2, 1, -2)
    SliderOutline2.Image = "rbxassetid://2592362371"
    SliderOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    SliderOutline2.ScaleType = Enum.ScaleType.Slice
    SliderOutline2.SliceCenter = Rect.new(2, 2, 62, 62)

    SliderVal.Name = "SliderVal"
    SliderVal.Parent = SliderElement
    SliderVal.BackgroundTransparency = 1
    SliderVal.Position = UDim2.new(1, -40, 0, 0)
    SliderVal.Size = UDim2.fromOffset(40, 13)
    SliderVal.Font = Enum.Font.Code
    SliderVal.TextColor3 = Color3.fromRGB(200, 200, 200)
    SliderVal.TextSize = 14
    SliderVal.TextXAlignment = Enum.TextXAlignment.Right

    return SliderFrame, SliderCurrentFrame, SliderVal
end

local function clampToStep(value: number, step: number?): number
    if not step or step <= 0 then
        return value
    end
    return math.floor(value / step + 0.5) * step
end

--- Initialise all of the connections for a [`Slider`].
function Slider.InitialiseConnections(self: Slider)
    self._trove:Connect(self.bar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._dragging = true
        end
    end)

    self._trove:Connect(self.bar.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._dragging = false
        end
    end)

    self._trove:Connect(UserInputService.InputChanged, function(input)
        if self._dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = self.bar.AbsolutePosition
            local absSize = self.bar.AbsoluteSize
            local mouseX = input.Position.X
            local rel = math.clamp((mouseX - absPos.X) / absSize.X, 0, 1)
            local min, max = self._settings.min, self._settings.max
            local raw = min + rel * (max - min)
            local stepped = clampToStep(raw, self._settings.step)
            self:Set(stepped)
            pcall(self._callback, self._value)
        end
    end)
end

--- Programmatically set the slider value.
function Slider.Set(self: Slider, value: number)
    local min, max = self._settings.min, self._settings.max
    local v = math.clamp(value, min, max)
    self._value = v
    local rel = (v - min) / (max - min)
    self.fill.Size = UDim2.fromScale(rel, 1)
    self.valueLabel.Text = tostring(math.floor(v + 0.5))
end

--- Get the current slider value.
function Slider.Get(self: Slider): number
    return self._value
end

return Slider
