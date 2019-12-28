RegisterServerEvent("pv-command:seatPlayerSV")
AddEventHandler("pv-command:seatPlayerSV", function(player)
    TriggerClientEvent("pv-command:seatPlayer", player)
end)

RegisterServerEvent("pv-command:unseatPlayerSV")
AddEventHandler("pv-command:unseatPlayerSV", function(player)
    TriggerClientEvent("pv-command:unseatPlayer", player)
end)