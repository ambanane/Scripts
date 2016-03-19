if GetObjectName(GetMyHero()) ~= "Pantheon" then return end

require("Inspired")

local PantheonMenu = Menu("Pantheon", "Pantheon")
PantheonMenu:SubMenu("Combo", "Combo")
PantheonMenu.Combo:Boolean("Q", "Use Q in combo", true)
PantheonMenu.Combo:Boolean("AQ", "Auto Q if enemy in range", true)
PantheonMenu.Combo:Boolean("W", "Use W in combo", true)
PantheonMenu.Combo:Boolean("E", "Use E in combo", true)

PantheonMenu:SubMenu("Killsteal", "Killsteal")
PantheonMenu.Killsteal:Boolean("KQ", "Killsteal with Q", true)

PantheonMenu:SubMenu("Draw", "Draw")
PantheonMenu.Draw:Boolean("DrawQ", "Draw QWE range", true)


OnTick(function (myHero)

	local target = GetCurrentTarget()

	if IOW:Mode() == "Combo" then

		if PantheonMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 600) then
			CastTargetSpell(target, _Q)
		end

		if PantheonMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) then
			CastTargetSpell(target, _W)
		end

		if PantheonMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 600) then
			targetPos = GetOrigin(target)
			CastSkillShot(_E, targetPos)
		end
	end

	if PantheonMenu.Combo.AQ:Value() and Ready(_Q) and ValidTarget(target, 600) then
		CastTargetSpell(target, _Q)
	end
	for _, enemy in pairs(GetEnemyHeroes()) do
		if PantheonMenu.Combo.Q:Value() and PantheonMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, 600) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 25 + 40 * GetCastLevel(myHero, _Q) + GetBonusDmg(myHero) * 1.4, 0) then
				CastTargetSpell(enemy, _Q)
			end
		end
	end
end)

	OnDraw(function(myHero)
		if PantheonMenu.Draw.DrawQ:Value() then
			DrawCircle(GetOrigin(myHero), 600, 1, 25, GoS.Red)
		end
	end)

	


print("Pantheon loaded")