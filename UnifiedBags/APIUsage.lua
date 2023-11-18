local IsEquipment = Baganator.Utilities.IsEquipment

local qualityColors = {
  [0] = CreateColor(157/255, 157/255, 157/255), -- Poor
  [1] = CreateColor(240/255, 240/255, 240/255), -- Common
  [2] = CreateColor(30/255, 178/255, 0/255), -- Uncommon
  [3] = CreateColor(0/255, 112/255, 221/255), -- Rare
  [4] = CreateColor(163/255, 53/255, 238/255), -- Epic
  [5] = CreateColor(225/255, 96/255, 0/255), -- Legendary
  [6] = CreateColor(229/255, 204/255, 127/255), -- Artifact
  [7] = CreateColor(79/255, 196/255, 225/255), -- Heirloom
  [8] = CreateColor(79/255, 196/255, 225/255), -- Blizzard
}

Baganator.UnifiedBags.API.RegisterButtonInitializer(function(self)
  if not self.BindingText then
    self.BindingText = self:CreateFontString(nil, nil, "NumberFontNormal")
  end
end)

Baganator.UnifiedBags.API.RegisterButtonClear(function(self)
  self.BindingText:SetText("")
end)

Baganator.UnifiedBags.API.RegisterButtonDataSet("show_boe_status", function(self, data)
  if IsEquipment(data.itemLink) and not data.isBound then
    self.BindingText:SetText(BAGANATOR_L_BOE)
  end
end)

Baganator.UnifiedBags.API.CreateOption("show_boa_status", BAGANATOR_L_SHOW_BOA_STATUS)

Baganator.UnifiedBags.API.RegisterButtonCorner(
  "binding_type",
  {"show_boe_status",},
  BAGANATOR_L_BINDING_TYPE,
  function(self, targetCorner, targetCornerNotScaled, fontSize)
  end
)
