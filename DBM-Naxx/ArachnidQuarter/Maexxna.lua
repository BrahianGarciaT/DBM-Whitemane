local mod	= DBM:NewMod("Maexxna", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221102120000")
mod:SetCreatureID(15952)
mod:SetUsedIcons(1, 2, 3, 4)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 28622 29484 54125 54124 54123 9250571 9250572 9250573 9250574",
	"SPELL_AURA_REMOVED 28622 9250571 9250572",
	"SPELL_CAST_SUCCESS 54121 28776 9250575 9250576",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

--TODO, verify nax40 web wrap timer
local warnWebWrap		= mod:NewTargetNoFilterAnnounce(28622, 2)
local warnWebSpraySoon	= mod:NewSoonAnnounce(29484, 1)
local warnWebSprayNow	= mod:NewSpellAnnounce(29484, 3)
local warnFrenzy		= mod:NewSpellAnnounce(54124, 3)
local warnSpidersSoon	= mod:NewAnnounce("WarningSpidersSoon", 2, 17332)
local warnSpidersNow	= mod:NewAnnounce("WarningSpidersNow", 4, 17332)

local specWarnWebWrap	= mod:NewSpecialWarningSwitch(28622, "RangedDps", nil, nil, 1, 2)
local yellWebWrap		= mod:NewYellMe(28622)

local timerWebSpray		= mod:NewNextTimer(30.5, 29484, nil, nil, nil, 2)
local timerWebWrap		= mod:NewNextTimer(30, 28622, nil, "RangedDps|Healer", nil, 3)
local timerSpider		= mod:NewTimer(30.2, "TimerSpider", 17332, nil, nil, 1)
local timerNecroticPoison	= mod:NewCDTimer(30, 54121, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerPoisonShock		= mod:NewTimer(40, "TimerPoisonShock", "Interface\\Icons\\Spell_Nature_CorrosiveBreath", nil, nil, 3)

local emoteSpiderlings = "Spiderlings appear on the web!"

mod:AddSetIconOption("SetIconOnWebWrap", 28622, true, false, {1, 2, 3, 4})

local wrapIcons = {} -- [playerName] = icon, 2 targets on heroic 10 and 4 on heroic 25 every 40s

local function clearWrapIcon(self, name)
	if wrapIcons[name] then
		wrapIcons[name] = nil
		self:Unschedule(clearWrapIcon, self, name)
		self:SetIcon(name, 0)
	end
end

local function setWrapIcon(self, name)
	if wrapIcons[name] then return end
	local used = {}
	for _, icon in pairs(wrapIcons) do
		used[icon] = true
	end
	for icon = 1, 4 do
		if not used[icon] then
			wrapIcons[name] = icon
			self:SetIcon(name, icon)
			self:Schedule(120, clearWrapIcon, self, name) -- failsafe in case the removal event is missed
			return
		end
	end
end

function mod:OnCombatStart(delay)
	table.wipe(wrapIcons)
	if self:IsHeroic() then -- Whitemane heroic (custom spell ids 9250xxx)
		timerNecroticPoison:Start(5 - delay)
		timerPoisonShock:Start(10 - delay)
		timerWebWrap:Start(20 - delay)
		warnWebSpraySoon:Schedule(35 - delay)
		timerWebSpray:Start(40 - delay)
	else
		warnWebSpraySoon:Schedule(30.5 - delay)
		timerWebSpray:Start(35.5 - delay)
		timerWebWrap:Start(15 - delay)
		warnSpidersSoon:Schedule(20.2 - delay)
		timerSpider:Start(25.2 - delay)
	end
end

function mod:OnCombatEnd(wipe)
	for name in pairs(wrapIcons) do
		self:SetIcon(name, 0)
	end
	table.wipe(wrapIcons)
	if not wipe then
		if DBT:GetBar(L.ArachnophobiaTimer) then
			DBT:CancelBar(L.ArachnophobiaTimer)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28622, 9250571, 9250572) then -- Web Wrap
		warnWebWrap:CombinedShow(0.5, args.destName)
		if self:AntiSpam(3, 1) then
			specWarnWebWrap:Show()
			if args:IsSpellID(9250571, 9250572) then -- heroic 10/25: every 40s
				timerWebWrap:Start(40)
			elseif self:IsDifficulty("normal25", "heroic25") then
				timerWebWrap:Start()
			else
				timerWebWrap:Start(25)
			end
		end
		
		if self.Options.SetIconOnWebWrap then
			setWrapIcon(self, args.destName)
		end
		if args.destName == UnitName("player") then
			yellWebWrap:Yell()
		elseif not DBM:UnitDebuff("player", args.spellName) and self:AntiSpam(3, 2) then
			specWarnWebWrap:Play("targetchange")
		end
	elseif args:IsSpellID(29484, 54125, 9250573, 9250574) and self:AntiSpam(3, 3) then -- Web Spray
		warnWebSprayNow:Show()
		if args:IsSpellID(9250573, 9250574) then -- heroic 10/25: every 40s
			warnWebSpraySoon:Schedule(35)
			timerWebSpray:Start(40)
		else
			warnWebSpraySoon:Schedule(30.5)
			timerWebSpray:Start()
		end
	elseif args:IsSpellID(54123, 54124) then -- Frenzy (heroic: once per fight at ~130-139s; 54123 seen on heroic 10, 54124 on heroic 25)
		warnFrenzy:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(28622, 9250571, 9250572) and self.Options.SetIconOnWebWrap then -- Web Wrap
		clearWrapIcon(self, args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(54121, 28776) then -- Necrotic Poison (28776 seen on heroic 25)
		timerNecroticPoison:Start()
	elseif args:IsSpellID(9250575, 9250576) then -- Poison Shock (heroic 10/25)
		timerPoisonShock:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == emoteSpiderlings then
		self:SendSync("Spiderlings")
	end
end

function mod:OnSync(event)
	if event == "Spiderlings" then
		warnSpidersNow:Show()
		warnSpidersSoon:Schedule(25.2)
		timerSpider:Start()
	end
end
