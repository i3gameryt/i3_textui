local textUIStack = {}
local textUIVisible = false
local nuiReady = false
local lastTop = nil


RegisterNUICallback("nui_ready", function(_, cb)
    nuiReady = true
    if lastTop then
        SendNUIMessage({ action = 'show', key = lastTop.key, text = lastTop.text })
        textUIVisible = true
    end
    cb({})
end)


RegisterNetEvent('i3_textui:show', function(key, text)
    if not key or not text then return end

    local top = textUIStack[#textUIStack]
    if top and top.key == key then
        if top.text ~= text then
            top.text = text
            lastTop = top
            if nuiReady then
                SendNUIMessage({ action = 'show', key = key, text = text })
            end
        end
    else
        local newTop = { key = key, text = text }
        table.insert(textUIStack, newTop)
        lastTop = newTop
        if nuiReady then
            SendNUIMessage({ action = 'show', key = key, text = text })
        end
    end
    textUIVisible = true
end)


RegisterNetEvent('i3_textui:hide', function()
    if #textUIStack > 0 then
        table.remove(textUIStack)
    end

    if #textUIStack > 0 then
        local top = textUIStack[#textUIStack]
        lastTop = top
        if nuiReady then
            SendNUIMessage({ action = 'show', key = top.key, text = top.text })
        end
        textUIVisible = true
    else
        lastTop = nil
        if nuiReady then
            SendNUIMessage({ action = 'hide' })
        end
        textUIVisible = false
    end
end)


CreateThread(function()
    while true do
        Wait(300)

        if nuiReady then
            if textUIVisible then
                if IsPauseMenuActive() or IsNuiFocused() or IsNuiFocusKeepingInput() then
                    SendNUIMessage({ action = 'hide' })
                    textUIVisible = false
                end
            elseif not textUIVisible and #textUIStack > 0 then
                if not IsPauseMenuActive() and not IsNuiFocused() and not IsNuiFocusKeepingInput() then
                    local top = textUIStack[#textUIStack]
                    SendNUIMessage({ action = 'show', key = top.key, text = top.text })
                    textUIVisible = true
                end
            end
        end
    end
end)











-- RegisterCommand("hexui", function()
--     TriggerEvent("i3_textui:show", " F1 ", "Open")
--     SetTimeout(10000, function()
--         TriggerEvent("i3_textui:hide")
--     end)
-- end)


-- local HexZones = {
--     -- {
--     --     coords = vec3(324.75, -229.48, 54.22),
--     --     size = vec3(2.0, 1.0, 2.3),
--     --     rotation = -15,
--     --     label = "Open Motel Menu",
--     --     key = "E"
--     -- },

-- }

-- for i, zone in pairs(HexZones) do
--     local inZone = false

--     lib.zones.box({
--         coords = zone.coords,
--         size = zone.size,
--         rotation = zone.rotation,
--         debug = false,
--         inside = function()
--             if not inZone then
--                 inZone = true
--                 TriggerEvent("i3_textui:show", zone.key, zone.label)
--             end
--         end,
--         onExit = function()
--             if inZone then
--                 inZone = false
--                 TriggerEvent("i3_textui:hide")
--             end
--         end
--     })
-- end




