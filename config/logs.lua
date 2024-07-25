local discordWebhook = ''

---@param playerSource number Player server id 
---@param realPlate string Vehicle actual plate
---@param fakePlate string Fake plate that was installed
---Fake plate was installed
function logFakeInstall(playerSource, realPlate, fakePlate)
    local logString = 'Player [**'..Player(playerSource).state.mk_identifier..'**] | ID [**'..playerSource..'**] Insalled fakeplate [**'..fakePlate..'**] onto vehicle [**'..realPlate..'**]'

    utils:discordLog(discordWebhook, 'Fake Plate Install', 15105570, logString)
end

---@param playerSource number Player server id 
---@param realPlate string Vehicle actual plate
---@param fakePlate string Fake plate that was removed
---Fake plate was removed
function logFakeRemove(playerSource, realPlate, fakePlate)
    local logString = 'Player [**'..Player(playerSource).state.mk_identifier..'**] | ID [**'..playerSource..'**] Removed fakeplate [**'..fakePlate..'**] from vehicle [**'..realPlate..'**]'

    utils:discordLog(discordWebhook, 'Fake Plate Removed', 15548997, logString)
end

---@param playerSource number Player server id 
---@param oldPlate string Original vehicle plate
---@param newPlate string New vanity plate
---Vanity plate was installed
function logVanityInstall(playerSource, oldPlate, newPlate)
    local logString = 'Player [**'..Player(playerSource).state.mk_identifier..'**] | ID [**'..playerSource..'**] Installed vanity plate [**'..newPlate..'**] onto vehicle [**'..oldPlate..'**]'

    utils:discordLog(discordWebhook, 'Vanity Plate Install', 5763719, logString)
end