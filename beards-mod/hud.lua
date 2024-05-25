local string_find, string_upper, djui_chat_message_create, spawn_non_sync_object, camera_unfreeze, obj_mark_for_deletion, djui_hud_set_color, djui_hud_render_rect, djui_hud_get_screen_height, djui_hud_get_screen_width, djui_hud_set_resolution, djui_hud_measure_text, djui_hud_print_text, vec3f_copy, vec3f_set, hook_event = string.find, string.upper, djui_chat_message_create, spawn_non_sync_object, camera_unfreeze, obj_mark_for_deletion, djui_hud_set_color, djui_hud_render_rect, djui_hud_get_screen_height, djui_hud_get_screen_width, djui_hud_set_resolution, djui_hud_measure_text, djui_hud_print_text, vec3f_copy, vec3f_set, hook_event


local view_text = {
    "View: Front",
    "View: Back",
    "View: Left",
    "View: Right"
}

local objects_found = false
local function search_mode_name()
    for i, v in pairs(BMOD_OBJ_LIST) do
        if string_find(v.name, string_upper(SEARCH_TERM)) then
            djui_chat_message_create(v.name)
            objects_found = true
        end
    end

    if not objects_found then
        djui_chat_message_create("\\#b85e5e\\No objects found.")
    end
    objects_found = false
end

local function search_mode_model()
    for i, v in pairs(BMOD_OBJ_LIST) do
        if _G[string_upper(SEARCH_TERM)] == v.model then
            djui_chat_message_create(v.name)
            objects_found = true
        end
    end

    if not objects_found then
        djui_chat_message_create("\\#b85e5e\\No objects found.")
    end
end

local function search_mode_bhv()
    for i, v in pairs(BMOD_OBJ_LIST) do
        if _G[SEARCH_TERM] == v.behavior then
            djui_chat_message_create(v.name)
            objects_found = true
        end
    end

    if not objects_found then
        djui_chat_message_create("\\#b85e5e\\No objects found.")
    end
end

local function spawn_mode_synced()
    SPAWN_SYNC = true
    CURRENT_OBJ = spawn_non_sync_object(id_bhvbmodMoveObject, BMOD_OBJ_LIST[OBJECT_TO_SPAWN].model, 0, 0, 0, nil)
    SPAWNING = true
end

local function spawn_mode_unsynced()
    SPAWN_SYNC = false
    CURRENT_OBJ = spawn_non_sync_object(id_bhvbmodMoveObject, BMOD_OBJ_LIST[OBJECT_TO_SPAWN].model, 0, 0, 0, nil)
    SPAWNING = true
end

local function change_object_view()
    if OBJECT_VIEW + 1 > 4 then
        OBJECT_VIEW = 1
    else
        OBJECT_VIEW = OBJECT_VIEW + 1
    end
    BMOD_HUDS[2].texts[4].text = view_text[OBJECT_VIEW]
end

local function stop_spawning()
    SPAWNING = false
    CURRENT_MENU = nil
    camera_unfreeze()
    obj_mark_for_deletion(CURRENT_OBJ)
end

BMOD_HUDS = {
    -- Spawn Menu
    {
        mainText = "Spawn Mode",
        texts = {
            {text = "Synced", helpText = "Spawns in for everyone.", func = function () spawn_mode_synced() end},
            {text = "Unsynced", helpText = "Spawns in only on your side.", func = function () spawn_mode_unsynced() end},
        }
    },
    -- Spawn Menu 2
    {
        mainText = "Tools",
        texts = {
            {text = "Teleport Object To You", helpText = " ", func = function () vec3f_copy(OBJECT_POS, gMarioStates[0].pos) end},
            {text = "Teleport You To Object", helpText = " ", func = function () vec3f_copy(gMarioStates[0].pos, OBJECT_POS) end},
            {text = "Reset Object Rotation", helpText = " ", func = function () vec3f_set(OBJECT_FACEANGLE, 0, 0, 0) end},
            {text = view_text[OBJECT_VIEW], helpText = " ", func = function () change_object_view() end},
            {text = "Stop Spawning", helpText = " ", func = function () stop_spawning() end}
        }
    },
    -- Search Menu
    {
        mainText = "Search Mode",
        texts = {
            {text = "Name", helpText = "Normal searching mode.", func = function () search_mode_name() end},
            {text = "Behavior", helpText = "Example: /bmod search id_bhv1Up", func = function () search_mode_bhv() end},
            {text = "Model", helpText = "Example: /bmod search E_MODEL_1UP", func = function () search_mode_model() end},
        }
    },
}

local function on_hud_render()
    if CURRENT_MENU ~= nil then
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width() + 1000, djui_hud_get_screen_height())

        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(255, 255, 255, 255)

        local mainText = BMOD_HUDS[CURRENT_MENU].mainText
        local mainTextX = (djui_hud_get_screen_width() / 2) - ((djui_hud_measure_text(mainText)) / 2)
        local mainTextY = 20
        djui_hud_print_text(mainText, mainTextX, mainTextY, 1)

        local helpText = BMOD_HUDS[CURRENT_MENU].texts[SELECTED_MENU_OPTION].helpText
        local helpTextX = (djui_hud_get_screen_width() / 2) - ((djui_hud_measure_text(helpText) * 0.5) / 2)
        djui_hud_print_text(helpText, helpTextX, djui_hud_get_screen_height() - 20, 0.5)

        local startingY = (djui_hud_get_screen_height() / 2 - 75)

        for i, v in pairs(BMOD_HUDS[CURRENT_MENU].texts) do
            djui_hud_set_color(255, 255, 255, 255)
            if SELECTED_MENU_OPTION == i then djui_hud_set_color(255, 165, 0, 255) end
            local X = (djui_hud_get_screen_width() / 2) - ((djui_hud_measure_text(v.text) * 0.75) / 2)
            local Y = startingY + (i * 30)
            djui_hud_print_text(v.text, X, Y, 0.75)
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)