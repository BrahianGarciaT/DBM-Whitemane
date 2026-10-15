if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end
local L

-------------
-- Malygos --
-------------
L = DBM:GetModLocalization("Malygos")

L:SetGeneralLocalization({
	name = "Malygos"
})

L:SetWarningLocalization({
	WarningArcaneStorm		= "Tormenta arcana - daño a la banda",
	WarningArcaneFeedback	= "Retroalimentación arcana en >%s<"
})

L:SetTimerLocalization({
	TimerArcaneBreath		= "Aliento arcano",
	TimerArcaneFeedback		= "Retroalimentación arcana"
})

L:SetOptionLocalization({
	WarningArcaneStorm		= "Mostrar aviso de Tormenta arcana (heroico)",
	WarningArcaneFeedback	= "Mostrar aviso del objetivo de Retroalimentación arcana (heroico)",
	TimerArcaneBreath		= "Mostrar temporizador para Aliento arcano (heroico)",
	TimerArcaneFeedback		= "Mostrar temporizador para Retroalimentación arcana (heroico)"
})

L:SetMiscLocalization({
	YellPull	= "Habéis agotado mi paciencia. ¡Me desharé de vosotros!",
	EmoteSpark	= "¡Un Chispazo toma forma a partir de una falla cercana!",
	YellPhase2	= "Esperaba acabar con vuestras vidas rápidamente",
	YellBreath	= "¡No lo conseguiréis mientras me quede aliento!",
	YellPhase3	= "Ahora aparecen vuestros benefactores, ¡pero llegan demasiado tarde!",
	EmoteSurge	= "¡%s fija su mirada en ti!"
})
