-- Assumes stacks are combined
function Baganator.Sorting.MergeAndTransferToBank(bags, bagIDs, bank, bankIDs)
  local containers = {}
  tAppendAll(containers, bagIDs)
  tAppendAll(containers, bankIDs)
  local bagChecks = Baganator.Sorting.GetBagUsageChecks(containers)
  local bagsByItemID = {}
  local bankByItemID = {}
  local function Add(map, itemID, location, quantity)
    map[itemID] = map[itemID] or {}
    table.insert(map[itemID], {location = location, quantity = quantity})
  end
  for b, bagSlots in ipairs(bags) do
    for s, item in ipairs(bagSlots) do
      Add(bagsByItemID, item.itemID, ItemLocation:CreateFromBagAndSlot(bagIDs[b], s), item.itemCount)
    end
  end
  for b, bagSlots in ipairs(bank) do
    for s, item in ipairs(bagSlots) do
      Add(bankByItemID, item.itemID, ItemLocation:CreateFromBagAndSlot(bagIDs[b], s), item.itemCount)
    end
  end

end
