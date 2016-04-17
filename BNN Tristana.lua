if GetObjectName(GetMyHero()) ~= "Tristana" then return end

local TristanaMenu = Menu("Tristana", "BNN Tristana")

TristanaMenu:SubMenu("Combo", "Combo")

TristanaMenu.Combo:Boolean("Q", "Use Q in combo", true)
TristanaMenu.Combo:Boolean("W", "Use W in combo", true)
TristanaMenu.Combo:Boolean("E", "Use E in combo", true)

TristanaMenu:SubMenu("Killsteal", "Killsteal")
TristanaMenu.Killsteal:Boolean("KW", "Killsteal with W", true)
TristanaMenu.Killsteal:Boolean("KE", "Killsteal with E", true)
TristanaMenu.Killsteal:Boolean("KR", "Killsteal with R", true)

TristanaMenu:SubMenu("Farm", "Farm")
TristanaMenu.Farm:Boolean("LH", "Last hit minions", true)
TristanaMenu.Farm:Boolean("MC", "Last hit circle", true)

TristanaMenu:SubMenu("Misc", "Misc")
TristanaMenu.Misc:Boolean("Level", "Auto level spells", true)
TristanaMenu.Misc:Boolean("Ignite", "Auto Ignite if killable", true)

TristanaMenu:SubMenu("Drawings", "Drawings")
TristanaMenu.Drawings:Boolean("DW", "Draw W range", true)
TristanaMenu.Drawings:Boolean("DER", "Draw E and R range", true)
TristanaMenu.Drawings:Boolean("Dmg", "Draw damage calculator", true)
TristanaMenu.Drawings:Boolean("Jungler", "Enemy jungler tracker", true)

OnTick(function (myHero)

	local target = GetCurrentTarget()
	local BaseHPHero = GetMaxHP(myHero)
	local CurrentHPHero = GetCurrentHP(myHero)
	local BaseHPTarget = GetMaxHP(target)
	local CurrentHPTarget = GetCurrentHP(target)
	local MeleeRange = 543 + 7 * GetLevel(myHero)
	local BaseAD = GetBaseDamage(myHero)
	local BonusAD = GetBonusDmg(myHero)
	local BonusAP = GetBonusAP(myHero)
	local WRange = 900
	local ERange = 543 + 7 * GetLevel(myHero)
	local RRange = 543 + 7 * GetLevel(myHero)
	local WDmg = 10 + 50 * GetCastLevel(myHero, _W) + BonusAP * 0.5
	local EDmg = 50 + 10 * GetCastLevel(myHero, _E) + (((35 + 15 * GetCastLevel(myHero, _E)) / 100 * BonusAD) + 0.5 * BonusAP)
	local RDmg = 200 + 100 * GetCastLevel(myHero, _R) + BonusAP
	local WPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), 1100, 500, 900, 120, false, true)

	--AUTO LEVEL UP
	if TristanaMenu.Misc.Level:Value() then

		if GetLevel(myHero) == 1 then

			LevelSpell(_E)

		elseif GetLevel(myHero) == 2 then

			LevelSpell(_W)

		elseif GetLevel(myHero) == 3 then

			LevelSpell(_Q)

		elseif GetLevel(myHero) == 4 then

			LevelSpell(_E)

		elseif GetLevel(myHero) == 5 then

			LevelSpell(_E)

		elseif GetLevel(myHero) == 6 then

			LevelSpell(_R)

		elseif GetLevel(myHero) == 7 then

			LevelSpell(_E)

		elseif GetLevel(myHero) == 8 then

			LevelSpell(_Q)

		elseif GetLevel(myHero) == 9 then

			LevelSpell(_E)

		elseif GetLevel(myHero) == 10 then

			LevelSpell(_Q)

		elseif GetLevel(myHero) == 11 then

			LevelSpell(_R)

		elseif GetLevel(myHero) == 12 then

			LevelSpell(_Q)

		elseif GetLevel(myHero) == 13 then

			LevelSpell(_Q)

		elseif GetLevel(myHero) == 14 then

			LevelSpell(_W)

		elseif GetLevel(myHero) == 15 then

			LevelSpell(_W)

		elseif GetLevel(myHero) == 16 then

			LevelSpell(_R)

		elseif GetLevel(myHero) == 17 then

			LevelSpell(_W)

		elseif GetLevel(myHero) == 18 then

			LevelSpell(_W)

		end

	end

	--COMBO
	if IOW:Mode() == "Combo" then

		if TristanaMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, ERange) then
			CastTargetSpell(target, _E)
		end

		if TristanaMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, MeleeRange) then
			CastSpell(_Q)
		end

		if TristanaMenu.Combo.W:Value() and Ready(_W) and GetDistance(myHero, target) < WRange and GetDistance(myHero, target) > RRange and EnemiesAround(target, 800) < 2 then
			if WPred.HitChance == 1 then
				CastSkillShot(_W, target)
			end
		end

	else

		--LAST HIT MINIONS
		if not UnderTurret(GetOrigin(myHero), enemyTurret) then
			if TristanaMenu.Farm.LH:Value() then
				for _, minion in pairs(minionManager.objects) do
					if ValidTarget(minion, MeleeRange) and GetCurrentHP(minion) < BaseAD + BonusAD then
						AttackUnit(minion)
					end
				end
			end
		end

	end

	--KILLSTEAL
	for _, enemy in pairs(GetEnemyHeroes()) do
		local WPredKillsteal = GetPredictionForPlayer(GetOrigin(myHero), enemy, GetMoveSpeed(target), 1100, 500, 900, 120, false, true)

		if TristanaMenu.Killsteal.KR:Value() and Ready(_R) and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, RDmg) and ValidTarget(enemy, RRange) then
			CastTargetSpell(enemy, _R)
		end

		if TristanaMenu.Killsteal.KE:Value() and Ready(_E) and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, EDmg, 0) and ValidTarget(enemy, ERange) then
			CastTargetSpell(enemy, _E)
		end

		if TristanaMenu.Killsteal.KW:Value() and Ready(_W) and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) and ValidTarget(enemy, WRange - 15) then
			if WPredKillsteal.HitChance == 1 then
				CastSkillShot(_W, enemy)
			end
		end

	end

	--AUTO IGNITE
	if TristanaMenu.Misc.Ignite:Value() then

		for _, enemy in pairs(GetEnemyHeroes()) do
		
			if GetCastName(myHero, SUMMONER_1) == "SummonerDot" then
				local Ignite = SUMMONER_1
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end

			elseif GetCastName(myHero, SUMMONER_2) == "SummonerDot" then
				local Ignite = SUMMONER_2
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			end

		end

	end

end)

--DRAWINGS
OnDraw(function (myHero)

	local target = GetCurrentTarget()
	local BaseHPHero = GetMaxHP(myHero)
	local CurrentHPHero = GetCurrentHP(myHero)
	local BaseHPTarget = GetMaxHP(target)
	local CurrentHPTarget = GetCurrentHP(target)
	local MeleeRange = 543 + 7 * GetLevel(myHero)
	local BaseAD = GetBaseDamage(myHero)
	local BonusAD = GetBonusDmg(myHero)
	local BonusAP = GetBonusAP(myHero)
	local WRange = 900
	local ERange = 543 + 7 * GetLevel(myHero)
	local RRange = 543 + 7 * GetLevel(myHero)
	local WDmg = 10 + 50 * GetCastLevel(myHero, _W) + BonusAP * 0.5
	local EDmg = 50 + 10 * GetCastLevel(myHero, _E) + (((35 + 15 * GetCastLevel(myHero, _E)) / 100 * BonusAD) + 0.5 * BonusAP)
	local RDmg = 200 + 100 * GetCastLevel(myHero, _R) + BonusAP

	for _, enemy in pairs(GetEnemyHeroes()) do

		--DRAW IF KILLABLE
		if ValidTarget(enemy) then

			local enemyPos = GetOrigin(enemy)
			local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)

			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, RDmg) and Ready(_R) then

				DrawText("R=Kill", 12, drawpos.x-60, drawpos.y, GoS.White)
			
			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) and Ready(_R) then

				DrawText("W=Kill", 12, drawpos.x-60, drawpos.y, GoS.White)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, EDmg, 0) and Ready(_E) then

				DrawText("E=Kill", 12, drawpos.x-60, drawpos.y, GoS.White)

			end


			--DRAW DMG ON HP BAR ENEMY
			if TristanaMenu.Drawings.Dmg:Value() then
				if Ready(_W) and Ready(_E) and Ready(_R) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), CalcDamage(myHero, enemy, EDmg, 0), CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, RDmg), GoS.Green)


				elseif Ready(_W) and Ready(_R) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, RDmg), GoS.Green)


				elseif Ready(_W) and Ready(_E) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), CalcDamage(myHero, enemy, EDmg, 0), CalcDamage(myHero, enemy, 0, WDmg), GoS.Green)


				elseif Ready(_E) and Ready(_R) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), CalcDamage(myHero, enemy, EDmg, 0), CalcDamage(myHero, enemy, 0, RDmg), GoS.Green)


				elseif Ready(_R) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), GoS.Green)


				elseif Ready(_W) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), GoS.Green)


				elseif Ready(_E) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), CalcDamage(myHero, enemy, EDmg, 0), 0, GoS.Green)


				end
			end

		end

	end

		--DRAW CIRCLE ON MINIONS
		if TristanaMenu.Farm.MC:Value() then
			if IsObjectAlive(myHero) then
				for _, minion in pairs(minionManager.objects) do
					if ValidTarget(minion, MeleeRange) then
						if GetCurrentHP(minion) < BaseAD + BonusAD + (BaseAD + BonusAD) * 0.20 and GetCurrentHP(minion) > BaseAD + BonusAD then
							DrawCircle(GetOrigin(minion), 50, 2, 8, GoS.Red)
						elseif GetCurrentHP(minion) < BaseAD + BonusAD then
							DrawCircle(GetOrigin(minion), 50, 2, 8, GoS.Green)
						end
					end
				end
			end
		end

	--DRAW RANGE
	if IsObjectAlive(myHero) then
		if TristanaMenu.Drawings.DW:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), WRange, 2, 8, GoS.Cyan)
			else
				DrawCircle(GetOrigin(myHero), WRange, 2, 8, GoS.Red)
			end
		end

		if TristanaMenu.Drawings.DER:Value() then
			if Ready(_E) or Ready(_R) then
				DrawCircle(GetOrigin(myHero), RRange, 2, 8, GoS.Green)
			else
				DrawCircle(GetOrigin(myHero), RRange, 2, 8, GoS.Red)
			end
		end
	end


	--DRAW LINE BETWEEN MYHERO AND ENEMY JUNGLER
	if TristanaMenu.Drawings.Jungler:Value() then
		if IsObjectAlive(myHero) then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if IsObjectAlive(enemy) then
					if IsVisible(enemy) then
						if GetCastName(enemy, SUMMONER_1) == "SummonerSmite" or GetCastName(enemy, SUMMONER_2) == "SummonerSmite" or GetCastName(enemy, SUMMONER_1) == "S5_SummonerSmitePlayerGanker" or GetCastName(enemy, SUMMONER_2) == "S5_SummonerSmitePlayerGanker" or GetCastName(enemy, SUMMONER_1) == "S5_SummonerSmiteDuel" or GetCastName(enemy, SUMMONER_2) == "S5_SummonerSmiteDuel" then
							local junglerPos = WorldToScreen(0, GetOrigin(enemy))
							local myPos = WorldToScreen(1, GetOrigin(myHero))

							if GetDistance(myHero, enemy) > 2000 then

								DrawLine(myPos.x, myPos.y, junglerPos.x, junglerPos.y, 2, GoS.White)

							elseif GetDistance(myHero, enemy) < 2000 and GetDistance(myHero, enemy) > 1300 then

								DrawLine(myPos.x, myPos.y, junglerPos.x, junglerPos.y, 2, GoS.Yellow)

							elseif GetDistance(myHero, enemy) < 1300 then

								DrawLine(myPos.x, myPos.y, junglerPos.x, junglerPos.y, 2, GoS.Red)

							end
						end
					end
				end
			end
		end
	end

end)

--DRAW CIRCLE ON MINIMAP FOR ENEMY JUNGLER
OnDrawMinimap(function (myHero)
	if TristanaMenu.Drawings.Jungler:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if IsObjectAlive(enemy) then
				if IsVisible(enemy) then
					if GetCastName(enemy, SUMMONER_1) == "SummonerSmite" or GetCastName(enemy, SUMMONER_2) == "SummonerSmite" or GetCastName(enemy, SUMMONER_1) == "S5_SummonerSmitePlayerGanker" or GetCastName(enemy, SUMMONER_2) == "S5_SummonerSmitePlayerGanker" or GetCastName(enemy, SUMMONER_1) == "S5_SummonerSmiteDuel" or GetCastName(enemy, SUMMONER_2) == "S5_SummonerSmiteDuel" then
						DrawCircleMinimap(GetOrigin(enemy), 1500, 1, 8, GoS.Red)
					end
				end
			end
		end
	end
end)


print("[BNN Tristana] by ambanane Loaded!")

--[[USEFUL - TO DO NEXT

Jump away at max range from enemy with W

GetOrigin(myHero) + (GetOrigin(myHero)-GetOrigin(enemy)):normalized()*WRange




INSEC

CountObjectsOnLineSegment(startVector3D, endVector3D, width, objects)

]]--