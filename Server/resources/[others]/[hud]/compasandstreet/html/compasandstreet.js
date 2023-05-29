$(function(){
    let closed = true
    window.addEventListener("message", function(event){   
        if(event.data.close){
            $('.streetname').fadeOut(200);
            $('.streetname').hide()
            setTimeout(() => {
                $('.streetname').text('');
                closed = true
            }, 200);
        }
        if(event.data.action == 'setStreetName'){
            if (closed == true) {
                $('.streetname').fadeIn(200);
                closed = false
            }
            $('.streetname').text(event.data.streetname);
        };
    });
});