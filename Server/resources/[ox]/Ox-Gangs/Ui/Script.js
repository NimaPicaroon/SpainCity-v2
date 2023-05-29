$(document).ready(function () {
    let selectedCategory = '#home';
    let ranks = 0;
    let markers = 0;
    let gangsData = {};

    const infoWrapper = {
        ['#home']: `
            <table class="styled-table">
                <thead>
                    <tr>
                        <th>Nombre</th>
                        <th>Label</th>
                        <th>Rangos</th>
                        <th>Nivel</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="tbody">
                </tbody>
            </table>
        `,
        ['#create']: `
            <div class="create-wrapper">
                <form>
                    <div class="banner">
                        <h1>Creación de bandas</h1>
                    </div>
                    <p>Información básica</p>
                    <div class="item">
                        <label for="name">Nombre<span>*</span>:</label>
                        <input id="gang-name" type="text" name="name" required/>
                    </div>
                    <div class="item">
                        <label for="label">Label<span>*</span>:</label>
                        <input id="gang-label" type="label" name="label" required/>
                    </div>
                    <div class="item">
                        <label for="level">Nivel<span>*</span>:</label>
                        <input id="gang-level" type="level" name="level" required/>
                    </div>
                    <p>Blip</p>

                    <div class="blip">
                        Label <input id="label-blip" type="label" name="label" required/>
                        Sprite <input id="sprite-blip" type="sprite" name="sprite" required/>
                        Color <input id="color-blip" type="colorr" name="color" required/>
                        X <input id="x-blip" type="x" name="x" required/>
                        Y <input id="y-blip" type="y" name="y" required/>
                        Z <input id="z-blip" type="z" name="z" required/>
                        <div id="coords-blip" class="coords">
                            <span>Actuales</span>
                        </div>
                    </div>

                    <p>Rangos</p>

                    <div class="ranks-wrapper">

                    </div>

                    <div style="background-color: #01a0fc62;" id="add-rank" class="btn-block2">
                        <span>Añadir rango</span>
                    </div>
                    
                    <div style="background-color: red;" id="delete-rank" class="btn-block2">
                        <span>Eliminar último</button>
                    </div>

                    <p>Puntos</p>

                    <div class="markers-wrapper">

                    </div>

                    <div style="background-color: #01a0fc62;" id="add-marker" class="btn-block2">
                        <span>Añadir punto</button>
                    </div>
                    
                    <div id="delete-marker" class="btn-block2">
                        <span >Eliminar último</button>
                    </div>

                    <hr></hr>

                    <div class="btn-block">
                        <button id="createGang">Crear banda</button>
                    </div>
                </form>
            </div>
        `
    }

    $('body').on("click", "#home", function() {
        $(selectedCategory).removeClass("selected");
        $(this).addClass("selected");
        $('.header-text').hide().html($(this).children(".category-text").text()+'<i id="close" style="position:absolute; text-align:center; font-size: 2.5vw; left: 34vw;" class="fas fa-times"></i>').fadeIn(500);
        selectedCategory = '#home';
        editingGang = {}
        $('.info-wrapper').hide().html(infoWrapper[selectedCategory]).fadeIn(500);
        updateGangs(gangsData);
    });

    $('body').on("click", "#create", function() {
        $(selectedCategory).removeClass("selected");
        $(this).addClass("selected");
        $('.header-text').hide().html($(this).children(".category-text").text()+'<i id="close" style="position:absolute; text-align:center; font-size: 2.5vw; left: 34vw;" class="fas fa-times"></i>').fadeIn(500);
        selectedCategory = '#create';
        editingGang = {}
        $('.info-wrapper').hide().html(infoWrapper[selectedCategory]).fadeIn(500);
    });


    $('body').on("click", '#add-rank', function() {
        ranks++;
        $('.ranks-wrapper').append(`
            <div id="rank-${ranks}" isBoss="false" class="rank">
                Label <input id="label-${ranks}" type="label" name="label" required/>
                Nombre <input id="name-${ranks}" type="name" name="name" required/>
                Salario <input id="salary-${ranks}" type="salary" name="salary" required/>
                <div id="isBoss-${ranks}" class="isBoss">
                    <span>Jefe</span>
                </div>
            </div>
        `);

        $('#isBoss-'+ranks).on("click", function() {
            if ($(this).parent(".rank").attr('isBoss') == 'false') {
                $(this).css('background-color', 'green');
                $(this).parent(".rank").attr('isBoss', 'true')
            } else {
                $(this).css('background-color', 'red');
                $(this).parent(".rank").attr('isBoss', 'false')
            };
        });
    });

    $('body').on("click", '#delete-rank', function() {
        $('.ranks-wrapper .rank:last-child').remove();
        ranks = ranks - 1;
    });

    $('body').on("click", '#add-marker', function() {
        markers++;
        $('.markers-wrapper').append(`
            <div id="marker-${markers}" class="marker">
                <label for="marker-type-${markers}">Tipo:</label>
                <select num="${markers}" name="marker-type-${markers}" id="marker-type-${markers}" style="width: 8vw; height: 2vw;" required>
                    <option value="armory">Armario</option>
                    <option value="getvehs">Sacar coches</option>
                    <option value="savevehs">Guardar vehículos</option>
                    <option value="boss">Jefe</option>
                    <option value="clothing">Cambiar de Ropa</option>
                </select>

                X <input id="x-${markers}" type="x" name="x" required/>
                Y <input id="y-${markers}" type="y" name="y" required/>
                Z <input id="z-${markers}" type="z" name="z" required/>
                <div id="coords-${markers}" class="coords">
                    <span>Actuales</span>
                </div>
            </div>
        `);

        $('body').on("click", '#coords-'+markers, function() {
            $.post("https://Ox-Gangs/actualCoords", JSON.stringify({}), function(coords){
                if (coords) {
                    coords = JSON.parse(coords)
                    $("#x-"+markers).val(coords.x)
                    $("#y-"+markers).val(coords.y)
                    $("#z-"+markers).val(coords.z)
                }
            })
        });
    });

    $('body').on("click", '#coords-blip', function() {
        $.post("https://Ox-Gangs/actualCoords", JSON.stringify({}), function(coords){
            if (coords) {
                coords = JSON.parse(coords)
                $("#x-blip").val(coords.x)
                $("#y-blip").val(coords.y)
                $("#z-blip").val(coords.z)
            }
        })
    });

    $("body").on("click", "#delete-marker", function(){
        if ($('#marker-'+markers)[0]) {
            $('#marker-'+markers)[0].remove();
            markers = markers - 1;
            return;
        }
    });

    $("body").on("click", "#close", function(){
        $(".main-wrapper").fadeOut(400);
        gangsData = {};
        $.post("https://Ox-Gangs/close", JSON.stringify({}));
    });

    $("body").on("click", "#createGang", function(){
        let initialData = {
            name: $("#gang-name").val(),
            label: $("#gang-label").val(),
            level: $("#gang-level").val(),
            blip: [],
            points: [],
            ranks: [],
        }

        let toInsert = {
            x: $(`#x-blip`).val(),
            y: $(`#y-blip`).val(),
            z: $(`#z-blip`).val(),
            color: $(`#color-blip`).val(),
            text: $(`#label-blip`).val(),
            sprite: $(`#sprite-blip`).val(),
        }
        initialData.blip.push(toInsert)

        for (var i = 1; i <= markers; i++) {
            let toInsert = {
                x: $(`#x-${i}`).val(),
                y: $(`#y-${i}`).val(),
                z: $(`#z-${i}`).val(),
                selected: $(`#marker-type-${i}`).val(),
            }
            initialData.points.push(toInsert)
        };

        for (var i = 1; i <= ranks; i++) {
            let toInsert = {
                name: $(`#name-${i}`).val(),
                label: $(`#label-${i}`).val(),
                salary: $(`#salary-${i}`).val(),
                isBoss: $(`#rank-${i}`).attr("isBoss"),
            }
            initialData.ranks.push(toInsert)
        }

        $('.info-wrapper').hide().html(infoWrapper[selectedCategory]).fadeIn(500);
        $.post("https://Ox-Gangs/createGang", JSON.stringify(initialData), function(newdata){
            if (newdata) {
                updateGangs(newdata)
            }
        });
    });

    $("body").on("click", "#editGang", function(){
        let initialData = {
            name: $("#gang-name").val(),
            label: $("#gang-label").val(),
            level: $("#gang-level").val(),
            blip: [],
            points: [],
            ranks: [],
        }

        let toInsert = {
            x: $(`#x-blip`).val(),
            y: $(`#y-blip`).val(),
            z: $(`#z-blip`).val(),
            color: $(`#color-blip`).val(),
            text: $(`#label-blip`).val(),
            sprite: $(`#sprite-blip`).val(),
        }
        initialData.blip.push(toInsert)

        for (var i = 1; i <= Object.keys(editingGang.points).length; i++) {
            let toInsert = {
                x: $(`#x-${i}`).val(),
                y: $(`#y-${i}`).val(),
                z: $(`#z-${i}`).val(),
                selected: $(`#marker-type-${i}`).val(),
            }
            initialData.points.push(toInsert)
        };

        for (var i = 1; i <= Object.keys(editingGang.ranks).length; i++) {
            let toInsert = {
                name: $(`#name-${i}`).val(),
                label: $(`#label-${i}`).val(),
                salary: $(`#salary-${i}`).val(),
                isBoss: $(`#rank-${i}`).attr("isBoss"),
            }
            initialData.ranks.push(toInsert)
        }

        $('.info-wrapper').hide().html(infoWrapper[selectedCategory]).fadeIn(500);
        editingGang = {}

        $.post("https://Ox-Gangs/editGang", JSON.stringify(initialData), function(newdata){
            if (newdata) {
                updateGangs(newdata)
            }
        });
    });

    $("body").on("click", "#edit", function(){
        editingGang = gangsData[$(this).parent("#modify").attr('name')];
        $('.header-text').hide().html('Edición <i id="close" style="position:absolute; text-align:center; font-size: 2.5vw; left: 34vw;" class="fas fa-times"></i>').fadeIn(500);
        $('.info-wrapper').hide().html(`
        <div class="create-wrapper">
            <form>
                <div class="banner">
                    <h1>Edición de bandas</h1>
                </div>
                <p>Información básica</p>
                <div class="item">
                    <label for="name">Nombre:</label>
                    <input id="gang-name" type="text" name="name" value="${editingGang.name}" required/>
                </div>
                <div class="item">
                    <label for="label">Label:</label>
                    <input id="gang-label" type="label" name="label" value="${editingGang.label}" required/>
                </div>
                <div class="item">
                    <label for="level">Nivel:</label>
                    <input id="gang-level" type="level" name="level" value="${editingGang.level}" required/>
                </div>
                <p>Blip</p>

                <div class="blip">
                    Label <input id="label-blip" type="label" name="label" value="${editingGang.blip[0].text}" required/>
                    Sprite <input id="sprite-blip" type="sprite" name="sprite" value="${editingGang.blip[0].sprite}" required/>
                    Color <input id="color-blip" type="colorr" name="color" value="${editingGang.blip[0].color}" required/>
                    X <input id="x-blip" type="x" name="x" value="${editingGang.blip[0].x}" required/>
                    Y <input id="y-blip" type="y" name="y" value="${editingGang.blip[0].y}" required/>
                    Z <input id="z-blip" type="z" name="z" value="${editingGang.blip[0].z}" required/>
                    <div id="coords-blip" class="coords">
                        <span>Actuales</span>
                    </div>
                </div>

                <p>Rangos</p>

                <div class="ranks-wrapper">

                </div>

                <div style="background-color: #01a0fc62;" id="add-rank" class="btn-block2">
                    <span>Añadir rango</span>
                </div>
                
                <div style="background-color: red;" id="delete-rank" class="btn-block2">
                    <span>Eliminar último</button>
                </div>

                <p>Puntos</p>

                <div class="markers-wrapper">

                </div>

                <div style="background-color: #01a0fc62;" id="add-marker" class="btn-block2">
                    <span>Añadir punto</button>
                </div>

                <hr></hr>

                <div class="btn-block">
                    <button id="editGang">Editar banda</button>
                </div>
            </form>
        </div>
    `).fadeIn(500);
        let markers = editingGang.points
        for (const i in markers) {
            if (markers[i]) {
                let id = parseInt(i) + 1
                $('.markers-wrapper').append(`
                    <div id="marker-${id}" class="marker">
                        <label for="marker-type-${id}">Tipo:</label>
                        <select num="${id}" name="marker-type-${id}" id="marker-type-${id}" value="${markers[i].selected}" style="width: 8vw; height: 2vw;" required>
                            <option value="armory">Armario</option>
                            <option value="getvehs">Sacar coches</option>
                            <option value="savevehs">Guardar vehículos</option>
                            <option value="boss">Jefe</option>
                            <option value="clothing">Cambiar de Ropa</option>
                        </select>

                        X <input id="x-${id}" value="${markers[i].x}" type="x" name="x" required/>
                        Y <input id="y-${id}" value="${markers[i].y}" type="y" name="y" required/>
                        Z <input id="z-${id}" value="${markers[i].z}" type="z" name="z" required/>
                        <div id="editingCoords-${id}" class="coords">
                            <span>Actuales</span>
                        </div>

                        <div style="margin-left: 2vw;" id="delete-this-marker" marker="${id}" class="btn-block2">
                            <span >Eliminar</button>
                        </div>
                    </div>
                `);

                $('body').on("click", '#editingCoords-'+id, function() {
                    $.post("https://Ox-Gangs/actualCoords", JSON.stringify({}), function(coords){
                        if (coords) {
                            coords = JSON.parse(coords)
                            $("#x-"+id).val(coords.x)
                            $("#y-"+id).val(coords.y)
                            $("#z-"+id).val(coords.z)
                        }
                    })
                });

                $("#marker-type-"+(id)).val(markers[i].selected).change();
            }
        }

        let ranks = editingGang.ranks
        for (const i in ranks) {
            if (ranks[i]) {
                let id = parseInt(i) + 1
                $('.ranks-wrapper').append(`
                    <div id="rank-${id}" isBoss="${ranks[i].isBoss}" class="rank">
                        Label <input id="label-${id}" value="${ranks[i].label}" type="label" name="label" required/>
                        Nombre <input id="name-${id}" value="${ranks[i].name}" type="name" name="name" required/>
                        Salario <input id="salary-${id}" value="${ranks[i].salary}"type="salary" name="salary" required/>
                        <div id="isBoss-${id}" class="isBoss">
                            <span>Jefe</span>
                        </div>

                        <div style="margin-left: 2vw;" id="delete-this-rank" rank="${id}" class="btn-block2">
                            <span >Eliminar</button>
                        </div>
                    </div>
                `);

                if (ranks[i].isBoss) {
                    $('#isBoss-'+(id)).css("background-color", "green")
                }

                $('#isBoss-'+(id)).on("click", function() {
                    if ($(this).parent(".rank").attr('isBoss') == 'false') {
                        $(this).css('background-color', 'green');
                        $(this).parent(".rank").attr('isBoss', 'true')
                    } else {
                        $(this).css('background-color', 'red');
                        $(this).parent(".rank").attr('isBoss', 'false')
                    };
                });
            }
        }
    });

    $("body").on("click", "#delete-this-rank", function(){
        $(this).parent(".rank").remove()
    });

    $("body").on("click", "#delete-this-marker", function(){
        $(this).parent(".marker").remove()
    });

    $("body").on("click", "#delete", function(){
        let name = $(this).attr('name');
        $('.confirm-wrapper').fadeIn(300);
        
        $("#cancel-btn").on("click", function(){
            $(".confirm-wrapper").fadeOut(300);
        });

        $("#confirm-btn").on("click", function(){
            $('.confirm-wrapper').fadeOut(300);
            $('.info-wrapper').hide().html(infoWrapper[selectedCategory]).fadeIn(500);
            $.post("https://Ox-Gangs/deleteGang", JSON.stringify(name), function(newdata){
                if (newdata) {
                    updateGangs(newdata)
                }
            });
        });
    });

    window.addEventListener("message", function (event) {  
        const open = event.data.open;

        if (open) {
            if (selectedCategory == "#home") {
                updateGangs(event.data.gangs)
            } else {
                gangsData = event.data.gangs;
            }
            $(".main-wrapper").fadeIn(400);
        };
    });

    function updateGangs(gangs){
        gangsData = gangs;
        $('.info-wrapper').html(infoWrapper['#home']);
        for (const i in gangs) {
            if (gangs[i]) {
                let name = gangs[i].name
                $('#tbody').append(`
                    <tr id="table-${name}">
                        <td id="name-${name}">${name}</td>
                        <td id="label-${name}">${gangs[i].label}</td>
                        <td id="ranks-${name}">${Object.keys(gangs[i].ranks).length}</td>
                        <td id="level-${name}">${gangs[i].level}</td>
                        <td></td>
                        <td id="modify" name="${name}">
                            <i name="${name}" id="edit" style="text-align:center; color:rgb(6, 110, 14);" class="fas fa-edit"></i>
                            <i name="${name}" id="delete" style="text-align:center; margin-left: 0.5vw; color:#ee6969;" class="fas fa-trash"></i>
                        </td>
                    </tr>
                `);
            }
        }
    }
})