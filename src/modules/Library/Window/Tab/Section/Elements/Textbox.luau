-- Dependencies
local Trove = require("@pkgs/trove")
local LibraryData = require("@modules/Library/data")

--- A textbox input.
local Textbox = {}
Textbox.__index = Textbox

-- Types
export type TextboxData = {
    _trove: Trove.Trove,
    _callback: (string) -> (),
    _numberOnly: boolean,
    _disappear: boolean,
    title: TextLabel,
    input: TextBox,
}
export type Textbox = setmetatable<TextboxData, typeof(Textbox)>

--- Create a new [`Textbox`] object.
function Textbox.new(
    container: GuiObject,
    text: string,
    numberOnly: boolean,
    disappear: boolean,
    callback: (string) -> ()
): Textbox
    -- Create the elements
    local title, input = Textbox.InitialiseElements(container, text)

    -- Create the object
    local self: TextboxData = {
        _trove = Trove.new(),
        _callback = callback,
        _numberOnly = numberOnly == true,
        _disappear = disappear == true,
        title = title,
        input = input,
    }
    self = setmetatable(self, Textbox)

    -- Initialise the connections
    self:InitialiseConnections()

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Textbox.Destroy(self: Textbox)
    self._trove:Destroy()
end

--- Create the instances for a [`Textbox`].
function Textbox.InitialiseElements(container: GuiObject, text: string)
    local Root = Instance.new("Frame")
    Root.Name = "Textbox"
    Root.Parent = container
    Root.BackgroundTransparency = 1
    Root.Size = UDim2.new(1, 0, 0, 22)

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

    local InputFrame = Instance.new("Frame")
    InputFrame.Parent = Root
    InputFrame.AnchorPoint = Vector2.new(1, 0.5)
    InputFrame.Position = UDim2.fromScale(1, 0.5)
    InputFrame.Size = UDim2.fromOffset(120, 18)
    InputFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    InputFrame.BorderColor3 = LibraryData.ACCENT_COLOUR
    InputFrame.BorderSizePixel = 0

    local InputOutline1 = Instance.new("ImageLabel")
    InputOutline1.Parent = InputFrame
    InputOutline1.BackgroundTransparency = 1
    InputOutline1.Size = UDim2.fromScale(1, 1)
    InputOutline1.Image = "rbxassetid://2592362371"
    InputOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    InputOutline1.ScaleType = Enum.ScaleType.Slice
    InputOutline1.SliceCenter = Rect.new(2, 2, 62, 62)

    local InputOutline2 = Instance.new("ImageLabel")
    InputOutline2.Parent = InputFrame
    InputOutline2.BackgroundTransparency = 1
    InputOutline2.Position = UDim2.fromOffset(1, 1)
    InputOutline2.Size = UDim2.new(1, -2, 1, -2)
    InputOutline2.Image = "rbxassetid://2592362371"
    InputOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    InputOutline2.ScaleType = Enum.ScaleType.Slice
    InputOutline2.SliceCenter = Rect.new(2, 2, 62, 62)

    local Input = Instance.new("TextBox")
    Input.Parent = InputFrame
    Input.BackgroundTransparency = 1
    Input.Size = UDim2.new(1, -6, 1, 0)
    Input.PlaceholderText = "Type here"
    Input.Text = ""
    Input.Position = UDim2.fromOffset(3, 0)
    Input.ClearTextOnFocus = false
    Input.Font = Enum.Font.Code
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.TextSize = 14
    Input.TextXAlignment = Enum.TextXAlignment.Left

    return Title, Input
end

--- Initialise all of the connections for a [`Textbox`].
function Textbox.InitialiseConnections(self: Textbox)
    self._trove:Connect(self.input.Focused, function()
        self.title.TextTransparency = 0
    end)
    self._trove:Connect(self.input.FocusLost, function()
        local text = self.input.Text or ""
        if self._numberOnly then
            text = string.gsub(text, "[^0-9.-]", "")
            self.input.Text = text
        end
        pcall(self._callback, text)
        if self._disappear then
            self.input.Text = ""
        end
    end)
end

-- Set the textbox's text value.
function Textbox.Set(self: Textbox, text: string)
    self.input.Text = text
    self.title.TextTransparency = 0
end

-- Grab the text within the textbox.
function Textbox.Get(self: Textbox): string
    return self.input.Text
end

return Textbox
