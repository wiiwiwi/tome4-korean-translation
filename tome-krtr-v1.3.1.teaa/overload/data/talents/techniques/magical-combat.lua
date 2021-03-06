-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newTalent{
	name = "Arcane Combat",
	type = {"technique/magical-combat", 1},
	mode = "sustained",
	points = 5,
	require = techs_req1,
	sustain_stamina = 20,
	no_energy = true,
	cooldown = 5,
	tactical = { BUFF = 2 },
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t) * (1 + self:getCun(9, true)), 100, 20, 0, 70, 50) end, -- Limit < 100%
	do_trigger = function(self, t, target)
		if self.x == target.x and self.y == target.y then return nil end

		local chance = t.getChance(self, t)
		if self:hasShield() then chance = chance * 0.75
		elseif self:hasDualWeapon() then chance = chance * 0.5
		end

		if rng.percent(chance) then
			local spells = {}
			local fatigue = (100 + 2 * self:combatFatigue()) / 100
			local mana = self:getMana() - 1
			if self:knowTalent(self.T_FLAME) and not self:isTalentCoolingDown(self.T_FLAME)and mana > self:getTalentFromId(self.T_FLAME).mana * fatigue then spells[#spells+1] = self.T_FLAME end
			if self:knowTalent(self.T_LIGHTNING) and not self:isTalentCoolingDown(self.T_LIGHTNING)and mana > self:getTalentFromId(self.T_LIGHTNING).mana * fatigue then spells[#spells+1] = self.T_LIGHTNING end
			if self:knowTalent(self.T_EARTHEN_MISSILES) and not self:isTalentCoolingDown(self.T_EARTHEN_MISSILES)and mana > self:getTalentFromId(self.T_EARTHEN_MISSILES).mana * fatigue then spells[#spells+1] = self.T_EARTHEN_MISSILES end
			local tid = rng.table(spells)
			if tid then
				local l = self:lineFOV(target.x, target.y)
				l:set_corner_block()
				local lx, ly, is_corner_blocked = l:step(true)
				local target_x, target_y = lx, ly
				-- Check for terrain and friendly actors
				while lx and ly and not is_corner_blocked and core.fov.distance(self.x, self.y, lx, ly) <= 10 do
					local actor = game.level.map(lx, ly, engine.Map.ACTOR)
					if actor and (self:reactionToward(actor) >= 0) then
						break
					elseif game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
						target_x, target_y = lx, ly
						break
					end
					target_x, target_y = lx, ly
					lx, ly = l:step(true)
				end
				print("[ARCANE COMBAT] autocast ",self:getTalentFromId(tid).name)
				local old_cd = self:isTalentCoolingDown(self:getTalentFromId(tid))
				self:forceUseTalent(tid, {ignore_energy=true, force_target={x=target_x, y=target_y, __no_self=true}})
				-- Do not setup a cooldown
				if not old_cd then
					self.talents_cd[tid] = nil
				end
				self.changed = true
			end
		end
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[Allows you to use a melee weapon to focus your spells, granting a %d%% chance per melee attack to deliver a Flame, Lightning or Earthen Missiles spell as a free action on the target.
		When using a shield the chance is reduced by one fourth.
		When dual wielding or using a shield the chance is halved for each weapon.
		Delivering the spell this way will not trigger a spell cooldown, but only works if the spell is not cooling down.
		The chance increases with your Cunning.]]):
		format(t.getChance(self, t))
	end,
}

newTalent{
	name = "Arcane Cunning",
	type = {"technique/magical-combat", 2},
	mode = "passive",
	points = 5,
	require = techs_req2,
	-- called by _M:combatSpellpower in mod\class\interface\Combat.lua
	getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40, 0.75) end,
	info = function(self, t)
		return ([[The user gains a bonus to Spellpower equal to %d%% of their Cunning.]]):
		format(t.getSpellpower(self,t))
	end,
}

newTalent{
	name = "Arcane Feed",
	type = {"technique/magical-combat", 3},
	mode = "sustained",
	points = 5,
	cooldown = 5,
	sustain_stamina = 20,
	require = techs_req3,
	range = 10,
	tactical = { BUFF = 2 },
	getManaRegen = function(self, t) return self:combatTalentScale(t, 1/7, 5/7, 0.75) end,
	getCritChance = function(self, t) return self:combatTalentScale(t, 2.5, 11, 0.75) end,
	activate = function(self, t)
		local power = t.getManaRegen(self, t)
		local crit = t.getCritChance(self, t)
		return {
			regen = self:addTemporaryValue("mana_regen", power),
			pc = self:addTemporaryValue("combat_physcrit", crit),
			sc = self:addTemporaryValue("combat_spellcrit", crit),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("mana_regen", p.regen)
		self:removeTemporaryValue("combat_physcrit", p.pc)
		self:removeTemporaryValue("combat_spellcrit", p.sc)
		return true
	end,
	info = function(self, t)
		return ([[Regenerates %0.2f mana per turn, and increases physical and spell critical chance by %d%% while active.]]):format(t.getManaRegen(self, t), t.getCritChance(self, t))
	end,
}

newTalent{
	name = "Arcane Destruction",
	type = {"technique/magical-combat", 4},
	mode = "passive",
	points = 5,
	require = techs_req4,
	radius = function(self, t) return self:getTalentLevel(t) < 5 and 1 or 2 end,
	getDamMult = function(self, t) return self:combatTalentScale(t, 0.5, 1.1, 1) end,
	getSPMult = function(self, t) return self:combatTalentScale(t, 1/7, 5/7) end,
	info = function(self, t)
		return ([[Raw magical damage channels through the caster's weapon, increasing Physical Power by %d.
		Each time you crit with a melee blow, you will unleash a radius %d ball of either fire, lightning or arcane damage, doing %0.2f.
		The bonus scales with your Spellpower and talent level.
		If you are using a shield this will only occur 75%% of the time.
		If you are dual wielding this will only occur 50%% of the time.
		At level 5 the ball becomes radius 2.
		]]):
		format(self:combatSpellpower() * t.getSPMult(self, t), self:getTalentRadius(t), self:combatSpellpower() * 2 * t.getDamMult(self, t))
	end,
}

