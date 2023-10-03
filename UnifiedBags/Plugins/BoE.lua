local qualityColors = Baganator.Constants.TextQualityColors

Baganator.API.Bags.RegisterIconCorner("boa_status", "BindingText", BAGANATOR_L_ITEM_LEVEL)

Baganator.API.Bags.RegisterAdjustItemIcon(function(frame, anchor, fontSize, scale)
  local font, originalSize, fontFlags = button.BindingText:GetFont()

  frame.BindingText:ClearAllPoints()
  frame.BindingText:SetPoint(unpack(anchor))
  frame.BindingText:SetFont(font, fontSize, fontFlags)
  frame.BindingText:SetScale(scale)
end)

Baganator.CallbackRegistry:RegisterCallback("OnUpdateSettings", function()
  local useColors = Baganator.Config.Get("icon_text_quality_colors")
  Baganator.API.Bags.RegisterIconItemDataSet("boe_status", function(frame, itemData)
    if IsEquipment(data.itemLink) and not data.isBound then
      self.BindingText:SetText(BAGANATOR_L_BOE)
      if useColors then
        local color = qualityColors[itemData.quality]
        self.BindingText:SetTextColor(color.r, color.g, color.b)
      else
        self.BindingText:SetTextColor(1,1,1)
      end
    end
  end)
end)

Baganator.API.Bags.RegisterIconItemDataClear(function(frame)
  self.BindingText:SetText("")
end)
