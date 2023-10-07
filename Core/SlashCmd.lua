Baganator.SlashCmd = {}

function Baganator.SlashCmd.Initialize()
  SlashCmdList["Baganator"] = Baganator.SlashCmd.Handler
  SLASH_Baganator1 = "/baganator"
  SLASH_Baganator2 = "/bgr"
end

local INVALID_OPTION_VALUE = "Wrong config value type %s (required %s)"
function Baganator.SlashCmd.Config(optionName, value1, ...)
  if optionName == nil then
    Baganator.Utilities.Message("No config option name supplied")
    for _, name in pairs(Baganator.Config.Options) do
      Baganator.Utilities.Message(name .. ": " .. tostring(Baganator.Config.Get(name)))
    end
    return
  end

  local currentValue = Baganator.Config.Get(optionName)
  if currentValue == nil then
    Baganator.Utilities.Message("Unknown config: " .. optionName)
    return
  end

  if value1 == nil then
    Baganator.Utilities.Message("Config " .. optionName .. ": " .. tostring(currentValue))
    return
  end

  if type(currentValue) == "boolean" then
    if value1 ~= "true" and value1 ~= "false" then
      Baganator.Utilities.Message(INVALID_OPTION_VALUE:format(type(value1), type(currentValue)))
      return
    end
    Baganator.Config.Set(optionName, value1 == "true")
  elseif type(currentValue) == "number" then
    if tonumber(value1) == nil then
      Baganator.Utilities.Message(INVALID_OPTION_VALUE:format(type(value1), type(currentValue)))
      return
    end
    Baganator.Config.Set(optionName, tonumber(value1))
  elseif type(currentValue) == "string" then
    Baganator.Config.Set(optionName, strjoin(" ", value1, ...))
  else
    Baganator.Utilities.Message("Unable to edit option type " .. type(currentValue))
    return
  end
  Baganator.Utilities.Message("Now set " .. optionName .. ": " .. tostring(Baganator.Config.Get(optionName)))
end

function Baganator.SlashCmd.Debug(...)
  Baganator.Config.Set(Baganator.Config.Options.DEBUG, not Baganator.Config.Get(Baganator.Config.Options.DEBUG))
  if Baganator.Config.Get(Baganator.Config.Options.DEBUG) then
    Baganator.Utilities.Message("Debug mode on")
  else
    Baganator.Utilities.Message("Debug mode off")
  end
end

function Baganator.SlashCmd.RemoveCharacter(characterName)
  local characterData = BAGANATOR_DATA.Characters[characterName or ""]
  if not characterData then
    Baganator.Utilities.Message("Unrecognised character")
    return
  end

  BAGANATOR_DATA.Characters[characterName] = nil
  local realmSummary = BAGANATOR_SUMMARIES.ByRealm[characterData.details.realmNormalized]
  if realmSummary and realmSummary[characterData.details.character] then
    realmSummary[characterData.details.character] = nil
  end
  Baganator.CallbackRegistry:TriggerEvent("CharacterDeleted", characterName)
  Baganator.Utilities.Message("Character '" .. characterName .. "' removed. Close any open bags to complete.")
end

function Baganator.SlashCmd.CustomiseUI()
  Baganator.CallbackRegistry:TriggerEvent("ShowCustomise")
end

local COMMANDS = {
  ["c"] = Baganator.SlashCmd.Config,
  ["config"] = Baganator.SlashCmd.Config,
  ["d"] = Baganator.SlashCmd.Debug,
  ["debug"] = Baganator.SlashCmd.Debug,
  ["remove"] = Baganator.SlashCmd.RemoveCharacter,
  [""] = Baganator.SlashCmd.CustomiseUI,
}
function Baganator.SlashCmd.Handler(input)
  local split = {strsplit("\a", (input:gsub("%s+","\a")))}

  local root = split[1]
  if COMMANDS[root] ~= nil then
    table.remove(split, 1)
    COMMANDS[root](unpack(split))
  else
    Baganator.Utilities.Message("Unknown command '" .. root .. "'")
  end
end
