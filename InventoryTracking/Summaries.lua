BaganatorSummariesMixin = {}

function BaganatorSummariesMixin:OnLoad()
  if BAGANATOR_SUMMARIES == nil then
    BAGANATOR_SUMMARIES = {
      Version = 1,
      ByRealm = {},
      Pending = {},
    }
  end
  self.SV = BAGANATOR_SUMMARIES
  Baganator.CallbackRegistry:RegisterCallback("CacheUpdate", self.CacheUpdate, self)
end

function BaganatorSummariesMixin:CacheUpdate(characterName)
  self.SV.Pending[characterName] = true
end

function BaganatorSummariesMixin:GenerateSummary(characterName)
  local summary = {}
  local details = BAGANATOR_DATA.Characters[characterName]

  for _, bag in pairs(details.bags) do
    for _, item in pairs(bag) do
      if item.itemLink then
        local key = Baganator.Utilities.GetItemKey(item.itemLink)
        if not summary[key] then
          summary[key] = {
            bags = 0,
            bank = 0,
          }
        end
        summary[key].bags = summary[key].bags + item.itemCount
      end
    end
  end

  for _, bag in pairs(details.bank) do
    for _, item in pairs(bag) do
      if item.itemLink then
        local key = Baganator.Utilities.GetItemKey(item.itemLink)
        if not summary[key] then
          summary[key] = {
            bags = 0,
            bank = 0,
          }
        end
        summary[key].bank = summary[key].bank + item.itemCount
      end
    end
  end

  if not self.SV.ByRealm[details.details.realmNormalized] then
    self.SV.ByRealm[details.details.realmNormalized] = {}
  end
  self.SV.ByRealm[details.details.realmNormalized][details.details.character] = summary
end

function BaganatorSummariesMixin:GetTooltipInfo(key)
  if next(self.SV.Pending) then
    local start = debugprofilestop()
    for character in pairs(self.SV.Pending) do
      self.SV.Pending[character] = nil
      self:GenerateSummary(character)
    end
    if Baganator.Config.Get(Baganator.Config.Options.DEBUG_TIMERS) then
      print("summaries", debugprofilestop() - start)
    end
  end

  local realms = GetAutoCompleteRealms()
  if #realms == 0 then
    realms = {GetNormalizedRealmName()}
  end

  local result = {}

  for _, r in ipairs(realms) do
    local byRealm = self.SV.ByRealm[r]
    if byRealm then
      for char, summary in pairs(byRealm) do
        local byKey = summary[key]
        if byKey ~= nil then
          table.insert(result, {
            character = char,
            realmNormalized = r,
            bags = byKey.bags, 
            bank = byKey.bank, 
          })
        end
      end
    end
  end

  return result
end