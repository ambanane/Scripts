if GetObjectName(GetMyHero()) ~= 'Karthus' then return end

require('OpenPredict')

KarthusMenu = Menu('Karthus', 'Karthus')

KarthusMenu:SubMenu('Combo', 'Combo')
KarthusMenu.Combo:Boolean('Q', 'Use Q in combo', true)
KarthusMenu.Combo:Boolean('W', 'Use W in combo', true)

KarthusMenu:SubMenu('Killsteal', 'Killsteal')
KarthusMenu.Killsteal:Boolean('KQ', 'Killsteal with Q', true)

KarthusMenu:SubMenu('Misc', 'Misc')
KarthusMenu.Misc:Boolean('AE', 'Auto E', true)
KarthusMenu.Misc:Boolean('Ignite', 'Ignite if killable', true)
KarthusMenu.Misc:Boolean('Level', 'Auto level', true)
KarthusMenu.Misc:Boolean('JT', 'Enemy jungler tracker', true)
KarthusMenu.Misc:SubMenu('Skin', 'Skin Changer')
KarthusMenu.Misc.Skin:Slider('SC', 'Select skin', 1, 1, 9)

KarthusMenu:SubMenu('Drawings', 'Drawings')
KarthusMenu.Drawings:Boolean('DQ', 'Draw Q range', true)
KarthusMenu.Drawings:Boolean('DW', 'Draw W range', false)
KarthusMenu.Drawings:Boolean('CT', 'Draw circle on curent target', true)

OnTick(function (myHero)

	target = GetCurrentTarget()
	MaxHP = GetMaxHP(myHero)
	CurrentHP = GetCurrentHP(myHero)
	BonusAP = GetBonusAP(myHero)
	MeleeRange = 450
	QRange = 875
	WRange = 1000
	ERange = 425
	QDmg = 20 + 20 * GetCastLevel(myHero, _Q) + BonusAP * 0.3
	QData = { delay = 0.650, range = 875 , radius = 250 }
	EDmg = 10 + 20 * GetCastLevel(myHero, _E) + BonusAP * 0.2
	RDmg = 100 + 150 * GetCastLevel(myHero, _R) + BonusAP * 0.6
	QPred = GetCircularAOEPrediction(target, QData)

	--COMBO
	if IOW:Mode() == 'Combo' then

		if KarthusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, QRange) then
			if QPred and QPred.hitChance >= 0.25 then
				CastSkillShot(_Q, QPred.castPos)
			end
		end

		if KarthusMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, WRange) then
			if GetCurrentHP(target) <= GetMaxHP(target) * 0.5 then
				CastSkillShot(_W, target)
			end
		end

	end

	--KILLSTEAL
	for _, enemy in pairs(GetEnemyHeroes()) do
		QPredKS = GetCircularAOEPrediction(enemy, QData)

		if KarthusMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, QRange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) then
				if QPredKS and QPredKS.hitChance >= 0.25 then
					CastSkillShot(_Q, QPredKS.castPos)
				end
			end
		end
	end

	--AUTO E
	E = GetBuffData(myHero, 'KarthusDefile')
	if KarthusMenu.Misc.AE:Value() and Ready(_E) then
		if GetDistance(myHero, GetOrigin(ClosestEnemy(myHero))) < ERange then
			if E.Count < 1 then
				CastSpell(_E)
			end
		end

		if GetDistance(myHero, GetOrigin(ClosestEnemy(myHero))) > ERange then
			if E.Count > 0 then
				CastSpell(_E)
			end
		end
	end

	--AUTO IGNITE
	if KarthusMenu.Misc.Ignite:Value() then

		for _, enemy in pairs(GetEnemyHeroes()) do
				
			if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
				Ignite = SUMMONER_1
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end

			elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
				Ignite = SUMMONER_2
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			end

		end

	end

	--AUTO LEVEL
	if KarthusMenu.Misc.Level:Value() then
		spellorder = {_Q, _E, _Q, _W, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
		if GetLevelPoints(myHero) > 0 then
			LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
		end
	end

end)

OnDraw(function (myHero)

	target = GetCurrentTarget()
	MaxHP = GetMaxHP(myHero)
	CurrentHP = GetCurrentHP(myHero)
	BonusAP = GetBonusAP(myHero)
	MeleeRange = 450
	QRange = 875
	WRange = 1000
	ERange = 425
	QDmg = 20 + 20 * GetCastLevel(myHero, _Q) + BonusAP * 0.3
	QData = { delay = 0.650, range = 875 , radius = 250 }
	EDmg = 10 + 20 * GetCastLevel(myHero, _E) + BonusAP * 0.2
	RDmg = 100 + 150 * GetCastLevel(myHero, _R) + BonusAP * 0.6

	--SKIN CHANGER
	HeroSkinChanger(myHero, KarthusMenu.Misc.Skin.SC:Value() - 1)

	--CURRENT TARGET CIRCLE
	if KarthusMenu.Drawings.CT:Value() then
		if IsObjectAlive(myHero) then
			DrawCircle(GetOrigin(target), 100, 5, 8, ARGB(100, 153, 51, 255))
		end
	end

	--JUNGLER TRACKER
	if KarthusMenu.Misc.JT:Value() then
		if IsObjectAlive(myHero) then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if IsObjectAlive(enemy) then
					if IsVisible(enemy) then
						if GetCastName(enemy, SUMMONER_1) == 'SummonerSmite' or GetCastName(enemy, SUMMONER_2) == 'SummonerSmite' or GetCastName(enemy, SUMMONER_1) == 'S5_SummonerSmitePlayerGanker' or GetCastName(enemy, SUMMONER_2) == 'S5_SummonerSmitePlayerGanker' or GetCastName(enemy, SUMMONER_1) == 'S5_SummonerSmiteDuel' or GetCastName(enemy, SUMMONER_2) == 'S5_SummonerSmiteDuel' then
							 junglerPos = WorldToScreen(0, GetOrigin(enemy))
							 myPos = WorldToScreen(1, GetOrigin(myHero))

							if GetDistance(myHero, enemy) > 2000 then

								DrawLine(myPos.x, myPos.y, junglerPos.x, junglerPos.y, 3, ARGB(150, 255, 255, 255))

							elseif GetDistance(myHero, enemy) < 2000 and GetDistance(myHero, enemy) > 1300 then

								DrawLine(myPos.x, myPos.y, junglerPos.x, junglerPos.y, 3, ARGB(150, 255, 255, 0))

							elseif GetDistance(myHero, enemy) < 1300 then

								DrawLine(myPos.x, myPos.y, junglerPos.x, junglerPos.y, 3, ARGB(150, 255, 0, 0))

							end

						end
					end
				end
			end
		end
	end

	--SPELL RANGE
	if IsObjectAlive(myHero) then

		--Q RANGE
		if KarthusMenu.Drawings.DQ:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), QRange, 5, 100, ARGB(100, 115, 0, 230))
			else
				DrawCircle(GetOrigin(myHero), QRange, 5, 100, ARGB(100, 255, 0, 0))
			end
		end

		--W RANGE
		if KarthusMenu.Drawings.DW:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), WRange, 5, 100, ARGB(100, 153, 51, 255))
			else
				DrawCircle(GetOrigin(myHero), WRange, 5, 100, ARGB(100, 255, 0, 0))
			end
		end

	end

	--DRAW ON ENEMY
	for _, enemy in pairs(GetEnemyHeroes()) do

		if IsObjectAlive(myHero) then

			if ValidTarget(enemy) then

				--DRAW IF KILLABLE
				 enemyPos = GetOrigin(enemy)
				 drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)

				if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) and Ready(_Q) then

					DrawText('Q', 13, drawpos.x-60, drawpos.y, ARGB(100, 0, 153, 51))

				end

				--DRAW DMG ON HP BAR
				if Ready(_Q) and Ready(_R) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, RDmg), ARGB(255, 0, 153, 51))

				elseif Ready(_Q) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), ARGB(255, 0, 153, 51))

				elseif Ready(_R) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), ARGB(255, 0, 153, 51))

				end

			end

		end

	end

	--R AWARENESS
	if IsObjectAlive(myHero) then

		if Ready(_R) then

			for _, enemy in pairs(GetEnemyHeroes()) do

				if IsObjectAlive(enemy) then

					if GetCurrentHP(enemy) + 20 < CalcDamage(myHero, enemy, 0, RDmg) then

						local myPos = myHero
						local drawPos = WorldToScreen(1, myPos.x, myPos.y, myPos.z)

						DrawText('>>> R <<<', 25, drawPos.x, drawPos.y, GoS.Green)

					end

				end

			end

		end

	end

end)

--DRAW ENEMY JUNGLER ON MINIMAP
OnDrawMinimap(function (myHero)
	if KarthusMenu.Misc.JT:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if IsObjectAlive(enemy) then
				if IsVisible(enemy) then
					if GetCastName(enemy, SUMMONER_1) == 'SummonerSmite' or GetCastName(enemy, SUMMONER_2) == 'SummonerSmite' or GetCastName(enemy, SUMMONER_1) == 'S5_SummonerSmitePlayerGanker' or GetCastName(enemy, SUMMONER_2) == 'S5_SummonerSmitePlayerGanker' or GetCastName(enemy, SUMMONER_1) == 'S5_SummonerSmiteDuel' or GetCastName(enemy, SUMMONER_2) == 'S5_SummonerSmiteDuel' then
						DrawCircleMinimap(GetOrigin(enemy), 1500, 1, 8, GoS.Red)
					end
				end
			end
		end
	end
end)

print('Merciless Karthus by Sibyl loaded!')