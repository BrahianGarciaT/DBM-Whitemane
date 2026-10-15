local L

---------------
--  Malygos  --
---------------
L = DBM:GetModLocalization("Malygos")

L:SetGeneralLocalization({
	name = "Malygos"
})

L:SetWarningLocalization({
	WarningArcaneStorm		= "Arcane Storm - raid damage",
	WarningArcaneFeedback	= "Arcane Feedback on >%s<"
})

L:SetTimerLocalization({
	TimerArcaneBreath		= "Arcane Breath",
	TimerArcaneFeedback		= "Arcane Feedback"
})

L:SetOptionLocalization({
	WarningArcaneStorm		= "Show warning for Arcane Storm (heroic)",
	WarningArcaneFeedback	= "Show warning for Arcane Feedback target (heroic)",
	TimerArcaneBreath		= "Show timer for Arcane Breath (heroic)",
	TimerArcaneFeedback		= "Show timer for Arcane Feedback (heroic)"
})

L:SetMiscLocalization({
	YellPull	= "My patience has reached its limit. I will be rid of you!",
	EmoteSpark	= "A Power Spark forms from a nearby rift!",
	YellPhase2	= "I had hoped to end your lives quickly",
--	EmoteBreath	= "%s takes a deep breath.",
	YellBreath	= "You will not succeed while I draw breath!",
	YellPhase3	= "Now your benefactors make their",
--	EnoughScream	= "ENOUGH! If you intend to reclaim Azeroth's magic, then you shall have it!"
	EmoteSurge	= "%s fixes his eyes on you!"
})
