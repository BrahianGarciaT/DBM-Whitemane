if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end
local L

-----------------
-- Anub'Rekhan --
-----------------
L = DBM:GetModLocalization("Anub'Rekhan")

L:SetGeneralLocalization({
	name = "Anub'Rekhan"
})

L:SetOptionLocalization({
	ArachnophobiaTimer	= "Mostrar temporizador para el logro 'Aracnofobia'"
})

L:SetMiscLocalization({
	ArachnophobiaTimer	= "Logro: Aracnofobia",
	Pull1				= "¡Eso, corred! ¡Así la sangre circula más rápido!",
	Pull2				= "Solo un bocado..."
})

-------------------------
-- Gran Viuda Faerlina --
-------------------------
L = DBM:GetModLocalization("Faerlina")

L:SetGeneralLocalization({
	name = "Gran Viuda Faerlina"
})

L:SetWarningLocalization({
	WarningEmbraceExpire	= "Abrazo de la viuda expirando en 5 s",
	SpecWarnVengefulBlight	= "Plaga vengativa - ¡interrumpe al Adorador resucitado!"
})

L:SetOptionLocalization({
	WarningEmbraceExpire	= "Mostrar aviso previo para cuando expire Abrazo de la viuda",
	SpecWarnVengefulBlight	= "Mostrar aviso especial para interrumpir Plaga vengativa (heroico 25)"
})

L:SetMiscLocalization({
	Pull					= "¡Arrodíllate ante mí, sabandija!"--Not actually pull trigger, but often said on pull
})

-------------
-- Maexxna --
-------------
L = DBM:GetModLocalization("Maexxna")

L:SetGeneralLocalization({
	name = "Maexxna"
})

L:SetWarningLocalization({
	WarningSpidersSoon	= "Arañitas de Maexxna en 5 s",
	WarningSpidersNow	= "Arañitas de Maexxna"
})

L:SetTimerLocalization({
	TimerSpider	= "Siguientes arañitas",
	TimerPoisonShock	= "Descarga de veneno"
})

L:SetOptionLocalization({
	WarningSpidersSoon	= "Mostrar aviso previo para cuando aparezcan Arañitas de Maexxna",
	WarningSpidersNow	= "Mostrar aviso cuando aparezcan Arañitas de Maexxna",
	TimerSpider			= "Mostrar temporizador para las siguientes Arañitas de Maexxna",
	TimerPoisonShock	= "Mostrar temporizador para Descarga de veneno (heroico)"
})

L:SetMiscLocalization({
	ArachnophobiaTimer	= "Logro: Aracnofobia"
})

-----------------------
-- Noth el Pesteador --
-----------------------
L = DBM:GetModLocalization("Noth")

L:SetGeneralLocalization({
	name = "Noth el Pesteador"
})

L:SetWarningLocalization({
	WarningTeleportNow	= "Teletransporte",
	WarningTeleportSoon	= "Teletransporte en 10 s",
	SpecWarnPlagueCurse	= "Maldición del Pesteador en ti - ¡sal de la banda, soltarás un charco!"
})

L:SetTimerLocalization({
	TimerTeleport		= "Teletransporte: Balcón",
	TimerTeleportBack	= "Teletransporte: Suelo"
})

L:SetOptionLocalization({
	WarningTeleportNow	= "Mostrar aviso para Teletransporte",
	WarningTeleportSoon	= "Mostrar aviso previo para Teletransporte",
	TimerTeleport		= "Mostrar temporizador para el siguiente Teletransporte: Balcón",
	TimerTeleportBack	= "Mostrar temporizador para Teletransporte: Suelo",
	SpecWarnPlagueCurse	= "Mostrar aviso especial cuando te afecte la Maldición del Pesteador (heroico)",
	YellPlagueCurse		= "Enviar mensaje por /decir cuando te afecte la Maldición del Pesteador (heroico)",
	SetIconOnPlagueCurse	= "Marcar con iconos a los jugadores afectados por la Maldición del Pesteador (solo heroico 10)"
})

L:SetMiscLocalization({
	Pull				= "¡Muere, intruso!",
	Adds				= "invoca a guerreros esqueletos!",
	AddsTwo				= "alza más esqueletos!",
	YellPlagueCurse		= "Maldición de peste en mí - ¡me aparto!"
})

----------------------
-- Heigan el Impuro --
----------------------
L = DBM:GetModLocalization("Heigan")

L:SetGeneralLocalization({
	name = "Heigan el Impuro"
})

L:SetWarningLocalization({
	WarningTeleportNow	= "Teletransporte",
	WarningTeleportSoon	= "Teletransporte en %d s"
})

L:SetTimerLocalization({
	TimerTeleport	= "Teletransporte",
	TimerDecrepitFever	= "Siguiente Fiebre decrépita"
})

L:SetOptionLocalization({
	WarningTeleportNow	= "Mostrar aviso para Teletransporte",
	WarningTeleportSoon	= "Mostrar aviso previo para Teletransporte",
	TimerTeleport		= "Mostrar aviso para Teletransporte",
	TimerDecrepitFever	= "Mostrar temporizador para Fiebre decrépita (heroico)"
})

L:SetMiscLocalization({
	Pull				= "Ahora me perteneces."
})

-------------
-- Loatheb --
-------------
L = DBM:GetModLocalization("Loatheb")

L:SetGeneralLocalization({
	name = "Loatheb"
})

L:SetWarningLocalization({
	WarningHealSoon	= "Sanación posible en 3 s",
	WarningHealNow	= "¡Sanad ahora!",
	WarningVolatileSpores	= "Esporas volátiles en >%s<",
	SpecWarnVolatileSpores	= "Esporas volátiles en ti - ¡ve a una Seta purificadora!"
})

L:SetTimerLocalization({
	TimerVolatileSpores	= "Esporas volátiles"
})

L:SetOptionLocalization({
	WarningHealSoon		= "Mostrar aviso previo para la franja de sanación",
	WarningHealNow		= "Mostrar aviso para la franja de sanación",
	SporeDamageAlert	= "Enviar susurros y avisar a la banda de los jugadores que estén dañando esporas\n(necesita 'anunciar' activado y lider/ayudante)",
	CorruptedSorting	= "Set infoframe sorting behaviour for $spell:55593", -- translation missing
	Alphabetical		= "Sort in alphabetical order", -- translation missing
	Duration			= "Sort by duration", -- translation missing
		WarningVolatileSpores	= "Mostrar aviso de objetivos de Esporas volátiles (heroico)",
		SpecWarnVolatileSpores	= "Mostrar aviso especial cuando te afecten las Esporas volátiles (heroico)",
		TimerVolatileSpores	= "Mostrar temporizador para Esporas volátiles (heroico)",
		YellVolatileSpores	= "Enviar mensaje por /decir cuando te afecten las Esporas volátiles (heroico)",
		SetIconOnVolatileSpores	= "Marcar con icono al objetivo de Esporas volátiles (heroico)"
})

L:SetMiscLocalization({
	YellVolatileSpores	= "Esporas en mí - ¡voy a la seta!"
})

---------------
-- Remendejo --
---------------
L = DBM:GetModLocalization("Patchwerk")

L:SetGeneralLocalization({
	name = "Remendejo"
})

L:SetOptionLocalization({
	WarningHateful = "Avisar por chat de banda los Golpes de Odio (necesitas ser ayudante o lider para eso)"
})

L:SetMiscLocalization({
	yell1 = "¡Remendejo quiere jugar!",
	yell2 = "¡Remendejo es la encarnación de guerra de Kel'Thuzad!",
	HatefulStrike = "Golpe de Odio --> %s [%s]"
})

---------------
-- Grobbulus --
---------------
L = DBM:GetModLocalization("Grobbulus")

L:SetGeneralLocalization({
	name = "Grobbulus"
})

L:SetWarningLocalization({
	SpecWarnVolatileBile	= "Bilis volátil en ti - ¡júntate con la banda!"
})

L:SetTimerLocalization({
	TimerVolatileBile	= "Bilis volátil"
})

L:SetOptionLocalization({
	TimerVolatileBile	= "Mostrar temporizador para Bilis volátil (heroico)",
	SpecWarnVolatileBile	= "Mostrar aviso especial cuando seas el objetivo de Bilis volátil (heroico)",
	YellVolatileBile	= "Enviar mensaje por /decir cuando seas el objetivo de Bilis volátil (heroico)",
	SetIconOnVolatileBile	= "Marcar con icono al objetivo de Bilis volátil (heroico)"
})

L:SetMiscLocalization({
	YellVolatileBile	= "Bilis volátil en mí - ¡juntaos!"
})

-----------
-- Gluth --
-----------
L = DBM:GetModLocalization("Gluth")

L:SetGeneralLocalization({
	name = "Gluth"
})

--------------
-- Thaddius --
--------------
L = DBM:GetModLocalization("Thaddius")

L:SetGeneralLocalization({
	name = "Thaddius"
})

L:SetWarningLocalization({
	WarningChargeChanged	= "Polaridad cambiada a %s",
	WarningChargeNotChanged	= "Tu polaridad no ha cambiado",
	WarningTeslaOverload	= "Sobrecarga de Tesla"
})

L:SetOptionLocalization({
	WarningChargeChanged	= "Mostrar aviso especial cuando tu polaridad cambie",
	WarningChargeNotChanged	= "Mostrar aviso especial cuando tu polaridad no cambie",
	WarningTeslaOverload	= "Mostrar aviso para Sobrecarga de Tesla (heroico)",
	ArrowsEnabled			= "Mostrar flechas (estrategia típica de dos grupos)",
	ArrowsRightLeft			= "Mostrar flechas de izquierda y derecha (estrategia de cuatro grupos; muestra la flecha izquierda si cambia la polaridad, y la derecha si no cambia)",
	ArrowsInverse			= "Mostrar flechas de izquierda y derecha inversas (estrategia de cuatro grupos; muestra la flecha derecha si cambia la polaridad, y la izquierda si no cambia)"
})

L:SetMiscLocalization({
	Yell	= "¡Stalagg aplasta!",
	Emote	= "¡%s se sobrecarga!",
	Emote2	= "¡Espiral Tesla se sobrecarga!",
	Boss1	= "Feugen",
	Boss2	= "Stalagg",
	Charge1 = "negativo",
	Charge2 = "positivo"
})

--------------------------
-- Instructor Razuvious --
--------------------------
L = DBM:GetModLocalization("Razuvious")

L:SetGeneralLocalization({
	name = "Instructor Razuvious"
})

L:SetWarningLocalization({
	WarningShieldWallSoon	= "Barrera de huesos termina en 5 s",
	SpecWarnJaggedKnife		= "Cuchillo dentado en ti - ¡aléjate del grupo!"
})

L:SetTimerLocalization({
	TimerJaggedKnife		= "Cuchillo dentado",
	TimerDisciplinaryShout	= "Grito disciplinario"
})

L:SetOptionLocalization({
	WarningShieldWallSoon	= "Mostrar aviso previo para cuando termine $spell:29061",
	TimerJaggedKnife		= "Mostrar temporizador para Cuchillo dentado (heroico)",
	TimerDisciplinaryShout	= "Mostrar temporizador para Grito disciplinario (heroico)",
	SpecWarnJaggedKnife		= "Mostrar aviso especial cuando seas el objetivo de Cuchillo dentado (heroico)",
	YellJaggedKnife			= "Enviar mensaje por /decir cuando seas el objetivo de Cuchillo dentado (heroico)",
	SetIconOnJaggedKnife	= "Marcar con icono al objetivo de Cuchillo dentado (heroico)"
})

L:SetMiscLocalization({
	YellJaggedKnife = "Cuchillo dentado en mí - ¡me aparto!",
	Yell1 = "¡No tengáis piedad!",
	Yell2 = "¡El tiempo de practicar ha pasado! ¡Quiero ver lo que habéis aprendido!",
	Yell3 = "¡Poned en práctica lo que os he enseñado!",
	Yell4 = "Un barrido con pierna... ¿Tienes algún problema?"
})

--------------------------
-- Gothik el Cosechador --
--------------------------
L = DBM:GetModLocalization("Gothik")

L:SetGeneralLocalization({
	name = "Gothik el Cosechador"
})

L:SetWarningLocalization({
	WarningWaveSoon		= "Oleada %d: %s en 3 s",
	WarningWaveSpawned	= "Oleada %d: %s",
	WarningRiderDown	= "Jinete muerto",
	WarningKnightDown	= "Caballero muerto",
	WarningPhase2		= "Fase 2",
	SpecWarnSoulConvergence	= "Convergencia de almas en ti - ¡júntate con los demás!"
})

L:SetTimerLocalization({
	TimerWave	= "Oleada %d",
	TimerPhase2	= "Fase 2",
	TimerSoulConvergence	= "Convergencia de almas"
})

L:SetOptionLocalization({
	TimerSoulConvergence	= "Mostrar temporizador para Convergencia de almas (heroico)",
	SpecWarnSoulConvergence	= "Mostrar aviso especial cuando te afecte la Convergencia de almas (heroico)",
	YellSoulConvergence		= "Enviar mensaje por /decir cuando te afecte la Convergencia de almas (heroico)",
	SetIconOnSoulConvergence	= "Marcar con iconos a los jugadores afectados por la Convergencia de almas (heroico)",
	TimerWave			= "Mostrar temporizador para la siguiente oleada de esbirros",
	TimerPhase2			= "Mostrar temporizador para el cambio a Fase 2",
	WarningWaveSoon		= "Mostrar aviso previo para la siguiente oleada de esbirros",
	WarningWaveSpawned	= "Mostrar aviso cuando comience una oleada de esbirros",
	WarningRiderDown	= "Mostrar aviso cuando muera un Jinete inflexible",
	WarningKnightDown	= "Mostrar aviso cuando muera un Caballero de la Muerte inflexible"
})

L:SetMiscLocalization({
	yell			= "Tú mismo has buscado tu final.",
	YellSoulConvergence	= "Convergencia de almas en mí - ¡juntaos!",
	WarningWave1	= "%d %s",
	WarningWave2	= "%d %s y %d %s",
	WarningWave3	= "%d %s, %d %s y %d %s",
	Trainee			= "practicantes",
	Knight			= "caballeros",
	Rider			= "jinetes"
})

------------------------
-- Los Cuatro Jinetes --
------------------------
L = DBM:GetModLocalization("Horsemen")

L:SetGeneralLocalization({
	name = "Los Cuatro Jinetes"
})

L:SetWarningLocalization({
	WarningMarkSoon				= "Marca %d en 3 s",
	SpecialWarningMarkOnPlayer	= "%s: %s"
})

L:SetTimerLocalization({
	TimerUnholyShadow			= "Sombra profana"
})

L:SetOptionLocalization({
	TimerUnholyShadow			= "Mostrar temporizador para Sombra profana (heroico)",
	WarningMarkSoon				= "Mostrar aviso previo para las marcas",
	SpecialWarningMarkOnPlayer	= "Mostrar aviso especial cuando estés afectado por más de cuatro marcas"
})

L:SetMiscLocalization({
	Korthazz	= "Señor feudal Korth'azz",
	Rivendare	= "Barón Osahendido",
	Blaumeux	= "Lady Blaumeux",
	Zeliek		= "Sir Zeliek"
})

---------------
-- Sapphiron --
---------------
L = DBM:GetModLocalization("Sapphiron")

L:SetGeneralLocalization({
	name = "Sapphiron"
})

L:SetWarningLocalization({
	WarningAirPhaseSoon	= "Fase aérea en 10 s",
	WarningAirPhaseNow	= "Fase aérea",
	WarningLanded		= "Fase en tierra",
	WarningDeepBreath	= "Aliento de Escarcha",
	SpecWarnSapphLow	= "¡Sapphiron no puede volar!"
})

L:SetTimerLocalization({
	TimerAir		= "Fase aérea",
	TimerLanding	= "Fase en tierra",
	TimerIceBlast	= "Aliento de Escarcha",
	TimerFrostBreath	= "Aliento de Escarcha"
})

L:SetOptionLocalization({
	WarningAirPhaseSoon	= "Mostrar aviso previo para el cambio a fase aérea",
	WarningAirPhaseNow	= "Anunciar cambio a fase aérea",
	WarningLanded		= "Anunciar cambio a fase en tierra",
	TimerAir			= "Mostrar temporizador para el cambio a fase aérea",
	TimerLanding		= "Mostrar temporizador para el cambio a fase en tierra",
	TimerIceBlast		= "Mostrar temporizador para $spell:28524",
	TimerFrostBreath	= "Mostrar temporizador para Aliento de Escarcha (heroico)",
	WarningDeepBreath	= "Mostrar aviso especial para $spell:28524",
	SpecWarnSapphLow	= "Advertencia especial para fase de ejecución del 10% (cancelación de fase de aire)"
})

L:SetMiscLocalization({
	EmoteBreath			= "%s respira hondo.",
	AirPhase			= "¡Sapphiron se eleva en el aire!",
	LandingPhase		= "¡Sapphiron reanuda su ataque!"
})

----------------
-- Kel'Thuzad --
----------------
L = DBM:GetModLocalization("Kel'Thuzad")

L:SetGeneralLocalization({
	name = "Kel'Thuzad"
})

L:SetWarningLocalization({
	specwarnP2Soon	= "Fase 2 en 10 s",
	warnAddsSoon	= "Guardianes de Corona de Hielo en breve",
	WarningNecroticSurge	= "Oleada necrótica sobre la banda"
})

L:SetTimerLocalization({
	TimerPhase2	= "Fase 2",
	TimerFreezingBlast	= "Explosión congelante"
})

L:SetOptionLocalization({
	TimerPhase2			= "Mostrar temporizador para el cambio a Fase 2",
	specwarnP2Soon		= "Mostrar aviso especial 10 s antes del cambio a Fase 2",
	warnAddsSoon		= "Mostrar aviso previo para cuando aparezcan los Guardianes de Corona de Hielo",
	WarningNecroticSurge	= "Mostrar aviso para Oleada necrótica (heroico)",
	TimerFreezingBlast	= "Mostrar temporizador para Explosión congelante (heroico)",
	EqUneqWeaponsKT		= "Desequipar y equipar armas automáticamente antes y después del $spell:28410. Requiere equipamiento llamado \"pve\"",
	EqUneqWeaponsKT2	= "Desequipar y equipar armas automáticamente cuando se lanza $spell:28410 sobre USTED",
	RemoveBuffsOnMC		= "Elimina los buffs cuando $spell:28410 es lanzado sobre ti. Cada opción es acumulativa",
	Gift				= "Eliminar $spell:48469 / $spell:48470. Enfoque mínimo para evitar que $spell:33786 se resista",
	CCFree				= "+ Eliminar $spell:48169 / $spell:48170. Tener en cuenta las resistencias de los hechizos de la escuela Sombra",
	ShortOffensiveProcs	= "+ Elimina los procs ofensivos de baja duración. Recomendado para la seguridad de la raid sin comprometer la producción de daño de la raid",
	MostOffensiveBuffs	= "+ Elimina la mayoría de los buffs ofensivos (principalmente para los Casters y los |cFFFF7C0ADruidas Ferales|r). Máxima seguridad en la incursión con la pérdida de daño y la necesidad de auto-buff/cambio de forma"
})

L:SetMiscLocalization({
	Yell		= "¡Esbirros, sirvientes, soldados de la fría oscuridad! ¡Obedeced la llamada de Kel'Thuzad!",
	setMissing	= "¡ATENCIÓN! El desequipamiento / equipamiento automático de armas de DBM no funcionará hasta que cree un equipamiento llamado pve",
	EqUneqLineDescription	= "Equipar/desequipar automático"
})
