BaganatorGuildViewMixin = {}

function BaganatorGuildViewMixin:OnLoad()
  ButtonFrameTemplate_HidePortrait(self)
  ButtonFrameTemplate_HideButtonBar(self)
  self.Inset:Hide()
  self:RegisterForDrag("LeftButton")
  self:SetMovable(true)

  if Baganator.Constants.IsRetail then
    self.tabsPool = CreateFramePool("Button", self, "BaganatorRetailTabButtonTemplate")
  else
    self.tabsPool = CreateObjectPool(function(pool)
      classicTabObjectCounter = classicTabObjectCounter + 1
      return CreateFrame("Button", "BGRGuildViewTabButton" .. classicTabObjectCounter, self, "BaganatorClassicTabButtonTemplate")
    end, FramePool_HideAndClearAnchors)
  end

  self.SearchBox:HookScript("OnTextChanged", function(_, isUserInput)
    if isUserInput and not self.SearchBox:IsInIMECompositionMode() then
      local text = self.SearchBox:GetText()
      Baganator.CallbackRegistry:TriggerEvent("SearchTextChanged", text:lower())
    end
  end)

  self.SearchBox.clearButton:SetScript("OnClick", function()
    Baganator.CallbackRegistry:TriggerEvent("SearchTextChanged", "")
  end)

  Baganator.CallbackRegistry:RegisterCallback("GuildCacheUpdate",  function(_, guild, updatedBags)
    for _, layout in ipairs(self.Layouts) do
      layout:RequestContentRefresh()
    end
    if self:IsShown() then
      self:UpdateForGuild(guild)
    end
  end)

  Baganator.CallbackRegistry:RegisterCallback("ContentRefreshRequired",  function()
    for _, layout in ipairs(self.Layouts) do
      layout:RequestContentRefresh()
    end
    if self:IsVisible() then
      self:UpdateForGuild(self.lastGuild, self.isLive)
    end
  end)

  Baganator.CallbackRegistry:RegisterCallback("SettingChanged",  function(_, settingName)
    self.settingChanged = true
    if not self.lastGuild then
      return
    end
    if tIndexOf(Baganator.Config.VisualsFrameOnlySettings, settingName) ~= nil then
      if self:IsShown() then
        Baganator.Utilities.ApplyVisuals(self)
      end
    elseif tIndexOf(Baganator.Config.ItemButtonsRelayoutSettings, settingName) ~= nil then
      for _, layout in ipairs(self.Layouts) do
        layout:InformSettingChanged(settingName)
      end
      if self:IsShown() then
        self:UpdateForGuild(self.lastGuild, self.isLive)
      end
    end
  end)

  Baganator.CallbackRegistry:RegisterCallback("SearchTextChanged",  function(_, text)
    self:ApplySearch(text)
  end)
end

function BaganatorGuildViewMixin:ApplySearch(text)
  self.SearchBox:SetText(text)

  if not self:IsShown() then
    return
  end

  self.GuildCached:ApplySearch(text)
end

function BaganatorGuildViewMixin:OnDragStart()
  if not Baganator.Config.Get(Baganator.Config.Options.LOCK_FRAMES) then
    self:StartMoving()
    self:SetUserPlaced(false)
  end
end

function BaganatorGuildViewMixin:OnDragStop()
  self:StopMovingOrSizing()
  self:SetUserPlaced(false)
  local point, _, relativePoint, x, y = self:GetPoint(1)
  Baganator.Config.Set(Baganator.Config.Options.GUILD_VIEW_POSITION, {point, x, y})
end

function BaganatorGuildViewMixin:UpdateForGuild(guild, isLive)
  local guildWidth = Baganator.Config.Get(Baganator.Config.Options.GUILD_VIEW_WIDTH)

  self.GuildCached:ShowGuild(guild, 1, guildWidth)

  local height = self.GuildCached:GetHeight() + 6
  self:SetSize(
    self.GuildCached:GetWidth() + 30,
    height + 68
  )
end
