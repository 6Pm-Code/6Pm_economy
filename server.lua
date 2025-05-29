

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	SendAllEconomyToWebhook()
end)


function SendAllEconomyToWebhook()

	local GeldtabelleRAW = {}
	local Geldtabelle = {}
	local result = MySQL.query.await("SELECT * from `users`")

	if next(result) then
		for k,v in pairs(result) do
			local vorname = v.firstname
			local nachname = v.lastname
			local accounts = require("json").decode(v.accounts)
			
			if accounts and vorname and nachname then 
				local summe = 0
				if tonumber(accounts["bank"]) then
					summe = summe + tonumber(accounts["bank"])
				end
				if tonumber(accounts["black_money"]) then
					summe = summe + tonumber(accounts["black_money"])
				end
				if tonumber(accounts["money"]) then
					summe = summe + tonumber(accounts["money"])
				end

				if summe then
					data = {
						geld = summe,
						name = vorname.. " " .. nachname,
					}
					table.insert(GeldtabelleRAW, data)
				end
			end

		end
	end

	if GeldtabelleRAW then
		table.sort(GeldtabelleRAW, function(a, b)
			return (a.geld or 0) > (b.geld or 0)
		end)
		-- for a, b in pairs(GeldtabelleRAW) do
		-- 	local name = a
		-- 	local geld = b
		-- 	for k,v in pairs(GeldtabelleRAW) do
		-- 		if v > b then
		-- 			name = k
		-- 			geld = v
		-- 		end
		-- 	end
		-- 	Geldtabelle[name] = geld
		-- 	table.remove(GeldtabelleRAW, name)
		-- end
	end

	local counter = 0
	local HookText = "```"

	for k,v in pairs(GeldtabelleRAW) do
		if counter <= 100 then
			if v.name and v.geld then
				counter = counter + 1
				--print(v.name .. " hat soviel geld: " .. v.geld)
				HookText = HookText .. tostring(counter) .. ". " ..tostring(v.name) .. " - " .. tostring(v.geld) .. "$\n"
			end
		else
			break
		end
	end
	HookText = HookText .. "```"

	if GeldtabelleRAW then
		TriggerEvent('6Pm_economy:discordlog', 12065136, "Top Reichesten Spieler", HookText, "~ 6Pm Your Server ", "https://discord.com/api/webhooks/1368429313720057966/7pEd8SMsJyQKo0nDjDUJ7YroaLNXUJ9GRMUUPzpblLx3if-KGhU0bEJ6cRL_qkHw9c-d")
	end

end


RegisterCommand("sendeconomy", function(source, args, raw)

	if source == 0 then
		SendAllEconomyToWebhook()
	end

end)



RegisterNetEvent('6Pm_economy:discordlog')
AddEventHandler('6Pm_economy:discordlog', function(color, name, message, footer, webhook)

    local embed = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }

  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "6Pm", embeds = embed}), { ['Content-Type'] = 'application/json' })

end)