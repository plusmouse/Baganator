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

-- Add any widgets needed for display to the item button
Baganator.UnifiedBags.API.RegisterButtonInitializer(function(self)
  if not self.BindingText then
    self.BindingText = self:CreateFontString(nil, nil, "NumberFontNormal")
  end
end)

-- Hide/remove any icons/text on the widgets so it has no visual, ready for new
-- item data or for being blank with no item set
Baganator.UnifiedBags.API.RegisterButtonClear(function(self)
  self.BindingText:SetText("")
end)

-- Add callback per item button when a specific option is enabled
Baganator.UnifiedBags.API.RegisterButtonDataSet("show_boe_status", function(self, data)
  if IsEquipment(data.itemLink) and not data.isBound then
    self.BindingText:SetText(BAGANATOR_L_BOE)

    local color = qualityColors[data.quality]
    self.BindingText:SetTextColor(color.r, color.g, color.b)
  end
end)

-- Add a widget for the corner to the dropdown for the icon corner settings.
Baganator.UnifiedBags.API.RegisterButtonCorner(
  "binding_type",
  BAGANATOR_L_BINDING_TYPE,
  function(self, targetCorner, targetCornerNotScaled, fontSize)
    self.BindingText:ClearAllPoints()
    self.BindingText:SetPoint(unpack(targetCorner))
    local font, originalSize, fontFlags = button.BindingText:GetFont()
    self.BindingText:SetFont(font, fontSize, fontFlags)
  end,
  function(self, widgetParent)
    self.BindingText:SetParent(widgetParent)
  end,
  {"show_boe_status",},
)

local function IsBindOnAccount(itemLink)
  local tooltipInfo = C_TooltipInfo.GetHyperlink(itemLink)
  if tooltipInfo then
    for _, row in ipairs(tooltipInfo.lines) do
      if row.type == Enum.TooltipDataLineType.ItemBinding and row.leftText == ITEM_BIND_TO_BNETACCOUNT then
        return true
      end
    end
  end
  return false
end

-- Create a visible option in the Customise dialog
Baganator.UnifiedBags.API.CreateOption("show_boa_status", BAGANATOR_L_SHOW_BOA_STATUS)

-- Add callback per item button when a specific option is enabled
Baganator.UnifiedBags.API.RegisterButtonDataSet("show_boa_status", function(self, data)
  if IsBindOnAccount(data.itemLink) then
    self.BindingText:SetText(BAGANATOR_L_BOA)

    local color = qualityColors[data.quality]
    self.BindingText:SetTextColor(color.r, color.g, color.b)
  end
end)
