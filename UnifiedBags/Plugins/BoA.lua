local qualityColors = Baganator.Constants.TextQualityColors
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

Baganator.CallbackRegistry:RegisterCallback("OnUpdateSettings", function()
  local useColors = Baganator.Config.Get("icon_text_quality_colors")
  Baganator.API.Bags.RegisterIconItemDataSet("item_level", function(frame, itemData)
    if IsBindOnAccount(data.itemLink) then
      self.BindingText:SetText(BAGANATOR_L_BOA)
      if useColors then
        local color = qualityColors[itemData.quality]
        self.BindingText:SetTextColor(color.r, color.g, color.b)
      else
        self.BindingText:SetTextColor(1,1,1)
      end
    end
  end)
end)
