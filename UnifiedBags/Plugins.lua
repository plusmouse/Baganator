Baganator.API.Bags.RegisterIconCorner("item_level", "ItemLevel", BAGANATOR_L_ITEM_LEVEL)

Baganator.API.Bags.RegisterAdjustItemIcon(function(frame, anchor, fontSize, scale)
  if not frame.ItemLevel then
    frame.ItemLevel = frame:CreateFontString(nil, nil, "GameFontHighlight")
  end
  frame.ItemLevel:ClearAllPoints()
  frame.ItemLevel:SetPoint(unpack(anchor))
  frame.ItemLevel:SetScale(scale)

  local font, originalSize, fontFlags = frame.ItemLevel:GetFont()
  frame.ItemLevel:SetFont(font, fontSize, fontFlags)
end)

local function IsCosmetic(bgr)
  return bgr.classID == Enum.ItemClass.Armor and bgr.subClassID == Enum.ItemArmorSubclass.Cosmetic
end

Baganator.API.Bags.RegisterIconItemDataSet(function(frame, itemData)
  if IsEquipment(itemData.itemLink) and not IsCosmetic(frame.BGR) then
    local itemLevel = GetDetailedItemLevelInfo(itemData.itemLink)
    self.ItemLevel:SetText(itemLevel)
    if qualityColours then
      local color = qualityColors[itemData.quality]
      self.ItemLevel:SetTextColor(color.r, color.g, color.b)
    else
      self.ItemLevel:SetTextColor(1,1,1)
    end
  end
end)

Baganator.API.Bags.RegisterIconItemDataClear(function(frame)
  frame.ItemLevel:SetText("")
end)
