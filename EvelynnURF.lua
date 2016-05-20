if GetObjectName(GetMyHero()) ~= "Evelynn" then return end

local EveMenu = Menu("Eve", "Evelynn")

EveMenu:SubMenu("Combo", "Combo")

EveMenu.Combo:Boolean("Q", "Use Q in combo", true)
EveMenu.Combo:Boolean("W", "Use W in combo", true)
EveMenu.Combo:Boolean("E", "Use E in combo", true)
EveMenu.Combo:Boolean("R", "Use R in combo", true)

EveMenu:SubMenu("Misc", "Misc")
EveMenu.Misc:Boolean("Level", "Auto level spells", true)
EveMenu.Misc:Boolean("Ghost", "Auto Ghost", true)

OnTick(function (myHero)

	local target = GetCurrentTarget()

	--AUTO LEVEL UP
	if EveMenu.Misc.Level:Value() then

			spellorder = {_Q, _W, _E, _Q, _W, _R, _Q, _W, _W, _Q, _R, _Q, _W, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end

	end

	--COMBO
	if IOW:Mode() == "Combo" then

		if EveMenu.Combo.Q:Value() and Ready(_Q) then
			CastSpell(_Q)
		end

		if EveMenu.Combo.W:Value() and Ready(_W) then
			CastSpell(_W)
		end

		if EveMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 225) then
			CastTargetSpell(target, _E)
		end

		if EveMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 650) then
			CastSkillShot(_R, target)
		end

	end

	if Ready(_W) then
		CastSpell(_W)
	end

	if EveMenu.Misc.Ghost:Value() then

		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end

	end

end)

print("Evelynn URF Edition by ambanane Loaded!")
