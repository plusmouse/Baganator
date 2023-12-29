local poolsSpec = {
  buttons = {
    ["bank"] = {"Button", "BaganatorToggleBankButtonTemplate"},
    --["guild"] = {"Button", "BaganatorToggleGuildBankButtonTemplate"},
    ["all-characters"] = {"Button", "BaganatorToggleBankButtonTemplate"},
    ["bag-slots"] = {"Button", "BaganatorToggleBagSlotsButtonTemplate"},
    ["reagents"] = {"Button", "BaganatorToggleReagentsButtonTemplate"},
    ["customise"] = {"Button", "BaganatorCustomiseButtonTemplate"},
  }
  rows = {
    ["search-box"] = {
      "Frame",
      function(self)
        self:SetHeight(22)
        self.SearchBox = CreateFrame("Frame", nil, self, "SearchBoxTemplate")
        self.SearchBox:SetAllPoints()
        self.SearchBox:HookScript("OnTextChanged", function(_, isUserInput)
          if isUserInput and not self.SearchBox:IsInIMECompositionMode() then
            local text = self.SearchBox:GetText()
            Baganator.CallbackRegistry:TriggerEvent("SearchTextChanged", text:lower())
          end
        end)
        self.SearchBox.clearButton:SetScript("OnClick", function()
          Baganator.CallbackRegistry:TriggerEvent("SearchTextChanged", "")
        end)
      end,
    },
    ["bag-slots"] = {
      "Frame",
      function(self)
        self.liveLayout = CreateFrame("Frame", nil, self, "BaganatorLiveBagLayoutTemplate")
        self.cachedLayout = CreateFrame("Frame", nil, self, "BaganatorCachedBagLayoutTemplate")
        function self:Allocate(globalState)
          self.liveLayout:SetLiveBagButtonPool(globalState.liveBagButtonPool)
        end
        function self:Deallocate()
          print("need to tidy up live layout")
          self.liveLayout:SetLiveBagButtonPool(nil)
        end
      end,
    }
  }
}

local buttonActions = {
  ["toggle-customise"] = function(self, button)
    Baganator.CallbackRegistry:TriggerEvent("ShowCustomise")
  end
  ["sort"] = function(self, button)
    CallMethodOnNearestAncestor(self, "CombineStacksAndSort", button == "RightButton")
  end
  ["toggle-panel-all-characters"] = function(self, button)
    CallMethodOnNearestAncestor(self, "ToggleCharactersSidebar")
  end
  ["toggle-bag-slots"] = function(self, button)
    CallMethodOnNearestAncestor(self, "ToggleBagSlots")
  end
}

function Baganator.BagLayouts.GetPools(parent)
  local function Deallocator(pool, object)
    FramePool_HideAndClearAnchors(pool, object)
    object:SetParent(nil)
    if object.Deallocate then
      object:Deallocate()
    end
  end
  local pools = {}
  for groupKey, groupSpec in pairs(poolsSpec) do
    local group = {}
    for key, spec in pairs(groupSpec) do
      if type(spec[2]) == "function" then
        group[key] = CreateFramePool(spec[1], nil, "", Deallocator, false, spec[2])
      else
        group[key] = CreateFramePool(spec[1], nil, spec[2], Deallocator)
      end
    end
    pools[groupKey] = group
  end
end

function Baganator.BagLayouts.CreateBlizzStyleContainer(name)
  local container = CreateFrame("Frame", name, UIParent, "ButtonFrameTemplate")
  ButtonFrameTemplate_HidePortrait(container)
  ButtonFrameTemplate_HideButtonBar(container)
  container:EnableMouse(true)
  container.Inset:Hide()
  container:RegisterForDrag("LeftButton")
  container:SetMovable(true)

  container.buttonGroup1 = CreateFrame("Frame", nil, container, "HorizontalLayoutFrame")
  container.buttonGroup1:SetPoint("RIGHT")
  container.buttonGroup1:SetPoint("TOPLEFT")
  container.buttonGroup1:SetHeight(22)
  container.buttonGroup2 = CreateFrame("Frame", nil, container, "HorizontalLayoutFrame")
  container.buttonGroup2:SetPoint("LEFT")
  container.buttonGroup2:SetPoint("TOPRIGHT")
  container.buttonGroup2:SetHeight(22)
  container.rows = CreateFrame("Frame", nil, container, "VerticalLayoutFrame")
  container.rows:SetPoint("TOPLEFT", 0, -20)
  container.rows:SetPoint("TOPRIGHT", 0, -20)
end

function Baganator.BagLayouts.BuildLayout(container, description, pools)
  local copy = CopyTable(description)

  for index, setup in ipairs(container.rows) do
    local obj = pools.rows[setup.type]:Acquire()
    obj:SetParent(container.rows)
    obj.layoutIndex = index
  end
  description.rows:Layout()

  for index, setup in ipairs(container.buttonGroup1) do
    local obj = pools.buttons[setup.type]:Acquire()
    obj:SetParent(container.buttonGroup1)
    obj.layoutIndex = index
  end
  container.buttonGroup1:Layout()

  for index, setup in ipairs(container.buttonGroup2) do
    local obj = pools.buttons[setup.type]:Acquire()
    obj:SetParent(container.buttonGroup2)
    obj.layoutIndex = index
  end
  container.buttonGroup2:Layout()
end

function Baganator.BagLayouts.DestroyLayout(container, description, pools)
end
