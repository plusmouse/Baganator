local addon, addonTable = ...

addonTable.unifiedBags = {}
addonTable.unifiedBags.cornerItems = {}
addonTable.unifiedBags.overlayItems = {}
addonTable.unifiedBags.adjustIconCallbacks = {}
addonTable.unifiedBags.itemDataSetCallbacks = {}
addonTable.unifiedBags.itemDataClearCallbacks = {}

-- Used to populate the dropdown for choosing which item goes in which corner in
-- the customise dialog.
function Baganator.API.Bags.RegisterIconCorner(optionKey, parentWidgetKey, text)
  assert(optionKey and parentWidgetKey and text)
  table.insert(addonTable.unifiedBags.cornerItems, {option = optionKey, parentKey = parentWidgetKey, text = text})
  Baganator.Config.Create("show_" .. optionKey, "SHOW_" .. optionKey:upper(), false)
end

-- Used to populate the dropdown for choosing which item goes in which corner in
-- the customise dialog.
function Baganator.API.Bags.RegisterIconOverlay(optionKey, default, parentWidgetKey, text)
  assert(optionKey and text)
  table.insert(addonTable.unifiedBags.overlayItems, {option = optionKey, parentKey = parentWidgetKey, text = text})
  Baganator.Config.Create("show_" .. optionKey, "SHOW_" .. optionKey:upper(), default)
end

-- Called when the item button is created or resized
-- callback: function(itemButton, iconSize, anchorPosition) where frame is the
-- item button and anchorPosition is the position the icon generated is expected
-- to be placed.
function Baganator.API.Bags.RegisterAdjustItemIcon(callback)
  table.insert(addonTable.unifiedBags.adjustIconCallbacks, callback)
end

-- Called as valid item data is assigned to the item button and is cached in the
-- Blizzard item cache. This will not be called if no item data is assigned to
-- the button or the associated option is disabled.
-- callback: function(itemButton, itemData)
function Baganator.API.Bags.RegisterIconItemDataSet(optionKey, callback)
  addonTable.unifiedBags.itemDataSetCallbacks[optionKey] = callback
end

-- Called each time the item button's data is reset
-- callback: function(itemButton)
function Baganator.API.Bags.RegisterIconItemDataClear(callback)
  table.insert(addonTable.unifiedBags.itemDataClearCallbacks, callback)
end
