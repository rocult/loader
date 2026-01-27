-- Dependencies
local Trove = require("@pkgs/trove")

--- A dropdown list.
local Dropdown = {}
Dropdown.__index = Dropdown

-- Types
export type DropdownData = {
    _trove: Trove.Trove,
    _callback: (string) -> (),
    _open: boolean,
    _items: { string },
    _selected: string?,
    header: TextButton,
    selectedLabel: TextLabel,
    listFrame: Frame,
}
export type Dropdown = setmetatable<DropdownData, typeof(Dropdown)>

--- Create a new [`Dropdown`] object.
function Dropdown.new(
    container: GuiObject,
    text: string,
    items: { string },
    selected: string?,
    callback: (string) -> ()
): Dropdown
    -- Create the elements
    local header, selectedLabel, listFrame = Dropdown.InitialiseElements(container, text)

    -- Create the object
    local self: DropdownData = {
        _trove = Trove.new(),
        _callback = callback,
        _open = false,
        _items = table.clone(items or {}),
        _selected = selected,
        header = header,
        selectedLabel = selectedLabel,
        listFrame = listFrame,
    }
    self = setmetatable(self, Dropdown)

    -- Initialise the connections
    self:InitialiseConnections()
    self:SetItems(self._items)
    if selected then
        self:Select(selected)
    end

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Dropdown.Destroy(self: Dropdown)
    self._trove:Destroy()
end

--- Create the instances for a [`Dropdown`].
function Dropdown.InitialiseElements(container: GuiObject, text: string)
    local Root = Instance.new("Frame")
    Root.Name = "Dropdown"
    Root.Parent = container
    Root.BackgroundTransparency = 1
    Root.Size = UDim2.new(1, 0, 0, 24)

    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.Parent = Root
    Header.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.AutoButtonColor = false
    Header.Font = Enum.Font.Code
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
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(6, 0)
    Title.Size = UDim2.fromScale(0, 1)
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Text = text

    local Selected = Instance.new("TextLabel")
    Selected.Name = "Selected"
    Selected.Parent = Header
    Selected.BackgroundTransparency = 1
    Selected.Position = UDim2.new(1, -6, 0, 0)
    Selected.Size = UDim2.fromScale(0, 1)
    Selected.Font = Enum.Font.Code
    Selected.TextColor3 = Color3.fromRGB(200, 200, 200)
    Selected.TextSize = 14
    Selected.TextXAlignment = Enum.TextXAlignment.Right

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "List"
    ListFrame.Parent = Root
    ListFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    ListFrame.BorderSizePixel = 0
    ListFrame.Position = UDim2.fromOffset(0, 24)
    ListFrame.Size = UDim2.fromScale(1, 0)
    ListFrame.Visible = false

    local UIL = Instance.new("UIListLayout")
    UIL.Parent = ListFrame
    UIL.FillDirection = Enum.FillDirection.Vertical
    UIL.SortOrder = Enum.SortOrder.LayoutOrder
    UIL.Padding = UDim.new(0, 2)

    return Header, Selected, ListFrame
end

local function createItem(self: Dropdown, text: string)
    local Item = Instance.new("TextButton")
    Item.Name = text
    Item.Parent = self.listFrame
    Item.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Item.AutoButtonColor = false
    Item.Size = UDim2.new(1, 0, 0, 20)
    Item.Font = Enum.Font.Code
    Item.TextColor3 = Color3.fromRGB(255, 255, 255)
    Item.TextSize = 14
    Item.TextXAlignment = Enum.TextXAlignment.Left
    Item.Text = text

    self._trove:Connect(Item.MouseButton1Click, function()
        self:Select(text)
        pcall(self._callback, text)
        self:Close()
    end)
end

--- Initialise all of the connections for a [`Dropdown`].
function Dropdown.InitialiseConnections(self: Dropdown)
    self._trove:Connect(self.header.MouseButton1Click, function()
        if self._open then
            self:Close()
        else
            self:Open()
        end
    end)
end

--- Populate items.
function Dropdown.SetItems(self: Dropdown, items: { string })
    self._items = table.clone(items or {})
    for _, child in self.listFrame:GetChildren() do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, v in self._items do
        createItem(self, v)
    end
    self.listFrame.Size = UDim2.new(1, 0, 0, #self._items * 22)
end

--- Open the dropdown list.
function Dropdown.Open(self: Dropdown)
    self._open = true
    self.listFrame.Visible = true
end

--- Close the dropdown list.
function Dropdown.Close(self: Dropdown)
    self._open = false
    self.listFrame.Visible = false
end

--- Select a value.
function Dropdown.Select(self: Dropdown, value: string)
    self._selected = value
    self.selectedLabel.Text = value or ""
end

--- Get selected value.
function Dropdown.Get(self: Dropdown): string?
    return self._selected
end

return Dropdown
