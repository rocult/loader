-- Dependencies
local Trove = require("@pkgs/trove")
local Window = require("@self/Window")

-- Services
local CoreGui = cloneref(game:GetService("CoreGui"))

--- The main key system library
local Library = {}
Library.__index = Library

-- Types
export type LibraryData = {
    _trove: Trove.Trove,
    _container: ScreenGui,
    _notifications: Folder,

    _accentColor: Color3,
    _dropdownFrames: { Frame },
    _colorPickerFrames: { Frame },
}
export type Library = setmetatable<LibraryData, typeof(Library)>

--- Create a new [`Library`] object.
function Library.new(): Library
    -- Create the objects
    local trove = Trove.new()
    local container = trove:Add(Instance.new("ScreenGui"))
    container.Name = "rocult"
    setthreadidentity(8)
    container.Parent = if gethui then gethui() else CoreGui
    container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local notifications = trove:Add(Instance.new("Folder"))
    notifications.Name = "NotificationFolder"
    notifications.Parent = container

    -- Create and return the object
    local self: LibraryData = {
        _trove = trove,
        _container = container,
        _notifications = notifications,
        _accentColor = Color3.fromRGB(128, 213, 247),
        _dropdownFrames = {},
        _colorPickerFrames = {},
    }
    return setmetatable(self, Library)
end

--- Destroy this object and clean up.
function Library.Destroy(self: Library)
    self._trove:Destroy()
end

--- Show a notification.
function Library.Notify(self: Library, title: string, text: string, duration: number)
    for _, notification in self._notifications:GetChildren() do
        notification = notification :: GuiObject

        notification:TweenPosition(
            UDim2.fromScale(0.5, notification.Position.Y.Scale - 0.05),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.3,
            true
        )
    end

    local Notification = Instance.new("Frame")
    local OutlineNotification1 = Instance.new("ImageLabel")
    local OutlineNotification2 = Instance.new("ImageLabel")
    local NotificationIco = Instance.new("ImageLabel")
    local NotificationTitle = Instance.new("TextLabel")
    local NotificationDesc = Instance.new("TextLabel")

    Notification.Name = "Notification"
    Notification.Parent = self._notifications
    Notification.AnchorPoint = Vector2.new(0.5, 0.5)
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Notification.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.fromScale(1.5, 0.5)
    Notification.Size = UDim2.fromOffset(328, 45)

    OutlineNotification1.Name = "OutlineNotification1"
    OutlineNotification1.Parent = Notification
    OutlineNotification1.BackgroundTransparency = 1.000
    OutlineNotification1.Position = UDim2.fromOffset(1, 1)
    OutlineNotification1.Size = UDim2.new(1, -2, 1, -2)
    OutlineNotification1.Image = "rbxassetid://2592362371"
    OutlineNotification1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    OutlineNotification1.ScaleType = Enum.ScaleType.Slice
    OutlineNotification1.SliceCenter = Rect.new(2, 2, 62, 62)

    OutlineNotification2.Name = "OutlineNotification2"
    OutlineNotification2.Parent = Notification
    OutlineNotification2.BackgroundTransparency = 1.000
    OutlineNotification2.Size = UDim2.fromScale(1, 1)
    OutlineNotification2.Image = "rbxassetid://2592362371"
    OutlineNotification2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    OutlineNotification2.ScaleType = Enum.ScaleType.Slice
    OutlineNotification2.SliceCenter = Rect.new(2, 2, 62, 62)

    NotificationIco.Name = "NotificationIco"
    NotificationIco.Parent = Notification
    NotificationIco.AnchorPoint = Vector2.new(0, 0.5)
    NotificationIco.BackgroundColor3 = Color3.fromRGB(0, 184, 113)
    NotificationIco.BackgroundTransparency = 1.000
    NotificationIco.Position = UDim2.new(0, 7, 0.5, 0)
    NotificationIco.Size = UDim2.fromOffset(25, 25)
    NotificationIco.Image = "http://www.roblox.com/asset/?id=6026568210"
    NotificationIco.ImageColor3 = self._accentColor

    NotificationTitle.Name = "NotificationTitle"
    NotificationTitle.Parent = Notification
    NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationTitle.BackgroundTransparency = 1.000
    NotificationTitle.Position = UDim2.fromOffset(39, 6)
    NotificationTitle.Size = UDim2.fromOffset(200, 19)
    NotificationTitle.Font = Enum.Font.Code
    NotificationTitle.Text = title
    NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotificationTitle.TextSize = 16.000
    NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

    NotificationDesc.Name = "NotificationDesc"
    NotificationDesc.Parent = Notification
    NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationDesc.BackgroundTransparency = 1.000
    NotificationDesc.Position = UDim2.new(0.0143884895, 35, 1, -25)
    NotificationDesc.Size = UDim2.fromOffset(200, 19)
    NotificationDesc.Font = Enum.Font.Code
    NotificationDesc.Text = text
    NotificationDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotificationDesc.TextSize = 15.000
    NotificationDesc.TextXAlignment = Enum.TextXAlignment.Left

    Notification.Size = UDim2.fromOffset(NotificationDesc.TextBounds.X + 45, 45)

    if #NotificationTitle.Text >= #NotificationDesc.Text then
        Notification.Size = UDim2.fromOffset(NotificationTitle.TextBounds.X + 45, 45)
    end

    Notification:TweenPosition(UDim2.fromScale(0.5, 0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)

    self._trove:Add(task.delay(duration, function()
        Notification:TweenPosition(
            UDim2.fromScale(1.5, Notification.Position.Y.Scale),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Linear,
            0.2,
            true,
            function()
                if Notification.Parent then
                    Notification:Destroy()
                end
            end
        )
    end))
end

--- Create a new [`Window`] object, under this library.
function Library.Window(self: Library, title: string)
    return self._trove:Add(Window.new(self._container, title))
end

return Library
