BaganatorGuildViewMixin = {}

function BaganatorGuildViewMixin:OnLoad()
  ButtonFrameTemplate_HidePortrait(self)
  ButtonFrameTemplate_HideButtonBar(self)
  self.Inset:Hide()
  self:RegisterForDrag("LeftButton")
  self:SetMovable(true)

  self.tabsPool = Baganator.UnifiedBags.GetTabButtonPool(self)
  self.currentTab = 1

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

function BaganatorGuildViewMixin:UpdateTabs()
  self.tabsPool:ReleaseAll()

  local lastTab
  local tabs = {}
  for index, tabInfo in ipairs(BAGANATOR_DATA.Guilds[self.lastGuild].bank) do
    local tabButton = self.tabsPool:Acquire()
    tabButton:SetText(CreateTextureMarkup(tabInfo.iconTexture, 22, 22, 18, 18, 0, 1, 0, 1) .. " " .. tabInfo.name)
    tabButton:SetScript("OnClick", function()
      self:SetCurrentTab(index)
    end)
    if not lastTab then
      tabButton:SetPoint("BOTTOM", 0, -30)
    else
      tabButton:SetPoint("TOPLEFT", lastTab, "TOPRIGHT")
    end
    tabButton:SetID(index)
    tabButton:Show()
    lastTab = tabButton
    table.insert(tabs, tabButton)
  end

  self.Tabs = tabs

  PanelTemplates_SetNumTabs(self, #tabs)

  PanelTemplates_SetTab(self, self.currentTab)
end

function BaganatorGuildViewMixin:SetCurrentTab(index)
  self.currentTab = index
  self:UpdateForGuild(self.lastGuild, self.isLive)
end

function BaganatorGuildViewMixin:UpdateForGuild(guild, isLive)
  guild = guild or ""

  local guildWidth = Baganator.Config.Get(Baganator.Config.Options.GUILD_VIEW_WIDTH)

  self.isLive = isLive

  local guildData = BAGANATOR_DATA.Guilds[guild]
  if not guildData then
    self:SetTitle("")
  else
    self.lastGuild = guild
    self:SetTitle(BAGANATOR_L_XS_GUILD_BANK:format(guildData.details.guild))
  end

  self:UpdateTabs()

  self.GuildCached:ShowGuild(guild, self.currentTab, guildWidth)

  -- 300 is the default searchbox width
  self.SearchBox:SetWidth(math.min(300, self.GuildCached:GetWidth() - 5))

  self.Tabs[1]:SetPoint("LEFT", self.GuildCached, "LEFT")

  local height = self.GuildCached:GetHeight() + 6
  self:SetSize(
    self.GuildCached:GetWidth() + 30,
    height + 68
  )
end
