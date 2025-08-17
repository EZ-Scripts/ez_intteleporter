
RegisterServerEvent("dda_teleporter:server:route", function(set)
    local src = source
    SetPlayerRoutingBucket(
        src,
        tonumber(set)
    )
end)