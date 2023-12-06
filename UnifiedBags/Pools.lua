local offset = 0
function Baganator.UnifiedBags.GetCachedItemButtonPool(parent)
  if Baganator.Constants.IsRetail then
    return CreateFramePool("ItemButton", parent, "BaganatorRetailCachedItemButtonTemplate")
  else
    offset = offset + 1
    local offsetFixed = offset
    local objectCounter = 0
    return CreateObjectPool(function(pool)
      objectCounter = objectCounter + 1
      return CreateFrame("Button", "BGRCachedItemButton" .. offset .. "_" .. objectCounter, parent, "BaganatorClassicCachedItemButtonTemplate")
    end, FramePool_HideAndClearAnchors)
  end
end

function Baganator.UnifiedBags.GetLiveItemButtonPool(parent)
  if Baganator.Constants.IsRetail then
    return CreateFramePool("ItemButton", parent, "BaganatorRetailLiveItemButtonTemplate")
  else
    offset = offset + 1
    local offsetFixed = offset
    local objectCounter = 0
    return CreateObjectPool(function(pool)
      objectCounter = objectCounter + 1
      return CreateFrame("Button", "BGRLiveItemButton" .. offset .. "_" .. objectCounter, parent, "BaganatorClassicLiveItemButtonTemplate")
    end, FramePool_HideAndClearAnchors)
  end
end
