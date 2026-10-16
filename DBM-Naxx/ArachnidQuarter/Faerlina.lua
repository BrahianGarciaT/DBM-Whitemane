local mod	= DBM:NewMod("Faerlina", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221016190115")
mod:SetCreatureID(15953)

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 28798 54100 28732 54097 28794 54099 9250586 9250587",
	"SPELL_CAST_SUCCESS 28796 54098 9250584 9250585 9250586 9250587 9250686 9250687",
	"UNIT_DIED"
)

local warnEmbraceActive		= mod:NewSpellAnnounce(28732, 1)
local warnEmbraceExpire		= mod:NewAnnounce("WarningEmbraceExpire", 2, 28732, nil, nil, nil, 28732)
local warnEmbraceExpired	= mod:NewFadesAnnounce(28732, 3)
local warnEnrageSoon		= mod:NewSoonAnnounce(28131, 3)
local warnEnrageNow			= mod:NewSpellAnnounce(28131, 4)

local specWarnEnrage		= mod:NewSpecialWarningDefensive(28131, nil, nil, nil, 3, 2)
local specWarnGTFO			= mod:NewSpecialWarningGTFO(28794, nil, nil, nil, 1, 8)
local specWarnVengefulBlight	= mod:NewSpecialWarning("SpecWarnVengefulBlight", nil, nil, nil, 1, 2) -- Whitemane heroic (custom spell ids 9250686 in 10 HC / 9250687 in 25 HC, no spell info on the client)

local timerEmbrace			= mod:NewBuffActiveTimer(30, 28732, nil, nil, nil, 6)
local timerEnrage			= mod:NewCDTimer(60, 28131, nil, nil, nil, 6)
local timerPoisonVolleyCD	= mod:NewCDTimer(14, 54098, nil, nil, nil, 5)
local timerRainOfFireCD		= mod:NewCDTimer(12, 28794, nil, nil, nil, 3)

mod.vb.enraged = false

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic25") then -- Whitemane heroic 25 (custom spell ids 9250xxx, 10 man ids + 1): first Frenzy ~68s, then ~70s apart
		timerEnrage:Start(68 - delay)
		warnEnrageSoon:Schedule(63 - delay)
		timerPoisonVolleyCD:Start(14-delay)
		timerRainOfFireCD:Start(14-delay)
	else
		timerEnrage:Start(-delay)
		warnEnrageSoon:Schedule(55 - delay)
		timerPoisonVolleyCD:Start(12.6-delay) -- REVIEW! variance? (25man Lordaeron 2022/10/16) - 12.6
		if self:IsHeroic() then -- Whitemane heroic (custom spell ids 9250xxx)
			timerRainOfFireCD:Start(9-delay)
		end
	end
	self.vb.enraged = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28798, 54100) then -- Frenzy
		self.vb.enraged = true
		--if self:IsTanking("player", nil, nil, true, args.destGUID) then -- Whitemane PTR (boss1 doesn't work currently, changed to GUID-based)
		if self:IsTanking("player", "boss1", nil, true) then -- seems to be fixed now
			specWarnEnrage:Show()
			specWarnEnrage:Play("defensive")
		else
			warnEnrageNow:Show()
		end
	elseif args:IsSpellID(28732, 54097)	and args:GetDestCreatureID() == 15953 and self:AntiSpam(5, 2) then	-- Widow's Embrace
		warnEmbraceExpire:Cancel()
		warnEmbraceExpired:Cancel()
		warnEnrageSoon:Cancel()
		timerPoisonVolleyCD:Cancel()
		timerPoisonVolleyCD:Schedule(30, 10) -- seems inconsistent
		timerEnrage:Stop()
		if self.vb.enraged then
			timerEnrage:Start()
			warnEnrageSoon:Schedule(55)
		else
			timerEnrage:Start(35)
			warnEnrageSoon:Schedule(30)
		end
		timerEmbrace:Start()
		warnEmbraceActive:Show()
		warnEmbraceExpire:Schedule(25)
		warnEmbraceExpired:Schedule(30)
		self.vb.enraged = false
	elseif args:IsSpellID(28794, 54099, 9250586, 9250587) and args:IsPlayer() then
		specWarnGTFO:Show(args.spellName)
		specWarnGTFO:Play("watchfeet")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28796, 54098, 9250584, 9250585) then -- Poison Bolt Volley
		timerPoisonVolleyCD:Start()
	elseif args:IsSpellID(9250586, 9250587) then -- Rain of Fire (heroic 10/25)
		timerRainOfFireCD:Start()
	elseif args:IsSpellID(9250686, 9250687) then -- Vengeful Blight (heroic 10/25): raid-wide channel of the Risen Worshipper (raised when a Worshipper dies), recast every ~4s until interrupted
		if self:AntiSpam(3, 3) and self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
			specWarnVengefulBlight:Show()
			specWarnVengefulBlight:Play("kickcast")
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15953 then
		warnEnrageSoon:Cancel()
		warnEmbraceExpire:Cancel()
		warnEmbraceExpired:Cancel()
		timerPoisonVolleyCD:Cancel()
		timerRainOfFireCD:Cancel()
	end
end
