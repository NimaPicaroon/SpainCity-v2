$(function() {
    window.addEventListener("message", function (event) {  
        let percentage = event.data.percentage || 0
        let time = event.data.time || 0
        let hide = event.data.hide

        if (event.data.show_percentage) {
            $(".image").fadeIn(500)
            $("#percentage").fadeIn(500).text(percentage)
        }
        
        if (event.data.show_time) {
            $(".image_time").fadeIn(500)
            $("#time").fadeIn(500).text(time+"s")
        }

        if (percentage) {
            $("#percentage").text(percentage)
        }

        if (time) {
            $("#time").text(time+"s")
        }

        if (hide) {
            $(".image").fadeOut(500)
            $(".image_time").fadeOut(500)
            $("#percentage").fadeOut(500)
            $("#time").fadeOut(500)
        }
    })
})