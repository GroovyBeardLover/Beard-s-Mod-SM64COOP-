local movedSelection = false
OBJECT_VIEW = 1
local l, camera_freeze, vec3f_set, vec3f_copy, camera_unfreeze, obj_mark_for_deletion, spawn_sync_object, djui_popup_create_global, tostring, spawn_non_sync_object, clamp, play_sound, hook_event, hook_on_sync_table_change = gLakituState, camera_freeze, vec3f_set, vec3f_copy, camera_unfreeze, obj_mark_for_deletion, spawn_sync_object, djui_popup_create_global, tostring, spawn_non_sync_object, clamp, play_sound, hook_event, hook_on_sync_table_change

local function spawning_controls(m)
    m.actionState = 0
    m.actionTimer = 0
    m.peakHeight = m.pos.y
    m.freeze = true
    camera_freeze()
    if OBJECT_VIEW == 1 then
        vec3f_set(l.pos, OBJECT_POS.x, OBJECT_POS.y, OBJECT_POS.z - DISTANCE)
    elseif OBJECT_VIEW == 2 then
        vec3f_set(l.pos, OBJECT_POS.x, OBJECT_POS.y, OBJECT_POS.z + DISTANCE)
    elseif OBJECT_VIEW == 3 then
        vec3f_set(l.pos, OBJECT_POS.x - DISTANCE, OBJECT_POS.y, OBJECT_POS.z)
    elseif OBJECT_VIEW == 4 then
        vec3f_set(l.pos, OBJECT_POS.x + DISTANCE, OBJECT_POS.y, OBJECT_POS.z)
    end
    vec3f_copy(l.focus, OBJECT_POS)

    if (m.controller.buttonPressed & L_TRIG) ~= 0 then
        SELECTED_MENU_OPTION = 1
        if CURRENT_MENU ~= 2 then
            CURRENT_MENU = 2
        else
            CURRENT_MENU = nil
        end
    end

    if CURRENT_MENU ~= nil then return end

    if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
        camera_unfreeze()
        SPAWNING = false
        obj_mark_for_deletion(CURRENT_OBJ)
        if SPAWN_SYNC then
            spawn_sync_object(BMOD_OBJ_LIST[OBJECT_TO_SPAWN].behavior, BMOD_OBJ_LIST[OBJECT_TO_SPAWN].model, OBJECT_POS.x, OBJECT_POS.y, OBJECT_POS.z, function (o)
                o.oFaceAnglePitch = OBJECT_FACEANGLE.x
                o.oFaceAngleYaw = OBJECT_FACEANGLE.y
                o.oFaceAngleRoll = OBJECT_FACEANGLE.z
                o.oBehParams = (OBJECT_PARAMS.param1 << 24) | (OBJECT_PARAMS.param2 << 16) | (OBJECT_PARAMS.param3 << 8) | (OBJECT_PARAMS.param4)
                o.oBehParams2ndByte = OBJECT_PARAMS.param2ndbyte
            end)
            local spawnText = gNetworkPlayers[0].name.. " spawned \\#FFFF00\\"..BMOD_OBJ_LIST[OBJECT_TO_SPAWN].name.. "\n\n("..tostring(OBJECT_PARAMS.param1)..", "..tostring(OBJECT_PARAMS.param2)..", "..tostring(OBJECT_PARAMS.param3)..", "..tostring(OBJECT_PARAMS.param4)..", "..tostring(OBJECT_PARAMS.param2ndbyte)..")\n\n"
            if BMOD_OBJ_LIST[OBJECT_TO_SPAWN].name == "CUSTOM" then
                spawnText = spawnText.. "("..BMOD_OBJ_LIST[find_object_by_behavior(BMOD_OBJ_LIST[1].behavior)].name..", "..BMOD_OBJ_LIST[find_object_by_model(BMOD_OBJ_LIST[1].model)].name..")"
            end
            djui_popup_create_global(spawnText, 6)
        else
            spawn_non_sync_object(BMOD_OBJ_LIST[OBJECT_TO_SPAWN].behavior, BMOD_OBJ_LIST[OBJECT_TO_SPAWN].model, OBJECT_POS.x, OBJECT_POS.y, OBJECT_POS.z, function (o)
                o.oFaceAnglePitch = OBJECT_FACEANGLE.x
                o.oFaceAngleYaw = OBJECT_FACEANGLE.y
                o.oFaceAngleRoll = OBJECT_FACEANGLE.z
                o.oBehParams = (OBJECT_PARAMS.param1 << 24) | (OBJECT_PARAMS.param2 << 16) | (OBJECT_PARAMS.param3 << 8) | (OBJECT_PARAMS.param4)
                o.oBehParams2ndByte = OBJECT_PARAMS.param2ndbyte
            end)
        end
    end

    if (m.controller.buttonDown & L_JPAD) ~= 0 then
        if OBJECT_VIEW == 1 then
            OBJECT_FACEANGLE.y = OBJECT_FACEANGLE.y - OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 2 then
            OBJECT_FACEANGLE.y = OBJECT_FACEANGLE.y + OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 3 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x - OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 4 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x + OBJECT_SPEED * 50
        end
    elseif (m.controller.buttonDown & R_JPAD) ~= 0 then
        if OBJECT_VIEW == 1 then
            OBJECT_FACEANGLE.y = OBJECT_FACEANGLE.y + OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 2 then
            OBJECT_FACEANGLE.y = OBJECT_FACEANGLE.y - OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 3 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x + OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 4 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x - OBJECT_SPEED * 50
        end
    end

    if (m.controller.buttonDown & U_JPAD) ~= 0 then
        if OBJECT_VIEW == 1 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x + OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 2 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x - OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 3 then
            OBJECT_FACEANGLE.z = OBJECT_FACEANGLE.z - OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 4 then
            OBJECT_FACEANGLE.z = OBJECT_FACEANGLE.z + OBJECT_SPEED * 50
        end
    elseif (m.controller.buttonDown & D_JPAD) ~= 0 then
        if OBJECT_VIEW == 1 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x - OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 2 then
            OBJECT_FACEANGLE.x = OBJECT_FACEANGLE.x + OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 3 then
            OBJECT_FACEANGLE.z = OBJECT_FACEANGLE.z + OBJECT_SPEED * 50
        elseif OBJECT_VIEW == 4 then
            OBJECT_FACEANGLE.z = OBJECT_FACEANGLE.z - OBJECT_SPEED * 50
        end
    end

    if (m.controller.buttonDown & A_BUTTON) ~= 0 then
        OBJECT_POS.y = OBJECT_POS.y + OBJECT_SPEED
    elseif (m.controller.buttonDown & Z_TRIG) ~= 0 then
        OBJECT_POS.y = OBJECT_POS.y - OBJECT_SPEED
    end

    if m.controller.rawStickX >= 40 then
        if OBJECT_VIEW == 1 then
            OBJECT_POS.x = OBJECT_POS.x - OBJECT_SPEED
        elseif OBJECT_VIEW == 2 then
            OBJECT_POS.x = OBJECT_POS.x + OBJECT_SPEED
        elseif OBJECT_VIEW == 3 then
            OBJECT_POS.z = OBJECT_POS.z + OBJECT_SPEED
        elseif OBJECT_VIEW == 4 then
            OBJECT_POS.z = OBJECT_POS.z - OBJECT_SPEED
        end
    elseif m.controller.rawStickX <= -40 then
        if OBJECT_VIEW == 1 then
            OBJECT_POS.x = OBJECT_POS.x + OBJECT_SPEED
        elseif OBJECT_VIEW == 2 then
            OBJECT_POS.x = OBJECT_POS.x - OBJECT_SPEED
        elseif OBJECT_VIEW == 3 then
            OBJECT_POS.z = OBJECT_POS.z - OBJECT_SPEED
        elseif OBJECT_VIEW == 4 then
            OBJECT_POS.z = OBJECT_POS.z + OBJECT_SPEED
        end
    end

    if m.controller.rawStickY >= 40 then
        if OBJECT_VIEW == 1 then
            OBJECT_POS.z = OBJECT_POS.z + OBJECT_SPEED
        elseif OBJECT_VIEW == 2 then
            OBJECT_POS.z = OBJECT_POS.z - OBJECT_SPEED
        elseif OBJECT_VIEW == 3 then
            OBJECT_POS.x = OBJECT_POS.x + OBJECT_SPEED
        elseif OBJECT_VIEW == 4 then
            OBJECT_POS.x = OBJECT_POS.x - OBJECT_SPEED
        end
    elseif m.controller.rawStickY <= -40 then
        if OBJECT_VIEW == 1 then
            OBJECT_POS.z = OBJECT_POS.z - OBJECT_SPEED
        elseif OBJECT_VIEW == 2 then
            OBJECT_POS.z = OBJECT_POS.z + OBJECT_SPEED
        elseif OBJECT_VIEW == 3 then
            OBJECT_POS.x = OBJECT_POS.x - OBJECT_SPEED
        elseif OBJECT_VIEW == 4 then
            OBJECT_POS.x = OBJECT_POS.x + OBJECT_SPEED
        end
    end
end

local function update()
    local m = gMarioStates[0]

    if CURRENT_MENU ~= nil then
        m.freeze = true

        if (m.controller.buttonPressed & START_BUTTON) ~= 0 then
            CURRENT_MENU = nil
        end

        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            BMOD_HUDS[CURRENT_MENU].texts[SELECTED_MENU_OPTION].func()
            if CURRENT_MENU ~= 2 then CURRENT_MENU = nil end
        end

        if m.controller.rawStickY == 0 then
            movedSelection = false
        elseif m.controller.rawStickY <= -40 and not movedSelection then
            movedSelection = true
            SELECTED_MENU_OPTION = clamp(SELECTED_MENU_OPTION + 1, 1, #BMOD_HUDS[CURRENT_MENU].texts)
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, m.marioObj.header.gfx.cameraToObject)
        elseif m.controller.rawStickY >= 40 and not movedSelection then
            movedSelection = true
            SELECTED_MENU_OPTION = clamp(SELECTED_MENU_OPTION - 1, 1, #BMOD_HUDS[CURRENT_MENU].texts)
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, m.marioObj.header.gfx.cameraToObject)
        end
    end

    if SPAWNING then
        spawning_controls(m)
    end
end

hook_event(HOOK_UPDATE, update)
hook_on_sync_table_change(gGlobalSyncTable, "bmodHostOnly", nil, function (tag, oldVal, newVal)
    if network_is_server() then return end

    if newVal == true then
        CURRENT_MENU = nil
        SPAWNING = false
        camera_unfreeze()
        if CURRENT_OBJ ~= nil then
            obj_mark_for_deletion(CURRENT_OBJ)
        end
    end
end)
