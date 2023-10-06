Config = {}

Config.ConsoleLogging = true --TRUE DISPLAYS SCRIPT LOGGING INFO IN F8 AND SERVER CONSOLE

Config.GiveKeys = function(Vehicle, Plate)
    ---@param Vehicle number Vehicle entity
    ---@param Plate string Vehicle plate text
    --If you use custom vehiclekeys script add your export/event here to give keys on plate update if required
    --qb-vehiclekeys is checked for automatically and not needed here
    --mk_vehiclekeys does not require key updates for plate changes. Export is not needed here.
end

--Fake Plates Config
    Config.FakePlateItem = 'fakeplate' --Inventory item used to install a fakeplate (You must set this item up yourself)

    Config.FakePlateRemoveItem = 'screwdriverset' --Inventory item used to remove an already installed fake plate
    Config.RemovePlateReturnItem = true --Will give player the fakeplate item back into inventory when its removed if set true
    Config.FakePlateTheme = {
        --MAKE YOUR OWN CUSTOM THEME FOR FAKE PLATES TO MATCH YOUR SERVER PLATES
        --PARAMS YOU CAN USE {number} = random number 0-9 {letter} = random letter a-z {space} = a space
        --YOU CAN ALSO DEFINE A STRING: EXAMPLE: 
            --'ESX',
            --'{space}',
            --'{number}',
            --'{number}',
            --'{letter}',
            --'{letter}'
                --This would produce a plate like 'ESX 09AZ'
        --8 CHARACTERS IS THE MAX FOR A PLATE. DO NOT ADD ANYTHING BESIDES NUMBERS/LETTERS/SPACE OR YOU WILL BREAK YOUR DATABASE
        '{number}',
        '{letter}',
        '{letter}',
        '{number}',
        '{number}',
        '{number}',
        '{letter}',
        '{letter}'
    }

    Config.Database = {
        UseCustom = false, --FALSE = USES DEFAULT QBCORE OR ESX DATABASE TABLES / TRUE = USES INFO BELOW
        VehicleTable = 'player_vehicles', --Player Vehicles table in database
        PlateField = 'plate', --Field that stores plate number inside player vehicles table
        FakePlateField = 'fakeplate', --Field that stores fakeplate number inside player vehicles table
        CitizenIdField = 'citizenid', --Field that stores player citizenid inside player vehicles table
        ModsField = 'mods', --Field that stores vehicle mods in the player vehicles table
        GloveBoxTable = {TableName = 'gloveboxitems', PlateField = 'plate'}, --Database Table for glovebox inventory
        TrunkTable = {TableName = 'trunkitems', PlateField = 'plate'}, --Database Table for trunk items inventory
    }

    Config.FakeInstalled = function(PlayerSource, RealPlate, FakePlate, Vehicle, VehicleNetId)
        ---@param PlayerSource number Player server id
        ---@param RealPlate string Vehicle real plate
        ---@param FakePlate string Vehicle fake plate that was installed
        ---@param Vehicle number Vehicle entity
        ---@param VehicleNetId number Vehicle network id

        --ADD ANY SERVER SIDE UPDATES YOU NEED TO DO HERE AFTER A FAKE PLATE IS INSTALLED
        --EXAMPLE DATABASE UPDATE:
        --local Result = MySQL.update.await('UPDATE `mycustomdatabasetable` SET fakeplate = :fake WHERE plate = :current', {fake = FakePlate, current = RealPlate})
        --If using mk_vehiclekeys the script handles these updates so nothing needs to be added here for that script

    end

    Config.FakeRemoved = function(PlayerSource, RealPlate, FakePlate, Vehicle, VehicleNetId)
        ---@param PlayerSource number Player server id
        ---@param RealPlate string Vehicle real plate that was set onto vehicle
        ---@param FakePlate string Vehicle fake plate that was removed
        ---@param Vehicle number Vehicle entity
        ---@param VehicleNetId number Vehicle network id

        --ADD ANY SERVER SIDE UPDATES YOU NEED TO DO HERE AFTER A FAKE PLATE IS REMOVED
        --EXAMPLE DATABASE UPDATE:
        --local Result = MySQL.update.await('UPDATE `mycustomdatabasetable` SET fakeplate = NULL WHERE plate = :current', {current = RealPlate})
        --If using mk_vehiclekeys the script handles these updates so nothing needs to be added here for that script

    end
--

--Progress Bar Config
Config.ProgressCircle = true --true = circle progress bar from ox_lib / false = rectangle progress bar from ox_lib
Config.ProgressCirclePosition = 'middle' --position of the progress circle. can be either 'middle' or 'bottom'
--

--Vanity Plates Config
    Config.Vanity = true --Set to false if you do not wish you use vanity plates on your server
    
    Config.VanityItem = 'vanityplate' --Inventory item used to install a vanity plate (You must set this item up youself)
    Config.VanityJobs = { --Any jobs listed here can install a vanity plate on a vehicle (example: mechanic) (job must be setup in QBShared.Jobs). Default 'VehicleOwner' means the vehicle owner can install their own custom plate
        'VehicleOwner', --Person who owns the vehicle (Removing this will only let jobs set in this table install vanity plates)
        'mechanic',
    }

    Config.RestrictedPlates = { --Anything inside this table will be restricted in a vanity plate (Doesn't have to be the entire word; Example: if 'BCSO' is restricted then 'BCSO SUX' would not be a valid vanity plate.)
        'FORSALE', --Could be used for vehicleshop scripts
        'FOR SALE', --Could be used for vehicleshop scripts
        'LSPD',
        'BCSO',
        'SAHP',
    }

    Config.ProfanityFilter = true --If set to true anything inside this table will be restricted in a vanity plate (Doesn't have to be the entire word; Example; if 'ass' is restricted then 'class' would not be a valid vanity plate.) Add/Remove as many words as you like.

    Config.VanityInstalled = function(PlayerSource, OldPlate, NewPlate, Vehicle, VehicleNetId)
        ---@param PlayerSource number Player server id
        ---@param OldPlate string Old vehicle plate text
        ---@param NewPlate string New vehicle plate next that was installed
        ---@param Vehicle number Vehicle entity
        ---@param VehicleNetId number Vehicle network id

        --ADD ANY SERVER SIDE UPDATES YOU NEED TO DO HERE AFTER A VANITY PLATE IS INSTALLED
        --EXAMPLE DATABASE UPDATE:
        --local Result = MySQL.update.await('UPDATE `mycustomdatabasetable` SET plate = :vanity WHERE plate = :current', {vanity = NewPlate, current = OldPlate})
        --If using mk_vehiclekeys the script handles these updates so nothing needs to be added here for that script
        
    end

--Notify Config
    Config.Notify = { 
        UseCustom = false, --FALSE = DEFAULT NOTIFY WILL BE YOUR FRAMEWORKS NOTIFY SYSTEM (QBCore:Notify / esx:showNotification) / TRUE = CUSTOM NOTIFY SCRIPT (OX_LIB / T-NOTIFY / ECT) (VIEW README FILE FOR DETAILED SETUP INFO)
        CustomClientNotifyFunction = function(Data) --**CLIENT SIDE CODE**
            ---@param Data table: { Message string, Type string (error, success, primary), Duration number }

            --TriggerEvent('QBCore:Notify', Data.Message, Data.Type, Data.Duration) --QBCORE EXAMPLE
        end,
        CustomServerNotifyFunction = function(PlayerSource, Data) --**SERVER SIDE CODE** SAME AS ABOVE EXCEPT PASSES THE SOURCE TO SEND THE NOTIFICATION TO FROM THE SERVER
            ---@param PlayerSource number Server id of the player
            ---@param Data table: { Message string, Type string (error, success, primary), Duration number }

            --TriggerClientEvent('QBCore:Notify', PlayerSource, Data.Message, Data.Type, Data.Duration) --QBCORE EXAMPLE
        end,
    }

--Profanity Config
    Config.Profanity = {
        "4r5e", 
        "5h1t", 
        "5hit", 
        "a55", 
        "anal", 
        "anus", 
        "ar5e", 
        "arrse", 
        "arse", 
        "ass", 
        "ass-fucker", 
        "asses", 
        "assfucker", 
        "assfukka", 
        "asshole", 
        "assholes", 
        "asswhole", 
        "a_s_s", 
        "b!tch", 
        "b00bs", 
        "b17ch", 
        "b1tch",
        "ballbag", 
        "balls", 
        "ballsack", 
        "bastard", 
        "beastial", 
        "beastiality", 
        "bellend", 
        "bestial", 
        "bestiality", 
        "bi+ch", 
        "biatch", 
        "bitch", 
        "bitcher", 
        "bitchers", 
        "bitches", 
        "bitchin", 
        "bitching", 
        "bloody", 
        "blow job", 
        "blowjob", 
        "blowjobs", 
        "boiolas", 
        "bollock", 
        "bollok", 
        "boner", 
        "boob", 
        "boobs", 
        "booobs", 
        "boooobs", 
        "booooobs", 
        "booooooobs", 
        "breasts", 
        "buceta", 
        "bugger", 
        "bum", 
        "bunny fucker", 
        "butt", 
        "butthole", 
        "buttmuch", 
        "buttplug", 
        "c0ck", 
        "c0cksucker", 
        "carpet muncher", 
        "cawk", 
        "chink", 
        "cipa", 
        "cl1t", 
        "clit", 
        "clitoris", 
        "clits", 
        "cnut", 
        "cock", 
        "cock-sucker", 
        "cockface", 
        "cockhead", 
        "cockmunch", 
        "cockmuncher", 
        "cocks", 
        "cocksuck", 
        "cocksucked", 
        "cocksucker", 
        "cocksucking", 
        "cocksucks", 
        "cocksuka", 
        "cocksukka", 
        "cok", 
        "cokmuncher", 
        "coksucka", 
        "coon", 
        "cox", 
        "crap", 
        "cum", 
        "cummer", 
        "cumming", 
        "cums", 
        "cumshot", 
        "cunilingus", 
        "cunillingus", 
        "cunnilingus", 
        "cunt", 
        "cuntlick", 
        "cuntlicker", 
        "cuntlicking", 
        "cunts", 
        "cyalis", 
        "cyberfuc", 
        "cyberfuck", 
        "cyberfucked", 
        "cyberfucker", 
        "cyberfuckers", 
        "cyberfucking", 
        "d1ck", 
        "damn", 
        "dick", 
        "dickhead", 
        "dildo", 
        "dildos", 
        "dink", 
        "dinks", 
        "dirsa", 
        "dlck", 
        "dog-fucker", 
        "doggin", 
        "dogging", 
        "donkeyribber", 
        "doosh", 
        "duche", 
        "dyke", 
        "ejaculate", 
        "ejaculated", 
        "ejaculates", 
        "ejaculating", 
        "ejaculatings", 
        "ejaculation", 
        "ejakulate", 
        "f u c k", 
        "f u c k e r", 
        "f4nny", 
        "fag", 
        "fagging", 
        "faggitt", 
        "faggot", 
        "faggs", 
        "fagot", 
        "fagots", 
        "fags", 
        "fanny", 
        "fannyflaps", 
        "fannyfucker", 
        "fanyy", 
        "fatass", 
        "fcuk", 
        "fcuker", 
        "fcuking", 
        "feck", 
        "fecker", 
        "felching", 
        "fellate", 
        "fellatio", 
        "fingerfuck", 
        "fingerfucked", 
        "fingerfucker", 
        "fingerfuckers", 
        "fingerfucking", 
        "fingerfucks", 
        "fistfuck", 
        "fistfucked", 
        "fistfucker", 
        "fistfuckers", 
        "fistfucking",
        "fistfuckings", 
        "fistfucks", 
        "flange", 
        "fook", 
        "fooker", 
        "fuck", 
        "fucka", 
        "fucked", 
        "fucker", 
        "fuckers", 
        "fuckhead", 
        "fuckheads", 
        "fuckin", 
        "fucking", 
        "fuckings", 
        "fuckingshitmotherfucker", 
        "fuckme", 
        "fucks", 
        "fuckwhit", 
        "fuckwit", 
        "fudge packer", 
        "fudgepacker", 
        "fuk", 
        "fuker", 
        "fukker", 
        "fukkin", 
        "fuks", 
        "fukwhit", 
        "fukwit", 
        "fux", 
        "fux0r", 
        "f_u_c_k", 
        "gangbang", 
        "gangbanged", 
        "gangbangs", 
        "gaylord", 
        "gaysex", 
        "goatse", 
        "God", 
        "god-dam", 
        "god-damned", 
        "goddamn", 
        "goddamned", 
        "hardcoresex", 
        "hell", 
        "heshe", 
        "hoar", 
        "hoare", 
        "hoer", 
        "homo", 
        "hore", 
        "horniest", 
        "horny", 
        "hotsex", 
        "jack-off", 
        "jackoff", 
        "jap", 
        "jerk-off", 
        "jism", 
        "jiz", 
        "jizm", 
        "jizz",
         "kawk", 
        "knob", 
        "knobead", 
        "knobed", 
        "knobend", 
        "knobhead", 
        "knobjocky", 
        "knobjokey", 
        "kock", 
        "kondum", 
        "kondums", 
        "kum", 
        "kummer", 
        "kumming", 
        "kums", 
        "kunilingus", 
        "l3i+ch", 
        "l3itch", 
        "labia", 
        "lust", 
        "lusting", 
        "m0f0", 
        "m0fo", 
        "m45terbate", 
        "ma5terb8", 
        "ma5terbate", 
        "masochist", 
        "master-bate", 
        "masterb8", 
        "masterbat*", 
        "masterbat3", 
        "masterbate", 
        "masterbation", 
        "masterbations", 
        "masturbate", 
        "mo-fo", 
        "mof0", 
        "mofo", 
        "mothafuck", 
        "mothafucka", 
        "mothafuckas", 
        "mothafuckaz", 
        "mothafucked", 
        "mothafucker", 
        "mothafuckers", 
        "mothafuckin", 
        "mothafucking", 
        "mothafuckings", 
        "mothafucks", 
        "mother fucker", 
        "motherfuck", 
        "motherfucked", 
        "motherfucker", 
        "motherfuckers", 
        "motherfuckin", 
        "motherfucking", 
        "motherfuckings", 
        "motherfuckka", 
        "motherfucks", 
        "muff", 
        "mutha", 
        "muthafecker", 
        "muthafuckker", 
        "muther", 
        "mutherfucker", 
        "n1gga", 
        "n1gger", 
        "nazi", 
        "nigg3r", 
        "nigg4h", 
        "nigga", 
        "niggah",
        "niggas", 
        "niggaz", 
        "nigger", 
        "niggers", 
        "nob", 
        "nob jokey", 
        "nobhead", 
        "nobjocky", 
        "nobjokey", 
        "numbnuts", 
        "nutsack", 
        "orgasim", 
        "orgasims", 
        "orgasm", 
        "orgasms", 
        "p0rn", 
        "pawn", 
        "pecker", 
        "penis", 
        "penisfucker", 
        "phonesex", 
        "phuck", 
        "phuk", 
        "phuked", 
        "phuking", 
        "phukked", 
        "phukking", 
        "phuks", 
        "phuq", 
        "pigfucker", 
        "pimpis", 
        "piss", 
        "pissed", 
        "pisser", 
        "pissers", 
        "pisses", 
        "pissflaps", 
        "pissin", 
        "pissing", 
        "pissoff", 
        "poop", 
        "porn", 
        "porno", 
        "pornography", 
        "pornos", 
        "prick", 
        "pricks", 
        "pron", 
        "pube", 
        "pusse", 
        "pussi", 
        "pussies", 
        "pussy", 
        "pussys", 
        "rectum", 
        "retard", 
        "rimjaw", 
        "rimming", 
        "s hit", 
        "s.o.b.", 
        "sadist", 
        "schlong", 
        "screwing", 
        "scroat", 
        "scrote", 
        "scrotum", 
        "semen", 
        "sex", 
        "sh!+", 
        "sh!t", 
        "sh1t", 
        "shag", 
        "shagger", 
        "shaggin", 
        "shagging", 
        "shemale", 
        "shi+", 
        "shit", 
        "shitdick", 
        "shite", 
        "shited", 
        "shitey", 
        "shitfuck", 
        "shitfull", 
        "shithead", 
        "shiting", 
        "shitings", 
        "shits", 
        "shitted", 
        "shitter", 
        "shitters", 
        "shitting", 
        "shittings", 
        "shitty", 
        "skank", 
        "slut", 
        "sluts", 
        "smegma", 
        "smut", 
        "snatch", 
        "son-of-a-bitch", 
        "spac", 
        "spunk", 
        "s_h_i_t", 
        "t1tt1e5", 
        "t1tties", 
        "teets", 
        "teez", 
        "testical", 
        "testicle", 
        "tit", 
        "titfuck", 
        "tits", 
        "titt", 
        "tittie5", 
        "tittiefucker", 
        "titties", 
        "tittyfuck", 
        "tittywank", 
        "titwank", 
        "tosser", 
        "turd", 
        "tw4t", 
        "twat", 
        "twathead", 
        "twatty", 
        "twunt", 
        "twunter", 
        "v14gra", 
        "v1gra", 
        "vagina", 
        "viagra", 
        "vulva", 
        "w00se", 
        "wang", 
        "wank", 
        "wanker", 
        "wanky", 
        "whoar", 
        "whore", 
        "willies", 
        "willy", 
        "xrated", 
        "xxx",
    }
--