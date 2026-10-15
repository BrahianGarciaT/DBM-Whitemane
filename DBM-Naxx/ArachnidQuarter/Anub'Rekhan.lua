local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221106133531")
mod:SetCreatureID(15956)

mod:RegisterCombat("combat_yell", L.Pull1, L.Pull2)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 28783 56090 28785 54021 9250578 9250579 9250582 9250583",
	"SPELL_CAST_SUCCESS 56090 9250579",
	"SPELL_AURA_REMOVED 28785 54021 9250582 9250583"
)

local warningLocustSoon		= mod:NewSoonAnnounce(28785, 2)
local warningLocustFaded	= mod:NewFadesAnnounce(28785, 1)
local warnImpale			= mod:NewTargetNoFilterAnnounce(28783, 3, nil, false)

local specialWarningLocust	= mod:NewSpecialWarningSpell(28785, nil, nil, nil, 2, 2)
local yellImpale			= mod:NewYell(28783, nil, false)

local timerLocustIn			= mod:NewCDTimer(60, 28785, nil, nil, nil, 6)
local timerLocustFade		= mod:NewBuffActiveTimer(23, 28785, nil, nil, nil, 6)
local timerImpale			= mod:NewCDTimer(20, 56090, nil, nil, nil, 3)

mod:AddBoolOption("ArachnophobiaTimer", true, "timer", nil, nil, nil, "at1859")--Sad caveat that 10 and 25 man have own achievements and we have to show only 1 in GUI

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic25") then -- Whitemane heroic 25 (custom spell ids 9250xxx, 10 man ids + 1)
		timerLocustIn:Start(60 - delay)
		warningLocustSoon:Schedule(50 - delay)
		timerImpale:Start(13-delay)
	elseif self:IsHeroic() then -- Whitemane heroic (custom spell ids 9250xxx)
		timerLocustIn:Start(59 - delay)
		warningLocustSoon:Schedule(49 - delay)
		timerImpale:Start(14-delay)
	else
		timerLocustIn:Start(60 - delay)
		warningLocustSoon:Schedule(50 - delay)
		timerImpale:Start(11-delay)
	end
end

function mod:OnCombatEnd(wipe)
	if not wipe and self.Options.ArachnophobiaTimer then
		DBT:CreateBar(1200, L.ArachnophobiaTimer, "Interface\\Icons\\INV_Misc_MonsterSpiderCarapace_01")
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(9250578, 9250579) then -- Impale (heroic 10/25, cast by a trigger so no target)
		timerImpale:Start(20)
	elseif args:IsSpellID(28783, 56090) then  -- Impale
		timerImpale:Start()
		warnImpale:Show(args.destName)
		if args:IsPlayer() then
			yellImpale:Yell()
		end
	elseif args:IsSpellID(28785, 54021, 9250582, 9250583) then  -- Locust Swarm
		specialWarningLocust:Show()
		specialWarningLocust:Play("aesoon")
		timerLocustIn:Stop()
		if args.spellId == 9250582 then -- heroic: cast start to buff fade ~19s
			timerLocustFade:Start(19)
		elseif self:IsDifficulty("normal25", "heroic25") then -- heroic 25 (9250583): cast start to buff fade ~23s
			timerLocustFade:Start(23)
		else
			timerLocustFade:Start(19)
		end
	end
end

mod.SPELL_CAST_SUCCESS = mod.SPELL_CAST_START

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 9250582 then -- Locust Swarm on the boss (heroic 10), next cast 90s after the previous cast
		warningLocustFaded:Show()
		timerLocustIn:Start(70.5)
		warningLocustSoon:Schedule(60.5)
	elseif args.spellId == 9250583 then -- Locust Swarm on the boss (heroic 25), next cast 90s after the previous cast
		warningLocustFaded:Show()
		timerLocustIn:Start(67)
		warningLocustSoon:Schedule(57)
	elseif args:IsSpellID(28785, 54021)
	and args.auraType == "BUFF" then
		warningLocustFaded:Show()
		timerLocustIn:Start()
		warningLocustSoon:Schedule(57)
	end
end
