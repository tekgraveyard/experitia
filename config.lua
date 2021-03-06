if(not eXPeritia or not LibStub) then return nil end

local panel = CreateFrame("Frame", nil, UIParent)
panel.name = "eXPeritia"
InterfaceOptions_AddCategory(panel)

panel:SetScript("OnShow", function(self)
	local function UpdateSliderValue(self) self.val:SetFormattedText("%.0f", self:GetValue()) end

	local title, subtitle = LibStub("tekKonfig-Heading").new(self, "eXPeritia "..GetAddOnMetadata("eXPeritia", "Version"), GetAddOnMetadata("eXPeritia", "Notes"))

	local width, _, cont = LibStub("tekKonfig-Slider").new(self, "Width", 100, 2000, "TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
	width.tiptext = "The width of the bar"
	width.val = width:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	width.val:SetPoint("TOP", width, "BOTTOM", 0, 3)
	width:SetScript("OnValueChanged", UpdateSliderValue)
	cont:SetWidth(300)
	self.width = width

	local height, _, cont = LibStub("tekKonfig-Slider").new(self, "Height", 5, 100, "TOPLEFT", width, "BOTTOMLEFT", 0, -20)
	height.tiptext = "The height of the bar"
	height.val = height:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	height.val:SetPoint("TOP", height, "BOTTOM", 0, 3)
	height:SetScript("OnValueChanged", UpdateSliderValue)
	cont:SetWidth(300)
	self.height = height

	local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	color = format("|cff%02x%02x%02x", color.r*255, color.g*255, color.b*255)

	local classcolor = LibStub("tekKonfig-Checkbox").new(self, 26, color.."Class|r colored indicators", "TOPLEFT", height, "BOTTOMLEFT", 0, -30)
	classcolor.tiptext = "Color the indicators based on your class"
	self.classColor = classcolor

	eXPeritia:SetScript("OnDragStart", eXPeritia.StartMoving)
	eXPeritia:SetScript("OnDragStop", eXPeritia.StopMovingOrSizing)
	eXPeritia:SetMovable(true)

	local function OnShow(self)
		self.classColor:SetChecked(eXPeritia.db.ClassColor)
		self.width:SetValue(eXPeritia.db.Width)
		self.height:SetValue(eXPeritia.db.Height)
		eXPeritia:SetAlpha(1)
		eXPeritia:Show()
		eXPeritia:RegisterForDrag("LeftButton")
	end
	self:SetScript("OnShow", OnShow)
	self:SetScript("OnHide", function(self)
		eXPeritia:Hide()
		eXPeritia:RegisterForDrag(nil)
	end)

	OnShow(self)
end)

function panel:okay()
	eXPeritia.db.ClassColor = self.classColor:GetChecked()
	eXPeritia.db.Width = self.width:GetValue()
	eXPeritia.db.Height = self.height:GetValue()
	eXPeritia:ApplyOptions()
end

SlashCmdList['EXPERITIA'] = function(msg)
	if(msg == "hide" or (msg == "toggle" and eXPeritia:IsShown())) then
		return eXPeritia:Hide()
	elseif(msg == "show" or msg == "toggle") then
		eXPeritia:SetAlpha(1)
		return eXPeritia:Show()
	else
		InterfaceOptionsFrame_OpenToFrame("eXPeritia")
	end
end
SLASH_EXPERITIA1 = '/exp'
SLASH_EXPERITIA2 = '/experitia'
