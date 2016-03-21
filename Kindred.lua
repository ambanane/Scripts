if GetObjectName(GetMyHero()) ~= "Kindred" then return end

require("Inspired")

local KindredMenu = Menu("Kindred", "Kindred")
KindredMenu:SubMenu("Combo", "Combo")
KindredMenu.Combo:Boolean("Q", "Use Q in combo", true)
KindredMenu.Combo:Boolean("W", "Use W in combo", true)
KindredMenu.Combo:Boolean("E", "Use E in combo", true)

KindredMenu:SubMenu("Killsteal", "Killsteal")
KindredMenu.Killsteal:Boolean("KQ", "Killsteal with Q", true)

KindredMenu:SubMenu("Misc", "Misc")
KindredMenu.Misc:Boolean("SelfR", "R on Yourself if HP < 20%", true)
KindredMenu.Misc:Boolean("AllyR", "R on Ally if HP < 20%", true)

KindredMenu:SubMenu("Draw", "Draw")
KindredMenu.Draw:Boolean("DrawQDash", "Draw Q Dash Range", true)
KindredMenu.Draw:Boolean("DrawQAttack", "Draw Q Attack Range", true)
KindredMenu.Draw:Boolean("DrawW", "Draw W Range", true)
KindredMenu.Draw:Boolean("DrawE", "Draw E Range", true)
KindredMenu.Draw:Boolean("DrawR", "Draw R Range", true)


OnTick(function (myHero)

	--[[
	Qdmg = 0
	Wdmg = 0
	Edmg = 0

	Qdmg = CalcDamage(myHero, target, 30 + 30 * GetCastLevel(myHero, _Q) + 0.2 * (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0)
	Wdmg = CalcDamage(myHero, target, 20 + 5 * GetCastLevel(myHero, _W) + 0.4 * (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0)
	Edmg = CalcDamage(myHero, target, 30 + 30 * GetCastLevel(myHero, _E) + 0.2 * (GetBaseDamage(myHero) + GetBonusDmg(myHero)) + GetCurrentHP(enemy) * 0.05, 0)
	]]--

	local target = GetCurrentTarget()

	if IOW:Mode() == "Combo" then

		if KindredMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 800) then
			CastSpell(_W)
		end

		if KindredMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 830) then
			CastSkillShot(_Q, target)
		end

		if KindredMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 500) then
			CastSkillShot(_Q, target)
		end

		if KindredMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 500) then
			CastTargetSpell(target, _E)
		end


	end

	for _, enemy in pairs(GetEnemyHeroes()) do

		if KindredMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, 830) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 30 + 30 * GetCastLevel(myHero, _Q) + 0.2 * (GetBaseDamage(myHero) + GetBonusDmg(myHero)), 0) then
				CastSkillShot(_Q, enemy)
			end
		end
	end

	for _, ally in pairs(GetAllyHeroes()) do
		
		if KindredMenu.Misc.SelfR:Value() and Ready(_R) and GetDistance(myHero, ClosestEnemy()) < 400 then
			if GetCurrentHP(myHero) < GetMaxHP(myHero) * 0.2 and Ready(_R) then
				CastTargetSpell(myHero, _R)
			end
		end

		if KindredMenu.Misc.AllyR:Value() and Ready(_R) and GetDistance(ally, myHero) < 400 and GetDistance(ally, ClosestEnemy()) < 400 then
			if GetCurrentHP(ally) < GetMaxHP(ally) * 0.2 and Ready(_R) then
				CastTargetSpell(ally, _R)
			end
		end
	end

end)

OnDraw(function (myHero)

		if KindredMenu.Draw.DrawQDash:Value() then
			DrawCircle(GetOrigin(myHero), 340, 0, 200, GoS.Yellow)
		end

		if KindredMenu.Draw.DrawQAttack:Value() then
			DrawCircle(GetOrigin(myHero), 500, 0, 200, GoS.Red)
		end

		if KindredMenu.Draw.DrawW:Value() then
			DrawCircle(GetOrigin(myHero), 800, 0, 200, GoS.White)
		end

		if KindredMenu.Draw.DrawE:Value() then
			DrawCircle(GetOrigin(myHero), 500, 0, 200, GoS.Blue)
		end

		if KindredMenu.Draw.DrawR:Value() then
			DrawCircle(GetOrigin(myHero), 500, 0, 200, GoS.Pink)
		end
	end)

print("Kindred by ambanane Loaded!")
