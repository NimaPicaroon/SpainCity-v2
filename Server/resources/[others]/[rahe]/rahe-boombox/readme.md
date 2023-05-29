Installation process of the RAHE Boombox System.

Requirements:
* oxmysql (minimum version 2.0.0) (https://github.com/overextended/oxmysql)
* ox_lib (tested version 2.3.3) (https://github.com/overextended/ox_lib)
* xsound (tested version 1.4.1, probably will work with older versions aswell) (https://github.com/Xogy/xsound)

Strongly recommended:
* Latest MariaDB as your database (some older MySQL versions might have issues)
* Basic knowledge of coding

Installing rahe-boombox:
2. Move 'rahe-boombox' into your server resources folder
3. Run the SQL file 'db.sql' in your database client (HeidiSQL recommended)
4. Add 'ensure rahe-boombox' to your server config
5. Open the file 'shared.lua' in the folder rahe-boombox/config
6. On line 4, set the framework you are using:
    * If you're using ESX, set line 4 to: framework = 'ESX'
    * If you're using QB, set line 4 to: framework = 'QB'.
    * If you're using any other framework (or custom), set line 4 to: framework = 'CUSTOM'
7. RECOMMENDED, not necessary - setting up your Youtube API key
    * Get your api key following our tutorial in config/server.lua (somewhere around lines 41-54)
    * Insert your Youtube API key to config/server.lua in youtubeApiKey variable

Resource starting order (oxmysql should start first):
1. oxmysql
2. ox_lib
3. xsound
4. rahe-boombox

Unencrypted, editable files in rahe-boombox:
* /api/client.lua
* /api/server.lua
* /config/client.lua
* /config/server.lua
* /config/shared.lua
* /config/translations.lua

Using rahe-boombox:
* Commands available:
    * /music - Opens menu for creating new music entities
    * /boomboxes - Opens admin menu which includes overview of boomboxes along with actions

These commands can be made into items. Examples are provided in the API files depending on your framework.

If you're encountering errors, these might be your mistakes:
* You are not running oxmysql version of at least 2.0.0. Check your version in oxmysql/fxmanifest.lua
* You downloaded ox_lib source, not release. You must download the release from https://github.com/overextended/ox_lib/releases (ox_lib.zip)
* You downloaded oxmysql source, not release. You must download the relase from https://github.com/overextended/oxmysql/releases (oxmysql.zip)


**IMPORTANT!**
**THESE THINGS ARE NOT IMPLEMENTED BY DEFAULT BECAUSE EVERYONE HAS DIFFERENT IMPLEMENTATIONS**

THINGS TO INTEGRATE YOURSELF:

* If you want to use the built in /music command for creating new entities, everything will work out of the box.
* You don't need to setup anything manually.

* We offer one more option, which we are using in our RP server. This is called inventoryBased (in config/server.lua)
    * This means that player has to have the required item in his inventory to create a new boombox.
    * Every time player places the boombox down, the item is removed from him.
    * Every time he stores the boombox, the item is returned to the player.
    * You can sell these items in your Tebex store or in your ingame store. Choice is up to you.

**If you decide to use inventoryBased setting, this is what you should do:**
* Check your config/server.lua file speakerTypes variable. There is a list of available speaker types.
    Every entry should have an itemId. You should create these items in your inventory resource. Make sure the itemIds match.
    Then you should make these items usable. There are how it should be done in QB or ESX in api/server.lua
* Make the items available for players (so they can get them from somewhere).
* Fill out the 'removeItem' function so the item can be removed from the player after it is used and placed down.
* Fill out the 'giveItem' function so the item can be given to player after it is stored.

Join our Discord for support and future updates / patch notes: https://discord.gg/Ckm4tVbmRE