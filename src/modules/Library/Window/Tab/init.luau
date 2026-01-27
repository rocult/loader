-- Dependencies
local Trove = require("@pkgs/trove")
local Section = require("@self/Section")

--- Services
local TweenService = cloneref(game:GetService("TweenService"))

--- A tab.
local Tab = {}
Tab.__index = Tab

-- Types
export type TabData = {
    _trove: Trove.Trove,
    _sectionCounter: number,

    _sectionA: ScrollingFrame,
    _sectionB: ScrollingFrame,
}
export type Tab = setmetatable<TabData, typeof(Tab)>

--- Create a new [`Tab`] object.
function Tab.new(text: string, show: boolean, TabHolderFrame: Frame, ContainerHolderFrame: Frame): Tab
    local TabBtn, SectionHolder1, SectionHolder2 =
        Tab.InitialiseElements(text, show, TabHolderFrame, ContainerHolderFrame)

    -- Create the object
    local self: TabData = {
        _trove = Trove.new(),
        _sectionCounter = 50,
        _sectionA = SectionHolder1,
        _sectionB = SectionHolder2,
    }
    self = setmetatable(self, Tab)

    -- Initialise the rest
    self:InitialiseConnections(TabBtn, TabHolderFrame, ContainerHolderFrame, SectionHolder1, SectionHolder2)

    -- Return the object
    return self
end

--- Destroy this object and clean up.
function Tab.Destroy(self: Tab)
    self._trove:Destroy()
end

--- Create the instances for a [`Tab`].
function Tab.InitialiseElements(text: string, show: boolean, TabHolderFrame: Frame, ContainerHolderFrame: Frame)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "TabBtn"
    TabBtn.Parent = TabHolderFrame
    TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.BackgroundTransparency = 1.000
    TabBtn.Font = Enum.Font.Code
    TabBtn.Text = text
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 15.000
    TabBtn.TextTransparency = if show then 0 else 0.400
    TabBtn.Size = UDim2.new(0, TabBtn.TextBounds.X, 1, 0)

    local SectionHolder1 = Instance.new("ScrollingFrame")
    local SectionHolder1Padding = Instance.new("UIPadding")
    local SectionHolder1Layout = Instance.new("UIListLayout")
    local SectionHolder2 = Instance.new("ScrollingFrame")
    local SectionHolder2Padding = Instance.new("UIPadding")
    local SectionHolder2Layout = Instance.new("UIListLayout")

    SectionHolder1.Name = "SectionHolder1"
    SectionHolder1.Parent = ContainerHolderFrame
    SectionHolder1.Active = true
    SectionHolder1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionHolder1.BackgroundTransparency = 1.000
    SectionHolder1.BorderSizePixel = 0
    SectionHolder1.Position = UDim2.fromOffset(1, 20)
    SectionHolder1.Size = UDim2.new(0, 281, 1, -40)
    SectionHolder1.Visible = show
    SectionHolder1.CanvasSize = UDim2.new(0, 0, 0, 0)
    SectionHolder1.ScrollBarThickness = 0
    SectionHolder1.ZIndex = 1

    SectionHolder1Padding.Name = "SectionHolder1Padding"
    SectionHolder1Padding.Parent = SectionHolder1
    SectionHolder1Padding.PaddingTop = UDim.new(0, 5)

    SectionHolder1Layout.Name = "SectionHolder1Layout"
    SectionHolder1Layout.Parent = SectionHolder1
    SectionHolder1Layout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionHolder1Layout.Padding = UDim.new(0, 10)

    SectionHolder2.Name = "SectionHolder2"
    SectionHolder2.Parent = ContainerHolderFrame
    SectionHolder2.Active = true
    SectionHolder2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionHolder2.BackgroundTransparency = 1.000
    SectionHolder2.BorderSizePixel = 0
    SectionHolder2.Position = UDim2.fromOffset(243, 32)
    SectionHolder2.Size = UDim2.new(0, 227, 1, -40)
    SectionHolder2.Visible = show
    SectionHolder2.CanvasSize = UDim2.new(0, 0, 0, 0)
    SectionHolder2.ScrollBarThickness = 0
    SectionHolder1.ZIndex = 2

    SectionHolder2Padding.Name = "SectionHolder2Padding"
    SectionHolder2Padding.Parent = SectionHolder2
    SectionHolder2Padding.PaddingTop = UDim.new(0, 5)

    SectionHolder2Layout.Name = "SectionHolder2Layout"
    SectionHolder2Layout.Parent = SectionHolder2
    SectionHolder2Layout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionHolder2Layout.Padding = UDim.new(0, 10)

    return TabBtn, SectionHolder1, SectionHolder2
end

--- Initialise all of the connections for the [`Tab`].
function Tab.InitialiseConnections(
    self: Tab,
    TabBtn: GuiButton,
    TabHolderFrame: Frame,
    ContainerHolderFrame: Frame,
    SectionHolder1: ScrollingFrame,
    SectionHolder2: ScrollingFrame
)
    self._trove:Connect(TabBtn.MouseButton1Click, function()
        for _, v in TabHolderFrame:GetChildren() do
            if v.Name == "TabBtn" then
                TweenService:Create(
                    v,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { TextTransparency = 0.4 }
                ):Play()
            end
        end

        for _, v in ContainerHolderFrame:GetChildren() do
            v = v :: GuiObject

            if v.Name == "SectionHolder1" or v.Name == "SectionHolder2" then
                v.Visible = false
            end
        end

        SectionHolder1.Visible = true
        SectionHolder2.Visible = true

        TweenService
            :Create(
                TabBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { TextTransparency = 0 }
            )
            :Play()
    end)
end

--- Create a new [`Section`] under this [`Tab`] object.
function Tab.Section(self: Tab, text: string)
    self._sectionCounter -= 1

    local sectionA = #self._sectionA:GetChildren()
    local sectionB = #self._sectionB:GetChildren()
    local parent = if sectionA == sectionB then self._sectionA else self._sectionB

    return self._trove:Add(Section.new(parent, self._sectionCounter, text))
end

return Tab
