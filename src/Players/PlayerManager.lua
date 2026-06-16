--[[
	Player Manager
	Handles player-specific logic, data, and interactions
]]

local PlayerManager = {}
local playerData = {}

-- Configuration
local PLAYER_CONFIG = {
	WALK_SPEED = 16,
	JUMP_POWER = 50,
	HEALTH = 100,
	RESPAWN_TIME = 5,
}

-- Initialize player data
function PlayerManager:initializePlayer(player)
	print("[PlayerManager] Initializing player: " .. player.Name)
	
	playerData[player.UserId] = {
		username = player.Name,
		userId = player.UserId,
		joinTime = tick(),
		level = 1,
		inventory = {},
		stats = {
			experience = 0,
			money = 1000,
		}
	}
	
	return playerData[player.UserId]
end

-- Setup character
function PlayerManager:setupCharacter(player, character)
	print("[PlayerManager] Setting up character for: " .. player.Name)
	
	-- Configure humanoid
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.MaxHealth = PLAYER_CONFIG.HEALTH
	humanoid.Health = PLAYER_CONFIG.HEALTH
	
	-- Configure humanoid root part
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	humanoidRootPart.CanCollide = true
	
	-- Update movement speed
	for _, part in pairs(character:FindDescendants()) do
		if part:IsA("Humanoid") then
			part.WalkSpeed = PLAYER_CONFIG.WALK_SPEED
			part.JumpPower = PLAYER_CONFIG.JUMP_POWER
		end
	end
	
	-- Add death handler
	humanoid.Died:Connect(function()
		print("[PlayerManager] Player died: " .. player.Name)
		wait(PLAYER_CONFIG.RESPAWN_TIME)
		player:LoadCharacter()
	end)
end

-- Get player data
function PlayerManager:getPlayerData(player)
	return playerData[player.UserId]
end

-- Update player stats
function PlayerManager:addExperience(player, amount)
	local data = playerData[player.UserId]
	if data then
		data.stats.experience = data.stats.experience + amount
		print("[PlayerManager] " .. player.Name .. " gained " .. amount .. " XP")
	end
end

-- Give player money
function PlayerManager:addMoney(player, amount)
	local data = playerData[player.UserId]
	if data then
		data.stats.money = data.stats.money + amount
		print("[PlayerManager] " .. player.Name .. " gained $" .. amount)
	end
end

-- Remove player data on logout
function PlayerManager:cleanupPlayer(player)
	print("[PlayerManager] Cleaning up player: " .. player.Name)
	playerData[player.UserId] = nil
end

return PlayerManager
