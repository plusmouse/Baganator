Baganator.BagLayouts.ViewDescriptor = {
  buttonGroup1 = { -- defaults to top left
    {
      type = "bank",
      action = "special",
    },
    --[[{
      type = "guild",
      action = "toggle-guild",
    },]]
    {
      type = "all-characters",
      action = "toggle-panel-all_characters",
    },
    {
      type = "bag-slots",
      action = "toggle-bag_slots",
    },
  },
  buttonGroup2 = { -- defaults to top right next to close button
    {
      type = "customise",
      action = "toggle-customise",
    },
    {
      type = "sort",
      action = "sort",
    },
  },
  rows = {
    {
      type = "search-box",
    },
    {
      type = "bag-slots",
      bags = {
        Enum.BagIndex.Backpack,
        Enum.BagIndex.Bag_1,
        Enum.BagIndex.Bag_2,
        Enum.BagIndex.Bag_3,
        Enum.BagIndex.Bag_4,
      }
      allocated = true,
    },
    {
      type = "bag-slots",
      bags = {
        Enum.BagIndex.ReagentBag,
      }
      toggleButton = "reagents",
      toggleTooltip = BAGANATOR_L_REAGENTS,
      allocated = true,
    },
  },
  bagSlotsPreallocated = 6 * Baganator.Constants.MaxBagSize,
}
