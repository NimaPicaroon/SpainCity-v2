# <center>Xander Twitch reward system</center>

```
This awesome module will allow streamers on your server to be rewarded for broadcasting on the Twitch platform. The module is quite adaptive. You can configure all the necessary settings. Everything that is needed in the code is commented. It can work as a standalone system or be integrated into an existing one. For this, the code provides support for ESX, QBCore and NDCore, as well as many exported functions.
```

Features ⭐️

-   Completely independent system.
-   Easy to install and configure.
-   ESX, QBCore and NDCore support is enabled with a single parameter in the configuration file.
-   A flexible amount of the reward, which allows you to set both a static figure for the fact of the stream itself, and for each viewer.
-   Checking the streamer category on Twitch as well as the broadcast title will allow you to better promote your server due to streamers.
-   The event system will allow you to connect the module anywhere and any way with a couple of lines of code

---

### Example of default chat notify

![alt text](chat_example.jpg 'Title')

The text is just as easily customizable in the settings file

---

## Exports list

| Export name          | Argmunents                             | Description                             |
| -------------------- | -------------------------------------- | --------------------------------------- |
| addStreamer          | int source, string login               | Add one streamer to system              |
| removeStreamer       | int source                             | Remove streamer from system             |
| disableTwitchCommand | bool status                            | Temp Enable/Disable twitch chat command |
| setTwitchAppConfig   | string client_id, string client_secret | Send new Twitch app config              |

The exported functions are easy to use. Example:

```LUA
--LUA
------------------------
local source = 1
exports["xander_twitch_reward_system"]:addStreamer(source, 'XanderWP') -- Calling this command will add a streamer with the login XanderWP to the system, linking it to the player with game ID 1
------------------------
local source = 1
exports["xander_twitch_reward_system"]:removeStreamer(source) -- Calling this command will remove streamer from the system
------------------------
```

---

## Input Events list

| Export name          | Argmunents                             | Description                             |
| -------------------- | -------------------------------------- | --------------------------------------- |
| addStreamer          | int source, string login               | Add one streamer to system              |
| removeStreamer       | int source                             | Remove streamer from system             |
| disableTwitchCommand | bool status                            | Temp Enable/Disable twitch chat command |
| setTwitchAppConfig   | string client_id, string client_secret | Send new Twitch app config              |

The events are the same as the exported methods for ease of use. Example:

```LUA
---------- LUA ----------
-------------------------
local source = 1
TriggerEvent("addStreamer", source, "XanderWP") -- Calling this event will add a streamer with the login XanderWP to the system, linking it to the player with game ID 1
-------------------------
local source = 1
TriggerEvent("removeStreamer", source) -- Calling this event will remove streamer from the system
-------------------------
```

```JS
// ---- JavaScript ---- //
// -------------------- //
let source = 1;
emit("addStreamer", source, "XanderWP"); // Calling this event will add a streamer with the login XanderWP to the system, linking it to the player with game ID 1
// -------------------- //
let source = 1;
emit("removeStreamer", source); // Calling this event will remove streamer from the system
// -------------------- //
```

---

## How to install the script?

Everything is very simple. It is enough to unpack it into a folder with resources and connect it to the `server.cfg` by adding the command:

```
ensure xander_twitch_reward_system
```

---

## List of settings in the configuration file

| Name                                | Type of value   | Description |
| ----------------------------------- | --------------- | ----------- |
| client_id                           | string          | Twitch application Client ID          |
| client_secret                       | string          | Twitch application Secret Key          |
| tick_minutes                        | int             | Interval for check streamers          |
| min_online                          | integer         | Minimum number of viewers          |
| game_id                             | string          | Twitch Game category (32982 - GTA:V by default)         |
| title_keywords                      | Array of string | List of keywords that are required in the title to receive an award. At least one match is required. Case insensitive          |
| reward_for_online                   | integer         | Base Reward          |
| reward_for_viewer                   | integer         | Award for each viewer          |
| chat_command                        | string          | Chat command with which the player can specify their Twitch login. If you use a third-party database with logins, it is recommended to disable it. To disable, just leave an empty line.          |
| chat_command_type                   | string          | Chat command work type. Can be `chat` or `oauth`. We recommend using the second option so that the player cannot specify someone else's Twitch profile          |
| chat_oauth_base_url                 | string          | Base URL for redirect user in browser when chat command work and type set to `oauth`          |
| chat_command_answer_no_login        | string          | Chat message that is sent to the player if he called the command to bind Twitch without specifying a login          |
| chat_command_answer_incorrect_login | string          | Chat message that is sent to the player if he called the command to bind Twitch with an incorrect login          |
| chat_command_answer_success         | string          | Chat message sent to the player after successfully linking Twitch          |
| custom_event                        | string          | An event to which data on active streamers is sent to connect the reward to any of your systems          |
| custom_client_event                 | string          | An event that sends data to the streamer in the client code          |
| reward_chat_notify                  | boolean         | Enable or disable the notification of receiving a reward in the chat          |
| reward_chat_notify_text             | string          | The text of the message about the award. Word ||money|| will be automatically replaced by the received amount          |
| esx_support                         | boolean         | Enable or disable connection to ESX framework. If ESX is not detected - this parameter will be ignored anyway          |
| esx_reward_type                     | string          | Type of money for reward in ESX framework. Can be `money` or `bank`          |
| ndcore_support                     | string          | Enable or disable connection to NDCore framework. If NDCore is not detected - this parameter will be ignored anyway          |
| qbcore_support                     | string          | Enable or disable connection to QBCore framework. If QBCore is not detected - this parameter will be ignored anyway          |

---

## How to register the Twitch app

Application registration is available in `Twitch Dev console`


https://dev.twitch.tv/console/apps

If you use the option of specifying a login through authorization, you must specify the redirect page in the application settings. Example - `http://localhost:30120`/xander_twitch_reward_system/twitch

The selected part depends on the address for connecting to the server, as well as the value in the config parameter `chat_oauth_base_url`

---

## Other data

|                          |                                         |
| ------------------------ | --------------------------------------- |
| Code accessible          | Config                                  |
| Source language          | LUA                                     |
| Subscription-based       | No                                      |
| Lines                    | ~750                                    |
| Requirements             | No (Custom frameworks Support optional) |
| Support                  | Yes                                     |
| Future Updates           | Free                                    |
