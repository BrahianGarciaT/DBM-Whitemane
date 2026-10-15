local mod	= DBM:NewMod("Loatheb", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221102120000")
mod:SetCreatureID(16011)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")--Maybe change to a yell later so pull detection works if you chain pull him from tash gauntlet

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 9250692",
	"SPELL_AURA_REMOVED 9250692",
	"SPELL_CAST_SUCCESS 29204 55052 55593 9250600 9250604",
	"SPELL_DAMAGE",
	"SPELL_SUMMON 29234",
	"SWING_DAMAGE",
	"UNIT_DIED"
)

--TODO, verify infoframe and spellIds ported from Classic as accurate, they didn't have to be accurate in classic since it just matched name, but here it does
--Also, 55593 is used instead of classic ID since classic ID has no tooltip
local warnSporeNow	= mod:NewCountAnnounce(32329, 2)
local warnSporeSoon	= mod:NewSoonAnnounce(32329, 1)
local warnDoomNow	= mod:NewSpellAnnounce(29204, 3)
local warnHealSoon	= mod:NewAnnounce("WarningHealSoon", 4, 48071, nil, nil, nil, 55593)
local warnHealNow	= mod:NewAnnounce("WarningHealNow", 1, 48071, false, nil, nil, 55593)
local warnVolatileSpores	= mod:NewAnnounce("WarningVolatileSpores", 3, "Interface\\Icons\\Spell_Shadow_CreepingPlague")--Whitemane heroic (custom spell id 9250692)

local specWarnVolatileSpores	= mod:NewSpecialWarning("SpecWarnVolatileSpores", nil, nil, nil, 1, 2)
local yellVolatileSpores		= mod:NewYell(nil, L.YellVolatileSpores, nil, "YellVolatileSpores")

local timerSpore	= mod:NewNextTimer(15, 32329, nil, nil, nil, 5, 42524, DBM_COMMON_L.DAMAGE_ICON)
local timerDoom		= mod:NewNextTimer(20, 29204, nil, nil, nil, 2)
local timerAura		= mod:NewBuffActiveTimer(17, 55593, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON)
local timerAuraCD		= mod:NewNextTimer(20, 55593, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON)--Whitemane heroic only
local timerDeathbloom	= mod:NewNextTimer(30, 29865, nil, nil, nil, 3)--Whitemane heroic only (custom spell id 9250604)
local timerVolatileSpores	= mod:NewTimer(15, "TimerVolatileSpores", "Interface\\Icons\\Spell_Shadow_CreepingPlague", nil, nil, 3)--Whitemane heroic only

mod:AddBoolOption("SporeDamageAlert", false)
mod:AddSetIconOption("SetIconOnVolatileSpores", nil, true, false, {8})

mod.vb.doomCounter	= 0
mod.vb.sporeTimer	= 15
mod.vb.sporeCounter = 0

function mod:OnCombatStart(delay)
	self.vb.doomCounter = 0
	self.vb.sporeCounter = 0
	if self:IsDifficulty("normal25", "heroic25") then
		self.vb.sporeTimer = 15
		timerDoom:Start(20 - delay, 1)
	else
		self.vb.sporeTimer = 36
		timerDoom:Start(120 - delay, 1)
	end
	if self:IsHeroic() then -- Whitemane heroic (10 man timings measured, 25 man assumed identical)
		timerDeathbloom:Start(4 - delay)
		timerAuraCD:Start(11 - delay)
		timerVolatileSpores:Start(14 - delay)
	end
	timerSpore:Start(18 - delay, 1)
	warnSporeSoon:Schedule(18 - 5 - delay)
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 29234 then -- Summon Spore
		self.vb.sporeCounter = self.vb.sporeCounter + 1
		timerSpore:Start(self.vb.sporeTimer, self.vb.sporeCounter + 1)
		warnSporeNow:Show(self.vb.sporeCounter)
		warnSporeSoon:Schedule(self.vb.sporeTimer - 5)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 9250692 then -- Volatile Spores (heroic: one player every 15s, explodes after ~10s)
		warnVolatileSpores:Show(args.destName)
		if self:AntiSpam(5, "VolatileSpores") then
			timerVolatileSpores:Start()
		end
		if self.Options.SetIconOnVolatileSpores then
			self:SetIcon(args.destName, 8, 11)
		end
		if args:IsPlayer() then
			specWarnVolatileSpores:Show()
			specWarnVolatileSpores:Play("runout")
			yellVolatileSpores:Yell()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 9250692 and self.Options.SetIconOnVolatileSpores then -- Volatile Spores
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if args:IsSpellID(29204, 55052, 9250600) then  -- Inevitable Doom
		self.vb.doomCounter = self.vb.doomCounter + 1
		warnDoomNow:Show(self.vb.doomCounter)
		if self:IsDifficulty("normal25", "heroic25") then
			timerDoom:Start(20, self.vb.doomCounter + 1)
		else
			timerDoom:Start(30, self.vb.doomCounter + 1)
		end
	elseif spellId == 9250604 then -- Deathbloom (heroic: every 30s)
		timerDeathbloom:Start()
	elseif spellId == 55593 then
		if self:IsHeroic() then
			timerAuraCD:Start()
		end
		timerAura:Start()
		warnHealSoon:Schedule(14)
		warnHealNow:Schedule(17)
	end
end

--Spore loser function. Credits to Forte guild and their old discontinued dbm plugins. Sad to see that guild disband, best of luck to them!
function mod:SPELL_DAMAGE(_, sourceName, _, _, destName, _, spellId, _, _, amount)
	if self.Options.SporeDamageAlert and destName == "Spore" and spellId ~= 62124 and self:IsInCombat() then
		SendChatMessage(sourceName..", You are damaging a Spore!!! ("..amount.." damage)", "RAID_WARNING")
		SendChatMessage(sourceName..", You are damaging a Spore!!! ("..amount.." damage)", "WHISPER", nil, sourceName)
	end
end

function mod:SWING_DAMAGE(_, sourceName, _, _, destName, _, _, _, _, amount)
	if self.Options.SporeDamageAlert and destName == "Spore" and self:IsInCombat() then
		SendChatMessage(sourceName..", You are damaging a Spore!!! ("..amount.." damage)", "RAID_WARNING")
		SendChatMessage(sourceName..", You are damaging a Spore!!! ("..amount.." damage)", "WHISPER", nil, sourceName)
	end
end

--because in all likelyhood, pull detection failed (cause 90s like to charge in there trash and all and pull it
--We unschedule the pre warnings on death as a failsafe
function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 16011 then
		warnSporeSoon:Cancel()
		warnHealSoon:Cancel()
		warnHealNow:Cancel()
	end
end
