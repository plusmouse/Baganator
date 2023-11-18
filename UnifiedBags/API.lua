table.insert(Baganator.Constants.Events, "NewPlugin")

Baganator.Constants.NewPluginType = EnumUtil.MakeEnum("ItemButtonInitializer")

local cornerDetails = {}
local clearCallbacks = {}
local onDataSetCallbacks = {}
local onButtonInitialized = {}

Baganator.UnifiedBags.API = {}

function Baganator.UnifiedBags.API:RegisterButtonCorner(cornerValue, localeText, positioningCallback, autoOptions)
  autoOptions = autoOptions or {"show_" .. cornerValue}
end

function Baganator.UnifiedBags.API:RegisterButtonClear(clearCallback)
end

function Baganator.UnifiedBags.API:RegisterButtonDataSet(configName, dataCallback, optionalSeparateOptionLocaleText)
end

function Baganator.UnifiedBags.API:RegisterButtonInitializer(callback)
  Baganator.CallbackRegistry:TriggerEvent("NewPlugin")
end
