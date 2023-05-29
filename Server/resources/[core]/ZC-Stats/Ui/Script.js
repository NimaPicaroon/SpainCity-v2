$(function () {
    window.addEventListener("message", function (event) {  
        const open = event.data.open

        if (open) {
            $(".main-wrapper").slideDown(500)
            setTimeout(() => {
                $('.main-wrapper').show()
            }, 500);
            $('#stamina-bar').css("width", getVW(open['stamina']))
            $('#strength-bar').css("width", getVW(open['strength']))
            $('#stress-bar').css("width", getVW(open['stress']))
            $('#diving-bar').css("width", getVW(open['diving']))

            $('#stamina').text('Resistencia: '+ open['stamina']+'%')
            $('#strength').text('Fuerza: '+ open['strength']+'%')
            $('#stress').text('Estrés: '+ open['stress']+'%')
            $('#diving').text('Buceo: '+ open['diving']+'%')
        }
    })

    window.addEventListener("keydown", function (data) {  
        if (data.which == 27 | data.which == 8) {
            $(".main-wrapper").slideUp(500)
            setTimeout(() => {
                $('.main-wrapper').hide()
            }, 500);
            $.post('https://ZC-Stats/close', JSON.stringify({}));
        };
    });

    function getVW(value) {
        return ((value * 5) / 100)+'vw'
    };
})