local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

local GetSpellInfo = GetSpellInfo

mod:SetRevision("20221102120000")
mod:SetCreatureID(15954)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS 29213 54835 9250590 9250591",
	"SPELL_AURA_APPLIED 29208 29209 29210 29211 9250590 9250591",
	"SPELL_AURA_REMOVED 9250688",
	"SPELL_CAST_START 54890 54891",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local emote_Teleport = "%s teleports to the balcony above!"
local emote_Return = "%s teleports back into the battle!"

mod.vb.returnCount = 0

local warnTeleportNow	= mod:NewAnnounce("WarningTeleportNow", 3, 46573)
local warnTeleportSoon	= mod:NewAnnounce("WarningTeleportSoon", 1, 46573)
local warnCurse			= mod:NewSpellAnnounce(29213, 2)
local warnBlinkSoon		= mod:NewSoonAnnounce(29208, 1)
local warnBlink			= mod:NewSpellAnnounce(29208, 3)

local specWarnAdds		= mod:NewSpecialWarningAdds(29212, "-Healer", nil, nil, 1, 2)
local specWarnExplosion	= mod:NewSpecialWarningInterrupt(54891)
local specWarnDecurse	= mod:NewSpecialWarningDispel(29213, "RemoveCurse", nil, nil, 1, 2)
local specWarnPlagueCurse	= mod:NewSpecialWarning("SpecWarnPlagueCurse", nil, nil, nil, 1, 2) -- Whitemane heroic (custom spell ids 9250590/9250591, no spell info on the client)
local yellPlagueCurse		= mod:NewYell(nil, L.YellPlagueCurse, nil, "YellPlagueCurse")

local timerTeleport		= mod:NewTimer(80, "TimerTeleport", 46573, nil, nil, 6)
local timerTeleportBack	= mod:NewTimer(70, "TimerTeleportBack", 46573, nil, nil, 6)
local timerCurseCD		= mod:NewCDTimer(25, 29213, nil, nil, nil, 5, nil, DBM_COMMON_L.CURSE_ICON) -- Whitemane PTR - buff notes say 15s, vod says consistent 25s
local timerAddsCD		= mod:NewAddsTimer(25, 29212, nil, "-Healer")
local timerBlink		= mod:NewNextTimer(30, 29208)

mod:AddSetIconOption("SetIconOnPlagueCurse", nil, true, false, {1, 2, 3, 4, 5, 6, 7, 8})

local curseIcons = {} -- [playerName] = icon, 3 targets on heroic 10 and 10 on heroic 25 (only 8 can be marked)

local function clearCurseIcon(self, name)
	if curseIcons[name] then
		curseIcons[name] = nil
		self:Unschedule(clearCurseIcon, self, name)
		self:SetIcon(name, 0)
	end
end

local function setCurseIcon(self, name)
	if curseIcons[name] then return end
	local used = {}
	for _, icon in pairs(curseIcons) do
		used[icon] = true
	end
	for icon = 1, 8 do
		if not used[icon] then
			curseIcons[name] = icon
			self:SetIcon(name, icon)
			self:Schedule(20, clearCurseIcon, self, name) -- failsafe, curse (up to ~8s) + Plague Residue (5s)
			return
		end
	end
end

function mod:OnCombatStart(delay)
	table.wipe(curseIcons)
	timerAddsCD:Start(-delay)
	timerCurseCD:Start(15-delay)
	if self:IsDifficulty("normal25", "heroic25") then
		timerBlink:Start(26-delay)
		warnBlinkSoon:Schedule(23-delay)
	end
	self.vb.returnCount = 0
	if self:IsDifficulty("heroic10", "heroic25") then -- Whitemane heroic (derived from 10 and 25 logs, identical): first teleport ~85s
		timerTeleport:Start(85-delay)
		warnTeleportSoon:Schedule(75-delay)
	else
		timerTeleport:Start(-delay)
		warnTeleportSoon:Schedule(70-delay)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(9250590, 9250591) and self:IsInCombat() then -- Curse of the Plaguebringer (heroic 10/25, 25s apart, 3-4 per ground phase)
		warnCurse:Show()
		timerCurseCD:Start()
	elseif args:IsSpellID(29213, 54835) then -- Curse of the Plaguebringer
		warnCurse:Show()
		timerCurseCD:Start()
		if self.Options.SpecWarn29213dispel and UnitPowerType("player") == 0 then -- crudely filter out feral druids
			specWarnDecurse:Show("raid")
			specWarnDecurse:Play("helpdispel")
		end
	end
end

function mod:OnCombatEnd()
	for name in pairs(curseIcons) do
		self:SetIcon(name, 0)
	end
	table.wipe(curseIcons)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(9250590, 9250591) and self:IsInCombat() then -- Curse of the Plaguebringer (heroic 10/25): ~1-8s later it turns into Plague Residue (5s) and a puddle drops under the player
		if self.Options.SetIconOnPlagueCurse and self:IsDifficulty("heroic10") then -- heroic 25 affects 10 players, more than the 8 icons, so only the say message is used there
			setCurseIcon(self, args.destName)
		end
		if args:IsPlayer() then
			specWarnPlagueCurse:Show()
			specWarnPlagueCurse:Play("runout")
			yellPlagueCurse:Yell()
		end
	elseif self:IsDifficulty("normal25", "heroic25") and args:IsSpellID(29208, 29209, 29210, 29211) then -- Blink
		warnBlink:Show()
		timerBlink:Start()
		warnBlinkSoon:Schedule(27)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 9250688 and self.Options.SetIconOnPlagueCurse then -- Plague Residue ends: the puddle has dropped
		clearCurseIcon(self, args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(54890, 54891) and self:AntiSpam(1, "ArcaneExplosion") then -- Arcane Explosion
		specWarnExplosion:Show(args.sourceName)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg) -- Syncing to help unlocalized clients
	if msg == emote_Teleport or msg:find(emote_Teleport) then
		self:SendSync("Teleport")
	elseif msg == emote_Return or msg:find(emote_Return) then
		self:SendSync("Return")
	elseif msg == L.Adds or msg:find(L.Adds) then
		self:SendSync("Adds")
	elseif msg == L.AddsTwo or msg:find(L.AddsTwo) then
		self:SendSync("AddsTwo")
	end
end

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "Teleport" then -- Teleport away
		timerCurseCD:Stop()
		timerAddsCD:Start(4)
		timerBlink:Stop()
		warnBlinkSoon:Cancel()
		if self:IsDifficulty("heroic10", "heroic25") then -- balcony phases lasted ~65s in the heroic 10 and 25 logs
			timerTeleportBack:Start(65)
			warnTeleportSoon:Schedule(65 - 10)
		else
			timerTeleportBack:Start()
			warnTeleportSoon:Schedule(70 - 10)
		end
		warnTeleportNow:Show()
	elseif msg == "Return" then -- Return to ground
		warnTeleportNow:Show()
		timerAddsCD:Start()
		timerCurseCD:Start(15)
		if self:IsDifficulty("normal25", "heroic25") then
			timerBlink:Start(26)
			warnBlinkSoon:Schedule(23)
		end
		self.vb.returnCount = self.vb.returnCount + 1
		if self:IsDifficulty("heroic10", "heroic25") and self.vb.returnCount == 1 then -- second ground phase lasted ~115s in the heroic 10 and 25 logs
			timerTeleport:Start(115)
			warnTeleportSoon:Schedule(105)
		else
			timerTeleport:Start()
			warnTeleportSoon:Schedule(70)
		end
	elseif msg == "Adds" then -- Boss Grounded
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")		
		timerAddsCD:Start()
	elseif msg == "AddsTwo" then -- Boss away
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")
		timerAddsCD:Start()
	end
end
