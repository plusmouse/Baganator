-- Retail bag indexes. Will need changing for classic.
Baganator.Constants = {
  AllBagIndexes = {
    Enum.BagIndex.Backpack,
    Enum.BagIndex.Bag_1,
    Enum.BagIndex.Bag_2,
    Enum.BagIndex.Bag_3,
    Enum.BagIndex.Bag_4,
  },
  AllBankIndexes = {
    Enum.BagIndex.Bank,
    Enum.BagIndex.BankBag_1,
    Enum.BagIndex.BankBag_2,
    Enum.BagIndex.BankBag_3,
    Enum.BagIndex.BankBag_4,
    Enum.BagIndex.BankBag_5,
    Enum.BagIndex.BankBag_6,
    Enum.BagIndex.BankBag_7,
  },
  IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE,
  IsEra = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC,
  IsClassic = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE,

  MaxRecents = 5,
  BattlePetCageID = 82800,
}

-- Not currently included as the keyring bag presents as quite large in the bag
-- view
--[[if Baganator.Constants.IsClassic then
  table.insert(Baganator.Constants.AllBagIndexes, Enum.BagIndex.Keyring)
end]]
if Baganator.Constants.IsRetail then
  table.insert(Baganator.Constants.AllBagIndexes, Enum.BagIndex.ReagentBag)
  table.insert(Baganator.Constants.AllBankIndexes, Enum.BagIndex.Reagentbank)
end

Baganator.Constants.Events = {
  "SettingChangedEarly",
  "SettingChanged",

  "OnUpdateSettings",

  "CharacterDeleted",

  "BagCacheUpdate",
  "MailCacheUpdate",

  "SearchTextChanged",
  "BagShow",
  "BagHide",
  "CharacterSelect",

  "ShowCustomise",
  "ResetFramePositions",

  "ReagentOnEnter",
  "ReagentOnLeave",
}

Baganator.Constants.TextQualityColors = {
  [0] = CreateColor(157/255, 157/255, 157/255), -- Poor
  [1] = CreateColor(240/255, 240/255, 240/255), -- Common
  [2] = CreateColor(30/255, 178/255, 0/255), -- Uncommon
  [3] = CreateColor(0/255, 112/255, 221/255), -- Rare
  [4] = CreateColor(163/255, 53/255, 238/255), -- Epic
  [5] = CreateColor(225/255, 96/255, 0/255), -- Legendary
  [6] = CreateColor(229/255, 204/255, 127/255), -- Artifact
  [7] = CreateColor(79/255, 196/255, 225/255), -- Heirloom
  [8] = CreateColor(79/255, 196/255, 225/255), -- Blizzard
}
