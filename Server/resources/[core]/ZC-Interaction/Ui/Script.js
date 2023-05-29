let time = 0;
let opened = true
let pressed = false

window.addEventListener("message", function(event) {
    if (event.data.open) {
        opened = true
        $(".interaction-wrapper").fadeIn(200)
    }
    if (event.data.coords) {
        time = new Date().getTime()
        $(".text-low").html(event.data.text)
        $(".interaction-wrapper").css("top", event.data.coords.y+"%")
        $(".interaction-wrapper").css("left", event.data.coords.x+"%")
    }

/*     if (event.data.distance) {

        let distance = event.data.distance
        let letter = 1.8
        let otherWidth = 2.5
        let textSize = 0.95

        textSize = textSize * 0.95 / distance 
        if (textSize > 0.95) {
            textSize = 0.95
        }

        otherWidth = otherWidth * 2.5 / distance 
        if (otherWidth > 2.5) {
            otherWidth = 2.5
        }
       

        letter = letter * 1.8 / distance 
        if (letter > 1.8) {
            letter = 1.8
        }
        


        $(".letter").css("width", letter + "vw")
        $(".letter").css("height", letter + "vw")

        $(".other-fill").css("width", otherWidth + "vw")
        $(".other-fill").css("height", otherWidth + "vw")

        $(".text-low").css("font-size", textSize + "vw")

    } */

    if (event.data.press) {
        $(".other-fill").addClass("press")
        pressed = true
        setTimeout(() => {
            $(".other-fill").removeClass("press")
            pressed = false
        }, 1000);
    }

})

setInterval(() => {
    if (opened) {
        if (!pressed) {
            if ((new Date().getTime() - time) > 50) {
                $(".interaction-wrapper").fadeOut(100)
                opened = false
            }
        }
    }
}, 50);