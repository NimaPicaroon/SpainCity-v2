var selectedChar = null;
var WelcomePercentage = "30vh"
qbMultiCharacters = {}
var Loaded = false;
var EnableDeleteButton = false;
var background = document.getElementById("musica_fondo");
var confirmar = document.getElementById("click");
var consejoAud = document.getElementById("click");
var transition = document.getElementById("click");
var swipe = document.getElementById("click");
var click = document.getElementById("click");
var over_button = document.getElementById("click");

$('.character-info').hide()

window.addEventListener('message', function (event) {
    var data = event.data;

    if (data.action == "ui") {

        if (data.toggle) {
            $('.container').show();
            $('.jugadores-on').hide();
            $('.bottombar').show();
            $('.imagenlogo').hide();
            $('.topbar').show();
            $('.topbar').css("top", "-50%");
            $('.bottombar').css("top", "50%");
            $('.fondocolor').hide();
            $('.btn-iniciar').hide();
            $(".welcomescreen").fadeIn(150);
            qbMultiCharacters.resetAll();

            var originalText = "Retrieving player data";
            var loadingProgress = 0;
            var loadingDots = 0;
            $("#loading-text").html(originalText);
            
            $('.fondocolor').show();
            var DotsInterval = setInterval(function() {
                $("#loading-text").append(".");
                loadingDots++;
                loadingProgress++;
                if (loadingProgress == 3) {
                    originalText = "Validating player data"
                    $("#loading-text").html(originalText);
                }
                if (loadingProgress == 4) {
                    originalText = "Retrieving characters"
                    $("#loading-text").html(originalText);
                }
                if (loadingProgress == 6) {
                    originalText = "Validating characters"
                    $("#loading-text").html(originalText);
                }
                if(loadingDots == 4) {
                    $("#loading-text").html(originalText);
                    loadingDots = 0;
                }
            }, 3000);

            $('.logo').css('transform', 'translate(-50%, -50%) scale(1.5)')
            $('.welcome-button').css({
                'transition': '0s',
                'opacity': '0'
            })
            $('.welcome-loader').hide();

            setTimeout(function(){
                $('.logo').css('transform', 'translate(-50%, -50%) scale(1)')
                setTimeout(function(){
                    $('.welcome-button').css({
                        'transition': '.5s',
                        'opacity': '1'
                    })

                    $('.welcome-button').on('click', function(){

                        $('.welcome-button').css('opacity', '0')
                        setTimeout(function(){

                            $('.logo').css({'top': '50%', 'width': '20vw'});

                            setTimeout(function(){
                                $('.welcome-loader').fadeIn(500);

                                setTimeout(function(){
                                    $('.logo').css({'top': '2.5vw', 'left': '2.5vw', 'transform': 'none', 'width': '8vw', 'opacity': '.5', 'transition': '.75s'});
                                    $('.welcome').fadeOut(1000);
                                    qbMultiCharacters.fadeIn('.characters-list', 400);
                                    $('.jugadores-on').fadeIn();
                                    $('.fondocolor').hide();
                                    qbMultiCharacters.fadeIn('.imagenlogo', 1700);
                                    $.post('https://MultiCharacters/removeBlur');
                                }, 2500);
                            }, 250)

                        }, 500)

                    });
                }, 500)
            }, 1000)

            setTimeout(function(){
                setCharactersList()
                $.post('https://MultiCharacters/setupCharacters');

                $(".welcomescreen").fadeOut(2000);
            }, 2000);
            // background.volume = 0.3;
            // background.currentTime = 0
            // background.play();
        } else {
            $('.container').fadeOut(250);
            qbMultiCharacters.resetAll();
        }
    }

    if (data.action == "setupCharacters") {
        setupCharacters(event.data.characters)
    }

    if (data.action == "setupCharInfo") {
        setupCharInfo(event.data.chardata)
    }
    if (data.action == "stopMusic") {
        musicFadeOut();
    }
});

$('.continue-btn').click(function(e){
    e.preventDefault();
});

$('.disconnect-btn').click(function(e){
    e.preventDefault();

    $.post('https://MultiCharacters/closeUI');
    $.post('https://MultiCharacters/disconnectButton');
});

$(".btn-iniciar").on("click", function() {
    background.volume = 0.3;
        $(".title-screen").fadeOut(300, function() {
            qbMultiCharacters.fadeIn('.character-info', 400);
            qbMultiCharacters.fadeIn('.characters-list', 400);
            $('.jugadores-on').fadeIn();
            $('.fondocolor').hide();
            qbMultiCharacters.fadeInDown('.imagenlogo', '0%', 1700);
            $.post('https://MultiCharacters/removeBlur');
        })
});

function setupCharInfo(cData) {

    $('.character-info').fadeIn(500)

    if (cData == 'empty') {
        $('.character-info').html('El jugador seleccionado no esta creado');
    } else {
        var gender = "Hombre"
        if (cData.identity.gender == "M") { gender = "Mujer" }
        $('.character-info').html(
        '<div class="character-info-box"><span id="info-label">Nombre: </span><span class="char-info-js">'+cData.identity.name+' '+cData.identity.lastname+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Fecha de nacimiento: </span><span class="char-info-js">'+cData.identity.birthdate+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Sexo: </span><span class="char-info-js">'+gender+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Nacionalidad: </span><span class="char-info-js">'+cData.identity.nacionality+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Trabajo: </span><span class="char-info-js">'+cData.job.label+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Efectivo: </span><span class="char-info-js">&#36; '+cData.money.money+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Dinero en el banco: </span><span class="char-info-js">&#36; '+cData.money.bank+'</span></div>' +
        '<div class="character-info-box"><span id="info-label">Número de teléfono: </span><span class="char-info-js">'+cData.phone+'</span></div>');
    }
}

function setupCharacters(characters) {
    $.each(characters, function(index, char){
        $('#char-1').html("");
        setTimeout(function(){
            $('#char-1').html('<span id="slot-name">'+char.identity.name+' '+char.identity.lastname+'</span>');
            $('#char-1').data('cData', char)
            $('#char-1').data('cid', 1)
        }, 100)
    })
}

$(document).on('click', '#close-log', function(e){
    e.preventDefault();
    selectedLog = null;
    $('.welcomescreen').css("filter", "none");
    $('.server-log').css("filter", "none");
    $('.server-log-info').fadeOut(250);
    logOpen = false;
});

$(document).on('click', '.character', function(e) {
    var cDataPed = $(this).data('cData');
    e.preventDefault();
    if (selectedChar === null) {
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("char-selected");
            setupCharInfo('empty')
            $("#play").html("Crear");
            $("#play").css({"display":"flex"});
            $("#delete").css({"display":"none"});
            $.post('https://MultiCharacters/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        } else {
            $(selectedChar).addClass("char-selected");
            setupCharInfo($(this).data('cData'))
            $("#play").html('Jugar');
            $("#delete-text").html('<i class="fa fa-trash" aria-hidden="true"></i> Delete');
            $("#play").css({"display":"flex"});
            if (EnableDeleteButton) {
                $("#delete").css({"display":"block"});
            }
            $.post('https://MultiCharacters/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        }
    } else if ($(selectedChar).attr('id') !== $(this).attr('id')) {
        $(selectedChar).removeClass("char-selected");
        selectedChar = $(this);
        if ((selectedChar).data('cid') == "") {
            $(selectedChar).addClass("char-selected");
            setupCharInfo('empty')
            $("#play").html('Registarse');
            $("#play").css({"display":"flex"});
            $("#delete").css({"display":"none"});
            $.post('https://MultiCharacters/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        } else {
            $(selectedChar).addClass("char-selected");
            setupCharInfo($(this).data('cData'))
            $("#play").html('Jugar');
            $("#delete-text").html('<i class="fa fa-trash" aria-hidden="true"></i> Delete');
            $("#play").css({"display":"flex"});
            if (EnableDeleteButton) {
                $("#delete").css({"display":"block"});
            }
            $.post('https://MultiCharacters/cDataPed', JSON.stringify({
                cData: cDataPed
            }));
        }
    }
});

var entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '': '&#x60;',
    '=': '&#x3D;'
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'=/]/g, function (s) {
        return entityMap[s];
    });
}
function hasWhiteSpace(s) {
    return /\s/g.test(s);
}

$('#nationality').keyup(function() {
    var nationalityValue = $(this).val();
    if(nationalityValue.indexOf(' ') !== -1) {
        $(this).val(nationalityValue.replace(' ', ''))
    }
});

$(document).on('click', '#create', function (e) {
    e.preventDefault();

    let firstname= escapeHtml($('#first_name').val())
    let lastname= escapeHtml($('#last_name').val())
    let nationality= escapeHtml($('#nationality').val())
    let birthdate= escapeHtml($('#birthdate').val())
    let gender= escapeHtml($('select[name=gender]').val())
    let cid = escapeHtml($(selectedChar).attr('id').replace('char-', ''))
    const regTest = new RegExp(profList.join('|'), 'i');
    //An Ugly check of null objects

    if (!firstname || !lastname || !nationality || !birthdate || hasWhiteSpace(firstname) || hasWhiteSpace(nationality) ){
        console.log("FIELDS REQUIRED")
        return false;
    }

    $.post('https://MultiCharacters/createNewCharacter', JSON.stringify({
        name: firstname,
        lastname: lastname,
        nacionality: nationality,
        birthdate: birthdate,
        gender: gender,
    }));
    $(".container").fadeOut(150);
    $('.characters-list').css("filter", "none");
    $('.character-info').css("filter", "none");
    qbMultiCharacters.fadeOut('.character-register', 400);
    refreshCharacters()

});

$(document).on('click', '#accept-delete', function(e){
    $.post('https://MultiCharacters/removeCharacter', JSON.stringify({}));
    $('.character-delete').fadeOut(150);
    $('.characters-block').css("filter", "none");
    refreshCharacters();
});

$(document).on('click', '#cancel-delete', function(e){
    e.preventDefault();
    $('.characters-block').css("filter", "none");
    $('.character-delete').fadeOut(150);
});

function setCharactersList() {
    var htmlResult = '<div class="character-list-header"><p>Selecciona un personaje</p></div>'
    htmlResult += '<div class="character" id="char-1" data-cid=""><span id="slot-name">Slot Vacio<span id="cid"></span></span></div>'
    htmlResult += '<div class="character-btn" id="play">Select a character</div>'
    $('.characters-list').html(htmlResult)
}

function refreshCharacters() {
    var htmlResult = ''
    htmlResult += '<div class="character" id="char-1" data-cid=""><span id="slot-name">Empty Slot<span id="cid"></span></span></div>'

    htmlResult += '<div class="character-btn" id="play">Select a character</div><div class="character-btn" id="delete"><p id="delete-text">Select a character</p></div>'
    $('.characters-list').html(htmlResult)
    
    setTimeout(function(){
        $(selectedChar).removeClass("char-selected");
        selectedChar = null;
        $.post('https://MultiCharacters/setupCharacters');
        $("#delete").css({"display":"none"});
        $("#play").css({"display":"none"});
        qbMultiCharacters.resetAll();
    }, 100)
}

$("#close-reg").click(function (e) {
    e.preventDefault();
    $('.characters-list').css("filter", "none")
    $('.character-info').css("filter", "none")
    //mostrar
    qbMultiCharacters.fadeIn('.character-info', 400);
    qbMultiCharacters.fadeIn('.characters-list', 400);
    qbMultiCharacters.fadeOut('.character-register', 400);
})

$("#close-del").click(function (e) {
    e.preventDefault();
    $('.characters-block').css("filter", "none");
    $('.character-delete').fadeOut(150);
})

$(document).on('click', '#play', function(e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $.post('https://MultiCharacters/selectCharacter', JSON.stringify({
                cData: $(selectedChar).data('cData')
            }));
            setTimeout(function(){
                qbMultiCharacters.fadeOut('.characters-list', 400);
                qbMultiCharacters.fadeOut('.character-info', 400);
                qbMultiCharacters.resetAll();
            }, 1500);
        } else {
            $('.characters-list').css("filter", "blur(2px)")
            $('.character-info').css("filter", "blur(2px)")
            //qbMultiCharacters.fadeOutDown('.characters-list', "-40%", 400);
            qbMultiCharacters.fadeOutDown('.character-info', "-40%", 400);
            qbMultiCharacters.fadeIn('.character-register', 500);
        }
    }
});

$(document).on('click', '#delete', function(e) {
    e.preventDefault();
    var charData = $(selectedChar).data('cid');

    if (selectedChar !== null) {
        if (charData !== "") {
            $('.characters-block').css("filter", "blur(2px)")
            $('.character-delete').fadeIn(250);
            qbMultiCharacters.fadeInDown('.character-delete', '40%', 2500);
        }
        
    }
});

qbMultiCharacters.fadeOutUp = function(element, time) {
    $(element).css({"display":"block"}).animate({top: "-80.5%",}, time, function(){
        $(element).css({"display":"none"});
    });
}

qbMultiCharacters.fadeOutDown = function(element, percent, time) {
    if (percent !== undefined) {
        $(element).css({"display":"block"}).animate({top: percent,}, time, function(){
            $(element).css({"display":"none"});
        });
    } else {
        $(element).css({"display":"block"}).animate({top: "103.5%",}, time, function(){
            $(element).css({"display":"none"});
        });
    }
}

qbMultiCharacters.fadeInDown = function(element, percent, time) {
    $(element).css({"display":"block"}).animate({top: percent,}, time);
}

qbMultiCharacters.fadeInDown2 = function(element, percent, time) {
    $(element).css({"display":"block"}).animate({'margin-top': percent,}, time);
}

qbMultiCharacters.fadeIn = function(element, time){
    $(element).fadeIn(time)
}

qbMultiCharacters.fadeOut = function(element, time){
    $(element).fadeOut(time)
}


qbMultiCharacters.resetAll = function() {
    $('.characters-list').hide();
    $('.characters-list').css("top", "-40");
    $('.character-info').hide();
    $('.character-info').css("top", "-40");
    $('.welcomescreen').css("top", WelcomePercentage);
    $(".main-screen").fadeIn();
    $(".welcomescreen").fadeIn(300);
    $(".fondo-negro").fadeIn(0);
    $('.server-log').show();
    $('.server-log').css("top", "25%");
    selectedChar = null;
}

function musicFadeOut() {
    $(background).animate({ volume: 0 }, 3000);
}