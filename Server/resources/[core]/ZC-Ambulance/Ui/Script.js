$(function() {
    window.addEventListener("message", function (event) {  
        let text = event.data.text || ''
        let hide = event.data.hide
        
        if (event.data.show) {
            $(".flex-notify").fadeIn(500)
        }

        if (text) {
            $("#text").html(text)
        }

        if (hide) {
            $(".flex-notify").fadeOut(500)
            setTimeout(() => {
                $("#text").html("Quedarás <b style='color:#F40202'>inconsciente</b> en ...")
            }, 500);
        }
    })
})