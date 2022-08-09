-- a message box
-- message('My first addon!')

-- C_Timer.NewTicker(3, function ()
--     for i = 1,3 do
--         if UnitExists("target") then
--             print(i, UnitName("target"))
--         else
--             print(i, UnitName("player"))
--         end
--     end
-- end)


DataCache.Initialize()

local events = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_LOOT"
}
local frame = CreateFrame("Frame")
for _, event in ipairs(events) do
    print(event)
    frame:RegisterEvent(event)
end

function EventsFactory(event, args)
    local enabled_tasks = Tasks
    local function eval(event)
        for _, obj in ipairs(enabled_tasks) do
            if table.has_value(obj.EVENTS, event) then
                obj.Actions(event, obj.ArgsParser(args))
            end
        end
    end

    eval(event)
end

function EventsCallbacks(_, event, ...)
    local event_args = {...}
    EventsFactory(event, event_args)
end

frame:SetScript("OnEvent", EventsCallbacks)
