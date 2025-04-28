-- init.lua
local core   = require("openmw.core")
local event  = require("openmw.event")
local util   = require("openmw.util")
local types  = require("openmw.types")

local log = core.getLogger("RetroLeveler")

-- 2.1: Plugin filenames as they appear in your Content Files list
local MADD_ESP      = "Madd Leveler - Base.esp"
local CAREFREE_ESP  = "Carefree Leveling.esp"

-- 2.2: Helper: check if an ESP is loaded
local function isPluginLoaded(name)
    for _, plugin in ipairs(core.getDataHandler().loadOrder) do
        if plugin.filename:lower() == name:lower() then
            return true
        end
    end
    return false
end

local useMadd     = isPluginLoaded(MADD_ESP)
local useCarefree = isPluginLoaded(CAREFREE_ESP)

if not (useMadd or useCarefree) then
    log:info("Neither Madd Leveler nor Carefree Leveling found — nothing to do.")
    return
end

-- 2.3: Skill→Attribute map (Morrowind defaults)
local skillAttr = {
    acrobatics   = "speed",
    alchemy      = "intelligence",
    athletics    = "endurance",
    blade        = "strength",
    block        = "endurance",
    blunt        = "strength",
    conjuration  = "intelligence",
    destruction  = "intelligence",
    handtohand   = "strength",
    heavyarmor   = "endurance",
    illusion     = "willpower",
    lightarmor   = "speed",
    marksman     = "agility",
    mercantile   = "personality",
    mysticism    = "willpower",
    restoration  = "willpower",
    security     = "agility",
    shortblade   = "speed",
    sneak        = "agility",
    speechcraft  = "personality",
}

local BASE_SKILL = 5

-- 2.4: Madd Leveler retro calc: for each skill, every 5 points above BASE_SKILL grants +1 to its attribute
local function calcMadd()
    local inc = {}
    local player = types.Actor.stats(types.Player).skills
    for skill, attr in pairs(skillAttr) do
        local val = player[skill].current
        local grants = math.floor((val - BASE_SKILL) / 5)
        if grants > 0 then
            inc[attr] = (inc[attr] or 0) + grants
        end
    end
    return inc
end

-- 2.5: Carefree Leveling retro calc (you’ll need to fill in the exact algorithm per mod docs)
local function calcCarefree()
    log:info("Carefree retro-calc not implemented — adjust this to match its +5-per-level logic.")
    return {}
end

-- 2.6: Apply any missing bumps to the player’s attributes
local function applyIncreases(increases)
    local actor   = types.Actor.stats(types.Player).attributes
    for attr, total in pairs(increases) do
        local base   = actor[attr].base
        local curr   = actor[attr].current
        -- how many points *should* have been gained
        local expected = base + total
        if curr < expected then
            local delta = expected - curr
            core.sendGlobalEvent("ModStatistic", {
                reference = core.getPlayerId(),
                attribute = attr,
                value     = delta
            })
            log:info(("Bumped %s by %d"):format(attr, delta))
        end
    end
end

-- 2.7: On game-loaded, do the work exactly once
event.register("loaded", function()
    log:info("RetroLeveler: Detected %s-based leveling",
        useMadd and "Madd" or "Carefree"
    )
    local inc = useMadd and calcMadd() or calcCarefree()
    applyIncreases(inc)
end)
