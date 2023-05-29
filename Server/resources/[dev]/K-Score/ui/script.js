$('body').hide()

window.addEventListener('message',
    (event) => {
        if (event.data.show) {
            $('body').show('slow')
            $('#Id').html(event.data.userID)
            $('#Players').html(event.data.players)
            for (let id in event.data.data){
                $(`.${id}_num`).html(event.data.data[id].count)
            }
        } else if (event.data.show == false) {
            $('body').hide('slow')
        }
    }
)