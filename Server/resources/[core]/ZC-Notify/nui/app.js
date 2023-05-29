var count = 0;

$(function(){
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'notification':
                Notification(event.data.type, event.data.message, event.data.duration);
            break;

            case 'checkRadar':
                if (event.data.map == true) {
                    $('.container').removeClass('mapOff').addClass('mapOn');
                } else {
                    $('.container').removeClass('mapOn').addClass('mapOff');
                }
            break;
        }
    })
})

function Notification(type, message, duration) {
    var id = $('.container .notify').length;

    $('.container').fadeIn(250)

    $('.container').append(`
        <div class="notify" id="notify-${id}">
            ${count >= 1 ? `<div class="notify__count"><h1>${count}</h1></div>` : ''}
            <div class="notify__type" id="${type}">
                <h1>${type}</h1>
            </div>

            <h1>${message}</h1>
            <div class="bar"></div>
        </div>
    `)

    count = count + 1;

    var current = $(`#notify-${id}`);
    var width = 100;
    var id = setInterval(frame, duration / 100);

    function frame() {
        if (width <= 0) {
            clearInterval(id);

            current.css({'animation': 'fadeOut 1s ease 0s 1 normal forwards'})
            current.fadeOut(250)
            count = count - 1;
        } else {
            width--;
            current.find('.bar').css('width', width + '%');
        }
    }
}