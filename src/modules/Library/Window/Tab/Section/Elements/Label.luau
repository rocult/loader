-- Dependencies
local Trove = require("@pkgs/trove")

--- A label.
local Label = {}
Label.__index = Label

-- Types
export type LabelData = {
    _trove: Trove.Trove,
    label: TextLabel,
}
export type Label = setmetatable<LabelData, typeof(Label)>

--- Create a new [`Label`] object.
function Label.new(container: GuiObject, text: string): Label
    local label = Label.InitialiseElements(container, text)

    local self: LabelData = {
        _trove = Trove.new(),
        label = label,
    }
    self = setmetatable(self, Label)

    return self
end

--- Destroy this object and cleanup.
function Label.Destroy(self: Label)
    self._trove:Destroy()
end

--- Create the instances for a [`Label`].
function Label.InitialiseElements(container: GuiObject, text: string)
    local LabelElement = Instance.new("TextLabel")
    LabelElement.Name = "Label"
    LabelElement.Parent = container
    LabelElement.BackgroundTransparency = 1
    LabelElement.Size = UDim2.new(1, 0, 0, 18)
    LabelElement.Font = Enum.Font.Code
    LabelElement.TextColor3 = Color3.fromRGB(255, 255, 255)
    LabelElement.TextSize = 14
    LabelElement.TextXAlignment = Enum.TextXAlignment.Left
    LabelElement.Text = text
    return LabelElement
end

function Label.SetText(self: Label, text: string)
    self.label.Text = text
end

function Label.GetText(self: Label): string
    return self.label.Text
end

return Label
