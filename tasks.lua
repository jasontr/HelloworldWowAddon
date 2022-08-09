local Chats = {}
Chats.EVENTS = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER"
}

function Chats.ArgsParser(args)
    local parsed_args = {}
    parsed_args.text = args[1]
    parsed_args.playerName = args[2]
    parsed_args.playerNameWithoutServer = args[5]
    parsed_args.channelBaseName = args[9]
    parsed_args.guid = args[12]
    return parsed_args
end

function Chats.Actions(event, args)
    local msg = string.format("Player: %s said: %s @ %s.", args.playerNameWithoutServer, args.text, event)
    print(msg)
end

local InstanceGrouping = {}
InstanceGrouping.EVENTS = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_CHANNEL"
}

InstanceGrouping.ArgsParser = Chats.ArgsParser

InstanceGrouping.KEY_WORDS = {
    '怒焰',
    'NY',
    -- 'YY',
    'AH',
    '哀嚎',
    '自强',
    '血色',
    'TestMessage'
}
InstanceGrouping.SKIP_WORDS = {
    '避雷',
    '双门',
    '老板',
    '2门',
    '价格'
}

-- local target_channel = "自强组队"
-- local channels = {GetChannelList()}
-- local target_channel_id = nil
-- local language_id = nil
-- for i = 1, #channels, 3 do
--     local id, name, disabled = channels[i], channels[i+1], channels[i+2]
-- 	print(id, name, disabled)
--     if name == target_channel then
-- 	    print(id, name, disabled)
--         target_channel_id = id
--         break
--     end
-- end
--local messageFrame = CreateFrame("ScrollingMessageFrame", 'InfoPannel', nil)
function GetChatWindowFrame(index)
    return getglobal("ChatFrame"..index) or DEFAULT_CHAT_FRAME
end
local messageFrame = GetChatWindowFrame(4)
messageFrame:SetSize(300, 300)
messageFrame:SetPoint("LEFT")
messageFrame:SetFont("Fonts\\ARHei.ttf", 11)
messageFrame:SetTimeVisible(180.0)
messageFrame:SetJustifyH("LEFT")
messageFrame:Show()

function InstanceGrouping.MsgBuilder(playerName, channel, text, event)
    local msg = ""
    local event_in_short = string.sub(event, 10)
    if channel ~= "" then
        msg = msg .. string.format("[%s] ", channel)
    else
        msg = msg .. string.format("(%s) ", event_in_short)
    end
    msg = msg .. string.format("[%s]: ", GetPlayerLink(playerName, playerName))
    -- msg = msg .. "------------------------------------------\n"
    msg = msg .. text
    msg = msg .. "\n\n"
    return msg
end

function InstanceGrouping.Actions(event, args)
    --print("check ", args.text)
    if table.has_value(InstanceGrouping.SKIP_WORDS, args.text, function (keyword, _text)
        return string.find(_text, keyword)
    end) then
        return
    end
    if table.has_value(InstanceGrouping.KEY_WORDS, args.text, function (keyword, _text)
        return string.find(_text, keyword)
    end) then
        local msg = InstanceGrouping.MsgBuilder(args.playerNameWithoutServer, args.channelBaseName, args.text, event)
        messageFrame.AddMessage(messageFrame, msg, 255/255, 192/255, 192/255, nil)
        -- if target_channel_id then
        --     
        --     SendChatMessage("======================", "CHANNEL", language_id, target_channel_id)
        --     SendChatMessage(string.format("= Player: %s", args.playerNameWithoutServer), "CHANNEL", language_id, target_channel_id)
        --     SendChatMessage(string.format("= Channel: %s", args.channelBaseName), "CHANNEL", language_id, target_channel_id)
        --     SendChatMessage("======================", "CHANNEL", language_id, target_channel_id)
        --     SendChatMessage(args.text, "CHANNEL", language_id, target_channel_id)
        -- end
    end
end

local LootInfos = {}
LootInfos.EVENTS = {
    'CHAT_MSG_LOOT'
}
LootInfos.ArgsParser = Chats.ArgsParser
function LootInfos.Actions(event, args)
    Data.FishingLoot:update(string.sub(args.text, 22, -4))
    print(string.sub(args.text, 22, -4))
end

Tasks = {
    Chats,
    InstanceGrouping,
    -- LootInfos
}