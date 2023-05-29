$(function () {
    let opened

    window.addEventListener("message", function (event) {  
        const type = event.data.type;
        const close = event.data.close;

        if (type) {
            $("#mugshot").attr('src', event.data.mugshot);
            $("#name").text(event.data.name);
            $("#birth").text(event.data.birth);
            $("#gender").text(event.data.gender);
            $("#nation").text(event.data.nation);
            $("#signature").text(event.data.name);
            if (type == 'driver')  {
                $("#mugshot2").attr('src', event.data.mugshot);
                $("#name2").text(event.data.name);
                $("#birth2").text(event.data.birth);
                $("#gender2").text(event.data.gender);
                $("#nation2").text(event.data.nation);
                $("#signature2").text(event.data.name);

                $('.driver').fadeIn(300);
                opened = '.driver'
            } else {
                $('.idcard').fadeIn(300);
                opened = '.idcard'
            }
        };

        if (close) {
            $(opened).fadeOut(300);
            opened = null;
        }
    })
})