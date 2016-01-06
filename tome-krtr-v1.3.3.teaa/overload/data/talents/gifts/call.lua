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
 	name = "Meditation",
+	kr_name = "명상",
 	type = {"wild-gift/call", 1},
 	require = gifts_req1,
 	points = 5,
-	message = "@Source@ meditates on nature.",
+	message = "@Source1@ 자연 위에서 명상합니다.",
 	mode = "sustained",
 	cooldown = 20,
 	range = 10,
 @@ -66,17 +67,18 @@ newTalent{
 		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
 		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost
 		local rest = 0.5 * self:getTalentLevelRaw(t)
-		return ([[Meditate on your link with Nature.
-		While meditating, you regenerate %d equilibrium per turn, your Mental Save is increased by %d, and your healing factor increases by %d%%.
-		Your deep meditation does not, however, let you deal damage correctly, reducing your damage done by 50%%.
-		Also, any time you are resting (even with Meditation not sustained) you enter a simple meditative state that lets you regenerate %0.2f equilibrium per turn.
-		The effects will increase with your Mindpower.]]):
+		return ([[자연을 느끼며 명상에 빠집니다.
+		명상 중에는 매 턴마다 %d 만큼의 평정을 찾으며, 정신 내성이 %d 증가하고 회복 효율이 %d%% 상승합니다.
+		하지만 명상에 지나치게 빠지게 되어, 적에게 주는 피해량이 50%% 감소하게 됩니다.
+		명상 상태가 아니더라도, 휴식할 때 가볍게 명상하여 매 턴마다 %0.2f 만큼의 평정을 찾게 됩니다.
+		이 효과는 정신력의 영향을 받아 증가합니다.]]):
 		format(pt, save, heal, rest)
 	end,
 }
 
 newTalent{ short_name = "NATURE_TOUCH",
 	name = "Nature's Touch",
+	kr_name = "자연의 손길",
 	type = {"wild-gift/call", 2},
 	require = gifts_req2,
 	random_ego = "defensive",
 @@ -105,14 +107,15 @@ newTalent{ short_name = "NATURE_TOUCH",
 		return true
 	end,
 	info = function(self, t)
-		return ([[Touch a target (or yourself) to infuse it with Nature, healing it for %d (this heal does not work on undead).
-		The amount healed will increase with your Mindpower.]]):
+		return ([[대상 (혹은 자신) 에게 자연의 힘을 불어넣어, %d 생명력을 회복시킵니다. 언데드에게는 사용할 수 없습니다.
+		생명력 회복량은 정신력의 영향을 받아 증가합니다.]]):
 		format(20 + self:combatTalentMindDamage(t, 20, 500))
 	end,
 }
 
 newTalent{
 	name = "Earth's Eyes",
+	kr_name = "대지의 눈",
 	type = {"wild-gift/call", 3},
 	require = gifts_req3,
 	points = 5,
 @@ -131,14 +134,15 @@ newTalent{
 	info = function(self, t)
 		local radius = self:getTalentRadius(t)
 		local radius_esp = t.radius_esp(self, t)
-		return ([[Using your connection to Nature, you can see your surrounding area in a radius of %d.
-		Also, while meditating, you are able to detect the presence of creatures around you in a radius of %d.]]):
+		return ([[자신과 자연 사이의 연결고리를 통해, 주변 %d 칸 반경의 지형을 볼 수 있게 됩니다.
+		그리고 명상 기술을 사용할 때, 주변 %d 칸 반경에 있는 적들의 위치를 감지하는 능력이 추가됩니다.]]):
 		format(radius, radius_esp)
 	end,
 }
 
 newTalent{
 	name = "Nature's Balance",
+	kr_name = "자연의 균형",
 	type = {"wild-gift/call", 4},
 	require = gifts_req4,
 	points = 5,
 @@ -171,7 +175,8 @@ newTalent{
 		return true
 	end,
 	info = function(self, t)
-		return ([[Your deep link with Nature allows you to reset the cooldown of %d of your wild gifts of tier %d or less.]]):
+		return ([[자연과의 깊은 연결을 통해, 자연의 권능 계통 기술의 재사용 대기시간을 초기화시킵니다.
+		%d 단계 이하의 무작위한 기술 %d 개에 적용됩니다.]]):
 		format(t.getTalentCount(self, t), t.getMaxLevel(self, t))
 	end,
 }
