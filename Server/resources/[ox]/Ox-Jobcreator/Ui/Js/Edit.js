handleLoad = () => {
    window.addEventListener("message", function (event) {  
        switch(event.data.type) {
            case "loadData":
                JOB.LoadJobs(event.data.JobsData)
        }
    })

    let JOB = []

    JOB.ExecuteCallback = async function(name, data, type, job) {
        return new Promise(resolve => {
            $.post(`https://${GetParentResourceName()}/`+name, JSON.stringify({data: data, type: type || "none", job: job}), function(result) {
                resolve(JSON.parse(result))
            })
        })
    }

    JOB.LoadJobs = (JobsData) => {
        Object.entries(JobsData).forEach(([key, value]) => {
            console.log(JSON.stringify(value));
            $(".edit-wrapper").append(`
            
                <div id="${key}" class="job-wrapper">
                    <a href="#homeSubmenu-${key}" id="dropdown-toggle-text" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle text" style="color: black; font-size: .7vw;">${value.label}</a>
                    <ul class="collapse list-unstyled" id="homeSubmenu-${key}">
                        <li class="item-list">
                            <a href="#homeSubmenu-markers-${key}" id="dropdown-toggle-negros" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle text" style="color: black; font-size: .7vw;">Puntos</a>
                            <ul class="collapse list-unstyled" id="homeSubmenu-markers-${key}">
                                <li class="item-list">
                                    <div class="edit-ranks" id="edit-markers-${key}">
                                    <div class="save" id="save-markers-${key}"><span class="text" style="font-size: .7vw;">Save</span></div> <div class="save" id="add-markers-${key}"><span class="text" style="font-size: .7vw;">Add</span></div>                                                            
                                    </div>
                                </li>
                            </ul>
                            <a href="#homeSubmenu-vehicles-${key}" id="dropdown-toggle-negros" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle text" style="color: black; font-size: .7vw;">Vehículos</a>
                            <ul class="collapse list-unstyled" id="homeSubmenu-vehicles-${key}">
                                <li class="item-list">
                                    <div class="edit-ranks">
                                        <div class="rank-num" id="vehicles-${key}">
                                            
                                        </div>          
                                        <div class="save" id="add-vehicle-${key}" style="background-color: blueviolet;"><span class="text" style="font-size: .4vw;">Add a vehicle</span></div> 
                                        <div class="save" id="save-vehicles-${key}"><span class="text" style="font-size: .7vw;">Save</span></div>                              
                                    </div>
                                </li>
                            </ul>
                            <a href="#homeSubmenu-shop-${key}" id="dropdown-toggle-negros" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle text" style="color: black; font-size: .7vw;">Tienda</a>
                            <ul class="collapse list-unstyled" id="homeSubmenu-shop-${key}">
                                <li class="item-list">
                                    <div class="edit-ranks">
                                        <div class="rank-num" id="shop-${key}">
                                            
                                        </div>          
                                        <div class="save" id="add-shop-${key}" style="background-color: blueviolet;"><span class="text" style="font-size: .4vw;">Add item</span></div> 
                                        <div class="save" id="save-shop-${key}"><span class="text" style="font-size: .7vw;">Save</span></div>                              
                                    </div>
                                </li>
                            </ul>
                            <a href="#homeSubmenu-options-${key}" id="dropdown-toggle-negros" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle text" style="color: black; font-size: .7vw;">Opciones</a>
                            <ul class="collapse list-unstyled" id="homeSubmenu-options-${key}">
                                <li class="item-list">
                                    <div class="edit-ranks" style="gap: 0vw;">
                                        <label class="text" style="color: black; font-size: .7vw;">Handcuff
                                            <input id="handcuff-${key}" type="checkbox" style="transform: scale(0.9);" checked="false">
                                        </label>
                                        <label class="text" style="color: black; font-size: .7vw;">Vehicle info
                                            <input id="vehinfo-${key}" type="checkbox" style="transform: scale(0.9);" checked="false">
                                        </label>
                                        <label class="text" style="color: black; font-size: .7vw;">Put objects
                                            <input id="objects-${key}" type="checkbox" style="transform: scale(0.9);" checked="false">
                                        </label>
                                        <label class="text" style="color: black; font-size: .7vw;">Billing (only ESX)
                                            <input id="billing-${key}" type="checkbox" style="transform: scale(0.9);" checked="false">
                                        </label>
                                        <label class="text" style="color: black; font-size: .7vw;">Search 
                                        <input id="search-${key}" type="checkbox" style="transform: scale(0.9);" checked="false">
                                        </label>
                                        <div class="save" name="${key}" id="saveoptions-${key}"><span class="text" style="font-size: .7vw;">Save</span></div>                              
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>            
            `)

            
            $(`#handcuff-${key}`).prop("checked", value['options']['handcuff'])
            $(`#vehinfo-${key}`).prop("checked", value['options']['vehinfo'])
            $(`#objects-${key}`).prop("checked", value['options']['objects'])
            $(`#billing-${key}`).prop("checked", value['options']['billing'])
            $(`#search-${key}`).prop("checked", value['options']['search'])

            $(`#saveoptions-${key}`).on("click", function() {
                const name = $(this).attr("name")
                const Data = {
                    handcuff: $(`#handcuff-${name}`).is(":checked"),
                    vehinfo: $(`#vehinfo-${name}`).is(":checked"),
                    objects: $(`#objects-${name}`).is(":checked"),
                    billing: $(`#billing-${name}`).is(":checked"),
                    search: $(`#search-${name}`).is(":checked")
                }
                JOB.ExecuteCallback("updateInfo", Data, "updateOptions", key)
            })

            $(`#add-markers-${key}`).on("click", async () => {
                markers++
                $(`#edit-markers-${key}`).append(`
                    <div class="rank-num" id="markers-${markers+'-'+key}">
                        <input class="text" id="markere-${markers+'-'+key}-x" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="X" value="0"></input>
                        <input class="text" id="markere-${markers+'-'+key}-y" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Y" value="0"></input>
                        <input class="text" id="markere-${markers+'-'+key}-z" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Z" value="0"></input>
                        <select num="${markers+'-'+key}" id="markere-${markers+'-'+key}-selected" style="width: 2vw;">
                            <option value="armory">Armario</option>
                            <option value="getheli">Sacar helicóptero</option>
                            <option value="getvehs">Sacar coches</option>
                            <option value="savevehs">Guardar coches</option>
                            <option value="boss">Jefe</option>
                            <option value="shop">Tienda</option>
                            <option value="wardrobe">Ropa</option>
                            <option value="duty">Entrar/Salir de Servicio</option>
                            <option value="clothing">Cambiarse de Ropa</option>
                        </select>
                        <div class="button actualcoords" style="position: relative;" num="${markers+'-'+key}" id="markere-${markers+'-'+key}-button" style="background-color: red;"><span class="text" style="font-size: .4vw;">Actual coords</span></div>
                        <div class="button actualcoords" style="position: relative;" num="${markers+'-'+key}" id="markeredelete-${markers+'-'+key}-button" style="background-color: red;"><span class="text" style="font-size: .4vw;">Delete</span></div>
                    </div>  
                `)
                $(`#markere-${markers+'-'+key}-button`).on("click", async function() {
                    let coords = await JOB.ExecuteCallback("getCoords")
                    let actualMarker = $(this).attr("num")
                    let axis = ['x', 'y', 'z']
                    axis.forEach((ax) => {
                        $(`#markere-${actualMarker}-${ax}`).val(coords[ax])
                    })
                })
                $(`#markeredelete-${markers+'-'+key}-button`).on("click", function() {
                    let actualMarker = $(this).attr("num")
                    $(`#markers-${actualMarker}`).remove()
                })
            })
            let markers = 0

            value['points'].forEach((val) => {
                markers++
                $(`#edit-markers-${key}`).append(`
                    <div class="rank-num" id="markers-${markers+'-'+val.Job}">
                        <input class="text" id="markere-${markers+'-'+val.Job}-x" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="X" value="${val.x}"></input>
                        <input class="text" id="markere-${markers+'-'+val.Job}-y" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Y" value="${val.y}"></input>
                        <input class="text" id="markere-${markers+'-'+val.Job}-z" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Z" value="${val.z}"></input>
                        <select num="${markers+'-'+val.Job}" id="markere-${markers+'-'+val.Job}-selected" style="width: 6vw;">
                            <option value="armory">Armario</option>
                            <option value="getheli">Sacar helicóptero</option>
                            <option value="getvehs">Sacar coches</option>
                            <option value="savevehs">Guardar coches</option>
                            <option value="boss">Jefe</option>
                            <option value="shop">Tienda</option>
                            <option value="wardrobe">Ropa</option>
                            <option value="duty">Entrar/Salir de Servicio</option>
                            <option value="clothing">Cambiarse de Ropa</option>
                        </select>
                        <div class="button actualcoords" style="position: relative;" num="${markers+'-'+val.Job}" id="markere-${markers+'-'+val.Job}-button" style="background-color: red;"><span class="text" style="font-size: .4vw;">Actual coords</span></div>
                        <div class="button actualcoords" style="position: relative;" num="${markers+'-'+val.Job}" id="markeredelete-${markers+'-'+val.Job}-button" style="background-color: red;"><span class="text" style="font-size: .4vw;">Delete</span></div>
                    </div>  
                `)
                $(`#markere-${markers+'-'+val.Job}-selected`).val(val.selected);
                $(`#markere-${markers+'-'+val.Job}-button`).on("click", async function() {
                    let coords = await JOB.ExecuteCallback("getCoords")
                    let actualMarker = $(this).attr("num")
                    let axis = ['x', 'y', 'z']
                    axis.forEach((ax) => {
                        $(`#markere-${actualMarker}-${ax}`).val(coords[ax])
                    })
                })
                $(`#markeredelete-${markers+'-'+val.Job}-button`).on("click", function() {
                    let actualMarker = $(this).attr("num")
                    $(`#markers-${actualMarker}`).remove()
                })
            })
            let vehicles = 0
            value['publicvehicles'].forEach((val) => {
                vehicles++
                $(`#vehicles-${key}`).append(`              
                    <input class="text" id="veh-${vehicles}-${key}" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Vehicle" value="${val}"></input>
                    <div style="background-color: red" class="save" num="${vehicles}" id="delete-vehicles-${key}-${vehicles}"><span class="text" style="font-size: .7vw;">Delete</span></div>       
                `)
                $(`#delete-vehicles-${key}-${vehicles}`).on("click", function() {
                    let actualVeh = $(this).attr("num")
                    $(`#veh-${actualVeh}-${key}`).remove()
                    $(this).remove()
                })
            })

            $(`#add-vehicle-${key}`).on("click", function() {
                vehicles++
                $(`#vehicles-${key}`).append(`              
                    <input class="text" id="veh-${vehicles}-${key}" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Vehicle" value=""></input>
                    <div style="background-color: red" class="save" num="${vehicles}" id="delete-vehicles-${key}-${vehicles}"><span class="text" style="font-size: .7vw;">Delete</span></div>
                `)
                $(`#delete-vehicles-${key}-${vehicles}`).on("click", function() {
                    let actualVeh = $(this).attr("num")
                    $(`#veh-${actualVeh}-${key}`).remove()
                    $(this).remove()
                })
            })

            $(`#save-vehicles-${key}`).on("click", function() {
                let Data = []
                for (var i = 1; i <= vehicles; i++) {
                    if ($(`#veh-${i}-${key}`).val()) {
                        Data.push($(`#veh-${i}-${key}`).val())
                    }
                }
                JOB.ExecuteCallback("updateInfo", Data, "updateVehicles", key)
            })

            let shop  = 0;
            value['shop'].forEach((val) => {
                shop++
                $(`#shop-${key}`).append(`              
                    <input class="text" id="it-${shop}-${key}" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Item" value="${val[0]}"></input>
                    <input class="text" id="it-${shop}-${key}" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Price" value="${val[1]}"></input>
                    <div style="background-color: red" class="save" num="${shop}" id="delete-shop-${key}-${shop}"><span class="text" style="font-size: .7vw;">Delete</span></div>       
                `)
                $(`#delete-shop-${key}-${shop}`).on("click", function() {
                    let actualVeh = $(this).attr("num")
                    $(`#it-${actualVeh}-${key}`).remove()
                    $(`#it-price-${actualVeh}-${key}`).remove()
                    $(this).remove()
                })
            })


            $(`#add-shop-${key}`).on("click", function() {
                shop++
                $(`#shop-${key}`).append(`              
                    <input class="text" id="it-${shop}-${key}" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Item" value=""></input>
                    <input class="text" id="it-price-${shop}-${key}" style="color: black; text-align: center; width: 50%; font-size: 0.8vw;" placeholder="Precio" value=""></input>
                    <div style="background-color: red" class="save" num="${shop}" id="delete-shop-${key}-${shop}"><span class="text" style="font-size: .7vw;">Delete</span></div>
                `)

                $(`#delete-shop-${key}-${shop}`).on("click", function() {
                    let actualVeh = $(this).attr("num")
                    $(`#it-${actualVeh}-${key}`).remove()
                    $(`#it-price-${actualVeh}-${key}`).remove()
                    $(this).remove()
                })
            })

            $(`#save-shop-${key}`).on("click", function() {
                let Data = []
                for (var i = 1; i <= shop; i++) {
                    if ($(`#it-${i}-${key}`).val() && $(`#it-price-${i}-${key}`).val()) {
                        Data.push([$(`#it-${i}-${key}`).val(), $(`#it-price-${i}-${key}`).val()])
                    }
                }
                JOB.ExecuteCallback("updateInfo", Data, "updateShop", key)
            })

            $(".dropdown-toggle").on("click", function() {
                var isExpanded = $(this).attr("aria-expanded")
                let that = this
                if (isExpanded === "false") {
                    
                } else {
                    setTimeout(() => {
                        $(that).removeClass("collapse")
                    }, 358);
                }
            })


            $(`#save-markers-${key}`).on("click", function() {
                let Data = []
                for (var i = 1; i <= markers; i++) {
                    if ($(`#markere-${i+'-'+key}-x`).val()) {
                        let toInsert = {
                            Job: key,
                            x: $(`#markere-${i+'-'+key}-x`).val(),
                            y: $(`#markere-${i+'-'+key}-y`).val(),
                            z: $(`#markere-${i+'-'+key}-z`).val(),
                            selected: $(`#markere-${i+'-'+key}-selected`).val(),
                        }
                        Data.push(toInsert)
                    }
                }
                JOB.ExecuteCallback("updateInfo", Data, "updateMarkers", key)
            })


        })
    }



}

window.addEventListener("load", this.handleLoad)