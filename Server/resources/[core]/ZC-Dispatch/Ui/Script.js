$( document ).ready(function () {
    let currentAlert = 0;
    let maxAlerts = 0;
    let playSounds = true;
    let receiveAlerts = true;

    const trans = {
        ['police']: 'CNP',
        ['ambulance']: 'EMS',
        ['taxi']: 'Taxis',
    }

    window.addEventListener("message", function (event) {  
        const toggle = event.data.toggle;
        const toggleConfig = event.data.toggleConfig;
        const newAlert = event.data.newalert;
        const changeAlert = event.data.changealert;
        const responding = event.data.responding;

        if (event.data.updateAndResponding == true) {
            maxAlerts = event.data.totalcalls;

            $("#actualAlert").html(currentAlert+'<span id="maxAlerts" style="font-family: font; color: white; font-size: .4vw;">/'+maxAlerts+'</span>');
        }

        if (toggle == true) {
            $('.dispatch').fadeIn(300)
            $('#logo').attr('src','Assets/'+event.data.myJob+'.png');
            $("#faction").html(trans[event.data.myJob] + "");
        } else if (toggle == false) {
            $('.dispatch').fadeOut(300)
            $('.settings').hide()
        }

        if (toggleConfig == true) {
            $('.settings').fadeIn(300)
        } else if (toggleConfig == false) {
            $('.settings').fadeOut(300)
        }

        if ((newAlert || changeAlert) && receiveAlerts) {
            const text = event.data.text;
            const type = event.data.type;
            const distance = event.data.distance;
            currentAlert = event.data.currentAlert;
            maxAlerts = event.data.totalcalls;

            $("#distance").text(distance + " km");
            if (type == 'vehicle') {
                $("#alertText").html(text + "");
            } else {
                $("#alertText").text(text + "");
            }
            $("#actualAlert").html(currentAlert+'<span id="maxAlerts" style="font-family: font; color: white; font-size: .4vw;">/'+maxAlerts+'</span>');

            if (newAlert) {
                if (playSounds) {
                    let audioName = 'AllUnits'

                    if (event.data.heist) {
                        audioName = 'robbery'
                    }

                    if (type == "drugs") {
                        audioName = 'drugs'
                    }

                    if (type == "vehicle") {
                        audioName = 'robvehicle'
                    }

                    if (type == "qrr") {
                        audioName = 'qrr'
                    }

                    audio = new Audio(`./Assets/${audioName}.mp3`)
                    audio.volume = 0.7;
                    audio.play();    
                }

                $("#circle").addClass('newAlert');
                setTimeout(function() {
                    $("#circle").removeClass('newAlert');
                }, 2000);
            }
        }

        if (responding) {
            if (playSounds) {
                audio = new Audio('./Assets/responding.mp3')
                audio.volume = 1;
                audio.play();
            }
        }
    });

    $("#sounds").on("click", function() {
        playSounds = !playSounds
    
        if (playSounds == true) {
            $("#sounds").css('background-color', '#17af0a')
        } else if (playSounds == false) {
            $("#sounds").css('background-color', 'red')
        }
    })

    $("#changeAlerts").on("click", function() {
        receiveAlerts = !receiveAlerts
    
        if (receiveAlerts == true) {
            $("#changeAlerts").css('background-color', '#17af0a')
        } else if (receiveAlerts == false) {
            $("#changeAlerts").css('background-color', 'red')
        }
    })

    $("#deleteAlerts").on("click", function() {
        $.post("https://ZC-Dispatch/deleteAlerts", JSON.stringify({}))
        $("#distance").text("0 km");
        $("#alertText").text("Sin alertas");
        $("#actualAlert").html('0<span id="maxAlerts" style="font-family: font; color: white; font-size: .4vw;">/0</span>');
    })
});