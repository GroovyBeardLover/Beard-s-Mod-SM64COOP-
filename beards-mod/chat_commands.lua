-- Localize functions to improve performance
local string_upper, djui_chat_message_create, tonumber, djui_popup_create_global, hook_chat_command, network_is_server, obj_mark_for_deletion, warp_to_level, camera_unfreeze = string.upper, djui_chat_message_create, tonumber, djui_popup_create_global, hook_chat_command, network_is_server, obj_mark_for_deletion, warp_to_level, camera_unfreeze

local function bmod_spawn_command(msg)
    if msg == nil then djui_chat_message_create("\\#00ffa6\\Example: /bmod spawn 1up") return true end
    if SPAWNING then djui_chat_message_create("\\#00ffa6\\You are already spawning an object!") return true end
    if find_object_by_name(string_upper(msg)) ~= nil then
        OBJECT_TO_SPAWN = find_object_by_name(string_upper(msg))
        SELECTED_MENU_OPTION = 1
        CURRENT_MENU = 1
        return true
    end

    if string_upper(msg) == "LAST" and OBJECT_TO_SPAWN ~= nil then
        SELECTED_MENU_OPTION = 1
        CURRENT_MENU = 1
        SPAWN_MENU = true
        return true
    end

    djui_chat_message_create("\\#00ffa6\\Object not found.")
    return true
end

local function bmod_search_command(msg)
    if msg == nil then djui_chat_message_create("\\#00ffa6\\Example: /bmod search 1up") return true end
    SELECTED_MENU_OPTION = 1
    SEARCH_TERM = msg
    CURRENT_MENU = 3
    return true
end

local function bmod_speed_command(msg)
    if tonumber(msg) == nil or msg == nil then djui_chat_message_create("\\#00ffa6\\Example: /bmod speed 100 (Default value is 50)") return true end

    OBJECT_SPEED = tonumber(msg)
    return true
end

local function bmod_distance_command(msg)
    if tonumber(msg) == nil or msg == nil then djui_chat_message_create("\\#00ffa6\\Example: /bmod distance 6000 (Default value is 1000)") return true end

    DISTANCE = tonumber(msg)
    djui_chat_message_create("\\#00ffa6\\Distance set to "..msg)
    return true
end

local function bmod_params_command(msg, msg2, msg3, msg4, msg5)
    if msg == nil or msg2 == nil or msg3 == nil or msg4 == nil or msg5 == nil then djui_chat_message_create("\\#00ffa6\\Example: /bmod params 0 1 0 0 2\n\nThe first 4 numbers are oBehParams. The last number is oBehParams2ndByte.") return true end

    if tonumber(msg) ~= nil and tonumber(msg2) ~= nil and tonumber(msg3) ~= nil and tonumber(msg4) ~= nil and tonumber(msg5) ~= nil then
        OBJECT_PARAMS.param1 = tonumber(msg)
        OBJECT_PARAMS.param2 = tonumber(msg2)
        OBJECT_PARAMS.param3 = tonumber(msg3)
        OBJECT_PARAMS.param4 = tonumber(msg4)
        OBJECT_PARAMS.param2ndbyte = tonumber(msg5)
        djui_chat_message_create("\\#00ffa6\\Object Params: "..msg.." "..msg2.." "..msg3.." "..msg4.." "..msg5)
        return true
    end
end

local function bmod_host_only_command(msg)
    if not network_is_server() then djui_chat_message_create("\\#00ffa6\\This command can only be used by the host.") return true end
    if msg == nil then djui_chat_message_create("\\#00ffa6\\Command Usage: /bmod host_only on|off") return true end

    if string_upper(msg) == "ON" then
        gGlobalSyncTable.bmodHostOnly = true
        djui_popup_create_global("\\#00ffa6\\BMod now can only be used by the host.", 3)
    elseif string_upper(msg) == "OFF" then
        gGlobalSyncTable.bmodHostOnly = false
        djui_popup_create_global("\\#00ffa6\\BMod now can be used by everyone.", 3)
    else
        djui_chat_message_create("\\#00ffa6\\Command usage: /bmod host_only on|off")
    end

    return true
end

local function bmod_custom_command(msg, msg2)
    if msg == nil or msg2 == nil then djui_chat_message_create("\\#00ffa6\\Example: /bmod custom objName objName\n\nThe first objName is the name of the object that has the behavior you want to use. The second is the object name that has the model you want to use.") return true end

    if find_object_by_name(string_upper(msg)) ~= nil then
        BMOD_OBJ_LIST[1].behavior = BMOD_OBJ_LIST[find_object_by_name(string_upper(msg))].behavior
        djui_chat_message_create("\\#00ffa6\\Custom Object Behavior: "..BMOD_OBJ_LIST[find_object_by_name(string_upper(msg))].name)
    end

    if find_object_by_name(string_upper(msg2)) ~= nil then
        BMOD_OBJ_LIST[1].model = BMOD_OBJ_LIST[find_object_by_name(string_upper(msg2))].model
        djui_chat_message_create("\\#00ffa6\\Custom Object Model: "..BMOD_OBJ_LIST[find_object_by_name(string_upper(msg2))].name)
    end
    return true
end

function respawn()
    CURRENT_MENU = nil
    obj_mark_for_deletion(CURRENT_OBJ)
    SPAWNING = false
    warp_to_level(gNetworkPlayers[0].currLevelNum, gNetworkPlayers[0].currAreaIndex, gNetworkPlayers[0].currActNum)
    camera_unfreeze()
    return true
end

local function bmod_command(msg)
    if gGlobalSyncTable.bmodHostOnly and not network_is_server() then djui_chat_message_create("\\#00ffa6\\This command currently can only be used by the host.") return true end

    local args = {} -- split msg into table
    for argument in msg:gmatch("%S+") do table.insert(args, argument) end
    if args[1] ~= nil then args[1] = string_upper(args[1]) end

    if args[1] == "SPAWN" then
        return bmod_spawn_command(args[2])
    elseif args[1] == "SEARCH" then
        return bmod_search_command(args[2])
    elseif args[1] == "CUSTOM" then
        return bmod_custom_command(args[2], args[3])
    elseif args[1] == "SPEED" then
        return bmod_speed_command(args[2])
    elseif args[1] == "DISTANCE" then
        return bmod_distance_command(args[2])
    elseif args[1] == "RESPAWN" then
        return respawn()
    elseif args[1] == "PARAMS" then
        return bmod_params_command(args[2], args[3], args[4], args[5], args[6])
    elseif args[1] == "HOST_ONLY" then
        return bmod_host_only_command(args[2])
    end
    return true
end

hook_chat_command("bmod", "[spawn|custom|params|speed|distance|respawn|search|host_only]", bmod_command)