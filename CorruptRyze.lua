if GetObjectName(GetMyHero()) ~= "Ryze" then return end

local ver = "0.1"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/ambanane/Scripts/master/CorruptRyze.lua', SCRIPT_PATH .. 'CorruptRyze.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync('https://raw.githubusercontent.com/ambanane/Scripts/master/CorruptRyze.version', AutoUpdate)

--MENU
local RyzeMenu = Menu('Ryze', 'Corrupt Ryze')

RyzeMenu:SubMenu('Combo', 'Combo')
RyzeMenu.Combo:Boolean('Q', 'Use Q', true)
RyzeMenu.Combo:Boolean('W', 'Use W', true)
RyzeMenu.Combo:Boolean('E', 'Use E', true)
RyzeMenu.Combo:Boolean('R', 'Use R', true)

RyzeMenu:SubMenu('Killsteal', 'Killsteal')
RyzeMenu.Killsteal:Boolean('KQ', 'Killsteal with Q', true)
RyzeMenu.Killsteal:Boolean('KW', 'Killsteal with W', true)
RyzeMenu.Killsteal:Boolean('KE', 'Killsteal with E', true)

RyzeMenu:SubMenu('Farm', 'Farm')
RyzeMenu.Farm:Boolean('LH', 'Last hit minions AA', false)
RyzeMenu.Farm:Boolean('LHQ', 'Last hit Q big minions', false)
RyzeMenu.Farm:Slider('MQ', 'If mana % is higher than', 50, 10, 100, 5)
RyzeMenu.Farm:Boolean('LHW', 'Last hit W big minions', false)
RyzeMenu.Farm:Slider('MW', 'If mana % is higher than', 50, 10, 100, 5)

RyzeMenu:SubMenu('Misc', 'Misc')
RyzeMenu.Misc:Boolean('Ignite', 'Ignite if killable', true)
RyzeMenu.Misc:Boolean('Level', 'Auto level', true)
RyzeMenu.Misc:Boolean('JT', 'Enemy jungler tracker', true)
RyzeMenu.Misc:Boolean('AW', 'Auto W on gap close', true)
RyzeMenu.Misc:SubMenu('Skin', 'Skin Changer')
RyzeMenu.Misc.Skin:Slider('SC', 'Select skin', 1, 1, 11)

RyzeMenu:SubMenu('Drawings', 'Drawings')
RyzeMenu.Drawings:Boolean('DQ', 'Draw Q range', true)
RyzeMenu.Drawings:Boolean('DWE', 'Draw W&E range', true)
RyzeMenu.Drawings:Boolean('DS', 'Draw passive stacks', true)
RyzeMenu.Drawings:Boolean('DCM', 'Draw circle on minions', true)
RyzeMenu.Drawings:Boolean('SF', 'Draw if slower or faster', true)
RyzeMenu.Drawings:Boolean('CT', 'Draw circle on curent target', true)

OnTick(function (myHero)

	--VARIABLES
	local stacksData = GetBuffData(myHero, 'RyzePassiveStack')
	local passiveData = GetBuffData(myHero, 'RyzePassiveCharged')
	local Stacks = stacksData.Count
	local Passive = passiveData.Count
	local target = GetCurrentTarget()
	local MaxMana = GetMaxMana(myHero)
	local MaxHP = GetMaxHP(myHero)
	local CurrentHP = GetCurrentHP(myHero)
	local BaseAD = GetBaseDamage(myHero)
	local BonusAD = GetBonusDmg(myHero)
	local BonusAP = GetBonusAP(myHero)
	local MeleeRange = 550
	local QRange = 900
	local WRange = 600
	local ERange = 600
	local QDmg = 25 + 35 * GetCastLevel(myHero, _Q) + BonusAP * 0.55 + (1.5 + 0.5 * GetCastLevel(myHero, _Q) / 100 * MaxMana)
	local WDmg = 60 + 20 * GetCastLevel(myHero, _W) + BonusAP * 0.4 + MaxMana * 0.025
	local EDmg = 20 + 16 * GetCastLevel(myHero, _E) + BonusAP * 0.2 + MaxMana * 0.02
	local QPredTarget = GetPredictionForPlayer(myHeroPos(), target, GetMoveSpeed(target), 1700, 250, 900, 50, false, true)
	local BigMinionBlue = 'SRU_OrderMinionSiege'
	local BigMinionRed = 'SRU_ChaosMinionSiege'
	local SuperMinionBlue = 'SRU_OrderMinionSuper'
	local SuperMinionRed = 'SRU_ChaosMinionSuper'

	function ComboQ()
		if RyzeMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, QRange) then
			if QPredTarget.HitChance == 1 then
				CastSkillShot(_Q, QPredTarget.PredPos)
			end
		end
	end

	function ComboW()
		if RyzeMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, WRange) then
			CastTargetSpell(target, W)
		end
	end

	function ComboE()
		if RyzeMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, ERange) then
			CastTargetSpell(target, _E)
		end
	end

	function ComboR()
		if RyzeMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, QRange) then
			CastSpell(_R)
		end
	end

	function ComboStacks0()
		if Stacks == 0 then
			ComboQ()
			ComboW()
			ComboE()
		end
	end

	function ComboStacks1()
		if Stacks == 1 then
			ComboQ()
			ComboW()
			ComboE()
		end
	end

	function ComboStacks2()
		if Stacks == 2 then
			ComboQ()
			ComboE()
			ComboW()
			ComboQ()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
		end
	end

	function ComboStacks3()
		if Stacks == 3 then
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
		end
	end

	function ComboStacks4()
		if Stacks == 4 then
			ComboR()
			ComboW()
			ComboQ()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
		end
	end

	function ComboStacks5()
		if Stacks == 5 then
			ComboQ()
			ComboW()
			ComboE()
		end
	end

	function ComboStacks1Ult()
		if Stacks == 1 then
			ComboR()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
		end
	end

	function ComboStacks2Ult()
		if Stacks == 2 then
			ComboR()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
		end
	end

	function ComboStacks3Ult()
		if Stacks == 3 then
			ComboR()
			ComboW()
			ComboQ()
			ComboE()
			ComboQ()
			ComboW()
			ComboQ()
			ComboE()
		end
	end

	--COMBO
	if IOW:Mode() == 'Combo' then

		if GetLevel(myHero) < 6 then

			ComboStacks0()
			ComboStacks1()
			ComboStacks2()
			ComboStacks3()
			ComboStacks4()

		else

			ComboStacks0()
			ComboStacks1Ult()
			ComboStacks2Ult()
			ComboStacks3Ult()
			ComboStacks4()

		end


	else

		--LAST HIT MINIONS W
		if RyzeMenu.Farm.LHW:Value() then
			if GetCurrentMana(myHero) > GetMaxMana(myHero) * RyzeMenu.Farm.MW:Value() / 100 then
				if not UnderTurret(GetOrigin(myHero), enemyTurret) then
					if IsObjectAlive(myHero) then
						for _, minion in pairs(minionManager.objects) do
							if ValidTarget(minion, WRange) and GetCurrentHP(minion) < WDmg then

								if GetTeam(myHero) == 100 then

									if GetObjectName(minion) == SuperMinionRed then
										if Ready(_Q) then
											CastSkillShot(_Q, minion)
										end
									end

									if GetObjectName(minion) == BigMinionRed then
										if Ready(_W) then
											CastTargetSpell(minion, _W)
										end
									end

								end

								if GetTeam(myHero) == 200 then

									if GetObjectName(minion) == SuperMinionBlue then
										if Ready(_W) then
											CastTargetSpell(minion, _W)
										end
									end

									if GetObjectName(minion) == BigMinionBlue then
										if Ready(_W) then
											CastTargetSpell(minion, _W)
										end
									end

								end

							end
						end
					end
				end
			end
		end

		--LAST HIT MINIONS Q
		if RyzeMenu.Farm.LHQ:Value() then
			if GetCurrentMana(myHero) > GetMaxMana(myHero) * RyzeMenu.Farm.MQ:Value() / 100 then
				if not UnderTurret(GetOrigin(myHero), enemyTurret) then
					if IsObjectAlive(myHero) then

						for _, minion in pairs(minionManager.objects) do

							if ValidTarget(minion, QRange) and GetCurrentHP(minion) < QDmg then
								if GetTeam(myHero) == 100 then
									if GetObjectName(minion) == BigMinionRed then
										if Ready(_Q) then
											CastSkillShot(_Q, minion)
										end
									end
								end

								if GetTeam(myHero) == 200 then
									if GetObjectName(minion) == BigMinionBlue then
										if Ready(_Q) then
											CastSkillShot(_Q, minion)
										end
									end
								end

							end
						end

					end
				end
			end
		end

		--LAST HIT MINIONS AA
		if not UnderTurret(GetOrigin(myHero), enemyTurret) then
			if RyzeMenu.Farm.LH:Value() then
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

		local QPredEnemy = GetPredictionForPlayer(myHeroPos(), enemy, GetMoveSpeed(enemy), 1700, 250, 900, 50, true, true)
		
		if RyzeMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, QRange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) then
				if QPredEnemy.HitChance == 1 then
					CastSkillShot(_Q, QPredEnemy.PredPos)
				end
			end
		end

		if RyzeMenu.Killsteal.KW:Value() and Ready(_W) and ValidTarget(enemy, WRange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) then
				CastTargetSpell(enemy, _W)
			end
		end

		if RyzeMenu.Killsteal.KE:Value() and Ready(_E) and ValidTarget(enemy, ERange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, EDmg) then
				CastTargetSpell(enemy, _E)
			end
		end

	end

	--AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			local Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			local Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

	--AUTO LEVEL
	if RyzeMenu.Misc.Level:Value() then
		spellorder = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
		if GetLevelPoints(myHero) > 0 then
			LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
		end
	end

	--AUTO W ON GAP CLOSER
	if RyzeMenu.Misc.AW:Value() then
		if IsObjectAlive(myHero) then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if IsObjectAlive(enemy) then
					if Ready(_W) then
						if GetDistance(myHero, enemy) < 200 then
							CastTargetSpell(enemy, _W)
						end
					end
				end
			end
		end
	end

end)

OnDraw(function (myHero)

	--SKIN CHANGER
	HeroSkinChanger(myHero, RyzeMenu.Misc.Skin.SC:Value() - 1)

	--VARIABLES
	local myPos = myHero
	local drawPos = WorldToScreen(1, myPos.x, myPos.y, myPos.z)
	local stacksData = GetBuffData(myHero, 'RyzePassiveStack')
	local passiveData = GetBuffData(myHero, 'RyzePassiveCharged')
	local Stacks = stacksData.Count
	local Passive = passiveData.Count
	local target = GetCurrentTarget()
	local MaxMana = GetMaxMana(myHero)
	local MaxHP = GetMaxHP(myHero)
	local CurrentHP = GetCurrentHP(myHero)
	local BaseAD = GetBaseDamage(myHero)
	local BonusAD = GetBonusDmg(myHero)
	local BonusAP = GetBonusAP(myHero)
	local MeleeRange = 550
	local QRange = 900
	local WRange = 600
	local ERange = 600
	local QDmg = 25 + 35 * GetCastLevel(myHero, _Q) + BonusAP * 0.55 + (1.5 + 0.5 * GetCastLevel(myHero, _Q) / 100 * MaxMana)
	local WDmg = 60 + 20 * GetCastLevel(myHero, _W) + BonusAP * 0.4 + MaxMana * 0.025
	local EDmg = 20 + 16 * GetCastLevel(myHero, _E) + BonusAP * 0.2 + MaxMana * 0.02
	local QPredTarget = GetPredictionForPlayer(myHeroPos(), target, GetMoveSpeed(target), 1700, 250, 900, 50, false, true)

	--STACKS DRAWING
	if RyzeMenu.Drawings.DS:Value() then
		if IsObjectAlive(myHero) then		
			DrawText('Stacks: ' .. Stacks, 16, drawPos.x, drawPos.y, GoS.White)
		end
	end

	--CURRENT TARGET CIRCLE
	if RyzeMenu.Drawings.CT:Value() then
		if IsObjectAlive(myHero) then
			DrawCircle(GetOrigin(target), 100, 5, 8, ARGB(100, 255, 0, 255))
		end
	end

	--JUNGLER TRACKER
	if RyzeMenu.Misc.JT:Value() then
		if IsObjectAlive(myHero) then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if IsObjectAlive(enemy) then
					if IsVisible(enemy) then
						if GetCastName(enemy, SUMMONER_1) == 'SummonerSmite' or GetCastName(enemy, SUMMONER_2) == 'SummonerSmite' or GetCastName(enemy, SUMMONER_1) == 'S5_SummonerSmitePlayerGanker' or GetCastName(enemy, SUMMONER_2) == 'S5_SummonerSmitePlayerGanker' or GetCastName(enemy, SUMMONER_1) == 'S5_SummonerSmiteDuel' or GetCastName(enemy, SUMMONER_2) == 'S5_SummonerSmiteDuel' then
							local junglerPos = WorldToScreen(0, GetOrigin(enemy))
							local myPos = WorldToScreen(1, GetOrigin(myHero))

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

	if IsObjectAlive(myHero) then

		--Q RANGE
		if RyzeMenu.Drawings.DQ:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), QRange, 5, 100, ARGB(100, 255, 0, 255))
			else
				DrawCircle(GetOrigin(myHero), QRange, 5, 100, ARGB(100, 255, 0, 0))
			end
		end

		--W&E Range
		if RyzeMenu.Drawings.DWE:Value() then
			if Ready(_W) or Ready(_E) then
				DrawCircle(GetOrigin(myHero), WRange, 5, 100, ARGB(100, 0, 150, 150))
			else
				DrawCircle(GetOrigin(myHero), WRange, 5, 100, ARGB(100, 255, 0, 0))
			end
		end

	end

	--DRAW ON ENEMY
	for _, enemy in pairs(GetEnemyHeroes()) do

		if ValidTarget(enemy) then

			--DRAW IF KILLABLE
			local enemyPos = GetOrigin(enemy)
			local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)

			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) and Ready(_Q) then

				DrawText('Q', 13, drawpos.x-60, drawpos.y, GoS.Green)
			
			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) and Ready(_W) then

				DrawText('W', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, EDmg) and Ready(_E) then

				DrawText('E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg) and Ready(_Q) and Ready(_W) then

				DrawText('Q + W', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, EDmg) and Ready(_Q) and Ready(_E) then

				DrawText('Q + E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg) and Ready(_W) and Ready(_E) then

				DrawText('W + E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg) and Ready(_Q) and Ready(_W) and Ready(_E) then

				DrawText('Q + W + E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			end

			--DRAW DMG ON HP BAR
			if Ready(_Q) and Ready(_W) and Ready(_E) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)

			elseif Ready(_Q) and Ready(_W) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg), GoS.Cyan)

			elseif Ready(_Q) and Ready(_E) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)

			elseif Ready(_W) and Ready(_E) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)

			elseif Ready(_Q) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), GoS.Cyan)

			elseif Ready(_W) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), GoS.Cyan)

			elseif Ready(_E) then

				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)
			
			end

			--DRAW IF FASTER OR SLOWER
			if RyzeMenu.Drawings.SF:Value() then
				if IsObjectAlive(myHero) then
					if GetMoveSpeed(myHero) < GetMoveSpeed(enemy) then
						DrawText('Slower', 13, drawpos.x, drawpos.y, GoS.Red)
					else
						DrawText('Faster', 13, drawpos.x, drawpos.y, GoS.Green)
					end
				end
			end

		end

	end

	--DRAW CIRCLE ON MINIONS
	if RyzeMenu.Drawings.DCM:Value() then
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

end)

--DRAW ENEMY JUNGLER ON MINIMAP
OnDrawMinimap(function (myHero)
	if RyzeMenu.Misc.JT:Value() then
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

print('<font color = "#00FFFF"><b>[Corrupt Ryze]</b> <font color = "#FFFFFF">by ambanane Loaded!')
print('<font color = "#FFFFFF">->Please select <font color = "#FF0000"><b>IOW</b><font color = "#FFFFFF"> Orbwalker!')
print('Test')
