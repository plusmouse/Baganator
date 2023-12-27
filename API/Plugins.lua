Baganator.Utilities.OnAddonLoaded("Peddler", function()
  if not PeddlerAPI then
    return
  end

  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_PEDDLER, "peddler", function(bagID, slotID, ...)
    local itemID, uniqueItemID, isSoulbound, itemLink = PeddlerAPI.getUniqueItemID(bagID, slotID)

    return uniqueItemID and PeddlerAPI.itemIsToBeSold(itemID, uniqueItemID, isSoulbound)
  end)
end)

Baganator.Utilities.OnAddonLoaded("SellJunk", function()
  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_SELLJUNK, "selljunk", function(bagID, slotID, itemID, itemLink)
    return SellJunk:CheckItemIsJunk(itemLink, bagID, slotID)
  end)
  hooksecurefunc(SellJunk, "Add", function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
  hooksecurefunc(SellJunk, "Rem", function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
end)

Baganator.Utilities.OnAddonLoaded("Scrap", function()
  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_SCRAP, "scrap", function(bagID, slotID, itemID, itemLink)
    return Scrap:IsJunk(itemID, bagID, slotID)
  end)
  hooksecurefunc(Scrap, "ToggleJunk", function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
end)

Baganator.Utilities.OnAddonLoaded("Dejunk", function()
  if not Dejunk_IsJunk then
    return
  end

  Baganator.API.RegisterJunkPlugin(BAGANATOR_L_DEJUNK, "dejunk", function(bagID, slotID, itemID, itemLink)
    return Dejunk_IsJunk(bagID, slotID)
  end)

  if not Dejunk_AddJunkUpdatedCallback then
    return
  end

  Dejunk_AddJunkUpdatedCallback(function()
    Baganator.API.RequestItemButtonsRefresh()
  end)
end)
