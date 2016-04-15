if GetObjectName(GetMyHero()) ~= "Nasus" then return end


if GetCastName(myHero,SUMMONER_1):lower() == "summonerdot" then
	Ignite = SUMMONER_1
elseif GetCastName(myHero,SUMMONER_2):lower() == "summonerdot" then
	Ignite = SUMMONER_2
else
	print("Auto Ignite not available!")
end

local NasusMenu = Menu("Nasus", "Nasus")

NasusMenu:SubMenu("Combo", "Combo")
NasusMenu.Combo:Boolean("Q", "Use Q in combo", true)
NasusMenu.Combo:Boolean("W", "Use W in combo", true)
NasusMenu.Combo:Boolean("E", "Use E in combo", true)

NasusMenu:SubMenu("Killsteal", "Killsteal")
NasusMenu.Killsteal:Boolean("KQ", "Killsteal with Q", true)
NasusMenu.Killsteal:Boolean("KE", "Killsteal with E", true)

NasusMenu:SubMenu("LaneClear", "Lane Clear")
NasusMenu.LaneClear:Boolean("LQ", "Last hit minions with Q", true)
NasusMenu.LaneClear:Boolean("LE", "Last hit minions with E", false)

NasusMenu:SubMenu("Misc", "Misc")
NasusMenu.Misc:Boolean("AR", "Auto R if HP < 25%", true)
NasusMenu.Misc:Boolean("Ignite", "Ignite if killable", true)

NasusMenu:SubMenu("Drawings", "Drawings")
NasusMenu.Drawings:Boolean("DW", "Draw W Range", false)
NasusMenu.Drawings:Boolean("DE", "Draw E Range", true)

OnTick(function (myHero)

	local target = GetCurrentTarget()
	local BaseHPHero = GetMaxHP(myHero)
	local CurrentHPHero = GetCurrentHP(myHero)
	local BaseHPTarget = GetMaxHP(target)
	local CurrentHPTarget = GetCurrentHP(target)
	local MeleeRange = 125
	local BaseAD = GetBaseDamage(myHero)
	local BonusAD = GetBonusDmg(myHero)
	local BonusAP = GetBonusAP(myHero)
	local BuffData = GetBuffData(myHero, "NasusQStacks")
	local BuffStacks = BuffData.Stacks
	local QDmg = 10 + 20 * GetCastLevel(myHero, _Q) + BaseAD + BonusAD + BuffStacks
	local QRange = 500
	local WRange = 600
	local EDmg = 15 * GetCastLevel(myHero, _E) + BonusAP * 0.6
	local ERange = 650

	if IOW:Mode() == "Combo" then

		--Combo
		if NasusMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, QRange) then
			CastSpell(_Q)
			AttackUnit(target)
		end

		if NasusMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, ERange) then
			CastSkillShot(_E, target)
		end

		if NasusMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, WRange) then
			CastTargetSpell(target, _W)
		end

	end

	--Killsteal
	for _, enemy in pairs(GetEnemyHeroes()) do
		if NasusMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, QRange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, QDmg, 0) then
				if Ready(_W) then
					CastTargetSpell(enemy, _W)
				end
				CastSpell(_Q)
				AttackUnit(enemy)
			end
		end

		if NasusMenu.Killsteal.KE:Value() and Ready(_E) and ValidTarget(enemy, ERange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, EDmg) then
				CastSkillShot(_E, enemy)
			end
		end

		if NasusMenu.Misc.Ignite:Value() and ValidTarget(enemy, 600) then
			if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
				CastTargetSpell(enemy, Ignite)
			end
		end
	end

	--Auto R
	if NasusMenu.Misc.AR:Value() and Ready(_R) and GetDistance(myHero, ClosestEnemy()) < 750 then
		if CurrentHPHero < BaseHPHero * 0.25 then
			CastSpell(_R)
		end
	end

	--Auto Q on minions
	for _, minion in pairs(minionManager.objects) do
		if NasusMenu.LaneClear.LQ:Value() and Ready(_Q) and ValidTarget(minion, QRange) and GetCurrentHP(minion) < QDmg then
			CastSpell(_Q)
			AttackUnit(minion)
		end

		if NasusMenu.LaneClear.LE:Value() and Ready(_E) and ValidTarget(minion, ERange) and GetCurrentHP(minion) < EDmg then
			CastSkillShot(_E, GetOrigin(minion))
		end
	end


end)

OnDraw(function (myHero)

	local target = GetCurrentTarget()
	local BaseHPHero = GetMaxHP(myHero)
	local CurrentHPHero = GetCurrentHP(myHero)
	local BaseHPTarget = GetMaxHP(target)
	local CurrentHPTarget = GetCurrentHP(target)
	local MeleeRange = 125
	local BaseAD = GetBaseDamage(myHero)
	local BonusAD = GetBonusDmg(myHero)
	local BonusAP = GetBonusAP(myHero)
	local BuffData = GetBuffData(myHero, "NasusQStacks")
	local BuffStacks = BuffData.Stacks
	local QDmg = 10 + 20 * GetCastLevel(myHero, _Q) + BaseAD + BonusAD + BuffStacks
	local QRange = 500
	local WRange = 600
	local EDmg = 15 * GetCastLevel(myHero, _E) + BonusAP * 0.6
	local ERange = 650

	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			    local enemyPos = GetOrigin(enemy)
			    local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)

			    if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, QDmg, 0) then
			    	DrawText("Killable with Q!", 12, drawpos.x-60, drawpos.y, GoS.White)
			    else
			    	DrawText("Not killable", 12, drawpos.x-60, drawpos.y, GoS.White)
			    end

		end
	end

	if NasusMenu.Drawings.DW:Value() then
		DrawCircle(GetOrigin(myHero), WRange, 0, 200, GoS.Red)
	end

	if NasusMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), ERange, 0, 200, GoS.Yellow)
	end

end)

print("Nasus by ambanane Loaded!")
