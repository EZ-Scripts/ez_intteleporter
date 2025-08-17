Citizen.CreateThread(function() 
    for k,v in pairs(Config.teleporter) do
        if v.dynamic then
            RemoveImap(k)
        end
    end
end)

local doorsCreated = {}
local inside = false

local groupp = PromptRegisterBegin()

Citizen.CreateThread(function() 
    while true do
        local sleep = 2500
        if inside then
            PromptSetEnabled(enterp, 0)
            PromptSetVisible(enterp, 0)
            PromptSetEnabled(exitp, 1)
            PromptSetVisible(exitp, 1)
            local d = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),Config.teleporter[inside].location.x,Config.teleporter[inside].location.y,Config.teleporter[inside].location.z , true)
            if d < 2 then
                sleep = 0
                local str = CreateVarString(10, 'LITERAL_STRING', "Leave")
                UiPromptSetActiveGroupThisFrame(groupp, str)
                if PromptHasStandardModeCompleted(exitp) then
                    DoScreenFadeOut(1000)
                    while IsScreenFadingOut() do
                        Wait(0)
                    end
                    TriggerServerEvent("dda_teleporter:server:route", tonumber(0))
                    SetEntityCoords(PlayerPedId(), Config.teleporter[inside].enter.x, Config.teleporter[inside].enter.y, Config.teleporter[inside].enter.z)
                    while IsPedFalling(PlayerPedId()) == 1 do 
                        Wait(1000)
                        SetEntityCoords(PlayerPedId(), Config.teleporter[inside].enter.x, Config.teleporter[inside].enter.y, Config.teleporter[inside].enter.z)
                    end
                    Wait(1000)
                    DoScreenFadeIn(1000)
                    while IsScreenFadingIn() do
                        Wait(0)
                    end
                    if Config.teleporter[inside].dynamic then
                        RemoveImap(inside)
                    end
                    inside = false
                end
            end
        else
            PromptSetEnabled(enterp, 1)
	        PromptSetVisible(enterp, 1)
            PromptSetEnabled(exitp, 0)
            PromptSetVisible(exitp, 0)
            for k,v in pairs(Config.teleporter) do 
                local d = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),v.enter.x,v.enter.y,v.enter.z , true)
                if d < 50 then
                    -- Create door object at v.enter
                    if d < 2 then
                        -- Draw text
                        local str = CreateVarString(10, 'LITERAL_STRING', v.label or k)
                        UiPromptSetActiveGroupThisFrame(groupp, str)
                        sleep = 0
                        if PromptHasStandardModeCompleted(enterp) then
                            RequestImap(k)
                            -- Teleport player to the location
                            DoScreenFadeOut(1000)
                            while IsScreenFadingOut() do
                                Wait(0)
                            end
                            TriggerServerEvent("dda_teleporter:server:route", tonumber(v.unique))
                            SetEntityCoords(PlayerPedId(), v.location.x, v.location.y, v.location.z)
                            FreezeEntityPosition(PlayerPedId(), true)
                            Wait(2500)
                            FreezeEntityPosition(PlayerPedId(), false)
                            Wait(1000)
                            while IsPedFalling(PlayerPedId()) == 1 do 
                                Wait(2500)
                                SetEntityCoords(PlayerPedId(), v.location.x, v.location.y, v.location.z)
                            end
                            Wait(2000)
                            DoScreenFadeIn(1000)
                            while IsScreenFadingIn() do
                                Wait(0)
                            end
                            inside = k
                        end
                    else
                        if sleep > 1000 then
                            sleep = 1000 
                        end
                        if not doorsCreated[k] and v.prop then
                            local door = CreateObject(GetHashKey("p_door10x"), v.enter.x, v.enter.y, v.enter.z, false, true, true)
                            FreezeEntityPosition(door, true)
                            SetEntityHeading(door, v.enter.w)
                            doorsCreated[k] = door
                        end
                    end
                else
                    -- Remove door object if player is not near
                    if doorsCreated[k] then
                        DeleteObject(doorsCreated[k])
                        doorsCreated[k] = nil
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
	exitp = PromptRegisterBegin()
	PromptSetControlAction(exitp, 0x760A9C6F)
	PromptSetText(exitp, CreateVarString(10, 'LITERAL_STRING', "Exit"))
	PromptSetEnabled(exitp, 1)
	PromptSetVisible(exitp, 1)
	PromptSetStandardMode(exitp,1)
	PromptSetGroup(exitp, groupp)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,exitp,true)
	PromptRegisterEnd(exitp)

	enterp = PromptRegisterBegin()
	PromptSetControlAction(enterp, 0x760A9C6F)
	PromptSetText(enterp, CreateVarString(10, 'LITERAL_STRING', "Enter"))
	PromptSetEnabled(enterp, 1)
	PromptSetVisible(enterp, 1)
	PromptSetStandardMode(enterp,1)
	PromptSetGroup(enterp, groupp)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,enterp,true)
	PromptRegisterEnd(enterp)
end)