-- Dependencies
local Trove = require("@pkgs/trove")
local Button = require("@self/Elements/Button")
local Toggle = require("@self/Elements/Toggle")
local Slider = require("@self/Elements/Slider")
local Dropdown = require("@self/Elements/Dropdown")
local Colorpicker = require("@self/Elements/Colorpicker")
local Bind = require("@self/Elements/Bind")
local Textbox = require("@self/Elements/Textbox")
local Label = require("@self/Elements/Label")

--- A Section.
local Section = {}
Section.__index = Section

-- Types
export type SectionData = {
    _trove: Trove.Trove,

    _container: Frame,
    _itemHolderFrame: Frame,
    _itemHolderLayout: UIListLayout,
}
export type Section = setmetatable<SectionData, typeof(Section)>

--- Create a new [`Section`] object.
function Section.new(container: GuiObject, zIndex: number, text: string): Section
    local SectionFrame, SectionItemHolderFrame, SectionItemHolderLayout =
        Section.InitialiseElements(container, zIndex, text)

    -- Create the object
    local self: SectionData = {
        _trove = Trove.new(),
        _container = SectionFrame,
        _itemHolderFrame = SectionItemHolderFrame,
        _itemHolderLayout = SectionItemHolderLayout,
    }
    self = setmetatable(self, Section)

    -- Return the object
    return self
end

--- Destroy this object and clean up.
function Section.Destroy(self: Section)
    self._trove:Destroy()
end

--- Create the instances for a [`Section`].
function Section.InitialiseElements(container: GuiObject, zIndex: number, text: string)
    local SectionFrame = Instance.new("Frame")
    local SectionOutline2 = Instance.new("ImageLabel")
    local SectionOutline1 = Instance.new("ImageLabel")
    local SectionTitleFrame = Instance.new("Frame")
    local SectionTitle = Instance.new("TextLabel")
    local SectionItemHolderFrame = Instance.new("Frame")
    local SectionItemHolderLayout = Instance.new("UIListLayout")

    SectionFrame.Name = "Section"
    SectionFrame.Parent = container
    SectionFrame.AnchorPoint = Vector2.new(0.5, 0)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Position = UDim2.fromScale(0.49559471, 0.0111856824)
    SectionFrame.Size = UDim2.new(1, -2, 0, 24)
    SectionFrame.ZIndex = zIndex

    SectionOutline2.Name = "SectionOutline2"
    SectionOutline2.Parent = SectionFrame
    SectionOutline2.BackgroundTransparency = 1.000
    SectionOutline2.Size = UDim2.fromScale(1, 1)
    SectionOutline2.Image = "rbxassetid://2592362371"
    SectionOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    SectionOutline2.ScaleType = Enum.ScaleType.Slice
    SectionOutline2.SliceCenter = Rect.new(2, 2, 62, 62)

    SectionOutline1.Name = "SectionOutline1"
    SectionOutline1.Parent = SectionFrame
    SectionOutline1.BackgroundTransparency = 1.000
    SectionOutline1.Position = UDim2.fromOffset(1, 1)
    SectionOutline1.Size = UDim2.new(1, -2, 1, -2)
    SectionOutline1.Image = "rbxassetid://2592362371"
    SectionOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    SectionOutline1.ScaleType = Enum.ScaleType.Slice
    SectionOutline1.SliceCenter = Rect.new(2, 2, 62, 62)

    SectionTitleFrame.Name = "SectionTitleFrame"
    SectionTitleFrame.Parent = SectionFrame
    SectionTitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionTitleFrame.BorderSizePixel = 0
    SectionTitleFrame.Position = UDim2.fromOffset(10, 0)
    SectionTitleFrame.Size = UDim2.fromOffset(65, 7)

    SectionTitle.Name = "SectionTitle"
    SectionTitle.Parent = SectionTitleFrame
    SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.BackgroundTransparency = 1.000
    SectionTitle.Position = UDim2.fromOffset(0, -3)
    SectionTitle.Size = UDim2.new(1, 0, 0, 7)
    SectionTitle.Font = Enum.Font.Code
    SectionTitle.Text = text
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 14.000

    SectionItemHolderFrame.Name = "SectionItemHolderFrame"
    SectionItemHolderFrame.Parent = SectionFrame
    SectionItemHolderFrame.AnchorPoint = Vector2.new(0.5, 0)
    SectionItemHolderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionItemHolderFrame.BackgroundTransparency = 1.000
    SectionItemHolderFrame.Position = UDim2.new(0.5, 0, 0, 15)
    SectionItemHolderFrame.Size = UDim2.new(1, -16, 0, 0)

    SectionItemHolderLayout.Name = "SectionItemHolderLayout"
    SectionItemHolderLayout.Parent = SectionItemHolderFrame
    SectionItemHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionItemHolderLayout.Padding = UDim.new(0, 5)

    SectionTitleFrame.Size = UDim2.fromOffset(SectionTitle.TextBounds.X + 6, 7)

    return SectionFrame, SectionItemHolderFrame, SectionItemHolderLayout
end

--- Create a new [`Button`] under this [`Section`] object.
function Section.Button(self: Section, text: string, callback: () -> ())
    local button = self._trove:Add(Button.new(self._itemHolderFrame, text, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return button
end

--- Create a new [`Toggle`] under this [`Section`] object.
function Section.Toggle(self: Section, text: string, def: boolean, callback: (boolean) -> ())
    local toggle = self._trove:Add(Toggle.new(self._itemHolderFrame, text, def, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return toggle
end

--- Create a new [`Slider`] under this [`Section`] object.
-- settings: { min: number, max: number, default?: number, step?: number }
function Section.Slider(self: Section, text: string, settings: any, callback: (number) -> ())
    local slider = self._trove:Add(Slider.new(self._itemHolderFrame, text, settings, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return slider
end

--- Create a new [`Dropdown`] under this [`Section`] object.
function Section.Dropdown(self: Section, text: string, items: { string }, selected: string?, callback: (string) -> ())
    local dropdown = self._trove:Add(Dropdown.new(self._itemHolderFrame, text, items, selected, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return dropdown
end

--- Create a new [`Colorpicker`] under this [`Section`] object.
function Section.Colorpicker(self: Section, text: string, preset: Color3, callback: (Color3) -> ())
    local colorpicker = self._trove:Add(Colorpicker.new(self._itemHolderFrame, text, preset, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return colorpicker
end

--- Create a new [`Bind`] under this [`Section`] object.
function Section.Bind(self: Section, text: string, preset: any, callback: (any) -> ())
    local bind = self._trove:Add(Bind.new(self._itemHolderFrame, text, preset, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return bind
end

--- Create a new [`Textbox`] under this [`Section`] object.
function Section.Textbox(self: Section, text: string, numberOnly: boolean, disappear: boolean, callback: (string) -> ())
    local textbox = self._trove:Add(Textbox.new(self._itemHolderFrame, text, numberOnly, disappear, callback))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return textbox
end

--- Create a new [`Label`] under this [`Section`] object.
function Section.Label(self: Section, text: string)
    local label = self._trove:Add(Label.new(self._itemHolderFrame, text))
    self._container.Size = UDim2.new(1, -2, 0, self._itemHolderLayout.AbsoluteContentSize.Y + 24)
    return label
end

return Section
