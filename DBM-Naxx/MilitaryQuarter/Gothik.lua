local mod	= DBM:NewMod("Gothik", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221102120000")
mod:SetCreatureID(16060)
mod:SetUsedIcons(1, 2, 3, 4)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 9250699 9250700",
	"SPELL_AURA_APPLIED 9250699 9250700",
	"SPELL_AURA_REMOVED 9250699 9250700",
	"UNIT_DIED"
)

--TODO, sync infoframe from classic era version?
--(source.type = "NPC" and source.firstSeen = timestamp) or (target.type = "NPC" and target.firstSeen = timestamp)
local warnWaveNow		= mod:NewAnnounce("WarningWaveSpawned", 3, nil, false)
local warnWaveSoon		= mod:NewAnnounce("WarningWaveSoon", 2)
local warnRiderDown		= mod:NewAnnounce("WarningRiderDown", 4)
local warnKnightDown	= mod:NewAnnounce("WarningKnightDown", 2)
local warnPhase2		= mod:NewPhaseAnnounce(2, 3)

local specWarnSoulConvergence	= mod:NewSpecialWarning("SpecWarnSoulConvergence", nil, nil, nil, 1, 2) -- Whitemane heroic (custom spell ids 9250699/9250700, no spell info on the client)
local yellSoulConvergence		= mod:NewYell(nil, L.YellSoulConvergence, nil, "YellSoulConvergence")

local timerPhase2		= mod:NewTimer(270, "TimerPhase2", 27082, nil, nil, 6)
local timerWave			= mod:NewTimer(20, "TimerWave", 5502, nil, nil, 1)
local timerGate			= mod:NewTimer(150, "Gate Opens", 9484)
local timerTeleport		= mod:NewTimer(25, "TimerTeleport", 31569)
local timerSoulConvergence	= mod:NewTimer(30, "TimerSoulConvergence", "Interface\\Icons\\Spell_Shadow_SoulLeech_3", nil, nil, 3)

mod:AddSetIconOption("SetIconOnSoulConvergence", nil, true, false, {1, 2, 3, 4})

mod.vb.wave = 0
local convergenceIcons = {} -- [playerName] = icon, 2 targets on heroic 10 and 4 on heroic 25

local function clearConvergenceIcon(self, name)
	if convergenceIcons[name] then
		convergenceIcons[name] = nil
		self:Unschedule(clearConvergenceIcon, self, name)
		self:SetIcon(name, 0)
	end
end

local function setConvergenceIcon(self, name)
	if convergenceIcons[name] then return end
	local used = {}
	for _, icon in pairs(convergenceIcons) do
		used[icon] = true
	end
	for icon = 1, 4 do
		if not used[icon] then
			convergenceIcons[name] = icon
			self:SetIcon(name, icon)
			self:Schedule(15, clearConvergenceIcon, self, name) -- failsafe, the aura lasts at most ~6s
			return
		end
	end
end

local wavesNormal = {
	{2, L.Trainee, timer = 20},
	{2, L.Trainee, timer = 20},
	{2, L.Trainee, timer = 10},
	{1, L.Knight, timer = 10},
	{2, L.Trainee, timer = 15},
	{1, L.Knight, timer = 5},
	{2, L.Trainee, timer = 20},
	{1, L.Knight, 2, L.Trainee, timer = 10},
	{1, L.Rider, timer = 10},
	{2, L.Trainee, timer = 5},
	{1, L.Knight, timer = 15},
	{2, L.Trainee, 1, L.Rider, timer = 10},
	{2, L.Knight, timer = 10},
	{2, L.Trainee, timer = 10},
	{1, L.Rider, timer = 5},
	{1, L.Knight, timer = 5},
	{2, L.Trainee, timer = 20},
	{1, L.Rider, 1, L.Knight, 2, L.Trainee, timer = 15},
	{2, L.Trainee},
}

local wavesHeroic = {
	{3, L.Trainee, timer = 20},
	{3, L.Trainee, timer = 20},
	{3, L.Trainee, timer = 10},
	{2, L.Knight, timer = 10},
	{3, L.Trainee, timer = 15},
	{2, L.Knight, timer = 5},
	{3, L.Trainee, timer = 20},
	{3, L.Trainee, 2, L.Knight, timer = 10},
	{3, L.Trainee, timer = 10},
	{1, L.Rider, timer = 5},
	{3, L.Trainee, timer = 15},
	{1, L.Rider, timer = 10},
	{2, L.Knight, timer = 10},
	{1, L.Rider, timer = 10},
	{1, L.Rider, 3, L.Trainee, timer = 5},
	{1, L.Knight, 3, L.Trainee, timer = 5},
	{1, L.Rider, 3, L.Trainee, timer = 20},
	{1, L.Rider, 2, L.Knight, 3, L.Trainee},
}

local waves = wavesNormal

local function getWaveString(wave)
	local waveInfo = waves[wave]
	if #waveInfo == 2 then
		return L.WarningWave1:format(unpack(waveInfo))
	elseif #waveInfo == 4 then
		return L.WarningWave2:format(unpack(waveInfo))
	elseif #waveInfo == 6 then
		return L.WarningWave3:format(unpack(waveInfo))
	end
end

local function NextWave(self)
	self.vb.wave = self.vb.wave + 1
	warnWaveNow:Show(self.vb.wave, getWaveString(self.vb.wave))
	local timer = waves[self.vb.wave].timer
	if timer then
		timerWave:Start(timer, self.vb.wave + 1)
		warnWaveSoon:Schedule(timer - 3, self.vb.wave + 1, getWaveString(self.vb.wave + 1))
		self:Schedule(timer, NextWave, self)
	end
end

local function StartPhase2(self)
	self:SetStage(2)
	self:Unschedule(NextWave) -- heroic 25: Gothik comes down before the last waves
	timerWave:Stop()
	warnWaveSoon:Cancel()
	if self:IsDifficulty("normal25", "heroic25") then
		timerTeleport:Start()
	else
		timerTeleport:Start(20)
	end
end

function mod:OnCombatStart()
	table.wipe(convergenceIcons)
	self:SetStage(1)
	if self:IsDifficulty("normal25", "heroic25") then
		waves = wavesHeroic
	else
		waves = wavesNormal
	end
	self.vb.wave = 0
	if self:IsHeroic() then -- Whitemane heroic (custom spell ids 9250xxx)
		timerSoulConvergence:Start(30)
	end
	local phase2Time = 270
	if self:IsDifficulty("heroic10", "heroic25") then -- Whitemane heroic (10 and 25): Gothik comes down (first Shadow Bolt) ~182s after the pull
		phase2Time = 180
	end
	timerGate:Start()
	timerPhase2:Start(phase2Time)
	warnPhase2:Schedule(phase2Time)
	timerWave:Start(25, self.vb.wave + 1)
	warnWaveSoon:Schedule(22, self.vb.wave + 1, getWaveString(self.vb.wave + 1))
	self:Schedule(25, NextWave, self)
	self:Schedule(phase2Time, StartPhase2, self)
end

function mod:OnCombatEnd()
	for name in pairs(convergenceIcons) do
		self:SetIcon(name, 0)
	end
	table.wipe(convergenceIcons)
end

function mod:OnTimerRecovery()
	if self:IsDifficulty("normal25", "heroic25") then
		waves = wavesHeroic
	else
		waves = wavesNormal
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(9250699, 9250700) and self:AntiSpam(5, 1) then -- Soul Convergence (heroic 10/25, several events per cast)
		timerSoulConvergence:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(9250699, 9250700) then -- Soul Convergence (heroic 10/25: 2/4 players every 30s, lasts up to ~6s)
		if self.Options.SetIconOnSoulConvergence then
			setConvergenceIcon(self, args.destName)
		end
		if args:IsPlayer() then
			specWarnSoulConvergence:Show()
			specWarnSoulConvergence:Play("gathershare")
			yellSoulConvergence:Yell()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(9250699, 9250700) and self.Options.SetIconOnSoulConvergence then -- Soul Convergence
		clearConvergenceIcon(self, args.destName)
	end
end

function mod:UNIT_DIED(args)
	if bit.band(args.destGUID:sub(0, 5), 0x00F) == 3 then
		local cid = self:GetCIDFromGUID(args.destGUID)
		if cid == 16126 then -- Unrelenting Rider
			warnRiderDown:Show()
		elseif cid == 16125 then -- Unrelenting Deathknight
			warnKnightDown:Show()
		end
	end
end
