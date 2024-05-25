-- name: Beard's Mod
-- description: Bare minimum Garry's Mod in SM64.\nProne to crashing.\n\nMod by BeardEnthusiast.
gGlobalSyncTable.bmodHostOnly = false
gServerSettings.stayInLevelAfterStar = true

OBJECT_POS = {x = 0, y = 0, z = 0}
OBJECT_FACEANGLE = {x = 0, y = 0, z = 0}
OBJECT_PARAMS = {param1 = 0, param2 = 0, param3 = 0, param4 = 0, param2ndbyte = 0}
OBJECT_SPEED = 50
CURRENT_OBJ = nil
OBJECT_TO_SPAWN = 1
SPAWN_SYNC = true
SPAWNING = false
DISTANCE = 1000

local table_insert, table_remove, string_upper = table.insert, table.remove, string.upper

SELECTED_MENU_OPTION = 1
CURRENT_MENU = nil

function find_object_by_name(string)
    for i, v in pairs(BMOD_OBJ_LIST) do
        if v.name == string then
            return i
        end
    end
end

function find_object_by_model(model)
    for i, v in pairs(BMOD_OBJ_LIST) do
        if i ~= 1 then
            if v.model == model then
                return i
            end
        end
    end
end

function find_object_by_behavior(behavior)
    for i, v in pairs(BMOD_OBJ_LIST) do
        if i ~= 1 then
            if v.behavior == behavior then
                return i
            end
        end
    end
end

local function bmod_add_object_to_list(name, behavior, model)
    name = string_upper(name)
    for i, v in pairs(BMOD_OBJ_LIST) do
        if v.name == name then
            table_remove(BMOD_OBJ_LIST, i)
        end
    end
    table_insert(BMOD_OBJ_LIST, {name = name, behavior = behavior, model = model})
end

_G.bmod = {
    spawning = SPAWNING,
    add_obj_to_list = bmod_add_object_to_list
}

SEARCH_TERM = "super"