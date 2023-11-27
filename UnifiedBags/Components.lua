BaganatorMoneyDisplayMixin = {}

function BaganatorMoneyDisplayMixin:SetAmount(money)
  local copper = money % 100
  local silver = math.floor(money % 10000 / 100)
  local gold = math.floor(money / 10000)

  self.CopperText(copper)
  self.SilverText(silver)
  self.GoldText(BreakUpLargeNumbers(gold))

  local items = {}

  if gold > 0 then
    table.insert(items, self.GoldText)
    table.insert(items, self.GoldIcon)
  else
    self.GoldIcon:Hide()
  end

  if silver > 0 then
    table.insert(items, self.SilverText)
    table.insert(items, self.SilverIcon)
  else
    self.SilverIcon:Hide()
  end

  if copper > 0 then
    table.insert(items, self.CopperText)
    table.insert(items, self.CopperIcon)
  else
    self.CopperIcon:Hide()
  end

  local width = 0
  for index, item in ipairs(items) do
    if index == 0 then
      item:SetPoint("TOPLEFT")
    else
      item:SetPoint("TOPLEFT", items[index - 1], "TOPRIGHT", 2, 0)
    end
    width = width + item:GetWidth() + 2
  end

  self:SetSize(width, 22)
end
