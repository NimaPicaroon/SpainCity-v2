$(async function () {  
    let resource = ""
    let name = ""
    let height = 3
    let id = 0
    let selected = 1
    let array = [ ]
    let metadataOpened = 0

    window.addEventListener("message", async (event) => { 
        if (event.data.openmenu) {
            array = event.data.array
            resource = event.data.resource
            name = event.data.name
            $(".menu-title").text(event.data.title)
            $(".main-wrapper").fadeIn(50)
            for (var i = 0; i < event.data.array.length; i++) {
                if (height > 10) {
                    height = 10
                }
                height = height + 2
                id++
                $(".part").css("max-height", height+"vw")
                if (event.data.array[i]['itemName']) {
                    $(".part").append(`
                        <div class="section" id="${id}">
                            <img class="img" onerror="this.style.display=\'none\'" src="Assets/images/${event.data.array[i]['itemName']}.png"/>
                            <span class="text-menu">${event.data.array[i]['label']}</span>
                        </div>
                    `)
                } else {
                    $(".part").append(`
                        <div class="section" id="${id}">
                            <span class="text-menu">${event.data.array[i]['label']}</span>
                        </div>
                    `)
                }
                $("#1")[0].scrollIntoView()
                $("#1").addClass("selected")

                if (array[selected-1]['metadataItem']) {
                    $(".flex-metadata").html(``)
                    array[selected-1]['metadataItem'].forEach(function(data) {
                        $(".flex-metadata").append(`
                            <div class="item" style=" padding-left: 0.2vw; padding-bottom: 0.3vw; width:9.5vw; max-width: 9.5vw; border-radius: .4vw;">
                                <span style="padding-left: 0.2vw; max-width: 9.5vw; text-align:center;" class="item-name">${data.label}: ${data.value}</span>
                            </div>
                        `)
                    });
    
                    $('.metadata-wrapper').fadeIn(50)
                    metadataOpened = 1
                } else {
                    if (metadataOpened == 1) {
                        metadataOpened = 0
                        $('.metadata-wrapper').fadeOut(50)
                    }
                }
            }
        }  
        if (event.data.key === "ArrowDown") {
            $("#"+selected).removeClass("selected")
            selected++
            if (selected === (array.length + 1)) {
                selected = 1
            } 
            $("#"+selected).addClass("selected")
            $("#"+selected)[0].scrollIntoView()

            if (array[selected-1]['metadataItem']) {
                $(".flex-metadata").html(``)
                array[selected-1]['metadataItem'].forEach(function(data) {
                    $(".flex-metadata").append(`
                        <div class="item" style=" padding-left: 0.2vw; padding-bottom: 0.3vw; width:9.5vw; max-width: 9.5vw; border-radius: .4vw;">
                            <span style="padding-left: 0.2vw; max-width: 9.5vw; text-align:center;" class="item-name">${data.label}: ${data.value}</span>
                        </div>
                    `)
                });

                $('.metadata-wrapper').fadeIn(50)
                metadataOpened = 1
            } else {
                if (metadataOpened == 1) {
                    metadataOpened = 0
                    $('.metadata-wrapper').fadeOut(50)
                }
            }
            
        } else if (event.data.key === "ArrowUp") {
            $("#"+selected).removeClass("selected")
            selected--
            if (selected === 0) {
                selected = array.length
            }
            $("#"+selected).addClass("selected")
            $("#"+selected)[0].scrollIntoView()

            if (array[selected-1]['metadataItem']) {
                $(".flex-metadata").html(``)
                array[selected-1]['metadataItem'].forEach(function(data) {
                    $(".flex-metadata").append(`
                        <div class="item" style=" padding-left: 0.2vw; padding-bottom: 0.3vw; width:9.5vw; max-width: 9.5vw; border-radius: .4vw;">
                            <span style="padding-left: 0.2vw; max-width: 9.5vw; text-align:center;" class="item-name">${data.label}: ${data.value}</span>
                        </div>
                    `)
                });

                $('.metadata-wrapper').fadeIn(50)
                metadataOpened = 1
            } else {
                if (metadataOpened == 1) {
                    metadataOpened = 0
                    $('.metadata-wrapper').fadeOut(50)
                }
            }

        } else if (event.data.key === "remove") {
            $(".main-wrapper").fadeOut(50)
            selected = 1
            height = 3
            id = 0
            resource = ""
            name = ""
            array = [ ]
            metadataOpened = 0
            $(".flex-metadata").html(``)
            $('.metadata-wrapper').hide()
            $(".section").remove()
        } else if (event.data.key === "enter") {
            $.post("https://ZC-Menu/ItemSelected", JSON.stringify({
                item: selected,
                resource: resource,
                name: name
            }))
            selected = 1
            height = 3
            id = 0
            resource = ""
            name = ""
            array = [ ]
            $(".flex-metadata").html(``)
            $('.metadata-wrapper').hide()
            metadataOpened = 0
        }
    })
})