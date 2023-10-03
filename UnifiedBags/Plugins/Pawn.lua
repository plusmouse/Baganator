Baganator.API.Bags.RegisterIconCorner("pawn_arrow", "UpgradeArrow", BAGANATOR_L_PAWN)

Baganator.API.Bags.RegisterAdjustItemIcon(function(frame, anchor, fontSize, scale)
  frame.UpgradeArrow:ClearAllPoints()
  frame.UpgradeArrow:SetSize(15 * scale, 15 * scale)
  frame.UpgradeArrow:SetPoint(unpack(anchor))
end)

Baganator.API.Bags.RegisterIconItemDataSet("pawn_arrow", function(frame, itemData)
  if PawnShouldItemLinkHaveUpgradeArrowUnbudgeted(data.itemLink) then
    frame.UpgradeArrow:Show()
  end
end)

Baganator.API.Bags.RegisterIconItemDataClear(function(frame)
  frame.UpgradeArrow:SetTexture("Interface\\AddOns\\Pawn\\Textures\\UpgradeArrow")
  frame.UpgradeArrow:Hide()
end)
