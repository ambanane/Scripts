if GetObjectName(GetMyHero()) ~= "MonkeyKing" then return end

require("Inspired")

if GetCastName(myHero,SUMMONER_1):lower() == "summonerdot" then
	Ignite = SUMMONER_1
elseif GetCastName(myHero,SUMMONER_2):lower() == "summonerdot" then
	Ignite = SUMMONER_2
end

local WukongMenu = Menu("Wukong", "Wukong")

WukongMenu:SubMenu("Combo", "Combo")
WukongMenu.Combo:Boolean("Q", "Use Q in combo", true)
WukongMenu.Combo:Boolean("W", "Use W in combo", true)
WukongMenu.Combo:Boolean("E", "Use E in combo", true)
WukongMenu.Combo:Boolean("R", "Use R in combo", false)

WukongMenu:SubMenu("ComboMode", "Combo Mode")
WukongMenu.ComboMode:Boolean("EQW", "EQW", true)
WukongMenu.ComboMode:Boolean("EWQ", "EWQ", false)

WukongMenu:SubMenu("Killsteal", "Killsteal")
WukongMenu.Killsteal:Boolean("KQ", "Killsteal with Q", true)
WukongMenu.Killsteal:Boolean("KE", "Killsteal with E", true)
WukongMenu.Killsteal:Boolean("KR", "Killsteal with R", true)

WukongMenu:SubMenu("LaneClear", "Lane Clear")
WukongMenu.LaneClear:Boolean("LCA", "Last Hit minions with Auto Attack", false)
WukongMenu.LaneClear:Boolean("LCQ", "Last Hit minions with Q", false)
WukongMenu.LaneClear:Boolean("LCE", "Last Hit minions with E", false)

WukongMenu:SubMenu("Misc", "Misc")
WukongMenu.Misc:Boolean("AW", "Auto W if life < 25%", true)
WukongMenu.Misc:Boolean("Ignite", "Use Ignite if killable", true)

WukongMenu:SubMenu("Drawings", "Drawings")
WukongMenu.Drawings:Boolean("DQ", "Draw Q Range", false)
WukongMenu.Drawings:Boolean("DW", "Draw W Range", false)
WukongMenu.Drawings:Boolean("DE", "Draw E Range", true)
WukongMenu.Drawings:Boolean("DR", "Draw R Range", false)

OnTick(function (myHero)

	local target = GetCurrentTarget()

	local MeleeRange = 175

	local QDmg = 0 + 30 * GetCastLevel(myHero, _Q) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)) * 0.1
	local QRange = 300

	local WDmg = 25 + 45 * GetCastLevel(myHero, _W) + GetBonusAP(myHero) * 0.6
	local WRange = 175

	local EDmg = 15 + 45 * GetCastLevel(myHero, _E) + GetBonusDmg(myHero) * 0.8
	local ERange = 625

	local RDmg = 0 + 90 * GetCastLevel(myHero, _R) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)) * 1.1
	local RRange = 162


	if IOW:Mode() == "Combo" then

		if WukongMenu.ComboMode.EQW:Value() then
			
			if WukongMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, ERange) then
				CastTargetSpell(target, _E)
			end

			if WukongMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, QRange) then
				CastSpell(_Q)
				if ValidTarget(target, QRange) then
					AttackUnit(target)
				end
			end

			if WukongMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, WRange) then
				CastSpell(_W)
			end
		end

		
		if WukongMenu.ComboMode.EWQ:Value() then
			
			if WukongMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, ERange) then
				CastTargetSpell(target, _E)
			end

			if WukongMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, WRange) then
				CastSpell(_W)
			end

			if WukongMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, QRange) then
				CastSpell(_Q)
				if ValidTarget(target, QRange) then
					AttackUnit(target)
				end
			end
		end

		if WukongMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, RRange) then
			CastSpell(_R)
		end

	end

	for _, enemy in pairs(GetEnemyHeroes()) do

		if WukongMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, QRange) then
			if CalcDamage(myHero, enemy, QDmg, 0) > GetCurrentHP(enemy) then
				CastSpell(_W)
				AttackUnit(enemy)
			end
		end

		if WukongMenu.Killsteal.KE:Value() and Ready(_E) and ValidTarget(enemy, ERange) then
			if CalcDamage(myHero, enemy, EDmg, 0) > GetCurrentHP(enemy) then
				CastTargetSpell(enemy, _E)
			end
		end

		if WukongMenu.Killsteal.KR:Value() and Ready(_R) and ValidTarget(enemy, RRange) then
			if CalcDamage(myHero, enemy, RDmg, 0) > GetCurrentHP(enemy) then
				CastSpell(_R)
			end
		end

		if WukongMenu.Misc.Ignite:Value() and ValidTarget(enemy, 600) then
			if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
				if Ignite then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end
	end

	if WukongMenu.Misc.AW:Value() and Ready(_W) and GetDistance(myHero, ClosestEnemy()) < 750 then
		if GetCurrentHP(myHero) < GetMaxHP(myHero) * 0.25 then
			CastSpell(_W)
		end
	end

	for _, minion in pairs(minionManager.objects) do
		if WukongMenu.LaneClear.LCA:Value() and ValidTarget(minion, MeleeRange) and GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
			AttackUnit(minion)
		end

		if WukongMenu.LaneClear.LCQ:Value() and Ready(_Q) and ValidTarget(minion, QRange) and GetCurrentHP(minion) < QDmg then
			CastSpell(_Q)
			AttackUnit(minion)
		end

		if WukongMenu.LaneClear.LCE:Value() and Ready(_E) and ValidTarget(minion, ERange) and GetCurrentHP(minion) < EDmg then
			CastTargetSpell(minion, _E)
		end
	end
end)

OnDraw(function (myHero)

	local QDDmg = 0 + 30 * GetCastLevel(myHero, _Q) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)) * 0.1
	local EDDmg = 15 + 45 * GetCastLevel(myHero, _E) + GetBonusDmg(myHero) * 0.8
	local RDDmg = 0 + 90 * GetCastLevel(myHero, _R) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)) * 1.1

	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			    local enemyPos = GetOrigin(enemy)
			    local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)

			    if WukongMenu.Combo.Q:Value() and WukongMenu.Combo.E:Value() and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, QDDmg + EDDmg, 0) then
			    	DrawText("E+Q=Kill", 12, drawpos.x-60, drawpos.y, GoS.White)
			    else
			    	DrawText("Not killable", 12, drawpos.x-60, drawpos.y, GoS.White)
			    end

		end
	end

	if WukongMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 300, 0, 200, GoS.Red)
	end

	if WukongMenu.Drawings.DW:Value() then
		DrawCircle(GetOrigin(myHero), 175, 0, 200, GoS.Yellow)
	end

	if WukongMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 625, 0, 200, GoS.Pink)
	end

	if WukongMenu.Drawings.DR:Value() then
		DrawCircle(GetOrigin(myHero), 162, 0, 200, GoS.Green)
	end

end)

print("Wukong by ambanane Loaded!")
