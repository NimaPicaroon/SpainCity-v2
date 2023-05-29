$(function () {

    var write = false;
    function display(bool) {
        if (bool) {
            $("#container").show();
            if (write){
                $("#complaintinfo").slideDown(400);
                $("#info").hide()
                $("#warn").hide()
                $("#done").hide() 
            } else{
            $("#startscreen").slideDown(400);
            $("#info").hide()
            $("#warn").hide()
            $("#done").hide()
            }
        } else {
            $("#container").hide();
        }

    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            
            $.post(`http://${GetParentResourceName()}/exit`, JSON.stringify({}));
            return
        }
    };

    var first = document.getElementById('firstname')
    var last = document.getElementById('lastname')
    var age = document.getElementById('age')
    var why = document.getElementById('why')
    var gender = document.getElementById('gender')


        $(".sumbit").click(function() {
            write = false
            var ft = document.getElementById('ft')
            var ln = document.getElementById('ln')
            var reason = document.getElementById('reason')
            var date = document.getElementById('date')

               if($(ft , ln , reason , date).val() === '') {
                    $("#warn").fadeIn(400)
                    return
                    
                } else{
                $("#warn").fadeOut(400)
                $("#complaintinfo").fadeOut(400)
                $("#done").fadeIn(400)
                $.post(
                    `http://${GetParentResourceName()}/complaintinfo`,
                  JSON.stringify({
                    ft: $("#ft").val(),     
                    ln: $("#ln").val(),
                    reason: $("#reason").val(),
                    date: $("#date").val(),
        
                    myImg: $("#myImg").val(),
        
        
                  })
                );
               }
        
    })


    $(".exit").click(function() {
        write = false
        $("#container").fadeOut();
        setTimeout(function(){
            $.post(`http://${GetParentResourceName()}/exit`, JSON.stringify({}));

        },400);


        return
    })

    $(".exit2").click(function() {
        $("#container").fadeOut();
        setTimeout(function(){
            $.post(`http://${GetParentResourceName()}/exit`, JSON.stringify({}));

        },400);


        return
    })
    
    

    $("#complaint").click(function(){
        write = true
        $("#startscreen").hide()
        document.getElementById('ft').value = ''
        document.getElementById('ln').value = ''
        document.getElementById('date').value = ''
        
        document.getElementById('reason').value = ''
        document.getElementById('myImg').value = ''

        $("#complaintinfo").slideDown(400);
        $("#warn").hide()


    })


        
    

        
    

})
