QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end

	while QBCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end 
		PlayerData = QBCore.Functions.GetPlayerData()
end)	



RegisterNetEvent("QBCore:Client:OnplayerLoaded")
AddEventHandler("QBCore:Client:OnplayerLoaded", function(xPlayer)
	PlayerData = xPlayer
	end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
	PlayerData.job = job
end)


function MyInvoices()
	QBCore.Functions.TriggerCallback("sadiqBilling:GetInvoice", function(invoices)
		SetNuiFocus(true, true)
		SendNuiMessage({
			action = 'MyInvoices',
			invoices = invoices,
			VAT = config.VATPercentage
		})
	end)
end

function SocietyInvoices(society)
	QBCore.Functions.TriggerCallback("sadiqBilling:GetSocietyInvoices", function(cb, totalInvoice, totalIncome, totalUnpaid, awaitedIncore)
		if json.encode(cb) ~= '[]' then
			SendNuiFocus(true, true)
			SendNuiMessage({
				action = 'societyinvoices',
				invoices = cb,
				totalInvoices = totalInvoices,
				totalIncome = totalIncome,
				totalUnpaid = totalUnpaid,
				awaitedIncome = awaitedIncome,
				VAT = Config.VATPercentage
			})
		else
			esports["okokNotify"]:Alert("BILLING", "Your society doesn't have invoices.", 10000, 'info')
			SetNuiFocus(false, false)
		end
	end, society)
end

function CreateInvoice(society)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'createinvoice',
		society = society
	})
end



RegisterCommand(Config.InvoicesCommand, function()
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == PlayerData.job.name then
			jobName = v
			isAllowed = true
		end
	end

	if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name == "boss" and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name ~= "boss" and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = true
		})
	elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif not isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
end, false)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		SetNuiFocus(false, false)
	elseif data.action == "payInvoice" then
		TriggerServerEvent("sadiqBilling:PayInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "cancelInvoice" then
		TriggerServerEvent("sadiqBilling:CancelInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "createInvoice" then
		local closestPlayer, playerDistance = QBCore.Functions.GetClosestPlayer()
		target = GetPlayerServerId(closestPlayer)
		data.target = target
		data.society = "society_"..PlayerData.job.name
		data.society_name = PlayerData.job.label

		if closestPlayer == -1 or playerDistance > 3.0 then
			exports['okokNotify']:Alert("BILLING", "Error sending the invoice! There's nobody near you.", 10000, 'error')
		else
			TriggerServerEvent("sadiqBilling:CreateInvoice", data)
			exports['okokNotify']:Alert("BILLING", "Invoice successfully sent!", 10000, 'success')
		end
		
		SetNuiFocus(false, false)
	elseif data.action == "missingInfo" then
		exports['okokNotify']:Alert("BILLING", "Fill in all fields before sending an invoice!", 10000, 'error')
	elseif data.action == "negativeAmount" then
		exports['okokNotify']:Alert("BILLING", "You need to set a positive amount!", 10000, 'error')
	elseif data.action == "mainMenuOpenMyInvoices" then
		MyInvoices()
	elseif data.action == "mainMenuOpenSocietyInvoices" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name == "boss" then
					SocietyInvoices(PlayerData.job.label)
				elseif not Config.OnlyBossCanAccessSocietyInvoices then
					SocietyInvoices(PlayerData.job.label)
				elseif Config.OnlyBossCanAccessSocietyInvoices then
					exports['okokNotify']:Alert("BILLING", "Only the boss can access the society invoices.", 10000, 'error')
				end
			end
		end
	elseif data.action == "mainMenuOpenCreateInvoice" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				CreateInvoice(PlayerData.job.label)
			end
		end
	end
end)