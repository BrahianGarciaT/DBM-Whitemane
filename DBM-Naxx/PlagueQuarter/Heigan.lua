local mod	= DBM:NewMod("Heigan", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190516165414")
mod:SetCreatureID(15936)

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 9250592 9250593"
)

local warnTeleportSoon			= mod:NewAnnounce("WarningTeleportSoon", 2, 46573)
local warnTeleportNow			= mod:NewAnnounce("WarningTeleportNow", 3, 46573)
local warnPlagueCloudEnd		= mod:NewEndAnnounce(30122, 1)

local timerTeleport				= mod:NewTimer(90, "TimerTeleport", 46573, nil, nil, 6)
local timerPlagueCloud			= mod:NewBuffActiveTimer(45, 30122, nil, nil, nil, 6)
local timerDecrepitFever		= mod:NewTimer(20, "TimerDecrepitFever", "Interface\\Icons\\Spell_Nature_NullifyDisease", nil, nil, 3)

mod.vb.feverCount = 0

function mod:DancePhase()
	timerPlagueCloud:Start()
	warnTeleportSoon:Schedule(35, 10)
	warnPlagueCloudEnd:Schedule(45)
	self:ScheduleMethod(45, "BackInRoom", self:IsHeroic() and 90 or 88) -- Whitemane heroic (10 and 25 logs): dance phases start 135s apart (45s dance + 90s in the room)
	self:SetStage(2)
end

function mod:BackInRoom(time)
	self.vb.feverCount = 0
	if self:IsHeroic() then -- Whitemane heroic (custom spell ids 9250xxx): first Decrepit Fever 12s after entering the room
		timerDecrepitFever:Start(12)
	end
	timerTeleport:Show(time)
	warnTeleportSoon:Schedule(time - 15, 15)
	warnTeleportNow:Schedule(time)
	self:ScheduleMethod(time, "DancePhase")
	self:SetStage(1)
end

function mod:OnCombatStart(delay)
	self:SetStage(1)
	self:BackInRoom(90 - delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(9250592, 9250593) then -- Decrepit Fever (heroic 10/25): batches of 4 casts, 20s apart
		self.vb.feverCount = self.vb.feverCount + 1
		if self.vb.feverCount < 4 then
			timerDecrepitFever:Start()
		end
	end
end
