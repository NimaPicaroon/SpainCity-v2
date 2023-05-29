$(function () {
    window.addEventListener("message", function (event) {  
        if (event.data.show == true) {
            $('.hud-wrapper').show()

            $("#shield").css("width", event.data.shield + "%");
            $("#health").css("width", event.data.health + "%");
            $("#hunger").css("width", event.data.hunger + "%");
            $("#thirst").css("width", event.data.thirst + "%");
            $("#stress").css("width", event.data.stress + "%");
            $("#water").css("width", event.data.water + "%");

            if (event.data.shield > 0) {
                $("#shield-bar").show();

            } else {
                $("#shield-bar").slideUp(500)
                setTimeout(() => {
                    $('#shield-bar').hide()
                }, 500);
            }

            if (event.data.health < 100) {
                var health = event.data.health;
                $("#health-bar").show();

                if (health < 30) {
                    $("#health-bar i").addClass('pulse-animation');
                } else {
                    $("#health-bar i").removeClass('pulse-animation');
                }
            } else {
                $("#health-bar").slideUp(500)
                setTimeout(() => {
                    $('#health-bar').hide()
                }, 500);
            }

            if (event.data.hunger < 50) {
                var hunger = event.data.hunger;
                $("#hunger-bar").show();

                if (hunger < 20) {
                    $("#hunger-bar i").addClass('pulse-animation');
                } else {
                    $("#hunger-bar i").removeClass('pulse-animation');
                }
            } else {
                $("#hunger-bar").slideUp(500)
                setTimeout(() => {
                    $('#hunger-bar').hide()
                }, 500);
            }

            if (event.data.thirst < 50) {
                var thirst = event.data.thirst;
                $("#thirst-bar").show();

                if (thirst < 20) {
                    $("#thirst-bar i").addClass('pulse-animation');
                } else {
                    $("#thirst-bar i").removeClass('pulse-animation');
                }
            } else {
                $("#thirst-bar").slideUp(500)
                setTimeout(() => {
                    $('#thirst-bar').hide()
                }, 500);
            }

            if (event.data.stress > 15) {
                var stress = event.data.stress;
                $("#stress-bar").show();

                if (stress > 75) {
                    $("#stress-bar i").addClass('pulse-animation');
                } else {
                    $("#stress-bar i").removeClass('pulse-animation');
                }
            } else {
                $("#stress-bar").slideUp(500)
                setTimeout(() => {
                    $('#stress-bar').hide()
                }, 500);
            }

            if (event.data.inWater && event.data.water > 0) {
                var water = event.data.water;
                $("#water-bar").show();

                if (water < 40) {
                    $("#water-bar i").addClass('pulse-animation');
                } else {
                    $("#water-bar i").removeClass('pulse-animation');
                }
            } else {
                $("#water-bar i").removeClass('pulse-animation');
                $("#water-bar").slideUp(500)
                setTimeout(() => {
                    $('#water-bar').hide()
                }, 500);
            }

        } else {
            $('.hud-wrapper').hide()
        }
    })
})