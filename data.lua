DataCache = DataCache or {}
Data = {}
DataCache.FishingLoot = {}

FishingInfo = {}
function FishingInfo.loadData()
    Data.FishingLoot = collections.Counter.new(DataCache.FishingLoot)
end

function FishingInfo.SerializeData()
    DataCache.FishingLoot = Data.FishingLoot:get_table()
end


function DataCache.Initialize()
    local frame = CreateFrame("Frame")
    local ADDON_LOADED = "ADDON_LOADED"
    local ADDONS_UNLOADING = "ADDONS_UNLOADING"
    frame:RegisterEvent(ADDON_LOADED)
    frame:RegisterEvent(ADDONS_UNLOADING)
    frame:SetScript("OnEvent", function (_, event, ...)
        if event == ADDON_LOADED then
            FishingInfo.loadData()
        end
        if event == ADDONS_UNLOADING then
            FishingInfo.SerializeData()
        end
    end)
end