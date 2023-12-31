function Baganator.Sorting.GetBagUsageChecks(bagIDs)
  local bagChecks = {}
  if Baganator.Constants.IsRetail and tIndexOf(bagIDs, Enum.BagIndex.ReagentBag) ~= nil then
    bagChecks[Enum.BagIndex.ReagentBag] = function(item)
      return item.itemLink and (select(17, GetItemInfo(item.itemLink)))
    end
  end
  if Baganator.Constants.IsRetail and tIndexOf(bagIDs, Enum.BagIndex.Reagentbank) ~= nil then
    bagChecks[Enum.BagIndex.Reagentbank] = function(item)
      return (select(17, GetItemInfo(item.itemLink)))
    end
  end
  if Baganator.Constants.IsWrath and tIndexOf(bagIDs, Enum.BagIndex.Keyring) ~= nil then
    bagChecks[Enum.BagIndex.Keyring] = function(item)
      return item.classID == Enum.ItemClass.Key or Baganator.Constants.KeyOverrides[item.itemID]
    end
  end

  for _, bagID in ipairs(bagIDs) do
    local _, family = C_Container.GetContainerNumFreeSlots(bagID)
    if family ~= nil and family ~= 0 then
      bagChecks[bagID] = function(item)
        local itemFamily = item.itemLink and GetItemFamily(item.itemLink)
        return itemFamily and item.classID ~= Enum.ItemClass.Container and item.classID ~= Enum.ItemClass.Quiver and bit.band(itemFamily, family) ~= 0
      end
    end
  end

  return bagChecks
end
