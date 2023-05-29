LOCALES = {}
setLocales = (locales) => {
    LOCALES = locales;
}
getLocale = (translation) => {
    for (let i = 0; i < LOCALES.length; i++) {
        if (LOCALES[i].name == translation) {
            return LOCALES[i].label;
        };
    };
}

let ResourceName = 'eden_airsoft';
var maps, weapons;
let lobbyID, TeamID, mapping, SWeapon, lobbyname, roundNum, TotalPlayers;
let page = 0;

// Create Lobby Functions
function onCreateLobby() {
    $('.question').hide();
    $('div[name="createlobby"]').show();
};

function getMapFromName(name) {
    for (let i = 0; i < maps.length; i++) {
        if (maps[i].name == name) {
            return maps[i];
        };
    };
};

function onChangeMap() {
    let newSelect = $('#map').val();
    let map = getMapFromName(newSelect);
    $('.map-img').attr('src', './assets/imgs/' + map.img)
};

function getIndexFromWeaponImage(image) {
    for (let i = 0; i < weapons.length; i++) {
        if (weapons[i].image == image) {
            return i;
        };
    };
    return 0;
};

function LeftWeaponButton() {
    let nowSelect = $('.weapon-select img').attr('src').split('/');
    setWeaponImg(getIndexFromWeaponImage(nowSelect[3]) - 1);
};

function RightWeaponButton() {
    let nowSelect = $('.weapon-select img').attr('src').split('/');
    setWeaponImg(getIndexFromWeaponImage(nowSelect[3]) + 1);
};

function setWeaponImg(index) {
    if (index === undefined || index === null) index = 0;

    if (index < 0) index = weapons.length - 1;
    if (index >= weapons.length) index = 0;

    $('.weapon-select img').attr('src', './assets/weapons/' + weapons[index].image);
    $('.weapon-name').attr('id', weapons[index].image.split('.')[0]);
    $('.weapon-name').html(weapons[index].label /*.split('.')[0].replace('_', ' '))*/);
};

function onSubmit() {
    lobbyname = $('#lname');
    lobbypass = $('#lbpass');
    roundNum = $('#round');
    if (lobbyname.length != 0 && lobbyname.val().length > lobbyname.attr('minlength')) {
        let max = roundNum.attr('max');
        if (roundNum.val() > 0 && parseInt(roundNum.val()) <= parseInt(max)) {
            fetch(`https://${ResourceName}/CreateLobby`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    mapName: mapping,
                    weaponModel: SWeapon,
                    lobbyName: lobbyname.val(),
                    roundNum: roundNum.val(),
                    Password: lobbypass.val()
                })
            }).then(resp => resp.json()).then(lobid => {
                lobbyID = lobid
            });
            page = 100;
            TeamID = 0;
            $('div[name="createlobby"]').hide();
            $('#startButton').show();
            $('div[name="main"]').show();
        } else {
            roundNum.val(max);
        };
    } else {
        $('#lname').css('border-color', 'red');
    };
};

// Join In Lobby Functions
function onJoinLobby() {
    $('.question').hide();
    $('.list').show();
    fetch(`https://${ResourceName}/LobbyList`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(data => {
        let jdata = JSON.parse(data);
        if (jdata.length != 0) {
            for (let i = 0; i < jdata.length; i++) {
                if (jdata[i].pass == null || jdata[i].pass == "") {
                    $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-' + jdata[i].LobbyId + '" onclick="onSelectLobby(this.id)">' + jdata[i].name + ' | ' + jdata[i].map + ' | ' + jdata[i].weapon + '</h1>');
                } else {
                    $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-' + jdata[i].LobbyId + '-locked" onclick="onSelectLobby(this.id)">' + jdata[i].name + ' | ' + jdata[i].map + ' | ' + getLocale('nui_room_locked') + '</h1>');
                };
            };
        } else {
            $('.boxlobbeys').append(`<h1 class="lobbeys">${getLocale('nui_no_rooms')}</h1>`);
        };
    });
};

function onSelectLobby(id) {
    let lid = id.split('-');
    lobbyID = lid[1];
    if (lid[2] == 'locked') {
        $('.lobby-password').show();
        $('.lobbeys').hide();
        page = 85;
    } else {
        page = 0;
        TeamID = 0;
        $('.list').hide();
        $('#startButton').hide();
        $('div[name="main"]').show();
        fetch(`https://${ResourceName}/JoinLobby`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                LobbyId: lobbyID
            })
        }).then(resp => resp.json()).then(data => {
            let jdata = JSON.parse(data);
            for (let i = 0; i < 3; i++) {
                let team = jdata[i];
                for (let i2 = 0; i2 < team.length; i2++) {
                    if (i == 0) {
                        $('.joiners').append(team[i2].value);
                    } else if (i == 1) {
                        $('.teamone').append(team[i2].value);
                    } else {
                        $('.teamtwo').append(team[i2].value);
                    };
                };
            };
        });
    };
};

function onJoin(id) {
    let tid = id.split('-')[1];
    fetch(`https://${ResourceName}/SwitchTeam`,
        {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                LobbyId: lobbyID,
                LastTeam: TeamID,
                JoinTeam: tid
            })
        }).then(resp => resp.json()).then(data => {
            if (data) {
                if (TeamID != 0) {
                    $('#TM-' + TeamID).show();
                };
                $('#' + id).hide();
                page = 100;
                TeamID = tid;
            };
        })
};

// In Lobby Functions
function onStart() {
    page = 0;
    fetch(`https://${ResourceName}/StartMatch`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID
        })
    }).then(resp => resp.json());
};

function onReady() {
    $('#ReadyButton').hide();
    $('#UnReadyButton').show();
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: true
        })
    }).then(resp => resp.json());
};

function onUnready() {
    $('#UnReadyButton').hide();
    $('#ReadyButton').show();
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: false
        })
    }).then(resp => resp.json());
};

function onLeave() {
    page = 0;
    $('.lobby').hide();
    fetch(`https://${ResourceName}/QuitLobby`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID
        })
    }).then(resp => resp.json());
    TeamID = 0;
    lobbyID = 0;
    location.reload();
};

// Other Functions
function onNext() {
    if (page == 0) {
        $('#cancelButton').hide();
        $('#backButton').show();
        $('.selectmap').hide();
        $('.weapon-select').show();
        mapping = $('#map').val();
        page = page + 1;
    } else {
        $('#nextButton').hide();
        $('#submitButton').show();
        $('.weapon-select').hide();
        $('.setting').show();
        SWeapon = $('.weapon-name').attr('id');
        page = page + 1;
    };
};

function onBack() {
    if (page == 2) {
        $('#nextButton').show();
        $('#submitButton').hide();
        $('.weapon-select').show();
        $('.setting').hide();
        page = page - 1;
    } else {
        $('#cancelButton').show();
        $('#backButton').hide();
        $('.selectmap').show();
        $('.weapon-select').hide();
        page = page - 1;
    };
};

function onCancel() {
    page = 0;
    $('.lobby').hide();
    fetch(`https://${ResourceName}/QuitFromMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json());
    location.reload()
};

function onBackQuestion() {
    if (page != 85) {
        $('.question').show();
        $('.list').hide();
        $('.boxlobbeys').find('h1').remove();
    } else {
        page = 0
        $('.lobby-password').hide();
        $('.lobbeys').show();
    };
};

// Keyup Event
document.onkeyup = function (data) {
    if (data.which == 27) { // ESC Press
        if (page == 0) {
            fetch(`https://${ResourceName}/QuitFromMenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            }).then(resp => resp.json());
            location.reload();
        };
    } else if (data.which == 13) {
        if (page == 85) {
            let pass = $('#lpass').val();
            if (pass != null || pass != "") {
                fetch(`https://${ResourceName}/GetLobbyPassword`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({
                        LobbyId: lobbyID,
                        Password: pass
                    })
                }).then(resp => resp.json()).then(data => {
                    if (data == true) {
                        page = 0;
                        TeamID = 0;
                        $('.list').hide();
                        $('#startButton').hide();
                        $('div[name="main"]').show();
                        fetch(`https://${ResourceName}/JoinLobby`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: JSON.stringify({
                                LobbyId: lobbyID
                            })
                        }).then(resp => resp.json()).then(data => {
                            let jdata = JSON.parse(data);
                            for (let i = 0; i < 3; i++) {
                                let team = jdata[i];
                                for (let i2 = 0; i2 < team.length; i2++) {
                                    if (i == 0) {
                                        $('.joiners').append(team[i2].value);
                                    } else if (i == 1) {
                                        $('.teamone').append(team[i2].value);
                                    } else {
                                        $('.teamtwo').append(team[i2].value);
                                    };
                                };
                            };
                        });
                    } else {
                        $('#lpass').css('border-color', 'red');
                    };
                });
            };
        };
    };
};

let SecondCounter = -1

setInterval(() => {
    if (SecondCounter != -1) {
        let date = new Date(0);
        date.setSeconds(SecondCounter);
        let timeString = date.toISOString().substr(14, 8);
        $('#timer').html(timeString.replace(".00", ""));
        SecondCounter--;
    }
}, 1000);

// NUI Sended Event
window.addEventListener("message", function (event) {
    if (event.data.type == 'loadData') {
        if (event.data.locales) {
            setLocales(event.data.locales);
            loadDefaultUI();
        }

        if (event.data.maps) {
            maps = event.data.maps;
            $('#map').append(`<option value='none' autofocus disabled>${getLocale('nui_choose_map')}</option>`);
            maps.forEach((element) => {
                $('#map').append(`<option value='${element.name}'>${element.label}</option>`);
            });
            $('.map-img').attr('src', './assets/imgs/' + maps[0].img)
        }

        if (event.data.weapons) {
            weapons = event.data.weapons;
            setWeaponImg(0);
        }
    }
    if (event.data.type == 'show') {
        if (event.data.show) {
            $('.lobby').show();
        } else {
            $('.lobby').hide();
            this.location.reload();
        };
    };
    if (event.data.action == 'JoinTeam') {
        if (event.data.team == 0) {
            $('.joiners').append(event.data.value);
        } else if (event.data.team == 1) {
            $('.teamone').append(event.data.value);
        } else {
            $('.teamtwo').append(event.data.value);
        };
    }
    else if (event.data.action == 'LeftTeam') {
        $('#' + event.data.player).remove();
    }
    else if (event.data.action == 'ToggleReadyPlayer') {
        $('#' + event.data.player).html(event.data.value);
    }
    else if (event.data.action == "RefreshLobbies") {
        $('.boxlobbeys').find('h1').remove();
        onJoinLobby()
    }
    else if (event.data.action == "ShowGameHUD") {
        if (event.data.value) $('.gamehud').show();
        else $('.gamehud').hide();
    }
    else if (event.data.action == "SpectatePlayer") {
        if (event.data.value) {
            $('#spectatedplayer').html(event.data.value);
            $('#spectatedplayer').show();
        }
        else $('#spectatedplayer').hide();
    }
    else if (event.data.action == "UpdateTeams") {
        if (event.data.team1 && event.data.team2) {
            $('#blueteam').html(event.data.team1);
            $('#redteam').html(event.data.team2);
            $('#blueteam').show();
            $('#redteam').show();
        }
        else {
            $('#blueteam').hide();
            $('#redteam').hide();
        }
    }
    else if (event.data.action == "UpdateTotalRounds") {
        if (event.data.value) {
            $('#round-count').html(getLocale('nui_round') + " " + parseInt(event.data.value));
            $('#round-count').show();
        }
        else $('#round-count').hide();
    }
    else if (event.data.action == "ResetRoundTimer") {
        if (event.data.value) {
            //$('#timer').css('background-color', 'rgba(' + event.data.r + ', ' + event.data.g + ', ' + event.data.b + ', 0.8)');
            $('#timer').show();
            SecondCounter = event.data.value;
        }
        else {
            $('#timer').hide();
            SecondCounter = -1
        }
    }
    else if (event.data.topKillers) {
        for (let i = 0; i < 5; i++) {
            if (event.data.topKillers[i].team == 0) {
                $('#topcat' + (i + 1)).fadeOut(850);
            }
            else {
                $('#topcat' + (i + 1)).fadeIn(850);
                if (event.data.topKillers[i].team == 1) {
                    $('#top' + (i + 1) + 'btn').css('background-color', '#427df0');
                    $('#top' + (i + 1) + 'a').css('background-color', '#427df0');
                }
                else if (event.data.topKillers[i].team == 2) {
                    $('#top' + (i + 1) + 'btn').css('background-color', '#fe4f4e');
                    $('#top' + (i + 1) + 'a').css('background-color', '#fe4f4e');
                }
            }
            $('#hud #top' + (i + 1)).text(event.data.topKillers[i].name);
            $('#hud #top' + (i + 1) + 'a #top' + (i + 1) + 'b').text(event.data.topKillers[i].kills);
        }
    }
});

function loadDefaultUI() {
    $('#script_title').html(getLocale('nui_title'));
    $('#new_room').html(getLocale('nui_create_room'));
    $('#join_room').html(getLocale('nui_join_room'));
    $('#lpass_label').html(getLocale('nui_lobby_password') + ':');
    $('#back_question').html(getLocale('nui_back_question'));
    $('#choosemap_title').html(getLocale('nui_choose_map'));
    $('#choose_weapon').html(getLocale('nui_choose_weapon'));
    $('#room_config').html(getLocale('nui_room_config'));
    $('#room_name').html(getLocale('nui_room_name'));
    $("#lname").attr("placeholder", getLocale('nui_room_name'));
    $('#room_pwd').html(getLocale('nui_room_pwd'));
    $("#lbpass").attr("placeholder", getLocale('nui_room_pwd'));
    $('#room_rounds').html(getLocale('nui_room_rounds'));
    $("#round").attr("placeholder", getLocale('nui_room_rounds'));
    $('#cancelButton').html(getLocale('nui_cancel'));
    $('#backButton').html(getLocale('nui_back_question'));
    $('#nextButton').html(getLocale('nui_continue'));
    $('#submitButton').html(getLocale('nui_confirm'));
    $('#room_players_title').html(getLocale('nui_room_players'));
    $('#team1_title').html(getLocale('nui_team') + ' 1');
    $('#team2_title').html(getLocale('nui_team') + ' 2');
    $('#TM-1').html(getLocale('nui_join'));
    $('#TM-2').html(getLocale('nui_join'));
    $('#ReadyButton').html(getLocale('nui_ready'));
    $('#UnReadyButton').html(getLocale('nui_unready'));
    $('#exitButton').html(getLocale('nui_exit'));
    $('#startButton').html(getLocale('nui_start'));
};