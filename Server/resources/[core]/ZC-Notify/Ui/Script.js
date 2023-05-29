$(function() {
    let id = 0;

    window.addEventListener("message", function (event) {  
        let title = event.data.title || "NOTIFICACIÓN"
        let content = event.data.content
        let type = event.data.type || "info"
        id++

        title = LuaToHtml(title, id)
        content = LuaToHtml(content, id)

        var myEle = document.getElementById(id.toString());
        if (!myEle) {
            $(".flex-notify").append(`
                <div class="notify-wrapper ${id}" id="${id}">
                    <span class="title">${title}</span>
                    <img class="image" src="Assets/${type}.png">
                    <div class="content-div">
                        <span class="content">${content}</span>
                    </div>
                </div> 
            `)
            $("#"+id).fadeIn(500)
            dissapear(id)
        }
    })

    function dissapear(id) {
        setTimeout(() => {
            $("#"+id).fadeOut(300)
            setTimeout(() => {
                $("#"+id).remove()
                $("b[id=var"+id+"]").remove()
            }, 300);
        }, 5000);
    }

    function LuaToHtml(text, id) {
        text = text.replace(/~r~/g, '<b id="var'+id+'" style="color:#F40202">') 
        text = text.replace(/~b~/g, '<b id="var'+id+'" style="color:#00B2FF">')
        text = text.replace(/~g~/g, '<b id="var'+id+'" style="color:#1DDA10">')
        text = text.replace(/~y~/g, '<b id="var'+id+'" style="color:#FFFF00">')
        text = text.replace(/~p~/g, '<b id="var'+id+'" style="color:#9910DA">')
        text = text.replace(/~c~/g, '<b id="var'+id+'" style="color:#6C6C6C">')
        text = text.replace(/~m~/g, '<b id="var'+id+'" style="color:#393939">')
        text = text.replace(/~u~/g, '<b id="var'+id+'" style="color:#000000">')
        text = text.replace(/~o~/g, '<b id="var'+id+'" style="color:#efb810">')
        text = text.replace(/~pk~/g,'<b id="var'+id+'" style="color:#ff00f2">')
        text = text.replace(/~s~/g, '</b>')
        text = text.replace(/~w~/g, '</b>')
        return text
    }
})

