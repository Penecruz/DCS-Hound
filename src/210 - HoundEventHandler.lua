    --- HOUND.EventHandler
    -- class to managing Hound Specific event handlers
    -- @module HOUND.EventHandler
do
    --- HOUND.EventHandler Decleration
    -- @type HOUND.EventHandler
    HOUND.EventHandler = {
        idx = 0,
        subscribers = {},
        _internalSubscribers = {}
    }

    HOUND.EventHandler.__index = HOUND.EventHandler

    --- register new event handler
    -- @param handler handler to register
    function HOUND.EventHandler.addEventHandler(handler)
        if type(handler) == "table" then
            HOUND.EventHandler.subscribers[handler] = handler
        end
    end

    --- deregister event handler
    -- @param handler handler to remove
    function HOUND.EventHandler.removeEventHandler(handler)
        HOUND.EventHandler.subscribers[handler] = nil
    end

    --- register new internal event handler
    -- @local
    -- @param handler handler to register
    function HOUND.EventHandler.addInternalEventHandler(handler)
        if type(handler) == "table" then
            HOUND.EventHandler._internalSubscribers[handler] = handler
        end
    end

    --- deregister internal event handler
    -- @local
    -- @param handler handler to register
    function HOUND.EventHandler.removeInternalEventHandler(handler)
        if setContains(HOUND.EventHandler._internalSubscribers,handler) then
            HOUND.EventHandler._internalSubscribers[handler] = nil
        end
    end

    --- Execute event on all registeres subscribers
    function HOUND.EventHandler.onHoundEvent(event)
        for _, handler in pairs(HOUND.EventHandler._internalSubscribers) do
            if handler.onHoundEvent and type(handler.onHoundEvent) == "function" then
                if handler and handler.settings then
                    handler:onHoundEvent(event)
                end
            end
        end
        for _, handler in pairs(HOUND.EventHandler.subscribers) do
            if handler.onHoundEvent and type(handler.onHoundEvent) == "function" then
                handler:onHoundEvent(event)
            end
        end
    end

    --- publish event to subscribers
    -- @local
    function HOUND.EventHandler.publishEvent(event)
        event.time = timer.getTime()
        HOUND.EventHandler.onHoundEvent(event)
        -- return event.idx
    end

    --- get next event idx
    -- @local
    function HOUND.EventHandler.getIdx()
        HOUND.EventHandler.idx = HOUND.EventHandler.idx + 1
        return  HOUND.EventHandler.idx
    end
end
