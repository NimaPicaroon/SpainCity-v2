//Variables necesarias
var animacionTabletActiva = false;
var lockAudio = new Audio("./extra/lock_tablet.mp3");
var unlockAudio = new Audio("./extra/unlock_tablet.mp3");
var notificacionActiva = false;
var lastSubmenuOpened = "";
var submenuAnimationActive = false;
var notificationAudio = new Audio("./extra/notification.mp3");
    notificationAudio.volume = .30;

var currentPage = "current_user_information_page";

var multas = [

];




//JSON de facturas
var facturas = [
    {
        "id": "FCT01",
        "definicion": "Atención Primaria",
        "coste": 200
    },
    {
        "id": "FCT02",
        "definicion": "Atención secundaria",
        "coste": 400
    },
    {
        "id": "FCT03",
        "definicion": "Atención terciaria",
        "coste": 1000
    },
    {
        "id": "FCT04",
        "definicion": "Atención metropolitana en ambulancia",
        "coste": 400
    },
    {
        "id": "FCT05",
        "definicion": "Atención extrarradio (hasta SANDY SHORES)",
        "coste": 500
    },
    {
        "id": "FCT06",
        "definicion": "Atención extrarradio (hasta PALETO)",
        "coste": 700
    },
    {
        "id": "FCT07",
        "definicion": "Suplemento por traslado al hospital",
        "coste": 100
    },
    {
        "id": "FCT08",
        "definicion": "Consultas externas",
        "coste": 200
    },
    {
        "id": "FCT09",
        "definicion": "Psicotécnico",
        "coste": 800
    },
    {
        "id": "FCT10",
        "definicion": "Reconocimiento médico",
        "coste": 1300
    }
];


var adminItems = [];

//Esto es solo para trabajar más cómodo
$(document).ready(function() {
    //$("body").hide(); // DESCOMENTAR y el de las posiciones de tablet y opacity de pantalla en CSS

    window.addEventListener('message', (event) => {
        if (event.data.action === 'show') {
            SetOpenDataTablet(event.data.data);
            multas = event.data.penalties;
            adminItems = event.data.items;
            mostrarOcultarTablet();
        } else if (event.data.action === 'refreshrobos') {
            actualizarRobosEnCurso(event.data.data);
        }
    });
    
});



function SetOpenDataTablet(data) {
    $('#sapd_button').hide();
    $('#normativa_button').hide();
    $('#ems_button').hide();
    $('#admin_button').hide();
    $('#jobs_button').hide();

    $('#current_user_photo').attr("src",data.Avatar);
    $('#current_user_name_tablet').text(data.Name)
    $('#current_user_name').text(data.RealName)
    $('#current_user_id').text(data.Identifier)
    if (data.Sex === 'H'){
        $('#current_user_genre').text("Masculino")
    }else{
        $('#current_user_genre').text("Femenino")
    }
    $('#current_user_phone').text(data.Phone)
    $('#current_user_date_birth').text(data.Dob)
    $('#current_user_penalties').text("$"+data.Unpaid)

    if (data.Secure === true){
        $('#current_user_life_insurance').removeClass('hasNotInsurance');
        $('#current_user_life_insurance').removeClass('hasInsurance');
        $('#current_user_life_insurance').addClass('hasInsurance');
        $('#current_user_life_insurance').text("Seguro disponible")
    }else{
        $('#current_user_life_insurance').removeClass('hasNotInsurance');
        $('#current_user_life_insurance').removeClass('hasInsurance');
        $('#current_user_life_insurance').addClass('hasNotInsurance');
        $('#current_user_life_insurance').text("Sin Seguro")
    }
    
    let recordsHtml = `
    <li>
        <span>Descripción de la consulta</span>
        <span>Doctor asignado</span>
        <span>Fecha de consulta</span>
        <span>Tratamiento</span>
    </li>`

    $('#current_user_medical_history_table').html("")

    data.Records.forEach(element => {
        recordsHtml = recordsHtml + `
        <li>
            <span>${element.description}</span>
            <span>${element.doctor}</span>
            <span>${element.sent_date}</span>
            <span>${element.tratamiento}</span>
        </li>
        `
        }
    );
    
    $('#current_user_medical_history_table').html(recordsHtml)

    //Crimenes
    let penaltiesHtml = `
    <li>
        <span>Descripción de la infracción</span>
        <span>Oficial asignado</span>
        <span>Fecha de registro</span>
        <span>Sanción</span>
    </li>`

    $('#current_user_crimes_history_table').html("")

    data.Penals.forEach(element => 
        penaltiesHtml = penaltiesHtml + `
        <li>
        <span>${element.description}</span>
        <span>${element.sender_name}</span>
        <span>${element.sent_date}</span>
        <span>${element.penaltie}</span>
        </li>
        `
    );
    $('#current_user_crimes_history_table').html(penaltiesHtml)

    //Facturas
    let invoicesHtml = `
    <li>
        <span>Definición</span>
        <span>Coste de la sanción</span>
        <span>Emisor</span>
        <span>Fecha de emisión</span>
        <span>Estado</span>
        <span>Acciones</span>
    </li>`

    $('#current_user_penalties_table').html("")

    data.Invoices.forEach(element => 
        invoicesHtml = invoicesHtml + `
        <li>
            <span>` + element.item + `</span>
            <span>$` + element.invoice_value + `</span>
            <span>` + element.author_name + `</span>
            <span>` + element.sent_date + `</span>
            <span data-id="` + element.id + `" class="status_label pending">
                <div class="text">Pediente</div>
            </span>
            <span class="action_buttons_container">
                <div class="action_button payment">
                    <img src="./img/payment_logo.png">
                    <span class="action_label">Pagar multa</span>
                </div>
                
            </span>
        </li>
        `
    );

    $('#current_user_penalties_table').html(invoicesHtml)

    //Casas
    let housesHtml = `
    <li>
        <span>Nº</span>
        <span>Reforma</span>
        <span>Estado de la puerta</span>
    </li>`

    $('#current_user_properties_table').html("")

    data.Houses.forEach(element => 

        housesHtml = housesHtml + `
        <li>
            <span>` + element.id + `</span>
            <span>` + element.interior + `</span>
            <span>` + (element.locked ? "Cerrada" : "Abierta") + `</span>
        </li>
        `
        
    );

    $('#current_user_properties_table').html(housesHtml);

    //Coches
    let carsHtml = `
    <li>
        <span>Matrícula</span>
        <span>Modelo</span>
        <span>Color</span>
        <span>Gasolina restante</span>
        <span>Garaje actual</span>
    </li>`

    $('#current_user_vehicles_table').html("")

    data.Vehicles.forEach(element => {
        var garage = element.garage;

        carsHtml = carsHtml + `
        <li>
            <span>` + element.plate + `</span>
            <span>` + element.model + `</span>
            <span><span class='color'>` + element.color[0] + `,` + element.color[1] + `,` + element.color[2] + `</span></span>
            <span>` + element.fuel.toFixed(2) + `%</span>
            <span>` + garage + `</span>
        </li>
        `
        }
    );
    
    $('#current_user_vehicles_table').html(carsHtml)
    $(".color").each(function() {
        $(this).css("background-color", "rgb(" + $(this).text() + ")")
        $(this).text("");
    })

    //Licencias
    let licensesHtml = `
    <li>
        <span>Licencias</span>
    </li>`

    $('#current_user_licenses_table').html("")

    data.Licenses.forEach(element => 

        licensesHtml = licensesHtml + `
        <li>
            <span>` + element.label + `</span>
        </li>
        `
    );

    $('#current_user_licenses_table').html(licensesHtml);

    //Job Listing
    let JobListHtml = `
    <li>
        <span>ID</span>
        <span>Nombre</span>
        <span>Rangos</span>
        <span>Acciones</span>
    </li>`

    $('#searched_jobs_table').html("")
 // snaily
    Object.entries(data.JobList).forEach(element => 
        {
            for (let index = 0; index < element[1].length; index++) {
                if (index === 0) {
                    JobListHtml = JobListHtml + `
                    <li>
                        <span>${element[1][index].name}</span>
                        <span>${element[1][index].label}</span>
                        <span class="ranges_list">
                    `
                }
                if(element[1][index].grade == "0") {
                    JobListHtml = JobListHtml + `
                    <span class="range_button selected" data-id="${element[1][index].grade}">${element[1][index].labelG} (${element[1][index].grade})</span>
                    `
                } else {
                    JobListHtml = JobListHtml + `
                    <span class="range_button" data-id="${element[1][index].grade}">${element[1][index].labelG} (${element[1][index].grade})</span>
                    `
                }
                if (index == element[1].length - 1) {
                    JobListHtml = JobListHtml + `
                    </span>
                    <span class="action_buttons_container">
                        <div class="action_button assign_job">
                            <img src="./img/new_job.png">
                            <span class="action_label">Asignar trabajo</span>
                        </div>
                    </span>
                </li>
                `
                }
            }
        }
    );

    $('#searched_jobs_table').html(JobListHtml);

    actualizarRobosEnCurso(data.ActualRobberys);

    if (data.Job === "police" || data.Job === "sheriff"){
        $('#sapd_button').show();
    }

    if (data.Job === "ambulance"){
        $('#ems_button').show();
    }
    
    if (data.Group === "admin"){
        $('#sapd_button').show();
        $('#ems_button').show();
        $('#admin_button').show();
        $('#jobs_button').show();
    }

    if (data.Group === "mod"){
        $('#admin_button').show();
        $('#jobs_button').show();
    }
}


$("#current_user_penalties_table").on('click', '.action_button.payment', function(){
       
    let id = $(this).parent().siblings(".status_label").data("id");
    $(this).addClass("disabled");
    fetch(`https://Ox-Tablet/payInvoice`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: id
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.payed === true){
                popupNotificacion("Factura pagada", true)
                $(this).parent().siblings(".status_label").removeClass("pending");
                $(this).parent().siblings(".status_label").addClass("paid");
                $(this).parent().siblings(".status_label").children(".text").text("Pagado");
                $(this).addClass("disabled");
            }else{
                popupNotificacion("No tienes suficiente dinero", false) //Con false ponemos una cruz roja en vez del check
                setTimeout(() => {
                    $(this).removeClass("disabled");
                }, 1800);

            }
        }
    );
})




$("#tablet_button").click(function() {
    mostrarOcultarTablet();
})

function mostrarOcultarTablet() {
    if(!isEditingText()){ //Control de focus en los elementos de búsqueda para que la T no cierre la tablet
        if(!animacionTabletActiva) {
            animacionTabletActiva = true;

            if($('#tablet_panel').hasClass('opened')) {

                // Apagamos la pantalla
                $('.tablet_screen_content').css("opacity", "0")
                lockAudio.play();

                //Eliminamos los elementos de la lista de items al cerrarla para que vuelvan a cargarse al entrar
                //Ademas asi ahorramos que el show de items no tenga timing ya que no habrá items 
                $("#admin_searched_items_table").children().not(":first").remove();

                //Limpiamos buscadores
                limpiarBuscadores();
                limpiarPopups();
                cortarNotificacion();                

                //Guardamos la tablet
                setTimeout(() => {  
                    $('#tablet_panel').css("transform", "translateY(120%)")
                }, 100);

                //Cerramos body
                setTimeout(() => {
                    $("body").hide();
                    animacionTabletActiva = false;
                    $('#tablet_panel').removeClass('opened');
                    $.post("https://Ox-Tablet/close", JSON.stringify({}));
                }, 400);

            } else {

                $("body").show();
                $('#tablet_panel').css("transform", "translateY(0)")

                // Cargamos los items de Administración
                cargarListadoDeItemsAdmin();

                setTimeout(() => {
                    $('.tablet_screen_content').css("opacity", "1")
                    unlockAudio.play();
                    animacionTabletActiva = false;
                    $('#tablet_panel').addClass('opened');
                }, 400);
            }
        }
    }
    
}
//Fin de encendido y apagado de la tablet con su boton y letra INICIO


function isEditingText() {
    return $("#players_search_bar").is(":focus") || $("#vehicles_search_bar").is(":focus")
        || $("#penalty_definition_textarea").is(":focus") || $("#crime_definition_textarea").is(":focus")
        || $("#new_sapd_note_textarea").is(":focus") || $("#ems_players_search_bar").is(":focus")
        
        || $("#ems_searched_user_blood_type").is(":focus") || $("#ems_searched_user_diseases").is(":focus")
        || $("#ems_searched_user_mental_disorders").is(":focus") || $("#ems_searched_user_surgeries_done").is(":focus")
        || $("#ems_searched_user_vision_problems").is(":focus") || $("#ems_searched_user_psychomotor_disorders").is(":focus")
        
        || $("#ems_medical_consultation_assigned_doctor").is(":focus") || $("#ems_medical_consultation_description").is(":focus")
        || $("#ems_medical_consultation_treatment").is(":focus") || $("#ems_medical_consultation_surgery_doctors").is(":focus")
        || $("#ems_medical_consultation_wounds").is(":focus") || $("#ems_medical_consultation_observations").is(":focus")
        || $("#admin_items_search_bar").is(":focus") || $("#penalties_selector_searcher").is(":focus")
        || $("#admin_players_search_bar").is(":focus") || $("#user_name_change").is(":focus")
        || $("#jobs_search_bar").is(":focus") || $("#new_admin_note_textarea").is(":focus")
        || $("#new_job_user_id_input").is(":focus");
}







//Funciones de accion del menu principal
$("#ficha_personal_button").click(function() {    
    limpiarBuscadores();

    cambiarBotonMainMenu("ficha_personal_button");
    cambiarPantallaPrincipal("current_user_information_page");

    currentPage = "current_user_information_page";
})

$("#normativa_button").click(function() {
    limpiarBuscadores();

    cambiarBotonMainMenu("normativa_button");
    cambiarPantallaPrincipal("normativa_page");

    currentPage = "normativa_page";
})

$("#sapd_button").click(function() {
    limpiarBuscadores();

    cambiarBotonMainMenu("sapd_button");
    cambiarPantallaPrincipal("SAPD_page");

    currentPage = "SAPD_page";
})

$("#vehiculos_button").click(function() {
    limpiarBuscadores();

    cambiarBotonMainMenu("vehiculos_button");
    cambiarPantallaPrincipal("vehicles_searcher_page");

    currentPage = "vehicles_searcher_page";
})

$("#byc_button").click(function() {
    limpiarBuscadores();
    
    cambiarBotonMainMenu("byc_button");
    cambiarPantallaPrincipal("search_seizure_page");

    currentPage = "search_seizure_page";

    //Cargar las busquedas y capturas
    fetch(`https://Ox-Tablet/getUsersSearched`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.users != false){
                $("#search_seizure_users_table").children().not(":first").remove();
                resp.users.forEach(element => 
                    {
                        let id = element.id;
                        $("#search_seizure_users_table").append(`
                        <li>
                            <span class="searched_user_img">
                                <div class="user_photo_frame">
                                    <div class="user_photo_content">
                                        <img src="${element.avatar}"> 
                                    </div>
                                </div>
                            </span>
                            <span>${element.name}</span>
                            <span>$${element.unpaid}</span>
                            <span>${(element.sex === 'H' ? 'Masculino' : 'Femenino')}</span>
                            <span>${id}</span>
                            <span>${element.phone}</span>
                            <span class="action_buttons_container">
                                <div data-id="${element.id}" class="action_button open_template">
                                    <img src="./img/document-logo.png">
                                    <span class="action_label">Abrir ficha</span>
                                </div>
                            </span>
                        </li>`);
                    }
                );
            }else{
                //popupNotificacion("No se encontraron resultados", false);
            }
        }
    );
})



$("#crimes_in_progress_button").click(function() {
    // limpiarBuscadores(); --> HAY QUE IMPLMENTARLO CON DELITOS
    
    cambiarBotonMainMenu("crimes_in_progress_button");
    cambiarPantallaPrincipal("crimes_in_progress_page");

    currentPage = "crimes_in_progress_page";

    //Cargar las busquedas y capturas

})


$("#ems_button").click(function() {
    limpiarBuscadores();
    
    cambiarBotonMainMenu("ems_button");
    cambiarPantallaPrincipal("EMS_page");

    currentPage = "EMS_page";
})

$("#admin_button").click(function() {
    limpiarBuscadores();
    
    cambiarBotonMainMenu("admin_button");
    cambiarPantallaPrincipal("admin_page");


    currentPage = "admin_page";
})

$("#admin_items_button").click(function() {
    limpiarBuscadores();
    
    cambiarBotonMainMenu("admin_items_button");
    cambiarPantallaPrincipal("admin_items_page");


    currentPage = "admin_items_page";
})


$("#admin_items_button").click(function() {
    limpiarBuscadores();
    
    cambiarBotonMainMenu("admin_items_button");
    cambiarPantallaPrincipal("admin_items_page");


    currentPage = "admin_items_page";
})


$("#jobs_button").click(function() {
    limpiarBuscadores();
    
    cambiarBotonMainMenu("jobs_button");
    cambiarPantallaPrincipal("jobs_page");


    currentPage = "jobs_page";
})




//En caso de que la anterior pantalla fuera un buscador, se limpia
function limpiarBuscadores() {
    if (currentPage == "SAPD_page") {
        limpiarBuscadorSAPD();
    } else if (currentPage == "vehicles_searcher_page") {
        limpiarBuscadorVehiculosSAPD();
    } else if (currentPage == "search_seizure_page") {
        recargarByC();
    } else if (currentPage == "EMS_page") {
        limpiarBuscadorEMS();
    } else if (currentPage == "admin_page") {
        limpiarBuscadorAdmin();
    } else if (currentPage == "admin_items_page") {
        limpiarBuscadorAdminItems();
    } else if (currentPage == "jobs_page") {
        limpiarBuscadorTrabajos();
    }

    //La lista de delitos en curso se carga al abrir tablet y se recargara con el tiempo,
    //por tanto no requiere de ningun limpiador
}









function cambiarBotonMainMenu(newButton) {
    let isSAPDSubmenuButtons = (newButton == "vehiculos_button" || newButton == "byc_button" || newButton == "crimes_in_progress_button");
    let isAdminSubmenuButtons = (newButton == "admin_items_button");
    
    
    //Quitamos el selected de todas las opciones posibles
    $('#tablet_options_menu').children().removeClass('selected');
    $('#tablet_options_menu').children(".sapd_submenu").children().removeClass('selected');
    $('#tablet_options_menu').children(".admin_submenu").children().removeClass('selected');


    //Ponemos el selected segun el menu o submenu
    if (isSAPDSubmenuButtons) {
        $('#tablet_options_menu').children(".sapd_submenu").children('#' + newButton).addClass('selected');

    } else if (isAdminSubmenuButtons) {
        $('#tablet_options_menu').children(".admin_submenu").children('#' + newButton).addClass('selected');

    } else {  
        $('#tablet_options_menu').children('#' + newButton).addClass('selected');

    }

    //En caso de cambiar dentro del mismo submenu (o boton principal del mismo), no hacemos nada. Si no, siempre cerramos los submenus
    if (!(((isSAPDSubmenuButtons || newButton == "sapd_button") && lastSubmenuOpened == "sapd_submenu"
        || ((isAdminSubmenuButtons || newButton == "admin_button") && lastSubmenuOpened == "admin_submenu")))) {  
        abrirCerrarSubmenu(lastSubmenuOpened, false);

    }

    //Si datos a SAPD y su submenú NO estaba abierto, lo abrimos (y los mismo con Admin)
    if (newButton == "sapd_button" && lastSubmenuOpened != "sapd_submenu") {
        abrirCerrarSubmenu("sapd_submenu", true);

    } else if (newButton == "admin_button" && lastSubmenuOpened != "admin_submenu") {
        abrirCerrarSubmenu("admin_submenu", true);

    }

    //Guardamos cual ha sido el submenu abierto (o que se mantiene abierto) con el ultimo boton presionado ( 0 "" si no era de submenu)
    if (newButton == "sapd_button" || isSAPDSubmenuButtons) {
        lastSubmenuOpened = "sapd_submenu";

    } else if (newButton == "admin_button" || isAdminSubmenuButtons) {
        lastSubmenuOpened = "admin_submenu";

    } else {
        lastSubmenuOpened = "";

    }

}


function abrirCerrarSubmenu(submenu, isOpening) {
    if (submenu != "") {
        //Calculamos el num de subelementos y hacemos la duracion .2s mas larga por cada uno (el timing si se cambia de .2 por elemento, debe cambiarse en el css de los li de submenu tambien)
        let numSubelements = $("#" + submenu).children().length;
        let transitionTiming = .2 * numSubelements;


        //Seteamos la duracion de la animacion según su contenido
        $("#" + submenu).css("transition-duration", transitionTiming + "s");


        //Recogemos el tamaño del contenedor con todo su contenido (hace falta referenciarlo como elemento JS)
        let element = $('#' + submenu)[0];
        var submenuHeight = element.scrollHeight; 



        if (isOpening) {
            //Ponemos el height a su maximo valor de contenido
            $("#" + submenu).css("height", submenuHeight + 'px');

            //Hacemos un control de animacion activa para cerrar todos de golpe o de uno en uno si se cambio de menu antes de que acabe de abrirse
            submenuAnimationActive = true;

            setTimeout(() => {
                submenuAnimationActive = false;
            }, transitionTiming*1000);


            //Mostramos los elementos uno por uno en base al tiempo de transicion
            let n = 0;

            $("#" + submenu).children().each(function() {
                setTimeout(() => {
                    $(this).css("width", "100%");
                    $(this).css("transform", "translateX(0)");
                    $(this).css("opacity", "1");
                }, (transitionTiming*1000/numSubelements)*n);

                n++;
            });


        } else {
            //Ponemos el height a 0px
            $("#" + submenu).css("height", 0);

            //Retiramos los elementos de uno en uno en base al tiempo de transicion
            let n = numSubelements - 1;


            if (submenuAnimationActive) {
                $("#" + submenu).children().each(function() {
                    $(this).css("width", "200%");
                    $(this).css("transform", "translateX(-50%)");
                    $(this).css("opacity", "0");
                })
                
                submenuAnimationActive = false;

            } else {
                $("#" + submenu).children().each(function() {

                    setTimeout(() => {
                        $(this).css("width", "200%");
                        $(this).css("transform", "translateX(-50%)");
                        $(this).css("opacity", "0");
                    }, (transitionTiming*1000/numSubelements)*n);

                    n--;

                })

            }
        }
    }
    

}


 
function cambiarPantallaPrincipal(nuevaPantalla) {
    $('#right_screen_panel').children().removeClass('opened');
    $('#right_screen_panel').children("#" + nuevaPantalla).addClass('opened');
}

//Fin de funciones de accion del menu principal







// Funciones de accion del menu de tablas de USUARIO ACTUAL
$("#current_user_properties_button").click(function() {
    cambiarBotonTablesMenu("current_user_tables_selector", "current_user_tables_panel",  "current_user_properties_button", "current_user_properties_table");
})

$("#current_user_vehicles_button").click(function() {
    cambiarBotonTablesMenu("current_user_tables_selector", "current_user_tables_panel",  "current_user_vehicles_button", "current_user_vehicles_table");
})

$("#current_user_licenses_button").click(function() {
    cambiarBotonTablesMenu("current_user_tables_selector", "current_user_tables_panel",  "current_user_licenses_button", "current_user_licenses_table");
})

$("#current_user_crimes_history_button").click(function() {
    cambiarBotonTablesMenu("current_user_tables_selector", "current_user_tables_panel",  "current_user_crimes_history_button", "current_user_crimes_history_table");
})

$("#current_user_medical_history_button").click(function() {
    cambiarBotonTablesMenu("current_user_tables_selector", "current_user_tables_panel",  "current_user_medical_history_button", "current_user_medical_history_table");
})

$("#current_user_penalties_button").click(function() {
    cambiarBotonTablesMenu("current_user_tables_selector", "current_user_tables_panel",  "current_user_penalties_button", "current_user_penalties_table");
})



function cambiarBotonTablesMenu(selectoresActuales, tablasActuales, nuevoBoton, nuevaTabla) {
    $("#" + selectoresActuales).children().removeClass('selected');
    $("#" + selectoresActuales).children('#' + nuevoBoton).addClass('selected');

    //Cambio sin animación
    $("#" + tablasActuales).children().removeClass('opened');
    $("#" + tablasActuales).children('#' + nuevaTabla).addClass('opened');
}
// Fin de funciones de accion del menu de tablas de USUARIO ACTUAL


//Listener para el boton de pagar facturas
//Botones de modificar notas de cada nota ya creada







//Funciones de busqueda de USUARIOS en SAPD
$(document).on("keyup", "input#players_search_bar", function(e) {
    if (e.key === 'Enter') {
        buscarUsuariosSAPD();
    }
});

function buscarUsuariosSAPD() { //Esta función solo mostrará un resultado de forma estática, de la funcion te encargas tú
    let usuario = $("#players_search_bar").val().replace("<", "&lt").replace(">", "&gt");
    limpiarBuscadorSAPD();
    if (usuario.length > 1) {
        fetch(`https://Ox-Tablet/getUsersSAPD`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            name: usuario
        })}).then(resp => resp.json()).then(
            (resp) => {
                console.log(JSON.stringify(resp));
                if(resp.users != false){
                    resp.users.forEach(element => 
                        {
                            let id = element.id
                            $("#searched_users_table").append(`<li>
                                    <span class="searched_user_img">
                                        <!-- Contenedor para la foto + boton de modifciar en SAPD -->
                                        <div class="user_photo_frame">
                                            <div class="user_photo_content">
                                                <img src="${element.avatar}"> 
                                            </div>
                                        </div>
                                        <!-- Fin de contenedor para foto -->
                                    </span>
                                    <span>${element.name}</span>
                                    <span>$${element.unpaid}</span>
                                    <span>${(element.sex)}</span>
                                    // <span>${id}</span>
                                    <span>${element.phone}</span>
                                    <span class="action_buttons_container">
                                        <div data-id="${id}" class="action_button open_template">
                                            <img src="./img/document-logo.png">
                                            <span class="action_label">Abrir ficha</span>
                                        </div>
                                    </span>
                                </li>`);
                        }
                    );
                }else{
                    popupNotificacion("No se encontraron resultados", false);
                }
            }
        );
    }
    else {
        popupNotificacion("Debes escribir al menos dos caracteres", false);
    }

                            // housesHtml = housesHtml + `
                        // <li>
                        //     <span>` + element.id + `</span>
                        //     <span>` + element.interior + `</span>
                        //     <span>` + (element.locked ? "Cerrada" : "Abierta") + `</span>
                        // </li>
                        // `
    // $("#searched_users_table").append(`<li>
    //     <span class="searched_user_img">
    //         <!-- Contenedor para la foto + boton de modifciar en SAPD -->
    //         <div class="user_photo_frame">
    //             <div class="user_photo_content">
    //                 <img src="./img/usuario_prueba.jpg"> 
    //             </div>
    //         </div>
    //         <!-- Fin de contenedor para foto -->
    //     </span>
    //     <span>${usuario}</span>
    //     <span>$534,21</span>
    //     <span>Masculino</span>
    //     <span>75GTH4</span>
    //     <span>6854298</span>
    //     <span class="action_buttons_container">
    //         <div class="action_button open_template">
    //             <img src="./img/document-logo.png">
    //             <span class="action_label">Abrir ficha</span>
    //         </div>
    //     </span>
    // </li>`);


}
//Fin de funciones de busqueda de USUARIOS

//Funcion de acceso a datos de usuraio en SAPD con boton de Mostrar plantilla
$('#searched_users_table').on('click', '.action_button.open_template', function(){ //Selector que funciona con elementos añadidos dinámicamente
    $("#user_searcher_panel").removeClass("opened");
    $("#searched_user_information_panel").addClass("opened");
    let id = $(this).data("id");
    
    fetch(`https://Ox-Tablet/getUserSAPD`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.user != false){
                    LoadSearchedUser(resp.user)
                }else{
                    console.log(JSON.stringify(resp.user))
                    popupNotificacion("Parece haber un error en la ficha", false);
                }
            }
        );

});
//Fin de funcion de acceso a datos de usuraio en SAPD con boton de Mostrar plantilla

function LoadSearchedUser(data){
    
    $('#searched_user_photo').attr("src",data.Avatar);
    $('#searched_user_change_photo_button').data("steam",data.Identifier);
    $('#searched_user_name').text(data.RealName)
    $('#searched_user_id').text(data.Identifier)
    if (data.Sex === 'H'){
        $('#searched_user_genre').text("Masculino")
    }else{
        $('#searched_user_genre').text("Femenino")
    }
    $('#searched_user_phone').text(data.Phone)
    $('#searched_user_date_birth').text(data.Dob)
    $('#searched_user_penalties').text("$"+data.Unpaid)

    if (data.Secure === true){
        $('#searched_user_life_insurance').removeClass('hasNotInsurance');
        $('#searched_user_life_insurance').removeClass('hasInsurance');
        $('#searched_user_life_insurance').addClass('hasInsurance');
        $('#searched_user_life_insurance').text("Seguro disponible")
    }else{
        $('#searched_user_life_insurance').removeClass('hasNotInsurance');
        $('#searched_user_life_insurance').removeClass('hasInsurance');
        $('#searched_user_life_insurance').addClass('hasNotInsurance');
        $('#searched_user_life_insurance').text("Sin Seguro")
    }

    $("#searched_user_option_dangerous").data("steam", data.Identifier);

    $("#register_sapd_note_button").data("steam", data.Identifier);
    
    if (data.Danger === true){
        $('#searched_user_option_dangerous').removeClass("dangerous_in");
        $('#searched_user_option_dangerous').addClass("dangerous_out");
        $('#searched_user_option_dangerous').text("Eliminar como sujeto peligroso");
        $("#searched_user_label_dangerous").addClass("opened");
    }else{
        $('#searched_user_option_dangerous').removeClass("dangerous_out");
        $('#searched_user_option_dangerous').addClass("dangerous_in");
        $('#searched_user_option_dangerous').text("Añadir como sujeto peligroso");
        $("#searched_user_label_dangerous").removeClass("opened");
    }

    $("#searched_user_option_search_seizure").data("steam", data.Identifier);

    if (data.Searched === true){
        $("#searched_user_label_search_seizure").removeClass("opened");
        $("#searched_user_option_search_seizure").removeClass("search_seizure_out");
        $("#searched_user_option_search_seizure").removeClass("search_seizure_in");
        $("#searched_user_option_search_seizure").addClass("search_seizure_out");
        $("#searched_user_option_search_seizure").text("Retirar de busca y captura");
        $("#searched_user_label_search_seizure").addClass("opened");
    }else{
        $("#searched_user_option_search_seizure").removeClass("search_seizure_in");
        $("#searched_user_option_search_seizure").removeClass("search_seizure_out");
        $("#searched_user_option_search_seizure").addClass("search_seizure_in");
        $("#searched_user_option_search_seizure").text("Poner en busca y captura");
        $("#searched_user_label_search_seizure").removeClass("opened");
    }

    $("#register_penalty_button").data("steam", data.Identifier);
    
    let recordsHtml = `
    <li>
        <span>Descripción de la consulta</span>
        <span>Doctor asignado</span>
        <span>Fecha de consulta</span>
        <span>Tratamiento</span>
    </li>`

    $('#searched_user_medical_history_table').html("")

    data.Records.forEach(element => {
        recordsHtml = recordsHtml + `
        <li>
            <span>${element.description}</span>
            <span>${element.doctor}</span>
            <span>${element.sent_date}</span>
            <span>${element.tratamiento}</span>
        </li>
        `
        }
    );
    
    $('#searched_user_medical_history_table').html(recordsHtml)


    //Crimenes
    let notesHtml = `
    <li>
        <span>Información de la nota</span>
        <span>Acciones</span>
    </li>`

    $('#searched_user_notes_table').html("")

    data.Notes.forEach(element => 
        notesHtml = notesHtml + `
        <li>
            <span>${element.note}</span>
            <span data-id="${element.id}" class="action_buttons_container">
                <div class="action_button delete_note">
                    <img src="./img/delete_note.png">
                    <span class="action_label">Eliminar nota</span>
                </div>
            </span>
        </li>
        `
    );
    $('#searched_user_notes_table').html(notesHtml)

    //Crimenes
    let penaltiesHtml = `
    <li>
        <span>Descripción de la infracción</span>
        <span>Oficial asignado</span>
        <span>Fecha de registro</span>
        <span>Sanción</span>
    </li>`

    $('#searched_user_crimes_history_table').html("")

    data.Penals.forEach(element => 
        penaltiesHtml = penaltiesHtml + `
        <li>
        <span>${element.description}</span>
        <span>${element.sender_name}</span>
        <span>${element.sent_date}</span>
        <span>${element.penaltie}</span>
        </li>
        `
    );
    $('#searched_user_crimes_history_table').html(penaltiesHtml)

    // //Facturas
    var invoicesHtml = `
    <li>
        <span>Definición</span>
        <span>Coste de la sanción</span>
        <span>Emisor</span>
        <span>Fecha de emisión</span>
        <span>Estado</span>
        <span>Acciones</span>
    </li>`

    $('#searched_user_penalties_table').html("")

    data.Invoices.forEach(element => {
        if (element.status === "unpaid"){
            invoicesHtml = invoicesHtml + `
            <li>
                <span>` + element.item + `</span>
                <span>$` + element.invoice_value + `</span>
                <span>` + element.author_name + `</span>
                <span>` + element.sent_date + `</span>
                <span data-id="` + element.id + `" class="status_label pending">
                    <div class="text">Pediente</div>
                </span>
                <span class="action_buttons_container">
                    <div class="action_button delete_penalty">
                        <img src="./img/drop_penalties.png">
                        <span class="action_label">Retirar multa</span>
                    </div>
                </span>
            </li>
            `
        }else if (element.status === "paid") {
            invoicesHtml = invoicesHtml + `
            <li>
                <span>` + element.item + `</span>
                <span>$` + element.invoice_value + `</span>
                <span>` + element.author_name + `</span>
                <span>` + element.sent_date + `</span>
                <span data-id="` + element.id + `" class="status_label paid">
                    <div class="text">Pagada</div>
                </span>
                <span class="action_buttons_container">

                </span>
            </li>
            `
        }else if (element.status === "cancelled") {
            invoicesHtml = invoicesHtml + `
            <li>
                <span>` + element.item + `</span>
                <span>$` + element.invoice_value + `</span>
                <span>` + element.author_name + `</span>
                <span>` + element.sent_date + `</span>
                <span data-id="` + element.id + `" class="status_label inSearch">
                    <div class="text">Retirada</div>
                </span>
                <span class="action_buttons_container">

                </span>
            </li>
            `
        }
    });

    $('#searched_user_penalties_table').html(invoicesHtml)

    $('#searched_user_penalties_table').on('click', '.action_button.delete_penalty', function(){
        // $(this).parent().parent("li").remove();

        let id = $(this).parent().siblings(".status_label").data("id");
        $(this).addClass("disabled");
        fetch(`https://Ox-Tablet/delInvoice`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.payed === true){
                    popupNotificacion("Factura Cancelada", true)
                    $(this).parent().siblings(".status_label").removeClass("pending");
                    $(this).parent().siblings(".status_label").addClass("inSearch");
                    $(this).parent().siblings(".status_label").children(".text").text("Cancelada");
                    $(this).addClass("disabled");
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
    });

    //Casas
    let housesHtml = `
    <li>
        <span>Nº</span>
        <span>Reforma</span>
    </li>`

    $('#searched_user_properties_table').html("")

    data.Houses.forEach(element => 
        housesHtml = housesHtml + `
        <li>
            <span>` + element.id + `</span>
            <span>` + element.interior + `</span>
        </li>
        `
    );

    $('#searched_user_properties_table').html(housesHtml);

    //Coches
    let carsHtml = `
    <li>
        <span>Matrícula</span>
        <span>Modelo</span>
        <span>Color</span>
    </li>`

    $('#searched_user_vehicles_table').html("")

    data.Vehicles.forEach(element => {
        carsHtml = carsHtml + `
        <li>
            <span>` + element.plate + `</span>
            <span>` + element.model + `</span>
            <span><span class='color'>` + element.color[0] + `,` + element.color[1] + `,` + element.color[2] + `</span></span>
        </li>
        `
        }
    );
    
    $('#searched_user_vehicles_table').html(carsHtml)

    $(".color").each(function() {
        $(this).css("background-color", "rgb(" + $(this).text() + ")")
        $(this).text("");
    })

    //Licencias
    let licensesHtml = `
    <li>
        <span>Licencia</span>
        <span>Acciones</span>
    </li>`

    $('#searched_user_licenses_table').html("")

    data.Licenses.forEach(element => 
        licensesHtml = licensesHtml + `
        <li>
            <span>${element.label}</span>
            <span class="action_buttons_container">
                <div data-id="${data.Identifier}" data-type="${element.name}" class="action_button delete_licence">
                    <img src="./img/drop_licence.png">
                    <span class="action_label">Eliminar licencia</span>
                </div>
            </span>
        </li>
        `
    );

    $('#searched_user_licenses_table').html(licensesHtml);

    $('#searched_user_licenses_table').on('click', '.action_button.delete_licence', function(){
        // $(this).parent().parent("li").remove();
        let id = $(this).data("id");
        let name = $(this).data("type");
        $(this).addClass("disabled");
        fetch(`https://Ox-Tablet/delLicense`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id,
            name: name
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.deleted === true){
                    popupNotificacion("Licencia Retirada", true)
                    $(this).parent().parent("li").remove();
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
    });
}


function LoadSearchedUserEMS(data){

    $('#ems_searched_user_photo').attr("src",data.Avatar);
    $('#ems_searched_user_name').text(data.RealName)
    $('#ems_searched_user_id').text(data.Identifier)
    if (data.Sex === 'H'){
        $('#ems_searched_user_genre').text("Masculino")
    }else{
        $('#ems_searched_user_genre').text("Femenino")
    }
    $('#ems_searched_user_phone').text(data.Phone)
    $('#ems_searched_user_date_birth').text(data.Dob)
    $('#ems_searched_user_penalties').text("$"+data.Unpaid)

    if (data.Secure === true){
        $('#ems_searched_user_hasSeguro').prop("checked", true);
        $('#ems_searched_user_hasNotSeguro').prop("checked", false);
    }else{
        $('#ems_searched_user_hasSeguro').prop("checked", false);
        $('#ems_searched_user_hasNotSeguro').prop("checked", true);
    }

    $('input:radio[name=seguro]').change(function() {
        if (this.id == 'ems_searched_user_hasSeguro') {
            $.post("https://Ox-Tablet/setSecure", JSON.stringify({ secure: true, citizenid: data.Identifier }))
            popupNotificacion("Seguro Médico Activado", true)
        }
        else if (this.id == 'ems_searched_user_hasNotSeguro') {
            $.post("https://Ox-Tablet/setSecure", JSON.stringify({ secure: false, citizenid: data.Identifier }))
            popupNotificacion("Seguro Médico Desactivado", false)
        }
        $('#ems_searched_user_life_insurance').hide();
        setTimeout(() => {  
            $('#ems_searched_user_life_insurance').fadeIn(1000)
        }, 5000);
    });

    $("#ems_searched_user_option_dangerous").data("steam", data.Identifier);
    $("#register_user_health_popup_button").data("steam", data.Identifier);

    $("#emd_add_new_medical_consultation_button").data("steam", data.Identifier);
    
    setPopupFichaMedica(data.Medical);

    let recordsHtml = `
    <li>
        <span>Descripción de la consulta</span>
        <span>Doctor asignado</span>
        <span>Fecha de consulta</span>
        <span>Tratamiento</span>
        <span>Acciones</span>
    </li>`

    $('#ems_searched_user_medical_history_table').html("")

    data.Records.forEach(element => {
        recordsHtml = recordsHtml + `
        <li>
            <span>${element.description}</span>
            <span>${element.doctor}</span>
            <span>${element.sent_date}</span>
            <span>${element.tratamiento}</span>
            <span class="action_buttons_container">
                <div data-steam="${element.identifier}" data-id="${element.id}" class="action_button show_medical_consultation">
                    <img src="./img/look_and_modify.png">
                    <span class="action_label">Revisar/Modificar consulta</span>
                </div>
                <div data-steam="${element.identifier}" data-id="${element.id}" class="action_button delete_medical_consultation">
                    <img src="./img/delete_note.png">
                    <span class="action_label">Eliminar consulta</span>
                </div>
                
            </span>
        </li>
        `
        }
    );
    
    $('#ems_searched_user_medical_history_table').html(recordsHtml)
    
}


$("#searched_user_option_dangerous").click(function() {
    let id = $(this).data("steam");
    if ($(this).hasClass("dangerous_in")) {
        $(this).removeClass("dangerous_in");
        $(this).addClass("dangerous_out");
        $(this).text("Eliminar como sujeto peligroso");
        $("#searched_user_label_dangerous").addClass("opened");
        $.post("https://Ox-Tablet/setDanger", JSON.stringify({ danger: true, citizenid: id }))
    } else {
        $(this).removeClass("dangerous_out");
        $(this).addClass("dangerous_in");
        $(this).text("Añadir como sujeto peligroso");
        $("#searched_user_label_dangerous").removeClass("opened");
        $.post("https://Ox-Tablet/setDanger", JSON.stringify({ danger: false, citizenid: id }))
    }
});

$("#searched_user_option_search_seizure").click(function() {
    let id = $(this).data("steam");
    if ($(this).hasClass("search_seizure_in")) {
        $(this).removeClass("search_seizure_in");
        $(this).addClass("search_seizure_out");
        $(this).text("Retirar de busca y captura");
        $.post("https://Ox-Tablet/setSearched", JSON.stringify({ searched: true, citizenid: id }))

        $("#searched_user_label_search_seizure").addClass("opened");
    } else {
        $(this).removeClass("search_seizure_out");
        $(this).addClass("search_seizure_in");
        $(this).text("Poner en busca y captura");
        $.post("https://Ox-Tablet/setSearched", JSON.stringify({ searched: false, citizenid: id }))

        $("#searched_user_label_search_seizure").removeClass("opened");
    }
});

//Funcion de acceso a datos de usuario en SAPD con boton de Mostrar plantilla DESDE VEHICULOS
$('#searched_vehicles_table').on('click', '.action_button.open_template', function(){ //Selector que funciona con elementos añadidos dinámicamente
    //Cerramos pagina de vehiculos y abrimos SAPD
    $("#vehicles_searcher_page").removeClass("opened");
    $("#SAPD_page").addClass("opened");

    let id = $(this).parent().data("steam");

    fetch(`https://Ox-Tablet/getUserSAPD`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.user != false){
                    LoadSearchedUser(resp.user)
                    $("#user_searcher_panel").removeClass("opened");
                    $("#searched_user_information_panel").addClass("opened");
                }else{
                    popupNotificacion("Parece haber un error en la ficha", false);
                }
            }
        );

    //Abrimos el panel de datos de usuario

});
//Fin de funcion de acceso a datos de usuario en SAPD con boton de Mostrar plantilla DESDE VEHICULOS



// Listener de boton de cierre de datos usuario SAPD y funciones de limpiado de lista de busqueda SAPD (usuarios, vehiculos y busca y captura)
$("#close_searched_user_information_button").click(function() {
    if($("#sapd_button").hasClass("selected")) { 
        limpiarBuscadorSAPD();

    } else if ($("#vehiculos_button").hasClass("selected")) {
        limpiarBuscadorVehiculosSAPD();

    } else if ($("#byc_button").hasClass("selected")) {
        //Aqui no hay que limpiar buscadores asi que recargamos pagina directamente
        recargarByC();
        
    }
});

function limpiarBuscadorSAPD() {
    //Cerramos el panel de datos de usuario si estuviera abierto y reabrimos el buscador
    if($("#searched_user_information_panel").hasClass("opened")) {
        $("#searched_user_information_panel").removeClass("opened");
        $("#user_searcher_panel").addClass("opened");
    }

    //Limpiamos buscador
    $("#players_search_bar").val("");

    //Limpiamos lista salvo primer elementos, que son los nombres
    $("#searched_users_table").children().not(":first").remove();
   
}

function limpiarBuscadorVehiculosSAPD() {
    //Cerramos el panel de datos de usuario si estuviera abierto y reabrimos el buscador de Vehículos
    if($("#searched_user_information_panel").hasClass("opened")) {
        $("#searched_user_information_panel").removeClass("opened");
        $("#user_searcher_panel").addClass("opened");

        $("#SAPD_page").removeClass("opened");

        
        $("#vehicles_searcher_page").addClass("opened"); //Se pone la clase opened en caso que no la tenga
        
    }

    //Limpiamos buscador
    $("#vehicles_search_bar").val("");

    //Limpiamos lista salvo primer elementos, que son los nombres
    $("#searched_vehicles_table").children().not(":first").remove();
}

function recargarByC() {
    if($("#searched_user_information_panel").hasClass("opened")) {
        $("#searched_user_information_panel").removeClass("opened");
        $("#user_searcher_panel").addClass("opened");

        $("#SAPD_page").removeClass("opened");

        //Aunque la tenga, siempre se la ponemos
        $("#search_seizure_page").addClass("opened");
        
    }
}
// Fin de listener de boton de cierre de datos usuario SAPD y funciones de limpiado de lista de busqueda SAPD (usuarios, vehiculos y busca y captura)






//Listener de los botones de poner y quitar en búsqueda VEHÍCULOS (es el mismo codigo en ambas, cambiando clases, src y textos)
$('#searched_vehicles_table').on('click', '.action_button.search_in', function(){ //Selector que funciona con elementos añadidos dinámicamente
    //Cambiamos color del boton
    $(this).removeClass("search_in")
    $(this).addClass("search_out")

    //Cambiamos imagen y etiqueta del botón
    $(this).children("img").attr("src", "./img/Search_out.png");
    $(this).children(".action_label").text("Quitar en búsqueda");


    //Cambiamos color y texto del aviso
    $(this).parent().siblings(".notInSearch").addClass("inSearch");
    $(this).parent().siblings(".notInSearch").removeClass("notInSearch");
    $(this).parent().siblings(".inSearch").children(".text").text("En búsqueda");

});

$('#searched_vehicles_table').on('click', '.action_button.search_out', function(){ //Selector que funciona con elementos añadidos dinámicamente
    //Cambiamos color del boton
    $(this).removeClass("search_out")
    $(this).addClass("search_in")

    //Cambiamos imagen y etiqueta del botón
    $(this).children("img").attr("src", "./img/Search_in.png");
    $(this).children(".action_label").text("Poner en búsqueda");


    //Cambiamos color y texto del aviso
    $(this).parent().siblings(".inSearch").addClass("notInSearch");
    $(this).parent().siblings(".inSearch").removeClass("inSearch");
    $(this).parent().siblings(".notInSearch").children(".text").text("No buscado");
});



//Fin de listener de los botones de poner y quitar en búsqueda



// Funcion de carga y update de los delitos en curso
function actualizarRobosEnCurso(data) {
    //Robos Actuales
    let robosHtml = `
    <li>
        <span>ID</span>
        <span>Nombre</span>
        <span>Robo</span>
        <span>Fecha y hora</span>
        <span>Estado</span>
        <span>Acciones</span>
    </li>`

    $('#crimes_in_progress_table').html("")

    data.forEach(element => 
        { 
            if(element.status === false) {
                robosHtml = robosHtml + `
                <li data-id="${element.crimenId}">
                    <span>${element.id}</span>
                    <span>${element.name}</span>
                    <span>${element.robo}</span>
                    <span>${element.fecha}</span>
                    <span class="status_label pending">
                        <div class="text">Pendiente</div>
                    </span>
                    <span class="action_buttons_container">
                        <div class="action_button attend_crime">
                            <img src="./img/attend_crime.png">
                            <span class="action_label">Atender delito</span>
                        </div>
                        <div class="action_button delete_crime">
                            <img src="./img/close_crime_check.png">
                            <span class="action_label">Cerrar caso</span>
                        </div>
                    </span>
                </li>
                `
            } else if(element.status === true) {
                robosHtml = robosHtml + `
                <li data-id="${element.crimenId}">
                    <span>${element.id}</span>
                    <span>${element.name}</span>
                    <span>${element.robo}</span>
                    <span>${element.fecha}</span>
                    <span class="status_label inProgress">
                        <div class="text">En progreso</div>
                    </span>
                    <span class="action_buttons_container">
                        <div class="action_button unattend_crime">
                            <img src="./img/unattend_crime.png">
                            <span class="action_label">Dejar de atender</span>
                        </div>
                        <div class="action_button delete_crime">
                            <img src="./img/close_crime_check.png">
                            <span class="action_label">Cerrar caso</span>
                        </div>
                    </span>
                </li>
                `
            }
        }
    );
    $('#crimes_in_progress_table').html(robosHtml)
}
// Fin de funcion de carga y update de los delitos en curso



//Funciones de busqueda de VEHÍCULOS en SAPD
$(document).on("keyup", "input#vehicles_search_bar", function(e) {
    if (e.key === 'Enter') {
        buscarVehiculosSAPD();
    }
});

function buscarVehiculosSAPD() { //Esta función solo mostrará un resultado de forma estática, de la funcion te encargas tú
    let vehiculo = $("#vehicles_search_bar").val().replace("<", "&lt").replace(">", "&gt");
    if (vehiculo.length > 2) {
        limpiarBuscadorVehiculosSAPD();
        fetch(`https://Ox-Tablet/getVehiclesSAPD`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            plate: vehiculo
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.vehs != false){
                    resp.vehs.forEach(element => 
                        {
                            $("#searched_vehicles_table").append(`
                                <li>
                                    <span>${element.plate}</span>
                                    <span>${element.model}</span>
                                    <span><span class='color'>${element.color[0]},${element.color[1]},${element.color[2]}</span></span>
                                    <span>${element.owner}</span>
                                    <span data-steam="${element.id}" class="action_buttons_container">
                                        <div class="action_button open_template">
                                            <img src="./img/document-logo.png">
                                            <span class="action_label">Abrir ficha del dueño</span>
                                        </div>
                                    </span>
                                </li>`);

                            //     <div class="action_button search_in">
                            //     <img src="./img/Search_in.png">
                            //     <span class="action_label">Poner en búsqueda</span>
                            // </div>

                            //{id = vehsDB[i].owner, model = vehsDB[i].name, color = _subData.color1Custom, searched = searched }
                            // $("#searched_users_table").append(`<li>
                            //         <span class="searched_user_img">
                            //             <!-- Contenedor para la foto + boton de modifciar en SAPD -->
                            //             <div class="user_photo_frame">
                            //                 <div class="user_photo_content">
                            //                     <img src="${element.avatar}"> 
                            //                 </div>
                            //             </div>
                            //             <!-- Fin de contenedor para foto -->
                            //         </span>
                            //         <span>${element.name}</span>
                            //         <span>$${element.unpaid}</span>
                            //         <span>${(element.sex === "m" ? 'Masculino' : 'Femenino')}</span>
                            //         <span>${id.replaceAll("steam:", "")}</span>
                            //         <span>${element.phone}</span>
                            //         <span class="action_buttons_container">
                            //             <div data-id="${element.id}" class="action_button open_template">
                            //                 <img src="./img/document-logo.png">
                            //                 <span class="action_label">Abrir ficha</span>
                            //             </div>
                            //         </span>
                            //     </li>`);
                        }
                    );
                    $(".color").each(function() {
                        $(this).css("background-color", "rgb(" + $(this).text() + ")")
                        $(this).text("");
                    })
                }else{
                    popupNotificacion("No se encontraron resultados", false);
                }
            }
        );
    }
    else {
        popupNotificacion("Debes escribir al menos tres caracteres", false);
    }

    // $("#searched_vehicles_table").append(`
    // <li>
    //     <span>${vehiculo}</span>
    //     <span>Coquette V2</span>
    //     <span>Verde Mar</span>
    //     <span>Artzalez</span>
    //     <span class="status_label notInSearch">
    //         <div class="text">No buscado</div>
    //     </span>
    //     <span class="action_buttons_container">
    //         <div class="action_button open_template">
    //             <img src="./img/document-logo.png">
    //             <span class="action_label">Abrir ficha del dueño</span>
    //         </div>
    //         <div class="action_button search_in">
    //             <img src="./img/Search_in.png">
    //             <span class="action_label">Poner en búsqueda</span>
    //         </div>
    //     </span>
    // </li>`);


}
//Fin de funciones de busqueda de VEHÍCULOS
$("#searched_user_change_photo_button").click(function() {
    $("body").hide()
    fetch(`https://Ox-Tablet/getphoto`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.photo != false){
                $("body").fadeIn(500)
                console.log(resp.photo)
                $('#searched_user_photo').attr("src",resp.photo);
                $.post("https://Ox-Tablet/setPhoto", JSON.stringify({ photo: resp.photo, citizenid: $(this).data("steam") }))
                //LoadSearchedUser(resp.user)
            }else{
                $("body").fadeIn(500)
                popupNotificacion("Parece haber un error en la ficha", false);
            }
        }
    );
});



//Funciones de los botones del Panel de busca y captura (tanto para usuarios como vehículos)

// --> Usuarios:
$('#search_seizure_users_table').on('click', '.action_button.open_template', function(){

    //Cerramos pagina de vehiculos y abrimos SAPD
    $("#search_seizure_page").removeClass("opened");
    $("#SAPD_page").addClass("opened");

    let id = $(this).data("id");
    
    $("#search_seizure_users_table").children().not(":first").remove();
    fetch(`https://Ox-Tablet/getUserSAPD`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: id
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.user != false){
                $("#user_searcher_panel").removeClass("opened");
                $("#searched_user_information_panel").addClass("opened");
                LoadSearchedUser(resp.user)
            }else{
                popupNotificacion("Parece haber un error en la ficha", false);
            }
        }
    );

    //Abrimos el panel de datos de usuario
   

});

$('#search_seizure_users_table').on('click', '.action_button.search_out', function(){
    $(this).parent().parent("li").remove();

});



// --> Vehiculos:
$('#vehicles_in_search_table').on('click', '.action_button.open_template', function(){

    //Cerramos pagina de vehiculos y abrimos SAPD
    $("#search_seizure_page").removeClass("opened");
    $("#SAPD_page").addClass("opened");

    //Abrimos el panel de datos de usuario
    $("#user_searcher_panel").removeClass("opened");
    $("#searched_user_information_panel").addClass("opened");

});

$('#vehicles_in_search_table').on('click', '.action_button.search_out', function(){
    $(this).parent().parent("li").remove();

});

//Fin de funciones de los botones del Panel de busca y captura (tanto para usuarios como vehículos)



// Listeners de los botones de acciones para los usuarios buscados






// Fin de listeners de los botones de acciones para los usuarios buscados



// Funciones de accion del menu de tablas de USUARIO BUSCADO
$("#searched_user_properties_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_properties_button", "searched_user_properties_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "");
})

$("#searched_user_vehicles_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_vehicles_button", "searched_user_vehicles_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "");
})

$("#searched_user_licenses_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_licenses_button", "searched_user_licenses_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "");
})

$("#searched_user_crimes_history_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_crimes_history_button", "searched_user_crimes_history_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "add_sapd_crimes_button");
})

$("#searched_user_medical_history_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_medical_history_button", "searched_user_medical_history_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "");
})

$("#searched_user_penalties_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_penalties_button", "searched_user_penalties_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "");
})

$("#searched_user_notes_button").click(function() {
    cambiarBotonTablesMenu("searched_user_tables_selector", "searched_user_tables_panel",  "searched_user_notes_button", "searched_user_notes_table");
    cambiarAddElementsButtons("searched_user_add_elements_buttons", "add_sapd_notes_button");
})



function cambiarAddElementsButtons(panelBotones,botonNuevo) {
    $("#" + panelBotones).children().removeClass("opened");

    if (botonNuevo == "add_sapd_notes_button") {
        $("#add_sapd_notes_button").addClass("opened");

    } else if (botonNuevo == "add_sapd_crimes_button") {
        $("#add_sapd_crimes_button").addClass("opened");

    } else if (botonNuevo == "add_admin_notes_button") {
        $("#add_admin_notes_button").addClass("opened");

    }
}
// Fin de funciones de accion del menu de tablas de USUARIO BUSCADO


// Botones de las tablas de usuario buscado de SAPD


//Boton de eliminar licencia (Tabla licencias)
// $('#searched_user_licenses_table').on('click', '.action_button.delete_licence', function(){
//     $(this).parent().parent("li").remove();

// });


//Boton de retirar multa
// $('#searched_user_penalties_table').on('click', '.action_button.delete_penalty', function(){
//     $(this).parent().parent("li").remove();

// });


//Botones de modificar y eliminar nota policial
$('#searched_user_notes_table').on('click', '.action_button.delete_note', function(){
    $(this).parent().parent("li").remove();
    let id = $(this).parent().data("id");
    $.post("https://Ox-Tablet/delNote", JSON.stringify({ id: id }));
});


//Botones de modificar notas de cada nota ya creada
$("#searched_user_notes_table").on('click', '.action_button.modify_note', function(){
    
    abrirCerrarPopup("add_sapd_note_popup", true);

    let id = $(this).parent().data("id")
    //Añadimos un texto de ejemplo al textarea, por los loles
    $("#new_sapd_note_textarea").val("Esto es una nota que está siendo modificada.");
})


// Fin de botones de las tablas de usuario buscado de SAPD


//Botones y buscador del modal de añadir multas
//Buscador de añadir multas
$("#penalties_selector_searcher").on("input", function() {
   let searchedMulta = $(this).val().toLowerCase();

   $("#penalties_selector option").each(function() {
      if($(this).text().toLowerCase().includes(searchedMulta)) {
         $(this).show(); 
      } else {
          $(this).hide();
      }
   })
});


//Boton para abrir el popup de añadir multas
$("#add_sapd_crimes_button").click(function() {
    abrirCerrarPopup("add_penalty_popup", true);

    //Carga de los valores del json al selector de multas (cambiar a boton de abertura del modal)
    let n = 0;
    $.each(multas, function() {
        if (n == 0) {
            $("#penalties_selector").append(`<option value="${n}" selected>${this.definicion} (${this.sancion}€ - ${this.meses}M)</option>`)
            
        } else {
            $("#penalties_selector").append(`<option value="${n}">${this.definicion} (${this.sancion}€ - ${this.meses}M)</option>`)

        }
        n++;
    })

})



//Boton para añadir una multa nueva
$("#add_penalty_button").click(function() {

    $("#added_penalties_table").append(
        `<li>
            <span>${multas[$("#penalties_selector").val()].definicion}</span>
            <span data-id="${$("#penalties_selector").val()}" class="penalty_price">${multas[$("#penalties_selector").val()].sancion}€ - ${multas[$("#penalties_selector").val()].meses}M</span>
            <span>
                <div class="delete_added_penalty_button">X</div>
            </span>
        </li>`
    )
})


//Boton para borrar las multas añadidas
$("#added_penalties_table").on('click', '.delete_added_penalty_button', function(){
    $(this).parent().parent("li").remove();
})
//Fin de botones del modal de añadir multas


//Listener para mostrar precio final automatico
$('#added_penalties_table').on('DOMSubtreeModified', function() {
    let precioFinal = 0;

    for(let i = 1; i < $(this).children().length; i++) { //A partir de 1 para saltarnos los titulos
        precioFinal += parseInt($(this).children(`:nth-child(${i+1})`).children('.penalty_price').text());
    }

    $("#new_crime_final_price").text(precioFinal + "$")
})


//Boton del precio final para apuntarlo en la sancion
$("#new_crime_final_price").click(function() {
    for(let i = 1; i < $("#added_penalties_table").children().length; i++) { //A partir de 1 para saltarnos los titulos
        let mid = parseInt($("#added_penalties_table").children(`:nth-child(${i+1})`).children('.penalty_price').data("id"));
        $("#penalty_definition_textarea").val($("#penalty_definition_textarea").val() + multas[mid].definicion + "\n")
    }
    if ($("#penalty_definition_textarea").val().indexOf($(this).text()) == -1) {
        $("#penalty_definition_textarea").val($("#penalty_definition_textarea").val() + $(this).text())
    }
})


function limpiarPopupRegistrarMulta() {
    // Limpiamos los textarea
    $("#crime_definition_textarea").val("");
    $("#penalty_definition_textarea").val("");

    // Limpiamos el selector de multas
    $("#penalties_selector").children().remove();

    //Limpiamos las multas ya seleccionadas
    $("#added_penalties_table").children().not(":first").remove();
}



//Boton para cancelar el añadir multas
$("#cancel_penalty_button").click(function() {

    abrirCerrarPopup("add_penalty_popup", false);

    limpiarPopupRegistrarMulta();
})

//Boton de registrar multas
$("#register_penalty_button").click(function() {

    abrirCerrarPopup("add_penalty_popup", false);

    let id = $(this).data("steam");

    let description = $("#crime_definition_textarea").val();

    let precioFinal = 0

    for(let i = 1; i < $("#added_penalties_table").children().length; i++) { //A partir de 1 para saltarnos los titulos
        precioFinal += parseInt($("#added_penalties_table").children(`:nth-child(${i+1})`).children('.penalty_price').text());
    }
    let penals = [];
    for(let i = 1; i < $("#added_penalties_table").children().length; i++) { //A partir de 1 para saltarnos los titulos
        let mid = parseInt($("#added_penalties_table").children(`:nth-child(${i+1})`).children('.penalty_price').data("id"));
        penals.push(mid);
    }

    let penaltydesc = $("#penalty_definition_textarea").val();

    fetch(`https://Ox-Tablet/addPenalties`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        citizenid: id,
        penal: penals,
        desc: description,
        pdesc: penaltydesc
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.completed === true){
                RefreshSAPDUser(id);
            }
        }
    );

    limpiarPopupRegistrarMulta();
})

//Fin de botones del modal de añadir multas


function RefreshSAPDUser(ident){
    fetch(`https://Ox-Tablet/getUserSAPD`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: ident
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.user != false){
                LoadSearchedUser(resp.user)
            }else{
                popupNotificacion("Parece haber un error en la ficha", false);
            }
        }
    );
}



//Botones del moda para añadir notas del sapd
//Boton para abrir el modal de añadir notas sapd
$("#add_sapd_notes_button").click(function() {

    abrirCerrarPopup("add_sapd_note_popup", true);
})



//Boton para cancelar el añadir notas sapd
$("#cancel_sapd_note_button").click(function() {

    abrirCerrarPopup("add_sapd_note_popup", false);

    limpiarPopupRegistrarNota("new_sapd_note_textarea");
})

//Boton de registrar notas sapd
$("#register_sapd_note_button").click(function() {

    abrirCerrarPopup("add_sapd_note_popup", false);

    let id = $(this).data("steam");

    let description = $("#new_sapd_note_textarea").val();

    fetch(`https://Ox-Tablet/addNotes`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            citizenid: id,
            text: description,
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.completed === true){
                    RefreshSAPDUser(id);
                }
            }
        );

    limpiarPopupRegistrarNota("new_sapd_note_textarea");
})

function RefreshAdminUser(ident){
    fetch(`https://Ox-Tablet/getUserAdmin`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        id: ident
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.user != false){
                LoadSearchedUserAdmin(resp.user)
            }else{
                popupNotificacion("Parece haber un error en la ficha", false);
            }
        }
    );
}


//Funcion para limpiar el creador de notas
function limpiarPopupRegistrarNota(textarea) {
    // Limpiamos los textarea
    $("#" + textarea).val("");
}
//Fin de botones del modal de añadir multas





//Limpiador de popupsPara cuando se apaga la pantalla
function limpiarPopups(){
    if ($("#add_penalty_popup").hasClass("opened")) {
        abrirCerrarPopup("add_penalty_popup", false);
        limpiarPopupRegistrarMulta();

    } else if ($("#add_sapd_note_popup").hasClass("opened")) {
        abrirCerrarPopup("add_sapd_note_popup", false);
        limpiarPopupRegistrarNota("new_sapd_note_textarea");

    } else if ($("#ems_user_health_data_popup").hasClass("opened")) {
        abrirCerrarPopup("ems_user_health_data_popup", false);
        limpiarPopupFichaMedica();

    } else if ($("#ems_user_medical_consultation_popup").hasClass("opened")) {
        abrirCerrarPopup("ems_user_medical_consultation_popup", false);
        limpiarPopupConsultaMedica();

    } else if($("#admin_change_user_data_popup").hasClass("opened")) {
        abrirCerrarPopup("admin_change_user_data_popup", false);
        limpiarPopupCambiarDatosAdmin();

    } else if ($("#add_admin_note_popup").hasClass("opened")) {
        abrirCerrarPopup("add_admin_note_popup", false);
        limpiarPopupRegistrarNota("new_admin_note_textarea");

    } else if ($("#assign_new_job_popup").hasClass("opened")) {
        abrirCerrarPopup("assign_new_job_popup", false);
        limpiarPopupGenerarTrabajo();
    }
}





// Funciones para las notificaciones
function popupNotificacion(texto, isCheck) {
    if(!notificacionActiva) {
        notificacionActiva = true;
        //Seteamos los valores del popup
        $("#text").text(texto);

        isCheck ? $("#notification_icon").attr("src", "./img/notification_check.png") : $("#notification_icon").attr("src", "./img/notification_cross.png");


        //Activamos las animaciones de CSS
        $(".tarjeta_notificaciones_container").css("display", "flex");

        //Activamos sonido
        setTimeout(() => {
            notificationAudio.play();
        }, 350);

        //Activamos la animacion del texto por JS
        setTimeout(() => {
            animarTexto()
        }, 1000);

        //Reseteamos el popup para que vuelva a poderse animar
        setTimeout(() => {
            //Activamos las animaciones de CSS
            $(".tarjeta_notificaciones_container").css("display", "none");
            notificacionActiva = false;
        }, 6001);
    }
}

function animarTexto() {
    let element = $('#notification_text_container')[0];

    //Recogemos el tamaño del contenedor con todo su contenido (sin importar que de inicio este a 0)
    var sectionWidth = element.scrollWidth; 

    //Ponemos el width a su maximo valor de contenido
    element.style.width = sectionWidth + 'px';


  
    // Mediante este listener controlamos el momento cuando acaba la transicion
    element.addEventListener('transitionend', function(e) {
      // y tras terminar lo borramos para que solo se ejecute una vez
      element.removeEventListener('transitionend', arguments.callee);
      
      // remove "Width" from the element's inline styles, so it can return to its initial value
      //element.style.width = null;
    });



    setTimeout(() => {
        element.style.width = '0px';

        // Mediante este listener controlamos el momento cuando acaba la transicion
        element.addEventListener('transitionend', function(e) {
        // y tras terminar lo borramos para que solo se ejecute una vez
        element.removeEventListener('transitionend', arguments.callee);
        
        // remove "Width" from the element's inline styles, so it can return to its initial value
        //element.style.width = null;
        });
        
    }, 4000);

}


function cortarNotificacion() {
    $(".tarjeta_notificaciones_container").css("display", "none");
    notificationAudio.pause();
    notificationAudio.currentTime = 0;

}
// Fin de funciones para las notificaciones





//Funciones de busqueda de USUARIOS en EMS
$(document).on("keyup", "input#ems_players_search_bar", function(e) {
    if (e.key === 'Enter') {
        buscarUsuariosEMS();
    }
});

function buscarUsuariosEMS() { //Esta función solo mostrará un resultado de forma estática, de la funcion te encargas tú
    let usuario = $("#ems_players_search_bar").val().replace("<", "&lt").replace(">", "&gt");
    limpiarBuscadorEMS();
    if (usuario.length > 1) {
        fetch(`https://Ox-Tablet/getUsersEMS`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            name: usuario
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.users != false){
                    resp.users.forEach(element => 
                        {
                            let id = element.id
                            $("#ems_searched_users_table").append(`<li>
                            <span class="searched_user_img">
                                <!-- Contenedor para la foto -->
                                <div class="user_photo_frame">
                                    <div class="user_photo_content">
                                        <img src="${element.avatar}"> 
                                    </div>
                                </div>
                                <!-- Fin de contenedor para foto -->
                            </span>
                            <span>${element.name}</span>
                            <span>$${element.unpaid}</span>
                            <span>${(element.sex === 'H' ? 'Masculino' : 'Femenino')}</span>
                            <span>${id}</span>
                            <span>${element.phone}</span>
                            <span class="action_buttons_container">
                                <div data-id="${element.id}" class="action_button open_template">
                                    <img src="./img/document-logo.png">
                                    <span class="action_label">Abrir ficha médica</span>
                                </div>
                            </span>
                        </li>`);
                        console.log(element.phone);
                        }
                    );
                }else{
                    popupNotificacion("No se encontraron resultados", false);
                }
            }
        );
    }
    else {
        popupNotificacion("Debes escribir al menos dos caracteres", false);
    }
    
    // let usuario = $("#ems_players_search_bar").val().replace("<", "&lt").replace(">", "&gt");

    // $("#ems_searched_users_table").append(`<li>
    //     <span class="searched_user_img">
    //         <!-- Contenedor para la foto -->
    //         <div class="user_photo_frame">
    //             <div class="user_photo_content">
    //                 <img src="./img/usuario_prueba.jpg"> 
    //             </div>
    //         </div>
    //         <!-- Fin de contenedor para foto -->
    //     </span>
    //     <span>${usuario}</span>
    //     <span>$534,21</span>
    //     <span>Masculino</span>
    //     <span>75GTH4</span>
    //     <span>6854298</span>
    //     <span class="action_buttons_container">
    //         <div class="action_button open_template">
    //             <img src="./img/document-logo.png">
    //             <span class="action_label">Abrir ficha médica</span>
    //         </div>
    //     </span>
    // </li>`);


}


//Funcion de acceso a datos de usuraio en SAPD con boton de Mostrar plantilla
$('#ems_searched_users_table').on('click', '.action_button.open_template', function(){ //Selector que funciona con elementos añadidos dinámicamente
    $("#ems_user_searcher_panel").removeClass("opened");
    let id = $(this).data("id");
    fetch(`https://Ox-Tablet/getUserEMS`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.user != false){
                    LoadSearchedUserEMS(resp.user)
                    $("#ems_searched_user_information_panel").addClass("opened");
                }else{
                    popupNotificacion("Parece haber un error en la ficha", false);
                }
            }
        );
        
});
//Fin de funcion de acceso a datos de usuraio en SAPD con boton de Mostrar plantilla



$("#ems_close_searched_user_information_button").click(function() {
    limpiarBuscadorEMS();
});



function limpiarBuscadorEMS() {
    //Cerramos el panel de datos de usuario si estuviera abierto y reabrimos el buscador
    if($("#ems_searched_user_information_panel").hasClass("opened")) {
        $("#ems_searched_user_information_panel").removeClass("opened");
        $("#ems_user_searcher_panel").addClass("opened");
    }

    //Limpiamos buscador
    $("#ems_players_search_bar").val("");

    //Limpiamos lista salvo primer elementos, que son los nombres
    $("#ems_searched_users_table").children().not(":first").remove();
   
}
// Fin de funciones de busqueda de USUARIOS  en EMS



//Listeners y funciones de ficha medica del menú EMS
//Boton para abrir el modal de añadir ver/modificar datos sanitarios en EMS
$("#ems_open_health_data_popup").click(function() {

    abrirCerrarPopup("ems_user_health_data_popup", true);
})


//Boton de cerrar popup de datos sanitarios
$("#close_user_health_popup_button").click(function() {

    abrirCerrarPopup("ems_user_health_data_popup", false);
})


//Boton de guardas datos sanitarios del popup
$("#register_user_health_popup_button").click(function() {
    let id = $(this).data("steam");


    fetch(`https://Ox-Tablet/updateMedical`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        citizenid: id,
        sangre: $("#ems_searched_user_blood_type").val(),
        efermedades: $("#ems_searched_user_diseases").val(),
        mentales: $("#ems_searched_user_mental_disorders").val(),
        operaciones: $("#ems_searched_user_surgeries_done").val(),
        vision: $("#ems_searched_user_vision_problems").val(),
        trastornos: $("#ems_searched_user_psychomotor_disorders").val(),
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.completed != false){
                popupNotificacion("Ficha de paciente actualizada", true);
                abrirCerrarPopup("ems_user_health_data_popup", false);
                RefreshUserEMS(id);
            }else{
                abrirCerrarPopup("ems_user_health_data_popup", false);
                popupNotificacion("Parece haber un error en la ficha", false);
            }
        }
    );
    // limpiarPopupFichaMedica();

})

function RefreshUserEMS(identifier) {
    fetch(`https://Ox-Tablet/getUserEMS`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: identifier
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.user != false){
                    LoadSearchedUserEMS(resp.user)
                    $("#ems_searched_user_information_panel").addClass("opened");
                }else{
                    popupNotificacion("Parece haber un error en la ficha", false);
                }
            }
        );
}

function limpiarPopupFichaMedica() {
    $("#ems_searched_user_blood_type").val("");
    $("#ems_searched_user_diseases").val("");
    $("#ems_searched_user_mental_disorders").val("");
    $("#ems_searched_user_surgeries_done").val("");
    $("#ems_searched_user_vision_problems").val("");
    $("#ems_searched_user_psychomotor_disorders").val("");
}

//Listeners y funciones de ficha medica del menú EMS
function setPopupFichaMedica(data) {
    $("#ems_searched_user_blood_type").val("");
    $("#ems_searched_user_diseases").val("");
    $("#ems_searched_user_mental_disorders").val("");
    $("#ems_searched_user_surgeries_done").val("");
    $("#ems_searched_user_vision_problems").val("");
    $("#ems_searched_user_psychomotor_disorders").val("");

    $("#ems_searched_user_blood_type").val(data.sangre);
    $("#ems_searched_user_diseases").val(data.efermedades);
    $("#ems_searched_user_mental_disorders").val(data.mentales);
    $("#ems_searched_user_surgeries_done").val(data.operaciones);
    $("#ems_searched_user_vision_problems").val(data.vision);
    $("#ems_searched_user_psychomotor_disorders").val(data.trastornos);
}





//Listeners y funciones del historial médico del menú EMS
$('#ems_searched_user_medical_history_table').on('click', '.action_button.delete_medical_consultation', function(){
    $.post("https://Ox-Tablet/delMedicalRecord", JSON.stringify({ id: $(this).data("id") }))
    $(this).parent().parent("li").remove();
    popupNotificacion("Ficha médica borrada", true);
});

$('#ems_searched_user_medical_history_table').on('click', '.action_button.show_medical_consultation', function(){
    limpiarPopupConsultaMedica();
    fetch(`https://Ox-Tablet/getMedicalRecord`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            citizenid: $(this).data("steam"),
            id: $(this).data("id"),
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.data != false){
                    setPopupConsultaMedica(resp.data)
                    abrirCerrarPopup("ems_user_medical_consultation_popup", true);
                }else{
                    popupNotificacion("Parece haber un error en la ficha", false);
                }
            }
        );
});

$("#emd_add_new_medical_consultation_button").click(function() {
    limpiarPopupConsultaMedica();
    abrirCerrarPopup("ems_user_medical_consultation_popup", true);

    //Carga de los valores del json al selector de multas (cambiar a boton de abertura del modal)
    let n = 0;
    $.each(facturas, function() {
        if (n == 0) {
            $("#bills_selector").append(`<option value="${n}" selected>${this.definicion} (Coste: ${this.coste})</option>`)
            
        } else {
            $("#bills_selector").append(`<option value="${n}">${this.definicion} (Coste: ${this.coste}$)</option>`)

        }
        n++;

    })
    //resto de datos
    $("#ems_register_new_medical_consultation_button").data("steam", $(this).data("steam"));
    $("#ems_register_new_medical_consultation_button").data("id", 0);
})


//Boton para añadir una factura nueva
$("#add_bill_button").click(function() {

    $("#added_bills_table").append(
        `<li>
            <span>${facturas[$("#bills_selector").val()].definicion}</span>
            <span data-id="${$("#bills_selector").val()}" class="bill_price">${facturas[$("#bills_selector").val()].coste}$</span>
            <span>
                <div class="delete_added_bill_button">X</div>
            </span>
            <span>${facturas[$("#bills_selector").val()].id}</span>
        </li>`
    )
})


//Boton para borrar las facturas añadidas
$("#added_bills_table").on('click', '.delete_added_bill_button', function(){
    $(this).parent().parent("li").remove();
})


//Listener para mostrar precio final automatico DE LAS FACTURAS
$('#added_bills_table').on('DOMSubtreeModified', function() {
    let precioFinal = 0;

    for(let i = 1; i < $(this).children().length; i++) { //A partir de 1 para saltarnos los titulos
        precioFinal += parseInt($(this).children(`:nth-child(${i+1})`).children('.bill_price').text());
    }

    $("#new_medical_consult_final_price").text(precioFinal + "$")
})


//Boton del precio final para apuntarlo en las observaciones
$("#new_medical_consult_final_price").click(function() {
    if ($("#ems_medical_consultation_observations").val().indexOf($(this).text()) == -1) {
        $("#ems_medical_consultation_observations").val($("#ems_medical_consultation_observations").val() + $(this).text())
    }

})



$("#ems_cancel_new_medical_consultation_button").click(function() {
    abrirCerrarPopup("ems_user_medical_consultation_popup", false);
    limpiarPopupConsultaMedica();

})

$("#ems_register_new_medical_consultation_button").click(function() {
    abrirCerrarPopup("ems_user_medical_consultation_popup", false);
    let bills = [];
    for(let i = 1; i < $("#added_bills_table").children().length; i++) { //A partir de 1 para saltarnos los titulos
        let mid = parseInt($("#added_bills_table").children(`:nth-child(${i+1})`).children('.bill_price').data("id"));
        console.log(facturas[mid].definicion);
        bills.push(mid);
    }
    fetch(`https://Ox-Tablet/updateMedicalRecords`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        citizenid: $(this).data("steam"),
        id: $(this).data("id"),
        doctor: $("#ems_medical_consultation_assigned_doctor").val(),
        description: $("#ems_medical_consultation_description").val(),
        tratamiento: $("#ems_medical_consultation_treatment").val(),
        doctores: $("#ems_medical_consultation_surgery_doctors").val(),
        heridas: $("#ems_medical_consultation_wounds").val(),
        observaciones: $("#ems_medical_consultation_observations").val(),
        bills: bills,
    })}).then(resp => resp.json()).then(
        (resp) => {
            if(resp.completed != false){
                popupNotificacion("¡Historial actualizado!", true);
                RefreshUserEMS($(this).data("steam"));
            }else{
                popupNotificacion("Parece haber un error en la ficha", false);
            }
        }
    );
    limpiarPopupConsultaMedica();
})


function limpiarPopupConsultaMedica() {
    $("#ems_medical_consultation_assigned_doctor").val("");
    $("#ems_medical_consultation_description").val("");
    $("#ems_medical_consultation_treatment").val("");
    $("#ems_medical_consultation_surgery_doctors").val("");
    $("#ems_medical_consultation_wounds").val("");
    $("#ems_medical_consultation_observations").val("");

    // Limpiamos el selector de facturas
    $("#bills_selector").children().remove();

    //Limpiamos las facturas ya seleccionadas
    $("#added_bills_table").children().not(":first").remove();
}


function setPopupConsultaMedica(data) {
    $("#ems_medical_consultation_assigned_doctor").val(data.doctor);
    $("#ems_medical_consultation_description").val(data.description);
    $("#ems_medical_consultation_treatment").val(data.tratamiento);
    $("#ems_medical_consultation_surgery_doctors").val(data.doctores);
    $("#ems_medical_consultation_wounds").val(data.heridas);
    $("#ems_medical_consultation_observations").val(data.observaciones);
    $("#ems_register_new_medical_consultation_button").data("steam", data.identifier);
    $("#ems_register_new_medical_consultation_button").data("id", data.id);
}
//Fin de listeners y funciones del historial médico del menú EMS



// Listeners y funcion para cambiar de normativa visible
$("#normativa_general_button").click(function() {
    cambiarNormativa("normativa_general_document", "normativa_general_button");
})

$("#normativa_bandas_button").click(function() {
    cambiarNormativa("normativa_bandas_document", "normativa_bandas_button");
})

$("#normativa_especifica_button").click(function() {
    cambiarNormativa("normativa_especifica_document", "normativa_especifica_button");
})

$("#normativa_comercio_button").click(function() {
    cambiarNormativa("normativa_comercio_document", "normativa_comercio_button");
})

$("#normativa_streaming_button").click(function() {
    cambiarNormativa("normativa_streaming_document", "normativa_streaming_button");
})


function cambiarNormativa(nuevaNormativa, nuevoBoton) {
    $("#normatives_selector").children().removeClass('selected');
    $("#normatives_selector").children('#' + nuevoBoton).addClass('selected');

    $('#normativa_page').children(".normativa_document").removeClass('opened');
    $('#normativa_page').children("#" + nuevaNormativa).addClass('opened');
}
//  Fin de listeners y funcion para cambiar de normativa visible






// Funciones y listeners de Administracion (buscador y pagina principal) --> TODO:
//Funcion y listener de busqueda de USUARIOS en Admin
$(document).on("keyup", "input#admin_players_search_bar", function(e) {
    if (e.key === 'Enter') {
        buscarUsuariosAdmin();
    }

});


$('#admin_searched_users_table').on('click', '.action_button.open_template', function(){

    let id = $(this).data("id");
    
    fetch(`https://Ox-Tablet/getUserAdmin`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.user != false){
                    LoadSearchedUserAdmin(resp.user)
                    cargarPaginaSearchedUserAdmin();
                }else{
                    popupNotificacion("Parece haber un error en la ficha", false);
                }
            }
        );
    // fetch(`https://Ox-Tablet/getMedicalRecord`, {
    //     method: 'POST',
    //     headers: {
    //         'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: JSON.stringify({
    //         citizenid: $(this).data("steam"),
    //         id: $(this).data("id"),
    //     })}).then(resp => resp.json()).then(
    //         (resp) => {
    //             if(resp.data != false){
    //                 setPopupConsultaMedica(resp.data)
    //                 abrirCerrarPopup("ems_user_medical_consultation_popup", true);
    //             }else{
    //                 popupNotificacion("Parece haber un error en la ficha", false);
    //             }
    //         }
    //     );
    //cargarPaginaSearchedUserAdmin();

});


function LoadSearchedUserAdmin(data){
    
    $('#admin_searched_user_photo').attr("src",data.Avatar);
    $('#admin_searched_user_change_photo_button').data("steam",data.Identifier);
    $('#admin_searched_user_name').text(data.RealName)
    $('#admin_searched_user_id').text(data.Identifier)
    if (data.Sex === 'H'){
        $('#admin_searched_user_genre').text("Masculino")
    }else{
        $('#admin_searched_user_genre').text("Femenino")
    }
    $('#admin_searched_user_phone').text(data.Phone)
    $('#admin_searched_user_date_birth').text(data.Dob)
    $('#admin_searched_user_penalties').text("$"+data.Unpaid)

    if (data.Secure === true){
        $('#admin_searched_user_life_insurance').removeClass('hasNotInsurance');
        $('#admin_searched_user_life_insurance').removeClass('hasInsurance');
        $('#admin_searched_user_life_insurance').addClass('hasInsurance');
        $('#admin_searched_user_life_insurance').text("Seguro disponible")
    }else{
        $('#admin_searched_user_life_insurance').removeClass('hasNotInsurance');
        $('#admin_searched_user_life_insurance').removeClass('hasInsurance');
        $('#admin_searched_user_life_insurance').addClass('hasNotInsurance');
        $('#admin_searched_user_life_insurance').text("Sin Seguro")
    }

    $("#admin_searched_user_option_dangerous").data("steam", data.Identifier);

    $("#register_admin_note_button").data("steam", data.Identifier);
    
    if (data.Danger === true){
        $('#admin_searched_user_option_dangerous').removeClass("dangerous_in");
        $('#admin_searched_user_option_dangerous').addClass("dangerous_out");
        $('#admin_searched_user_option_dangerous').text("Eliminar como sujeto peligroso");
        $("#admin_searched_user_label_dangerous").addClass("opened");
    }else{
        $('#admin_searched_user_option_dangerous').removeClass("dangerous_out");
        $('#admin_searched_user_option_dangerous').addClass("dangerous_in");
        $('#admin_searched_user_option_dangerous').text("Añadir como sujeto peligroso");
        $("#admin_searched_user_label_dangerous").removeClass("opened");
    }

    $("#admin_searched_user_option_search_seizure").data("steam", data.Identifier);

    if (data.admin_Searched === true){
        $("#admin_searched_user_label_search_seizure").removeClass("opened");
        $("#admin_searched_user_option_search_seizure").removeClass("search_seizure_out");
        $("#admin_searched_user_option_search_seizure").removeClass("search_seizure_in");
        $("#admin_searched_user_option_search_seizure").addClass("search_seizure_out");
        $("#admin_searched_user_option_search_seizure").text("Retirar de busca y captura");
        $("#admin_searched_user_label_search_seizure").addClass("opened");
    }else{
        $("#admin_searched_user_option_search_seizure").removeClass("search_seizure_in");
        $("#admin_searched_user_option_search_seizure").removeClass("search_seizure_out");
        $("#admin_searched_user_option_search_seizure").addClass("search_seizure_in");
        $("#admin_searched_user_option_search_seizure").text("Poner en busca y captura");
        $("#admin_searched_user_label_search_seizure").removeClass("opened");
    }

    $("#register_penalty_button").data("steam", data.Identifier);
    
    $("#register_data_change_button").data("steam", data.Identifier);

    
    
    let recordsHtml = `
    <li>
        <span>Descripción de la consulta</span>
        <span>Doctor asignado</span>
        <span>Fecha de consulta</span>
        <span>Tratamiento</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_medical_history_table').html("")

    data.Records.forEach(element => {
        recordsHtml = recordsHtml + `
        <li>
            <span>${element.description}</span>
            <span>${element.doctor}</span>
            <span>${element.sent_date}</span>
            <span>${element.tratamiento}</span>
            <span class="action_buttons_container">
                <div data-id="${element.id}" class="action_button delete_medical_consultation">
                    <img src="./img/drop_penalties.png">
                    <span class="action_label">Eliminar consulta</span>
                </div>
            </span>
        </li>
        `
        }
    );
    
    $('#admin_searched_user_medical_history_table').html(recordsHtml)


    //Crimenes
    let notesHtml = `
    <li>
        <span>Información de la nota</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_notes_table').html("")

    data.Notes.forEach(element => 
        notesHtml = notesHtml + `
        <li>
            <span>${element.note}</span>
            <span class="action_buttons_container">
                <div data-id="${element.id}" class="action_button delete_note">
                    <img src="./img/delete_note.png">
                    <span class="action_label">Eliminar nota</span>
                </div>
            </span>
        </li>
        `
    );
    $('#admin_searched_user_notes_table').html(notesHtml)

    //Crimenes
    let penaltiesHtml = `
    <li>
        <span>Descripción de la infracción</span>
        <span>Oficial asignado</span>
        <span>Fecha de registro</span>
        <span>Sanción</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_crimes_history_table').html("")

    data.Penals.forEach(element => 
        penaltiesHtml = penaltiesHtml + `
        <li>
            <span>${element.description}</span>
            <span>${element.sender_name}</span>
            <span>${element.sent_date}</span>
            <span>${element.penaltie}</span>
            <span class="action_buttons_container">
                <div data-id="${element.id}" class="action_button delete_penalty">
                    <img src="./img/drop_penalties.png">
                    <span class="action_label">Eliminar sanción</span>
                </div>
            </span>
        </li>
        `
    );
    $('#admin_searched_user_crimes_history_table').html(penaltiesHtml)

    // //Facturas
    var invoicesHtml = `
    <li>
        <span>Definición</span>
        <span>Coste de la sanción</span>
        <span>Emisor</span>
        <span>Fecha de emisión</span>
        <span>Estado</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_penalties_table').html("")

    data.Invoices.forEach(element => {
        if (element.status === "unpaid"){
            invoicesHtml = invoicesHtml + `
            <li>
                <span>` + element.item + `</span>
                <span>$` + element.invoice_value + `</span>
                <span>` + element.author_name + `</span>
                <span>` + element.sent_date + `</span>
                <span data-id="` + element.id + `" class="status_label pending">
                    <div class="text">Pediente</div>
                </span>
                <span class="action_buttons_container">
                    <div class="action_button delete_penalty">
                        <img src="./img/drop_penalties.png">
                        <span class="action_label">Retirar multa</span>
                    </div>
                </span>
            </li>
            `
        }else if (element.status === "paid") {
            invoicesHtml = invoicesHtml + `
            <li>
                <span>` + element.item + `</span>
                <span>$` + element.invoice_value + `</span>
                <span>` + element.author_name + `</span>
                <span>` + element.sent_date + `</span>
                <span data-id="` + element.id + `" class="status_label paid">
                    <div class="text">Pagada</div>
                </span>
                <span class="action_buttons_container">

                </span>
            </li>
            `
        }else if (element.status === "cancelled") {
            invoicesHtml = invoicesHtml + `
            <li>
                <span>` + element.item + `</span>
                <span>$` + element.invoice_value + `</span>
                <span>` + element.author_name + `</span>
                <span>` + element.sent_date + `</span>
                <span data-id="` + element.id + `" class="status_label inSearch">
                    <div class="text">Retirada</div>
                </span>
                <span class="action_buttons_container">

                </span>
            </li>
            `
        }
    });

    $('#admin_searched_user_penalties_table').html(invoicesHtml)

    $('#admin_searched_user_penalties_table').on('click', '.action_button.delete_penalty', function(){
        // $(this).parent().parent("li").remove();

        let id = $(this).parent().siblings(".status_label").data("id");
        $(this).addClass("disabled");
        fetch(`https://Ox-Tablet/delInvoice`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.payed === true){
                    popupNotificacion("Factura Cancelada", true)
                    $(this).parent().siblings(".status_label").removeClass("pending");
                    $(this).parent().siblings(".status_label").addClass("inSearch");
                    $(this).parent().siblings(".status_label").children(".text").text("Cancelada");
                    $(this).addClass("disabled");
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
    });

    //Casas
    let housesHtml = `
    <li>
        <span>Tipo</span>
        <span>Ubicación</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_properties_table').html("")

    data.Houses.forEach(element => 
        housesHtml = housesHtml + `
        <li>
            <span>` + element.id + `</span>
            <span>` + element.interior + `</span>
            <span class="action_buttons_container">
                <div data-id="${element.id}" class="action_button delete_property">
                    <img src="./img/drop_property.png">
                    <span class="action_label">Eliminar propiedad</span>
                </div>
            </span>
        </li>
        `
    );

    $('#admin_searched_user_properties_table').html(housesHtml);

    //Coches
    let carsHtml = `
    <li>
        <span>Matrícula</span>
        <span>Modelo</span>
        <span>Color</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_vehicles_table').html("")

    data.Vehicles.forEach(element => {
        carsHtml = carsHtml + `
        <li>
            <span>` + element.plate + `</span>
            <span>` + element.model + `</span>
            <span><span class='color'>` + element.color[0] + `,` + element.color[1] + `,` + element.color[2] + `</span></span>
            <span class="action_buttons_container">
                <div data-id="${element.plate}" class="action_button delete_vehicle">
                    <img src="./img/drop_car.png">
                    <span class="action_label">Eliminar vehículo</span>
                </div>
            </span>
        </li>
        `
        }
    );
    
    $('#admin_searched_user_vehicles_table').html(carsHtml)

    $(".color").each(function() {
        $(this).css("background-color", "rgb(" + $(this).text() + ")")
        $(this).text("");
    })

    //Licencias
    let licensesHtml = `
    <li>
        <span>Licencia</span>
        <span>Acciones</span>
    </li>`

    $('#admin_searched_user_licenses_table').html("")

    data.Licenses.forEach(element => 
        licensesHtml = licensesHtml + `
        <li>
            <span>${element.label}</span>
            <span class="action_buttons_container">
                <div data-id="${data.Identifier}" data-type="${element.name}" class="action_button delete_licence">
                    <img src="./img/drop_licence.png">
                    <span class="action_label">Eliminar licencia</span>
                </div>
            </span>
        </li>
        `
    );

    $('#admin_searched_user_licenses_table').html(licensesHtml);
}


$("#admin_close_searched_user_information_button").click(function() {
    limpiarBuscadorAdmin();

});


$("#admin_open_user_data_changer_popup").click(function(){
    abrirCerrarPopup("admin_change_user_data_popup", true);
 
});


$("#cancel_data_change_button").click(function(){ 
    abrirCerrarPopup("admin_change_user_data_popup", false);
    limpiarPopupCambiarDatosAdmin();

});


$("#register_data_change_button").click(function(){ 

    let name = $(this).parent().siblings("#user_name_change").val();
    let birthdate = $(this).parent().siblings("#user_birth_date_change").val();
    let gender = $(this).parent().siblings("#user_gender_change").val();
    let id = $(this).data("steam");


    modificarDatosUsuarioAdmin(id, name, birthdate, gender);

    abrirCerrarPopup("admin_change_user_data_popup", false);
    limpiarPopupCambiarDatosAdmin();

});


// Listeners de accion del menu de tablas de usuarios de Administracion
$("#admin_searched_user_properties_button").click(function() {
    cambiarBotonTablesMenu("admin_searched_user_tables_selector", "admin_searched_user_tables_panel",  "admin_searched_user_properties_button", "admin_searched_user_properties_table");
    cambiarAddElementsButtons("admin_searched_user_add_elements_buttons","");
})

$("#admin_searched_user_vehicles_button").click(function() {
    cambiarBotonTablesMenu("admin_searched_user_tables_selector", "admin_searched_user_tables_panel",  "admin_searched_user_vehicles_button", "admin_searched_user_vehicles_table");
    cambiarAddElementsButtons("admin_searched_user_add_elements_buttons","");

    //Esto es solo para mostrar los colores correctamente, deberas ponerlo en la carga de datos (revisa en la funcion de carga de vehiculos de SAPD, BORRA ESTE)
    $("#admin_searched_user_vehicles_table .color").each(function() {
        $(this).css("background-color", "rgb(" + $(this).text() + ")")
        $(this).text("");
    })
})

$("#admin_searched_user_crimes_history_button").click(function() {
    cambiarBotonTablesMenu("admin_searched_user_tables_selector", "admin_searched_user_tables_panel",  "admin_searched_user_crimes_history_button", "admin_searched_user_crimes_history_table");
    cambiarAddElementsButtons("admin_searched_user_add_elements_buttons","");
})

$("#admin_searched_user_medical_history_button").click(function() {
    cambiarBotonTablesMenu("admin_searched_user_tables_selector", "admin_searched_user_tables_panel",  "admin_searched_user_medical_history_button", "admin_searched_user_medical_history_table");
    cambiarAddElementsButtons("admin_searched_user_add_elements_buttons","");
})

$("#admin_searched_user_notes_button").click(function() {
    cambiarBotonTablesMenu("admin_searched_user_tables_selector", "admin_searched_user_tables_panel",  "admin_searched_user_notes_button", "admin_searched_user_notes_table");
    cambiarAddElementsButtons("admin_searched_user_add_elements_buttons","add_admin_notes_button");
})


//Listeners de los botones de borrado de registros (DEBES implementar el codigo de borrado en bbdd, esto solo lo borra al momento de la tabla)

//Eliminar propiedades
$('#admin_searched_user_properties_table').on('click', '.action_button.delete_property', function(){
    fetch(`https://Ox-Tablet/delAdminHouse`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: $(this).data("id"),
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.deleted === true){
                    popupNotificacion("Casa Eliminada", true)
                    $(this).parent().parent("li").remove();
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
    
});

//Eliminar vehículos
$('#admin_searched_user_vehicles_table').on('click', '.action_button.delete_vehicle', function(){
    fetch(`https://Ox-Tablet/delAdminCar`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: $(this).data("id"),
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.deleted === true){
                    popupNotificacion(`"Vehiculo con matricula ${$(this).data("id")} Eliminada"`, true)
                    $(this).parent().parent("li").remove();
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
});

//Eliminar registro policial
$('#admin_searched_user_crimes_history_table').on('click', '.action_button.delete_penalty', function(){
    fetch(`https://Ox-Tablet/delAdminDelitos`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: $(this).data("id"),
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.deleted === true){
                    popupNotificacion("Delito Eliminado", true)
                    $(this).parent().parent("li").remove();
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
});

//Eliminar consulta médica
$('#admin_searched_user_medical_history_table').on('click', '.action_button.delete_medical_consultation', function(){
    fetch(`https://Ox-Tablet/delAdminMedicHist`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: $(this).data("id"),
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.deleted === true){
                    popupNotificacion(`"Historial Medico Eliminado"`, true)
                    $(this).parent().parent("li").remove();
                }else{
                    popupNotificacion("No puedes hacer eso", false) //Con false ponemos una cruz roja en vez del check
                    setTimeout(() => {  
                        $(this).removeClass("disabled");
                    }, 1800);
                }
            }
        );
});

//Eliminar nota de admin
$('#admin_searched_user_notes_table').on('click', '.action_button.delete_note', function(){
    $(this).parent().parent("li").remove();
    let id = $(this).parent().data("id");
    $.post("https://Ox-Tablet/delAdminNote", JSON.stringify({ id: id }));
});


//Botones del moda para añadir notas de admin
//Boton para abrir el modal de añadir notas admin
$("#add_admin_notes_button").click(function() {
    abrirCerrarPopup("add_admin_note_popup", true);

})

//Boton para cancelar el añadir notas admin
$("#cancel_admin_note_button").click(function() {
    abrirCerrarPopup("add_admin_note_popup", false);
    limpiarPopupRegistrarNota("new_admin_note_textarea");

})

//Boton de registrar notas admmin
$("#register_admin_note_button").click(function() {

    abrirCerrarPopup("add_admin_note_popup", false);

    let id = $(this).data("steam");
    let description = $("#new_admin_note_textarea").val();
    console.log(id)
    fetch(`https://Ox-Tablet/addAdminNotes`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            citizenid: id,
            text: description,
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.completed === true){
                    RefreshAdminUser(id);
                }
            }
        );

    

    limpiarPopupRegistrarNota("new_admin_note_textarea");

})




function modificarDatosUsuarioAdmin(id, nombre, nacimiento, genero) {
    //En esta funcion compara si cada valor es distinto de "" y si lo es lo modificas en BBDD, si todo va bien notificacion de todo correcto, si falla algo, notif de error de lo que fallara
    fetch(`https://Ox-Tablet/modifyUser`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            citizenid: id,
            name: nombre,
            birthdate: nacimiento,
            gender: genero
        })}).then(resp => resp.json()).then(
            (resp) => {
                if(resp.completed === true){
                    RefreshAdminUser(id);
                }
            }
        );
}


function buscarUsuariosAdmin() { //Esta función solo mostrará un resultado de forma estática, de la funcion te encargas tú

    let usuario = $("#admin_players_search_bar").val().replace("<", "&lt").replace(">", "&gt");
    limpiarBuscadorAdmin();
    if (usuario.length > 1) {
        fetch(`https://Ox-Tablet/getUsersAdmin`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            name: usuario
        })}).then(resp => resp.json()).then(
            (resp) => {
                console.log(JSON.stringify(resp));
                if(resp.users != false){
                    resp.users.forEach(element => 
                        {
                            let id = element.id
                            $("#admin_searched_users_table").append(`<li>
                                <span class="searched_user_img">
                                    <div class="user_photo_frame">
                                        <div class="user_photo_content">
                                            <img src="${element.avatar}"> 
                                        </div>
                                    </div>
                                </span>
                                <span>${element.name}</span>
                                <span>${element.phone}</span>
                                <span>${element.id}</span>
                                <span class="action_buttons_container">
                                    <div data-id="${id}" class="action_button open_template">
                                        <img src="./img/document-logo.png">
                                        <span class="action_label">Abrir ficha</span>
                                    </div>
                                </span>
                            </li>`);
                        }
                    );
                }else{
                    popupNotificacion("No se encontraron resultados", false);
                }
            }
        );
    }
    else {
        popupNotificacion("Debes escribir al menos dos caracteres", false);
    }


}
//Fin de funcione de busqueda de USUARIOS ADMIN

//Limpiador del buscador
function limpiarBuscadorAdmin() {
    //Cerramos el panel de datos de usuario si estuviera abierto y reabrimos el buscador
    if($("#admin_searched_user_information_panel").hasClass("opened")) {
        $("#admin_searched_user_information_panel").removeClass("opened");
        $("#admin_user_searcher_panel").addClass("opened");
    }

    //Limpiamos buscador
    $("#admin_players_search_bar").val("");

    //Limpiamos lista salvo primer elementos, que son los nombres
    $("#admin_searched_users_table").children().not(":first").remove();
   
}


//Funcion de acceso a datos de usuraio en Admin con boton de Mostrar plantilla
function cargarPaginaSearchedUserAdmin() {
    $("#admin_user_searcher_panel").removeClass("opened");
    $("#admin_searched_user_information_panel").addClass("opened");

    //En caso de que falle la busqueda en BBDD o lo que sea: popupNotificacion("Parece haber un error en la ficha", false);

}


// Limpiador del popup de cambiar datos de usuarios de Administracion
function limpiarPopupCambiarDatosAdmin() {
    $("#user_name_change").val("");
    $("#user_birth_date_change").val("");
    $("#user_gender_change").val("");
}




// Fin de funciones y listeners de Administracion (buscador y pagina principal)







//Funciones y listeners de listado de items de Administración

function cargarListadoDeItemsAdmin() {
   
    $.each(adminItems, function() {
        
        $("#admin_searched_items_table").append(
            `<li>
                <span class="searched_user_img">
                    <div class="user_photo_frame">
                        <div class="user_photo_content">
                            <img src="./images/${this.name}.png"> 
                        </div>
                    </div>
                </span>
                <span>${this.label}</span>
                <span>${this.name}</span>
                <span>
                    <div class="item_amount_selector_container">
                        <div class="item_amount_selector_button item_amount_decrease">-</div>
                        <input class="item_amount_number" type="number" name="" value="1">
                        <div class="item_amount_selector_button item_amount_increase">+</div>
                    </div>
                </span>
                <span class="action_buttons_container">
                    <div class="action_button generate_item">
                        <img src="./img/new_item.png">
                        <span class="action_label">Generar item</span>
                    </div>
                </span>
            </li>`
        );
    });
}


function limpiarBuscadorAdminItems() {
    var listaItems = $('#admin_searched_items_table').children('li').not(":first");

    //Es este caso al cargarse los datos con la propia tablet el limpiador solo borra el texto buscado
    $("#admin_items_search_bar").val("");
    

    //Y mostramos todos los items y eliminamos el ultimo border-bottom
    mostrarItems(listaItems);
    listaItems.not(":hidden").last().css("border-bottom", "none");
}


//Filtro de busqueda por nombres (con funciones auxiliares)
$('#admin_items_search_bar').keyup(function() {
    var listaItems = $('#admin_searched_items_table').children('li').not(":first");

    mostrarItems(listaItems);
    if ($(this).val() != '') {
        filtrarItems(listaItems, $('#admin_items_search_bar').val().toLowerCase());
    }

    //Tras calcular toda la lista (con o sin filtros) al ultimo elemento se le borra el borde inferior
    listaItems.not(":hidden").last().css("border-bottom", "none");


});

function mostrarItems(listaItems) {
    listaItems.each(function(index) {
        $(this).show();

        //Ponemos el borde inferior a todos los elementos
        $(this).css("border-bottom", ".1vh solid rgb(212, 212, 212)");

        // Reseteamos las cantidades a 1
        $(this).children(':nth-child(4)').children().children(':nth-child(2)').val(1);
        
    });
}


function filtrarItems(listaItems, nombre) {
    listaItems.each(function() {
        if(!($(this).children(':nth-child(2)').text().toLowerCase().includes(nombre))) {
            $(this).hide();
        }
    });
}



//Funciones y listeners para los contadores de cantidad de cada elemento

//Listener de los botones de restar cantidad
$('#admin_searched_items_table').on('click', '.item_amount_decrease', function(){
    let currentValue = parseInt($(this).siblings(".item_amount_number").val());
   
    if (currentValue > 1) {
        $(this).siblings(".item_amount_number").val(--currentValue);
    }  
});


//Listener de los botones de sumar cantidad
$('#admin_searched_items_table').on('click', '.item_amount_increase', function(){
    let currentValue = parseInt($(this).siblings(".item_amount_number").val());
   
    if (currentValue < 10000) {
        $(this).siblings(".item_amount_number").val(++currentValue);
    }  
});


//Listener para escritura manual de cantidad (control completo de ccantidades y caracteres)
$('#admin_searched_items_table').on('keyup', '.item_amount_number', function(value){
    let currentValue = parseInt($(this).val());

    if (!(value.which === 0 //Null
        || value.which === 8 //Backspace
        || (value.which >= 48 && value.which <= 57) //de 0 a 9
        || value.which === 39 //Flecha derecha
        || value.which === 37)) { //Flecha izquierda

            return false;
    }
});

//Control de cantidad en el input
$('#admin_searched_items_table').on('input', '.item_amount_number', function(value){
    if ($(this).val() === '' || parseInt($(this).val()) < 1) {
        $(this).val(1);
    } else if (parseInt($(this).val()) > 10000) {
        $(this).val(10000);
    }
});



//Listener y funcion del boton de generar los items en el inventario
$('#admin_searched_items_table').on('click', '.action_button.generate_item', function(value){
    let nombre = $(this).parent().siblings(":nth-child(2)").text();
    let itemID = $(this).parent().siblings(":nth-child(3)").text();
    let cantidad = $(this).parent().siblings(":nth-child(4)").children().children(":nth-child(2)").val();

    generarItems(itemID, nombre, cantidad);

    //Reseteamos el valor de la cantidad a 1
    $(this).parent().siblings(":nth-child(4)").children().children(":nth-child(2)").val(1);
});



function generarItems(itemID, nombre, cantidad) {

    //Aqui genera el codigo que necesites

    $.post("https://Ox-Tablet/giveItem", JSON.stringify({ 
        item: itemID,
        count: cantidad
    }))




    
    //Notificaciones si las quieres usar:

        popupNotificacion(`${cantidad} ${nombre}/s añadido al inventario`, true) //Si todo fue bien
        //popupNotificacion(`No se ha podido generar el item. Vuelve a intentarlo`, false) //Si algo fue mal

}

//Fin de funciones y listeners de listado de items de Administración



// Funciones y listeners de los botones de los registros de Delitos en Curso

//Boton de ateneder delito
$('#crimes_in_progress_table').on('click', '.action_button.attend_crime', function(){  
    fetch(`https://Ox-Tablet/updateRobberies`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            crimenId: $(this).parent().parent("li").data("id")
        })
    }).then(resp => resp.json()).then(resp => {
        console.log(resp)
        if (resp.completed === true) {
            $(this).removeClass("attend_crime");
            $(this).addClass("unattend_crime");
            $(this).children("img").attr("src", "./img/unattend_crime.png");
            $(this).children("span").text("Dejar de atender");

            $(this).parent("").siblings(".status_label").removeClass("pending");
            $(this).parent("").siblings(".status_label").addClass("inProgress");
            $(this).parent("").siblings(".status_label").children(".text").text("En progreso");
        } else {
            popupNotificacion(`No se ha podido atender el caso.`, false)
        }
    });

});

//Boton de dejar de ateneder delito
$('#crimes_in_progress_table').on('click', '.action_button.unattend_crime', function(){  
    fetch(`https://Ox-Tablet/updateRobberies`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            crimenId: $(this).parent().parent("li").data("id")
        })
    }).then(resp => resp.json()).then(resp => {
        console.log(resp)
        if (resp.completed === true) {
            $(this).removeClass("unattend_crime");
            $(this).addClass("attend_crime");
            $(this).children("img").attr("src", "./img/attend_crime.png");
            $(this).children("span").text("Atender delito");
            
            $(this).parent("").siblings(".status_label").removeClass("inProgress");
            $(this).parent("").siblings(".status_label").addClass("pending");
            $(this).parent("").siblings(".status_label").children(".text").text("Pendiente");
        } else {
            popupNotificacion(`No se ha podido abandonar el caso.`, false)
        }
    });
    

});

//Boton de dejar de cerrar caso
$('#crimes_in_progress_table').on('click', '.action_button.delete_crime', function(){  
    // $.post("https://Ox-Tablet/updateRobberies", JSON.stringify({ id: $(this).parent().siblings(":nth-child(1)").text() }))

    fetch(`https://Ox-Tablet/deleteRobbery`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            crimenId: $(this).parent().parent("li").data("id")
        })
    }).then(resp => resp.json()).then(resp => {
        console.log(resp)
        if (resp.completed === true) {
            $(this).parent().parent("li").remove();
            popupNotificacion(`Se ha cerrado el caso satisfactoriamente.`, true)
        } else {
            popupNotificacion(`No se ha podido cerrar el caso.`, false)
        }
    });
    
});


// Fin de funciones y listeners de los botones de los registros de Delitos en Curso



//Funcion para abrir y cerrar popups de forma animada
function abrirCerrarPopup (popup, isOpening) {
    if (isOpening) {
        
        $("#popups_panel").addClass("opened");
        $("#" + popup).addClass("opened");

        setTimeout(() => {    
        $("#popups_panel").css("opacity", "1");
        $("#" + popup).css("transform", "scale(100%)");
            $("#" + popup).css("opacity", "1");
        }, 10);

    } else {
        $("#" + popup).css("transform", "scale(0)");
        $("#" + popup).css("opacity", "0");
        $("#popups_panel").css("opacity", "0");

        setTimeout(() => { 
            $("#" + popup).scrollTop(0);
            $("#" + popup).removeClass("opened");
            $("#popups_panel").removeClass("opened");
        }, 310);
    }
}
//Fin de funcion para abrir y cerrar popups de forma animada


// Listeners y funciones de los botones de menu de Trabajos
$("#searched_jobs_table").on("click", ".range_button", function() {
    $(this).siblings(".range_button").removeClass("selected")
    $(this).addClass("selected");
});


$("#searched_jobs_table").on("click", ".action_button.assign_job", function() {
    let idTrabajo = $(this).parent().siblings(":nth-child(1)").text();
    let nombreTrabajo = $(this).parent().siblings(":nth-child(2)").text();
    let idRango = $(this).parent().siblings(":nth-child(3)").children(".selected").data("id");
    let nombreRango = $(this).parent().siblings(":nth-child(3)").children(".selected").text();

    abrirCerrarPopup("assign_new_job_popup", true);
    cargarPopupGenerarTrabajo(idTrabajo, nombreTrabajo, idRango, nombreRango);

});


$("#cancel_assign_job_button").click(function() {
    abrirCerrarPopup("assign_new_job_popup", false);
    limpiarPopupGenerarTrabajo();

});


$("#register_assign_job_button").click(function() {
    let idTrabajo = $("#new_job_id_input").val();
    let idRango = $("#new_job_range_input").data("id");
    let idUsuario = $("#new_job_user_id_input").val();
    
    
    abrirCerrarPopup("assign_new_job_popup", false);

    registrarNuevoTrabajo(idTrabajo, idRango, idUsuario);

    limpiarPopupGenerarTrabajo();

});


//Filtro de busqueda por nombres e IDs (con funciones auxiliares)
$('#jobs_search_bar').keyup(function() {
    var listaTrabajos = $('#searched_jobs_table').children('li').not(":first");
    console.log(JSON.stringify(listaTrabajos))

    mostrarTrabajos(listaTrabajos);
    if ($(this).val() != '') {
        filtrarTrabajos(listaTrabajos, $('#jobs_search_bar').val().toLowerCase());
    }

    //Tras calcular toda la lista (con o sin filtros) al ultimo elemento se le borra el borde inferior
    listaTrabajos.not(":hidden").last().css("border-bottom", "none");


});



//Funcion auxiliar para buscar trabajos
function mostrarTrabajos(listaTrabajos) {
    listaTrabajos.each(function() {
        $(this).show();

        //Ponemos el borde inferior a todos los elementos
        $(this).css("border-bottom", ".1vh solid rgb(212, 212, 212)");

        // Cambiamos la opcion de rango seleccionada a la primera
        $(this).children('.ranges_list').children().removeClass("selected");
        $(this).children('.ranges_list').children(":nth-child(1)").addClass("selected");
        
    });
}

//Funcion auxiliar para filtrar trabajos en la búsqueda
function filtrarTrabajos(listaTrabajos, nombreId) {
    listaTrabajos.each(function() {
        if(!($(this).children(':nth-child(1)').text().toLowerCase().includes(nombreId)) && //Comparador por ID
           !($(this).children(':nth-child(2)').text().toLowerCase().includes(nombreId))) { //Comparador por nombre
            $(this).hide();
        }
    });
}

//Funcion de registrar trabajo
function registrarNuevoTrabajo(idTrabajo, idRango, idUsuario) {
    //Aquí añades el codigo necesario para asignar el nuevo trabajo
    fetch(`https://Ox-Tablet/setJob`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            target: idUsuario,
            job: idTrabajo,
            grade: idRango
        })
    }).then(resp => resp.json()).then(resp => {
        console.log(JSON.stringify(resp));
        if (resp.completed === false) {
            popupNotificacion(`La ID ${idUsuario} no esta conectada.`, false)
        } else {
            popupNotificacion(`Se le a asignado ${idTrabajo} - ${idRango} a la ID ${idUsuario}.`, true)
        }
    });
    // /* Esto borralo */ console.log("idTrabajo: " + idTrabajo + "\n" + "idRango: " + idRango + "\n" + "idUsuario: " + idUsuario);

}

//Cargador de los datos seleccionadoes en el popup
function cargarPopupGenerarTrabajo(idTrabajo, nombreTrabajo, idRango, nombreRango){
    $("#new_job_id_input").val(idTrabajo);
    $("#new_job_name_input").val(nombreTrabajo);
    $("#new_job_range_input").data("id", idRango);
    $("#new_job_range_input").val(nombreRango);

}


// Limpiador del popup de cambiar datos de usuarios de Administracion
function limpiarPopupGenerarTrabajo() {    
    $("#new_job_id_input").val("");
    $("#new_job_name_input").val("");
    $("#new_job_range_input").data("id", "");
    $("#new_job_range_input").val("");
    $("#new_job_user_id_input").val("");

}

//Limpiador del buscador de trabajos
function limpiarBuscadorTrabajos() {
    var listaTrabajos = $('#searched_jobs_table').children('li').not(":first");

    //Es este caso al cargarse los datos con la propia tablet el limpiador solo borra el texto buscado
    $("#jobs_search_bar").val("");
    

    //Y mostramos todos los items y eliminamos el ultimo border-bottom
    mostrarTrabajos(listaTrabajos);
    listaTrabajos.not(":hidden").last().css("border-bottom", "none");
}















// Encendido y apagado de la tablet con su boton y letra t
// $(document).keyup(function(e) {
//     if (e.key === 't' || e.key === 'T') {
//         mostrarOcultarTablet();
//     }
// });




/*


Apuntes:

    - Recordar quitar funcion de T y cambiar JQuery

    
    


Apuntes a futuro:

    - Al cerrar las paginas de info de usuario (por cualquier motivo) y si reseteamos la tabla inferior abierta????? (Info personal y buscados de sapd, ems y admin)

    - Y si en vez de llamar a los limpiadores de popups en cada vez que se cierran independientemente metemos el limpiador general en abrir cerra popups????

    - He implementado un control para los submenus segun si estos se estaban abriendo al querer cerrarlos o si se han cerrado ya, no funciona perfecto pero es lo suficientemente
        bueno como para dejarlo asi de momento, en el caso de las aberturas no puedo controlar mucho pero el chance de error, salvo que alguien lo quiera fastidiar a proposito, no es ni de lejos grande.
        Si eso revisar una nueva version mas adelante si los submenus se agrandan en más de 3 opciones


*/