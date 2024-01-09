local isBagCheck = {}
for _, bagID in pairs(Baganator.Constants.AllBagIndexes) do
  isBagCheck[bagID] = true
end
local isBankCheck = {}
for _, bankID in pairs(Baganator.Constants.AllBankIndexes) do
  isBankCheck[bankID] = true
end

local function SplitByWantedToBag(itemIDToQuantities, stackLimit)
  local toMove, unwantedBagItems, emptyBankSlots = {}, {}, {}
  if itemIDToQuantities[-1] then
    for _, item in ipairs(itemIDToQuantities[-1]) do
      if isBankCheck[item.bagID] then
        table.insert(emptyBankSlots, item)
      else
        table.insert(unwantedBagItems, item)
      end
    end
  end
  print("t1", #toMove, #unwantedBagItems, #emptyBankSlots)
  for itemID, quantities in pairs(itemIDToQuantities) do
    if itemID ~= -1 then
      local index = 1
      while index <= stackLimit do 
        local item = quantities[index]
        if isBankCheck[item.bagID] then
          table.insert(toMove, item)
        end
        index = index + 1
      end
      while index <= #quantities do
        local item = quantities[index]
        if isBagCheck[item.bagID] then
          table.insert(unwantedBagItems, item)
        end
        index = index + 1
      end
    end
  end
  print("r2", #toMove, #unwantedBagItems, #emptyBankSlots)
  return toMove, unwantedBagItems, emptyBankSlots
end

function Baganator.Sorting.ApplyStackLimit(stackLimit)
  local mergedBags, mergedIDs = Baganator.Sorting.GetMergedBankBags(Baganator.Utilities.GetCharacterFullName())
  local map = Baganator.Sorting.GetLocationsByItemID(mergedBags, mergedIDs)

  local toMove, unwantedInBag, emptyBankSlots = SplitByWantedToBag(map, stackLimit)

  local bagChecks = Baganator.Sorting.GetBagUsageChecks(mergedIDs)

  local function GetUnwanted(sourceLocation, forBagID, forItemID)
    local someMoveAvailable = false
    for index, unwantedItem in ipairs(unwantedInBag) do
      if not bagChecks[unwantedBagID] or bagChecks[unwantedBagID](forItemID) then
        someMoveAvailable = true
        targetLocation = ItemLocation:CreateFromBagAndSlot(unwantedItem.bagID, unwantedItem.slotID)

        if not C_Item.DoesItemExist(targetLocation) then
          table.remove(unwantedInBag, index)
          return sourceLocation, targetLocation, someMoveAvailable
        elseif not C_Item.IsLocked(targetLocation) then
          if not bagChecks[forBagID] or bagChecks[forBagID](unwantedItem) then
            table.remove(unwantedInBag, index)
            return sourceLocation, targetLocation, someMoveAvailable
          else
            for index, emptySlot in ipairs(emptyBankSlots) do
              if not bagChecks[emptySlot.bagID] or bagChecks[emptySlot.bagID](unwantedItem) then
                table.remove(emptyBankSlots, index)
                return ItemLocation:CreateFromBagAndSlot(unwantedItem.bagID, unwantedItem.slotID), ItemLocation:CreateFromBagAndSlot(emptySlot.bagID, emptySlot.slotID), someMoveAvailable
              end
            end
          end
        end
      end
    end
    return nil, nil, someMoveAvailable
  end

  local anyMovesFound = false
  for _, item in ipairs(toMove) do
    local sourceLocation = ItemLocation:CreateFromBagAndSlot(item.bagID, item.slotID)
    if not C_Item.IsLocked(sourceLocation) then
      local moveSourceLocation, moveTargetLocation, someMoveAvailable = GetUnwanted(sourceLocation, item.bagID, item.itemID)
      anyMovesFound = anyMovesFound or someMoveAvailable
      if moveSourceLocation ~= nil and moveTargetLocation ~= nil then
        C_Container.PickupContainerItem(moveSourceLocation:GetBagAndSlot())
        C_Container.PickupContainerItem(moveTargetLocation:GetBagAndSlot())
        ClearCursor()
      end
    else
      anyMovesFound = true
    end
  end

  return anyMovesFound
end
