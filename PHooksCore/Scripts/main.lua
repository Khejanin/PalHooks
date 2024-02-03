-- Copyright (c) 2024 Khejanin
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See the GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <https://www.gnu.org/licenses/>

-- This file tries to keep track of all ModActor Instances loaded by BPModLoaderMod
-- in order to expose functionality to other lua scripts to invoke callbacks for all mods.

-- Relative file structure:
-- require searches for:
-- Palworld\Pal\Binaries\Win64\?.lua;
-- actual path:
-- Palworld\Pal\Binaries\Win64\Mods\BPModLoaderMod\Scripts
local success, bpModLoader = pcall(require, "Mods\\BPModLoaderMod\\Scripts\\main")

ModActors = {}

function string:contains(sub)
    return self:find(sub, 1, true) ~= nil
end

function FetchAllMods()
    print("Retrieving Mod Actors...")
    local all_mods = FindAllOf("ModActor_C")
    if all_mods == nil then
        return
    end

    for index, Mod in pairs(all_mods) do
        AddMod(Mod)
    end
end

function ListenToMods()
    print("-- Listening to Mods --")
    for ModName, ModInfo in pairs(Mods) do
        local fp = ModInfo.AssetPath .. ".ModActor_C";
        print("Listening to Mod: " .. fp)
        NotifyOnNewObject(fp, function(new_mod)
            AddMod(new_mod)
        end)
    end
end

function AddMod(new_mod)
    if not TestMod(new_mod) then
        print("Mod did not pass the vibe check")
        return false
    else
        print("Adding Mod")
        TestModVerbose(new_mod)
    end

    local modpkg = GetPackageOfMod(new_mod)
    print(modpkg)
    if ModActors[modpkg] then
        if ModActors[modpkg] == new_mod then
            print("Warning: Mod instance already in Table : " .. modpkg)
        else
            print("Mod instance replaced for class: " .. modpkg)
            ModActors[modpkg] = new_mod
        end
    else
        ModActors[modpkg] = new_mod
    end
    return true
end

function GetPackageOfMod(mod_actor)
    for index, ModInfo in pairs(Mods) do
        local fp = ModInfo.AssetPath .. ".ModActor_C"
        print(fp)
        if mod_actor:IsA(fp) then
            return fp
        end
    end
    return nil
end

function DoAllMods(cb)
    if ModActors ~= nil then
         for index, Mod in pairs(ModActors) do
             if Mod ~= nil then
                 cb(Mod)
             end
         end
    else
        print("ModActors is nil!")
    end
end

RegisterInitGameStatePostHook(function(ContextParam)
    FetchAllMods()
end)

function TestMod(o)
    if o ~= nil then
        if o:IsValid() then
            if o:GetFName():ToString():contains("ModActor_C") then
                return true
            end
        end
    end
    return false
end

function TestModVerbose(o)
    if o ~= nil then
        if o:IsValid() then
            print("FullName: " .. o:GetFullName())
            print("FName: " .. o:GetFName():ToString())
            print("IsUObject():" ..  tostring(o:IsA("/Script/CoreUObject.Object")))
            print("IsActor():" ..  tostring(o:IsA("/Script/Engine.Actor")))
            print("IsAModActor():" ..  tostring(o:GetFName():ToString():contains("ModActor_C")))
            return true
        else
            print("Is Invalid")
        end
    else
        print("Is Nil")
    end
    return false
end

function PrintAllMods()
    print("Printing all Mods")
    DoAllMods(function(Mod)
        TestModVerbose(Mod)
    end)
end

RegisterKeyBind(Key.F6, function()
    PrintAllMods()
end)

RegisterKeyBind(Key.F7, function()
    FetchAllMods()
end)

ExecuteWithDelay(5000, function()
    FetchAllMods()
    ListenToMods()
end)