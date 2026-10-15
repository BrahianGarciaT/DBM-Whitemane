local mod	= DBM:NewMod("Razuvious", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221102120000")
mod:SetCreatureID(16061)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat_yell", L.Yell1, L.Yell2, L.Yell3, L.Yell4)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 55543 29107 29060 29061 9250606 9250607 9250608 9250609 9250696 26613",
	"SPELL_AURA_APPLIED 605",
	"SPELL_AURA_REMOVED 9250608 9250609",
	"UNIT_DIED"
)

local warnShoutNow		= mod:NewSpellAnnounce(29107, 1)
local warnShoutSoon		= mod:NewSoonAnnounce(29107, 3)
local warnShieldWall	= mod:NewAnnounce("WarningShieldWallSoon", 3, 29061, nil, nil, nil, 29061)

local specWarnJaggedKnife	= mod:NewSpecialWarning("SpecWarnJaggedKnife", nil, nil, nil, 1, 2) -- Whitemane heroic (custom spell ids 9250608/9250609, no spell info on the client)
local yellJaggedKnife		= mod:NewYell(nil, L.YellJaggedKnife, nil, "YellJaggedKnife")

local timerShout		= mod:NewNextTimer(15, 29107, nil, nil, nil, 2) -- Whitemane PTR buff notes say it should be 12, but was consistently 15s in the vod
local timerTaunt		= mod:NewCDTimer(20, 29060, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerShieldWall	= mod:NewCDTimer(20, 29061, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerMindControl	= mod:NewBuffActiveTimer(60, 605, nil, nil, nil, 6)
local timerUnbalancing	= mod:NewCDTimer(30, 26613, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerJaggedKnife	= mod:NewTimer(25, "TimerJaggedKnife", "Interface\\Icons\\INV_ThrowingKnife_04", nil, nil, 3)
local timerDisciplinary	= mod:NewTimer(15, "TimerDisciplinaryShout", "Interface\\Icons\\Ability_Warrior_WarCry", nil, nil, 2)

mod:AddSetIconOption("SetIconOnJaggedKnife", nil, true, false, {8})

-- Jagged Knife: the target is known on the cast, the knife lands ~3-4s later and the bleed lasts 5s
local function jaggedKnifeTarget(self, args)
	if not args.destName then return end
	if self.Options.SetIconOnJaggedKnife then
		self:SetIcon(args.destName, 8, 10)
	end
	if args:IsPlayer() then
		specWarnJaggedKnife:Show()
		specWarnJaggedKnife:Play("runout")
		yellJaggedKnife:Yell()
	end
end

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic25") then -- Whitemane heroic 25 (custom spell ids 9250xxx, 10 man ids + 1)
		timerShout:Start(12 - delay)
		warnShoutSoon:Schedule(7 - delay)
		timerJaggedKnife:Start(33 - delay)
		timerDisciplinary:Start(12 - delay)
		timerUnbalancing:Start(27 - delay)
	elseif self:IsHeroic() then -- Whitemane heroic (custom spell ids 9250xxx)
		timerShout:Start(20 - delay)
		warnShoutSoon:Schedule(15 - delay)
		timerJaggedKnife:Start(11 - delay)
		timerDisciplinary:Start(11 - delay)
		timerUnbalancing:Start(25 - delay)
	elseif self:IsDifficulty("normal25", "heroic25") then
		timerShout:Start(15 - delay)
		warnShoutSoon:Schedule(10 - delay)
	else
		timerShout:Start(25 - delay)
		warnShoutSoon:Schedule(20 - delay)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 9250607 then -- Disrupting Shout (heroic 25, every 15s)
		warnShoutNow:Show()
		timerShout:Start(15)
		warnShoutSoon:Schedule(10)
	elseif spellId == 9250606 then -- Disrupting Shout (heroic 10)
		warnShoutNow:Show()
		timerShout:Start(25)
		warnShoutSoon:Schedule(20)
	elseif spellId == 9250609 then -- Jagged Knife (heroic 25, mostly 10s apart with occasional 20s gaps)
		timerJaggedKnife:Start(10)
		jaggedKnifeTarget(self, args)
	elseif spellId == 9250608 then -- Jagged Knife (heroic 10)
		timerJaggedKnife:Start()
		jaggedKnifeTarget(self, args)
	elseif spellId == 9250696 and self:AntiSpam(5, 2) then -- Disciplinary Shout (heroic, hits several targets per cast)
		timerDisciplinary:Start()
	elseif spellId == 26613 then -- Unbalancing Strike
		timerUnbalancing:Start()
	elseif args:IsSpellID(55543, 29107) then  -- Disrupting Shout
		warnShoutNow:Show()
		if self:IsDifficulty("normal25", "heroic25") then
			timerShout:Start()
			warnShoutSoon:Schedule(10)
		else
			timerShout:Start(25)
			warnShoutSoon:Schedule(20)
		end
	elseif spellId == 29060 then -- Taunt
		timerTaunt:Start(20, args.sourceGUID)
	elseif spellId == 29061 and self:AntiSpam(2, 1) then -- ShieldWall
		timerShieldWall:Start(20, args.sourceGUID)
		warnShieldWall:Schedule(15)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 605 and args:IsSrcTypePlayer() then -- Mind Control
		timerMindControl:Start(nil, args.sourceName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(9250608, 9250609) and self.Options.SetIconOnJaggedKnife then -- Jagged Knife
		self:SetIcon(args.destName, 0)
	end
end

function mod:UNIT_DIED(args)
	local guid = args.destGUID
	local cid = self:GetCIDFromGUID(guid)
	if cid == 16803 then--Deathknight Understudy
		timerTaunt:Stop(args.destGUID)
		timerShieldWall:Stop(args.destGUID)
	end
end
