-- raise the closest car --
RegisterCommand("raisecar", function(source, args, raw)
	
	TriggerClientEvent('raisecar', source)
end)

-- lower the previously raised car --
RegisterCommand("lowercar", function(source, args, raw)
	
	TriggerClientEvent('lowercar', source)
end)
