-- Copyright (c) 2024 Khejanin
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See the GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <https://www.gnu.org/licenses/>

local success, hooksCore = pcall(require, "Mods\\PHooksCore\\Scripts\\main")

NotifyOnNewObject("/Game/Pal/Blueprint/Character/Monster/BP_MonsterBase.BP_MonsterBase_C", function(Pal)
    DoAllMods(function (Mod)
        local PHPalSpawn = Mod.PHPalSpawn
        if PHPalSpawn:IsValid() then
            Mod:PHPalSpawn(Pal)
        end
    end)
end)

RegisterHook("/Game/Pal/Blueprint/Weapon/Other/NewPalSphere/BP_PalSphere_Body.BP_PalSphere_Body_C:CaptureSuccessEvent", function(self)
    DoAllMods(function (Mod)
        local PHPalCaptureSuccess = Mod.PHPalCaptureSuccess
        if PHPalCaptureSuccess:IsValid() then
            Mod:PHPalCaptureSuccess()
        end
    end)
end)

--RegisterHook("/Game/Pal/Blueprint/Weapon/Other/NewPalSphere/BP_PalSphere_Body.BP_PalSphere_Body_C:PlayCaptureEffectEvent", function(self)
--    DoAllMods(function (Mod)
--        local PHPalCaptured = Mod.PHPalCaptured
--        if PHPalCaptured:IsValid() then
--            Mod:PHPalCaptured()
--        end
--    end)
--end)