$(function () {
    let selectedcategory = 1  
    let IsInRight = false
    let isAsigning = false
    let itemselected = 1
    let maxNumber = 3
    let optionSelected = 0
    let maxOption = 5
    let personSelected = 1
    let maxPeople = 1
    const categories = {
        [1]: 'item',
        [2]: 'food',
        [3]: 'weapon',
        [4]: 'drug',
        [5]: 'key'
    }

    window.addEventListener("message", function (event) {  
        const inv_data = event.data.open
        const totalWeight = event.data.totalWeight
        const maxWeight = event.data.maxWeight
        const data = event.data.data;

        if (inv_data) { // ESTO ES CUANDO SE ABRE EL INV
            openInventory(inv_data, totalWeight, maxWeight)
        } else if (event.data.close) { // SE CIERRA
            if (optionSelected === 0) { 
                closeInventory('all')
            } else {
                if (maxPeople === 1) {
                    closeInventory('options')
                } else {
                    closeInventory('people')
                }
            }
        } else if (event.data.hotbar) {
            showHotbar(event.data.hotbar, event.data.select)
        }

        if (event.data.key === "ArrowUp") {
                if (optionSelected !== 0) {
                    if (maxPeople === 1) {
                        $("#option-"+optionSelected).removeClass("selecteditem")
                        optionSelected--
                        if (optionSelected === 0 ) {
                            optionSelected = maxOption - 1
                        }
                        $("#option-"+optionSelected).addClass("selecteditem")
                    } else {
                        $("#person-"+personSelected).removeClass("selecteditem")
                        personSelected--
                        if (personSelected === 0) {
                            personSelected = maxPeople - 1
                        }
                        $("#person-"+personSelected)[0].scrollIntoView()
                        $("#person-"+personSelected).addClass("selecteditem")
                    }
                } else {
                    if (IsInRight) {
                        $("#item-"+itemselected).removeClass("selecteditem")
                        itemselected--
                        if (itemselected === 0 ) {
                            itemselected = maxNumber - 1
                        }
                        $("#item-"+itemselected)[0].scrollIntoView()
                        $("#item-"+itemselected).addClass("selecteditem")
    
                    } else {
                        $("#category-"+selectedcategory).removeClass("selectedcategory")
                        selectedcategory--
                        if (selectedcategory === 0 ) {
                            selectedcategory = 5
                        }
                        $("#category-"+selectedcategory).addClass("selectedcategory")
                    }
                }
        } else if (event.data.key === "ArrowDown") {
                if (optionSelected !== 0) {
                    if (maxPeople === 1) {
                        $("#option-"+optionSelected).removeClass("selecteditem")
                        optionSelected++
                        if (optionSelected === maxOption ) {
                            optionSelected = 1
                        }
                        $("#option-"+optionSelected).addClass("selecteditem")
                    } else {
                        $("#person-"+personSelected).removeClass("selecteditem")
                        personSelected++
                        if (personSelected === maxPeople) {
                            personSelected = 1
                        }
                        $("#person-"+personSelected)[0].scrollIntoView()
                        $("#person-"+personSelected).addClass("selecteditem")
                    }
                } else {
                    if (IsInRight) {
                        $("#item-"+itemselected).removeClass("selecteditem")
                        itemselected++
                        if (itemselected === maxNumber ) {
                            itemselected = 1
                        }
                        $("#item-"+itemselected)[0].scrollIntoView()
                        setTimeout(() => {
                            $("#item-"+itemselected).addClass("selecteditem")
                        }, 50);
                        
                    } else {
                        
                        $("#category-"+selectedcategory).removeClass("selectedcategory")
                        selectedcategory = selectedcategory + 1
                        if (selectedcategory === 6 ) {
                            selectedcategory = 1
                        }
                        $("#category-"+selectedcategory).addClass("selectedcategory")

                    }
                }
        } else if (event.data.key === "enter") {
            if (optionSelected === 0) {
                if (IsInRight) {
                    let item = $("#item-"+itemselected);
                    if (item) {
                        if (selectedcategory == 3) {
                            $(".selected-wrapper").css('width', '6vw')
                            $(".selected-wrapper").css('height', '7.2vw')
                            $(".flex-options").html(`
                            <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-1" data="use">
                                <span style="padding-left: .4vw; text-align:center;" class="item-name">Usar</span>
                            </div>
                            <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-2" data="give">
                                <span style="padding-left: .4vw; text-align:center;" class="item-name">Dar</span>
                            </div>
                            <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-3" data="drop">
                                <span style="padding-left: .4vw; text-align:center;" class="item-name">Tirar</span>
                            </div>
                            <div class="item" style=" width:4vw; padding-top: -.2vw;" id="option-4" data="cancel">
                                <span style="padding-left: .4vw; text-align:center;" class="item-name">Cancelar</span>
                            </div>
                            <div class="item" style=" width:5.5vw; padding-top: -.2vw;" id="option-5" data="slot">
                                <span style="padding-left: .4vw; text-align:center;" class="item-name">Asignar slot</span>
                                </div>
                        `)
                            maxOption = 6
                        }
                        IsInRight = false
                        optionSelected = 1
                        if (itemselected == 1) {
                            let money = $(".money").attr("money")
                            $.post("https://ZC-Inventory/selectedMoney", JSON.stringify({money: money}))
                            $(".selected-wrapper").css('width', '5vw')
                            $(".selected-wrapper").css('height', '4.5vw')
                            $(".flex-options").html(`
                                <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-1" data="give">
                                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Dar</span>
                                </div>
                                <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-2" data="drop">
                                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Tirar</span>
                                </div>
                                <div class="item" style=" width:4vw; padding-top: -.2vw;" id="option-3" data="cancel">
                                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Cancelar</span>
                                </div>
                            `)
                            maxOption = 4
                        } else {
                            let slotId = item.attr('slotId')
                            let name = item.attr('name')
                            $.post("https://ZC-Inventory/selected", JSON.stringify({
                                slotId: slotId,
                                name: name
                            }), function(metadata){
                                if (metadata) {
                                    metadata.forEach(function(data) {
                                        $(".flex-metadata").append(`
                                            <div class="item" style=" padding-left: 0.2vw; padding-bottom: 0.3vw; width:9.5vw; max-width: 9.5vw; border-radius: .4vw;">
                                                <span style="padding-left: 0.2vw; max-width: 9.5vw; text-align:center;" class="item-name">${data.label}: ${data.value}</span>
                                            </div>
                                        `)
                                    });

                                    $('.metadata-wrapper').fadeIn(100)
                                }
                            })
                        }
                        $("#option-"+optionSelected).addClass("selecteditem")
                        $('.selected-wrapper').fadeIn(100)
                    } 
                }
            } else {
                if (maxPeople === 1) {
                    let selected = $("#option-"+optionSelected).attr("data")

                    if (selected === "give") {
                        $.post("https://ZC-Inventory/getPeople", JSON.stringify({}), function(people){
                            if (people) {
                                maxPeople = people.length + 1
                                let id = 0

                                people.forEach(function(person) {
                                    id++
                                    $(".flex-people").append(`
                                        <div class="item" style=" padding-left: 0.3vw; width:4vw; padding-top: -.3vw;" id="person-${id}" playerId=${person.playerId}>
                                            <span style="padding-left: 1.4vw; text-align:center;" class="item-name">${person.label}</span>
                                        </div>
                                    `)
                                });
                                $('.selected-wrapper').fadeOut(100)
                                $('.people-wrapper').fadeIn(100)
                                $("#person-"+personSelected).addClass("selecteditem")
                            }
                        })
                    } else if (selected === "use") {
                        $.post("https://ZC-Inventory/useItem", JSON.stringify({}))

                        if (optionSelected === 0) {
                            $('.main-wrapper').fadeOut(100)
                            $(".flex-items").html(``)
                            $("#category-"+selectedcategory).removeClass("selectedcategory")
                            itemselected = 1 
                            IsInRight = false
                            maxNumber = 3
                            selectedcategory = 1  
                        } else {
                            if (maxPeople === 1) {
                                $.post("https://ZC-Inventory/notSelected", JSON.stringify({}))
                                IsInRight = true
                                $("#option-"+optionSelected).removeClass("selecteditem")
                                optionSelected = 0 
                                $('.selected-wrapper').fadeOut(200)
                                $('.metadata-wrapper').fadeOut(200)
                                $(".flex-metadata").html(``)
                            } else {
                                maxPeople = 1
                                personSelected = 1
                                $(".flex-people").html(``)
                                $('.people-wrapper').fadeOut(200)
                                $('.selected-wrapper').fadeIn(200)
                            }
                        }
                    } else if (selected === "drop") {
                        $.post("https://ZC-Inventory/dropItem", JSON.stringify({}))

                        if (optionSelected === 0) {
                            $('.main-wrapper').fadeOut(100)
                            $(".flex-items").html(``)
                            $("#category-"+selectedcategory).removeClass("selectedcategory")
                            itemselected = 1 
                            IsInRight = false
                            maxNumber = 3
                            selectedcategory = 1  
                        } else {
                            if (maxPeople === 1) {
                                $.post("https://ZC-Inventory/notSelected", JSON.stringify({}))
                                IsInRight = true
                                $("#option-"+optionSelected).removeClass("selecteditem")
                                optionSelected = 0 
                                $('.selected-wrapper').fadeOut(100)
                                $('.metadata-wrapper').fadeOut(100)
                                $(".flex-metadata").html(``)
                            } else {
                                maxPeople = 1
                                personSelected = 1
                                $(".flex-people").html(``)
                                $('.people-wrapper').fadeOut(100)
                                $('.selected-wrapper').fadeIn(100)
                            }
                        }
                    } else if (selected === "slot") {
                        maxPeople = 6
                        $(".flex-people").html(`
                            <div class="item" style=" padding-left: 0.3vw; width:4vw; padding-top: -.3vw;" id="person-1" slot=1>
                                <span style="padding-left:  0.4vw;" class="item-name">Slot 1</span>
                            </div>
                            <div class="item" style=" padding-left: 0.3vw; width:4vw; padding-top: -.3vw;" id="person-2" slot=2>
                                <span style="padding-left:  0.4vw;" class="item-name">Slot 2</span>
                            </div>
                            <div class="item" style=" padding-left: 0.3vw; width:4vw; padding-top: -.3vw;" id="person-3" slot=3>
                                <span style="padding-left:  0.4vw;" class="item-name">Slot 3</span>
                            </div>
                            <div class="item" style=" padding-left: 0.3vw; width:4vw; padding-top: -.3vw;" id="person-4" slot=4>
                                <span style="padding-left:  0.4vw" class="item-name">Slot 4</span>
                            </div>
                            <div class="item" style=" padding-left: 0.3vw; width:4vw; padding-top: -.3vw;" id="person-5" slot=5>
                                <span style="padding-left: 0.4vw;" class="item-name">Slot 5</span>
                            </div>
                        `)
                        isAsigning = true
                        $('.selected-wrapper').fadeOut(100)
                        $('.people-wrapper').fadeIn(100)
                        $("#person-"+personSelected).addClass("selecteditem")
                        resetHtml()
                    } else {
                        $.post("https://ZC-Inventory/notSelected", JSON.stringify({}))
                        IsInRight = true
                        $("#option-"+optionSelected).removeClass("selecteditem")
                        optionSelected = 0 
                        $('.selected-wrapper').fadeOut(100)
                        $('.metadata-wrapper').fadeOut(100)
                        $(".flex-metadata").html(``)
                    }

                } else {
                    if (maxOption == 6 && isAsigning == true) {
                        let selectedSlot = $("#person-"+personSelected).attr('slot')
                        $.post("https://ZC-Inventory/asignSlot", JSON.stringify({
                            slot: selectedSlot
                        }))
                        $("#option-"+optionSelected).removeClass("selecteditem")
                        $("#person-"+personSelected).removeClass("selecteditem")
                        $(".flex-people").html(``)
                        $('.metadata-wrapper').fadeOut(100)
                        $(".flex-metadata").html(``)
                        $('.people-wrapper').fadeOut(100)
                        IsInRight = true
                        optionSelected = 0 
                        maxOption = 5
                        maxPeople = 1
                        personSelected = 1
                    } else {
                        let selectedPersonID = $("#person-"+personSelected).attr('playerId')
                        $.post("https://ZC-Inventory/giveItem", JSON.stringify({
                            id: selectedPersonID
                        }))
                        $("#option-"+optionSelected).removeClass("selecteditem")
                        $("#person-"+personSelected).removeClass("selecteditem")
                        $(".flex-people").html(``)
                        $('.metadata-wrapper').fadeOut(100)
                        $(".flex-metadata").html(``)
                        $('.people-wrapper').fadeOut(100)
                        IsInRight = true
                        optionSelected = 0 
                        maxPeople = 1
                        maxOption = 5
                        personSelected = 1
                    }
                }
            }
        } else if (event.data.key === "ArrowRight") {
            if (optionSelected === 0) {
                if (IsInRight) {
                    IsInRight = false
                    $("#item-"+itemselected).removeClass("selecteditem")
                    itemselected = 1
                    $("#category-"+selectedcategory).addClass("selectedcategory")
                } else {
                    //if (maxNumber > 0) {
                        IsInRight = true
                        $("#item-"+itemselected).addClass("selecteditem")
                        $("#item-"+itemselected)[0].scrollIntoView()
                        $("#category-"+selectedcategory).removeClass("selectedcategory")
                    //}
                }
            }
        } else if (event.data.key === "ArrowLeft") {
            if (optionSelected === 0) {
                if (IsInRight) {
                    IsInRight = false
                    $("#item-"+itemselected).removeClass("selecteditem")
                    itemselected = 1
                    $("#category-"+selectedcategory).addClass("selectedcategory")
                } else {
                    //if (maxNumber > 0) {
                        IsInRight = true
                        $("#item-"+itemselected).addClass("selecteditem")
                        $("#item-"+itemselected)[0].scrollIntoView()
                        $("#category-"+selectedcategory).removeClass("selectedcategory")
                    //}
                }
            }
        }

        if (!IsInRight && optionSelected === 0) {
            if (event.data.key === "ArrowUp" || event.data.key === "ArrowDown") {
                filterInventory(data)
            }
        }
    })

    // PRINCIPAL FUNCTIONS
    function resetHtml () {
        setTimeout(() => {
            $(".flex-options").html(`
                <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-1" data="use">
                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Usar</span>
                </div>
                <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-2" data="give">
                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Dar</span>
                </div>
                <div class="item" style="width:4vw; padding-top: -.2vw;" id="option-3" data="drop">
                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Tirar</span>
                </div>
                <div class="item" style=" width:4vw; padding-top: -.2vw;" id="option-4" data="cancel">
                    <span style="padding-left: .4vw; text-align:center;" class="item-name">Cancelar</span>
                </div>
            `)
            $(".selected-wrapper").css('width', '5vw')
            $(".selected-wrapper").css('height', '6vw')
        }, 100);
    }

    function closeInventory(type) {
        if (type === 'options') {
            $.post("https://ZC-Inventory/notSelected", JSON.stringify({}))
            IsInRight = true
            maxOption = 5
            optionSelected = 0 
            $("#option-"+optionSelected).removeClass("selecteditem")
            $('.selected-wrapper').fadeOut(100)
            $('.metadata-wrapper').fadeOut(100)
            $(".flex-metadata").html(``)
            resetHtml()
        } else if (type === 'all') {
            $('.main-wrapper').fadeOut(100)
            $(".flex-items").html(``)
            $("#category-"+selectedcategory).removeClass("selectedcategory")
            itemselected = 1 
            IsInRight = false
            isAsigning = false
            maxNumber = 3
            selectedcategory = 1 
        } else if (type === 'people') {
            maxPeople = 1
            personSelected = 1
            isAsigning = false
            $(".flex-people").html(``)
            $('.people-wrapper').fadeOut(100)
            $('.selected-wrapper').fadeIn(100)
        }
    }

    function filterInventory(data) {
        $(".flex-items").html(`                  
            <span id="item-1" money="${data['money']}" class="money">
                <img onerror="this.src='https://media.discordapp.net/attachments/1057274673546678402/1061674591757537410/EXODOLOGODORADO.png'" src="https://i.imgur.com/r9RR2m8.png" class="image-item">
                <span id="money-text">${'$'+data['money']}</span>
            </span>
        `)
        if (data['coins'] > 0) {
            $(".flex-items").append(`                  
                <span id="item-1" money="${data['coins']}" class="coins">
                    <img onerror="this.src='https://media.discordapp.net/attachments/1057274673546678402/1061674591757537410/EXODOLOGODORADO.png'" src="https://cdn-icons-png.flaticon.com/512/138/138281.png" class="image-item">
                    <span id="money-text">${data['coins']}</span>
                </span>
            `)
        } 
        // $(".money").text('Dinero: ' + (data['money'])+'$')
        $("#item-"+itemselected).removeClass("selecteditem")
        const filtered = data['data'].filter(function(element){
            return element.type == categories[selectedcategory];
        });

        if (Object.keys(filtered).length > 0) {
            maxNumber = Object.keys(filtered).length + 3;
        } else {
            maxNumber = 3;
        }

        const slots = {};

        for (let i = 1; i < 6; i++) {
            if (data['slots'][i]) {
                slots[data['slots'][i].slotId] = i
            }
        }

        let id = 1
        filtered.forEach(function(item) {
            id++
            item.id = id
            let weight = (item.weight * item.quantity).toFixed(1)
            let slot = ""

            if (slots[item.slotId]) {
                slot = "Slot: " + slots[item.slotId]
            }


            $(".flex-items").append(`
            <div class="item" style="padding-top: -.3vw;" id="item-${item.id}" slotId=${item.slotId} name=${item.name}>
                <img onerror="this.src='https://media.discordapp.net/attachments/831490177104478208/1095118740477182052/spaincitypekenito.png'" src="Assets/images/${item.name}.png" class="image-item">
                <span style="position: absolute; bottom: 0.4vw; margin-left: 0.2vw;" class="item-name">[${item.quantity}] ${item.label}</span>
            </div>
        `)
        });
    }

    function openInventory(inv_data, totalWeight, maxWeight) {
        $("#category-"+selectedcategory).addClass("selectedcategory")
        $('.main-wrapper').fadeIn(100)
        $(".flex-items").html(`                  
            <span id="item-1" money="${inv_data['money']}" class="money">
                <img onerror="this.src='https://media.discordapp.net/attachments/1057274673546678402/1061674591757537410/EXODOLOGODORADO.png'" src="https://i.imgur.com/r9RR2m8.png" class="image-item">
                <span id="money-text">${'$'+inv_data['money']}</span>
            </span>
        `)
        if (inv_data['coins'] > 0) {
        $(".flex-items").append(`                  
            <span id="item-1" money="${inv_data['coins']}" class="coins">
                <img onerror="this.src='https://media.discordapp.net/attachments/1057274673546678402/1061674591757537410/EXODOLOGODORADO.png'" src="https://cdn-icons-png.flaticon.com/512/138/138281.png" class="image-item">
                <span id="money-text">${inv_data['coins']}</span>
            </span>
        `)
        }
        $(".weight-title").text((totalWeight).toFixed(1)+'/'+ (maxWeight).toFixed(1)+' kg')

        const filtered = inv_data['data'].filter(function(element){
            return element.type == categories[selectedcategory];
        });
        
        if (Object.keys(filtered).length > 0) {
            maxNumber = Object.keys(filtered).length + 3;

            let id = 1
            filtered.forEach(function(item) {
                id++
                item.id = id
                let weight = (item.weight * item.quantity).toFixed(1)
                //$(".flex-items").append(`
                    //<div class="item" style="padding-top: -.3vw;" id="item-${item.id}" slotId=${item.slotId} name=${item.name}>
                        //<img onerror="this.src='https://cdn.discordapp.com/attachments/662091435226431508/932040841097252904/waveeeeeeeeeeeeeeee.png'" src="Assets/images/${item.name}.png" class="image-item">
                        //<span style="position: absolute; bottom: 0.4vw; margin-left: 0.2vw;" class="item-name">[${item.quantity}] ${item.label}</span>
                        //<span class="weight-item">x${weight} Kg</span>
                    //</div>
                //`)

                $(".flex-items").append(`
                    <div class="item" style="padding-top: -.3vw;" id="item-${item.id}" slotId=${item.slotId} name=${item.name}>
                        <img onerror="this.src='https://media.discordapp.net/attachments/831490177104478208/1095118740477182052/spaincitypekenito.png'" src="Assets/images/${item.name}.png" class="image-item">
                        <span style="position: absolute; bottom: 0.4vw; margin-left: 0.2vw;" class="item-name">[${item.quantity}] ${item.label}</span>
                    </div>
                `)
            });
            
        } else {
            maxNumber = 3;
        }
    }

    function showHotbar(data, select) {
        if (select) {
            $('.hotbar-wrapper').hide()
            $(".flex-hotbar").html(``)
        }
        
        $(".hotbar-wrapper").slideDown(500)
        setTimeout(() => {
            $('.hotbar-wrapper').show()
        }, 500);

        let slot = [];
        let a = 'ㅤ';
        
        if (Object.keys(data).length > 0) {
            for (let i = 1; i < 6; i++) {
                if (data[i]) {
                    slot[i] = data[i]
                    if (select && (select == i)) {
                        $(".flex-hotbar").append(`
                            <div class="item" style="height: 4.2vw; width: 4.2vw; margin-top: .4vw; margin-left: .5vw;" id="slot-${i}">
                                <div class="hotbar-selected" style="background: #080808; height: 4.2vw; width: 4.2vw; border-radius: .2vw;">
                                    <img src="Assets/images/${data[i].name}.png" class="image-hotbar">
                                    <div class="hotbar-life">
                                        <div class="life" id="life-${i}"></div>
                                    </div>
                                    <span class="hotbar-name">${data[i].label}</span>
                                    <span class="slot-number">${i}</span>
                                </div>
                            </div>
                        `)
                    } else {
                        $(".flex-hotbar").append(`
                            <div class="item" style="background: #080808; height: 4.2vw; width: 4.2vw; border-radius: .2vw; margin-top: .4vw; margin-left: .5vw;" id="slot-${i}">
                                <img src="Assets/images/${data[i].name}.png" class="image-hotbar">
                                <div class="hotbar-life">
                                    <div class="life" id="life-${i}"></div>
                                </div>
                                <span class="hotbar-name">${data[i].label}</span>
                                <span class="slot-number">${i}</span>
                            </div>
                        `)
                    }
                } else {
                    slot[i] = ''
                    $(".flex-hotbar").append(`
                    <div class="item" style="background: #080808; height: 4.2vw; width: 4.2vw; border-radius: .2vw; margin-top: .4vw; margin-left: .5vw;" id="slot-no">
                        <img src="Assets/wave.png" class="no-slot-image">
                        <span class="hotbar-name">${a}</span>
                        <span class="slot-number">${i}</span>
                    </div>
                `)
                }

                if (data[i] && data[i].metadata) {
                    let life = data[i].metadata['life']
                    $("#life-"+i).css("width", life+"%")
                    if (life > 60) {
                        $("#life-"+i).css("background-color", "#26c007")
                    } else if (life > 25) {
                        $("#life-"+i).css("background-color", "#db810b")
                    } else {
                        $("#life-"+i).css("background-color", "#db0b0b")
                    }
                }
            };
        } else {
            for (let i = 1; i < 6; i++) {
                slot[i] = ''
                $(".flex-hotbar").append(`
                    <div class="item" style="background: #080808; height: 4.2vw; width: 4.2vw; border-radius: .2vw; margin-top: .4vw; margin-left: .5vw;" id="slot-no">
                        <img src="Assets/wave.png" class="no-slot-image">
                        <span class="hotbar-name">${a}</span>
                        <span class="slot-number">${i}</span>
                    </div>  
                `)
            }
        }

        if (select) {
            setTimeout(() => {
                $(".slot-"+select).removeClass("hotbar-selected")
                $(".hotbar-wrapper").slideUp(500)
                setTimeout(() => {
                    $('.hotbar-wrapper').hide()
                    $(".flex-hotbar").html(``)
                }, 250);
            }, 1000);
        } else {
            setTimeout(() => {
                $(".hotbar-wrapper").slideUp(500)
                setTimeout(() => {
                    $('.hotbar-wrapper').hide()
                    $(".flex-hotbar").html(``)
                }, 500);
            }, 5000);
        }
    }
})