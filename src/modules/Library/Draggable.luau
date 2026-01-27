-- Dependencies
local Trove = require("@pkgs/trove")

-- Services
local UserInputService = cloneref(game:GetService("UserInputService"))

--- Converts a Gui instance to a draggable one.
local Draggable = {}
Draggable.__index = Draggable

-- Types
export type DraggableData = {
    _trove: Trove.Trove,
    _draggable: GuiObject,
    _container: GuiObject,
}
export type Draggable = setmetatable<DraggableData, typeof(Draggable)>

--- Create a new [`Draggable`] object.
function Draggable.new(draggableObject: GuiObject, container: GuiObject): Draggable
    -- Create the object
    local self: DraggableData = {
        _trove = Trove.new(),
        _draggable = draggableObject,
        _container = container,
    }
    self = setmetatable(self, Draggable)

    -- Initialise the main behaviour
    self:Initialise()

    -- Return the object
    return self
end

--- Destory this object, and clean up.
function Draggable.Destroy(self: Draggable)
    self._trove:Destroy()
end

--- Initialise this object by creating all of the connections.
function Draggable.Initialise(self: Draggable)
    local dragging = false
    local dragInput: InputObject
    local mousePos: Vector3
    local framePos: UDim2

    self._trove:Connect(self._draggable.InputBegan, function(input: InputObject)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        dragging = true
        mousePos = input.Position
        framePos = self._container.Position

        self._trove:Connect(input.Changed, function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    self._trove:Connect(self._draggable.InputChanged, function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    self._trove:Connect(UserInputService.InputChanged, function(input: InputObject)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            self._container.Position = framePos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
end

return Draggable
