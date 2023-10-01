-- Used to populate the dropdown for choosing which item goes in which corner in
-- the customise dialog.
function Baganator.API.Bags.RegisterIconCornerItem(optionKey, text)
end

-- Called when the item button is created or resized
-- callback: function(frame, anchorPosition) where frame is the item button and
-- anchorPosition is the position the icon generated is expected to be placed.
function Baganator.API.Bags.RegisterAdjustItemIcon(callback, frameKey)
end

-- Called as valid item data is assigned to the item button and is cached in the
-- Blizzard item cache. This will not be called if no item data is assigned to
-- the button.
function Baganator.API.Bags.RegisterItemDataSet(optionKey, callback)
end

-- Called each time the item button's data is reset
function Baganator.API.Bags.RegisterItemDataClear(optionKey, callback)
end
