local liveCounter = 0
function Bagnanator.Layouts.GetLiveBagItemButtonPool(preallocation)
  local pool
  if Baganator.Constants.IsRetail then
    pool = CreateFramePool("ItemButton", self, "BaganatorRetailLiveItemButtonTemplate")
  else
    pool = CreateObjectPool(function(pool)
      liveCounter = liveCounter + 1
      return CreateFrame("Button", "BGRLiveBagItemButton" .. liveCounter, self, "BaganatorClassicLiveItemButtonTemplate")
    end, FramePool_HideAndClearAnchors)
  end

  for i = 1, preallocation do
    pool:Acquire()
  end
  pool:ReleaseAll()

  return pool
end

local cachedCounter = 0
function Bagnanator.Layouts.GetCachedBagItemButtonPool(preallocation)
  local pool
  if Baganator.Constants.IsRetail then
    pool = CreateFramePool("ItemButton", self, "BaganatorRetailCachedItemButtonTemplate")
  else
    pool = CreateObjectPool(function(pool)
      cachedCounter = cachedCounter + 1
      return CreateFrame("Button", "BGRCachedBagItemButton" .. cachedCounter, self, "BaganatorClassicCachedItemButtonTemplate")
    end, FramePool_HideAndClearAnchors)
  end

  for i = 1, preallocation do
    pool:Acquire()
  end
  pool:ReleaseAll()

  return pool
end
