function Baganator.Sorting.GetMergedBankBags(character)
  local characterData = BAGANATOR_DATA.Characters[character]

  local combined = CopyTable(characterData.bags)
  tAppendAll(combined, CopyTable(characterData.bank))
  local combinedIDs = CopyTable(Baganator.Constants.AllBagIndexes)
  tAppendAll(combinedIDs, Baganator.Constants.AllBankIndexes)

  return combined, combinedIDs
end

function Baganator.Sorting.GetLocationsByItemID(bags, bagIDs)
  local map = {}
  for index, bag in ipairs(bags) do
    for slotIndex, slot in ipairs(bag) do
      local itemID = slot.itemID
      if itemID == nil then
        itemID = -1
      end
      if not map[itemID] then
        map[itemID] = {}
      end
      table.insert(map[itemID], {bagID = bagIDs[index], slotID = slotIndex, bagIndex = index, itemCount = slot.itemCount, itemID = slot.itemID}) 
    end
  end
  for _, list in pairs(map) do
    table.sort(list, function(a, b)
      if a.itemCount == b.itemCount then
        if a.bagIndex == b.bagIndex then
          return a.slotID < b.slotID
        else
          return a.bagIndex < b.bagIndex
        end
      else
        return a.itemCount > b.itemCount
      end
    end)
  end
  return map
end
