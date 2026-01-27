-- Dependencies
local Trove = require("@pkgs/trove")
local Draggable = require("@modules/Library/Draggable")
local gameData = require("@core/data")
local Tab = require("@self/Tab")
local LibraryData = require("@modules/Library/data")

-- Services
local UserInputService = cloneref(game:GetService("UserInputService"))

--- A window.
local Window = {}
Window.__index = Window

-- Types
export type WindowData = {
    _trove: Trove.Trove,

    _toggled: boolean,
    _tabHolderFrame: Frame,
    _containerHolderFrame: Frame,

    topBarLine: Frame,
}
export type Window = setmetatable<WindowData, typeof(Window)>

--- Create a new [`Window`] object.
function Window.new(parent: GuiBase2d, text: string): Window
    local trove = Trove.new()
    local TopBar, TopBarLine, MainFrame, TabHolderFrame, ContainerHolderFrame = Window.InitialiseElements(parent, text)

    -- Create the object
    local self: WindowData = {
        _trove = trove,
        _toggled = false,
        _tabHolderFrame = TabHolderFrame,
        _containerHolderFrame = ContainerHolderFrame,
        topBarLine = TopBarLine,
    }
    self = setmetatable(self, Window)

    -- Initialise connections
    self:InitialiseConnections(TopBar, MainFrame)

    -- Return the object
    return self
end

--- Destroy this object and cleanup.
function Window.Destroy(self: Window)
    self._trove:Destroy()
end

--- Initialise the object by creating all of the objects.
function Window.InitialiseElements(parent: GuiBase2d, text: string)
    local MainFrame = Instance.new("Frame")
    local OutlineMainFrame1 = Instance.new("ImageLabel")
    local OutlineMainFrame2 = Instance.new("ImageLabel")
    local ContainerHolderFrame = Instance.new("Frame")
    local TabHolderFrame = Instance.new("Frame")
    local TabHolderFrameLayout = Instance.new("UIListLayout")
    local TabHolderFramePadding = Instance.new("UIPadding")
    local TopBar = Instance.new("Frame")
    local TopBarTitle = Instance.new("TextLabel")
    local TopBarLine = Instance.new("Frame")

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = parent
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.Size = UDim2.fromOffset(300, gameData.FFA and 250 or 235)
    MainFrame.Visible = true

    OutlineMainFrame1.Name = "OutlineMainFrame1"
    OutlineMainFrame1.Parent = MainFrame
    OutlineMainFrame1.BackgroundTransparency = 1.000
    OutlineMainFrame1.Position = UDim2.fromOffset(1, 1)
    OutlineMainFrame1.Size = UDim2.new(1, -2, 1, -2)
    OutlineMainFrame1.Image = "rbxassetid://2592362371"
    OutlineMainFrame1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    OutlineMainFrame1.ScaleType = Enum.ScaleType.Slice
    OutlineMainFrame1.SliceCenter = Rect.new(2, 2, 62, 62)

    OutlineMainFrame2.Name = "OutlineMainFrame2"
    OutlineMainFrame2.Parent = MainFrame
    OutlineMainFrame2.BackgroundTransparency = 1.000
    OutlineMainFrame2.Size = UDim2.fromScale(1, 1)
    OutlineMainFrame2.Image = "rbxassetid://2592362371"
    OutlineMainFrame2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    OutlineMainFrame2.ScaleType = Enum.ScaleType.Slice
    OutlineMainFrame2.SliceCenter = Rect.new(2, 2, 62, 62)

    ContainerHolderFrame.Name = "ContainerHolderFrame"
    ContainerHolderFrame.Parent = MainFrame
    ContainerHolderFrame.AnchorPoint = Vector2.new(0.5, 0)
    ContainerHolderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    ContainerHolderFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
    ContainerHolderFrame.Position = UDim2.fromScale(0.5, 0.071)
    ContainerHolderFrame.Size = UDim2.new(1, -18, 0, 487)
    ContainerHolderFrame.BackgroundTransparency = 1

    TabHolderFrame.Name = "TabHolderFrame"
    TabHolderFrame.Parent = ContainerHolderFrame
    TabHolderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabHolderFrame.BackgroundTransparency = 1.000
    TabHolderFrame.Size = UDim2.new(1, 0, 0, 28)
    TabHolderFrame.Visible = false

    TabHolderFrameLayout.Name = "TabHolderFrameLayout"
    TabHolderFrameLayout.Parent = TabHolderFrame
    TabHolderFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    TabHolderFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHolderFrameLayout.Padding = UDim.new(0, 8)

    TabHolderFramePadding.Name = "TabHolderFramePadding"
    TabHolderFramePadding.Parent = TabHolderFrame
    TabHolderFramePadding.PaddingLeft = UDim.new(0, 7)

    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.AnchorPoint = Vector2.new(0.5, 0)
    TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    TopBar.BorderSizePixel = 0
    TopBar.Position = UDim2.new(0.5, 0, 0, 2)
    TopBar.Size = UDim2.new(1, -5, 0, 28)

    TopBarTitle.Name = "TopBarTitle"
    TopBarTitle.Parent = TopBar
    TopBarTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopBarTitle.BackgroundTransparency = 1.000
    TopBarTitle.Position = UDim2.fromOffset(7, 5)
    TopBarTitle.Size = UDim2.fromOffset(0, 16)
    TopBarTitle.Font = Enum.Font.Code
    TopBarTitle.Text = text
    TopBarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopBarTitle.TextSize = 16.000
    TopBarTitle.TextXAlignment = Enum.TextXAlignment.Left

    TopBarLine.Name = "TopBarLine"
    TopBarLine.Parent = TopBar
    TopBarLine.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
    TopBarLine.BorderColor3 = LibraryData.ACCENT_COLOUR
    TopBarLine.BorderSizePixel = 0
    TopBarLine.Position = UDim2.fromOffset(0, 27)
    TopBarLine.Size = UDim2.new(1, 0, 0, 1)

    return TopBar, TopBarLine, MainFrame, TabHolderFrame, ContainerHolderFrame
end

--- Initialise all of the connections.
function Window.InitialiseConnections(self: Window, TopBar: Frame, MainFrame: Frame)
    self._trove:Add(Draggable.new(TopBar, MainFrame))
    self._trove:Connect(UserInputService.InputBegan, function(inputObject: InputObject)
        if inputObject.KeyCode == Enum.KeyCode.RightShift then
            self._toggled = not self._toggled
            MainFrame.Visible = self._toggled
        end
    end)
    self._trove:Add(MainFrame)
end

--- Create a new [`Tab`] object under this [`Window`] object.
function Window.Tab(self: Window, title: string, show: boolean)
    return self._trove:Add(Tab.new(title, show, self._tabHolderFrame, self._containerHolderFrame))
end

return Window
