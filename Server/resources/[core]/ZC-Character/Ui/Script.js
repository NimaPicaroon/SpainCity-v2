$(function () {
    $('.main-wrapper').hide()
    $('.camera-wrapper').hide()
    let selectedcategory = 1;
    let selectedSex = '';
    let shopType = '';
    let openCams = false
    const categories = {
        [1]: 'flex-identity',
        [2]: 'flex-face',
        [3]: 'flex-style'
    }
    const corresponsal = {
        ['tshirt_1']: 'tshirt_2',
        ['torso_1']: 'torso_2',
        ['arms']: 'arms_2',
        ['pants_1']: 'pants_2',
        ['shoes_1']: 'shoes_2',
        ['helmet_1']: 'helmet_2',
        ['chain_1']: 'chain_2',
        ['bproof_1']: 'bproof_2',
        ['bags_1']: 'bags_2',
        ['glasses_1']: 'glasses_2',
        ['watches_1']: 'watches_2',
        ['bracelets_1']: 'bracelets_2',
        ['mask_1']: 'mask_2',
        ['ears_1']: 'ears_2',
        ['decals_1']: 'decals_2'
    }

    window.addEventListener("message", function (event) {  
        let open = event.data.open
        let max = event.data.max
        let values = event.data.current
        let type = event.data.type
        let close = event.data.close

        if (max) {
            updateMax(max)
        }
        if (values) {
            updateVals(values)
        }
        if (open) {
            openMenu(type)
        } else if (close) {
            closeMenu()
        }
    });

    // Sexo
    $('#male').on("click", function() {
        if (selectedSex == 'female') {
            $('#female').removeClass("selectedSex")
        }
        selectedSex = 'male'
        $(this).addClass("selectedSex")
        $('#sex_value').text("Hombre")
        $.post("https://ZC-Character/changeValues", JSON.stringify({type: 'sex', value: 'mp_m_freemode_01'}))
    })

    $('#female').on("click", function() {
        if (selectedSex == 'male') {
            $('#male').removeClass("selectedSex")
        }
        selectedSex = 'female'
        $(this).addClass("selectedSex")
        $('#sex_value').text("Mujer")
        $.post("https://ZC-Character/changeValues", JSON.stringify({type: 'sex', value: 'mp_f_freemode_01'}))
    })

    // Barras
    const rangers = document.querySelectorAll(".ranger");
    for (let i = 0; i < rangers.length; i++) {
        rangers[i].querySelector("input").addEventListener("input", event => {
            const Value = rangers[i].querySelector("#ranger_value");
            Value.value=event.target.value;
            $.post("https://ZC-Character/changeValues", JSON.stringify({type: event.target.id, value:event.target.value}))
        });
    }

    // Colores
    let color = 'eye1';

    $('.color').each(function(){
        var color = $(this).attr('data-color');
        $(this).css('background-color', color);
    });

    // Ojos
    $('input[name=eyecolor]').on("click", function() {
        $('input[name=eyecolor][id='+color+']').prop('checked', false);
        var check = this.checked
        $(this).prop('checked', !check);
        $('.color[id='+color+']').removeClass("selectedColor")
        color = this.id
        $('.color[id='+color+']').addClass("selectedColor")  
        const value = color.replace(/\D/g, '');
        $.post("https://ZC-Character/changeValues", JSON.stringify({type: 'eye_color', value:(value-1)}))
    })

    // Botones
    $(".category1-button").on("click", function() {
        $("#category-"+selectedcategory).removeClass("selectedcategory")
        changeCategory(1)
    })

    $(".category2-button").on("click", function() {
        $("#category-"+selectedcategory).removeClass("selectedcategory")
        changeCategory(2)
    })

    $(".category3-button").on("click", function() {
        $("#category-"+selectedcategory).removeClass("selectedcategory")
        changeCategory(3)
    })

    $(".category4-button").on("click", function() {
        $("#category-"+selectedcategory).removeClass("selectedcategory")
        changeCategory(4)
    })

    $(".accept-button").on("click", function() {
        closeMenu()
    })

    $("#head").on("click", function() {
        $.post("https://ZC-Character/changeCam", JSON.stringify({type: 'head'}))
    })

    $("#body").on("click", function() {
        $.post("https://ZC-Character/changeCam", JSON.stringify({type: 'body'}))
    })

    $("#shoes").on("click", function() {
        $.post("https://ZC-Character/changeCam", JSON.stringify({type: 'shoes'}))
    })

    $("#cam").on("click", function() {
        if (openCams == false) {
            $(".camera2-wrapper").fadeIn(200).animate({
                left: "37%"
            }, 400)
            openCams = true
        } else {
            $(".camera2-wrapper").animate({
                left: "34%"
            }, 300)
            setTimeout(() => {
                $("#head").hide()
            }, 300)
            setTimeout(() => {
                $("#shoes").hide()
            }, 500)
            setTimeout(() => {
                $(".camera2-wrapper").hide()
                $("#head").show()
                $("#shoes").show()
            }, 700)
            openCams = false
        }
    })

    $("#cam-1").on("click", function() {
        $.post("https://ZC-Character/changeCam", JSON.stringify({type: 'back'}))
    })

    $("#cam-2").on("click", function() {
        $.post("https://ZC-Character/changeCam", JSON.stringify({type: 'rotate'}))
    })

    $("#cam-3").on("click", function() {
        $.post("https://ZC-Character/changeCam", JSON.stringify({type: 'rotate2'}))
    })

    // Ropa
    var timeoutId = 0;

    $('.next').on('click ', function(e) {
        let id = $(this).data('name');
        next(id)
    });

    $('.prev').on('click ', function(e) {
        let id = $(this).data('name');
        prev(id)
    });

    $('.next').on('mousedown touchstart', function(e) {
        let id = $(this).data('name');
        e.stopPropagation(); 
        e.preventDefault(); 
        timeoutId = setInterval(function(){
            next(id)
        }, 180);
      }).bind('mouseup mouseleave touchend mousemove touchmove', function() {
        clearInterval(timeoutId);
    });

      $('.prev').on('mousedown touchstart', function(e) {
        let id = $(this).data('name');
        e.stopPropagation(); 
        e.preventDefault(); 
        timeoutId = setInterval(function(){
            prev(id)
        }, 180);
      }).bind('mouseup mouseleave touchend mousemove touchmove', function() {
        clearInterval(timeoutId);
    });

    function next(id) {
        let number = parseInt($('input[id='+id+']').val()) + 1

        if ((number) <= $('input[id='+id+']').attr('max')) {
            $('input[id='+id+']').text(number)
            $('input[id='+id+']').val(number)
            $.post("https://ZC-Character/changeValues", JSON.stringify({type: id, value:number}))

            if (corresponsal[id]) {
                $('input[id='+corresponsal[id]+']').val(0)
                $.post("https://ZC-Character/changeValues", JSON.stringify({type: corresponsal[id], value:0}))
            }
        }
    }

    const container = document.querySelectorAll(".container");
    for (let i = 0; i < container.length; i++) {
        container[i].querySelector("input").addEventListener("input", event => {
            if (corresponsal[event.target.id]) {
                $('input[id='+corresponsal[event.target.id]+']').val(0)
                $.post("https://ZC-Character/changeValues", JSON.stringify({type: corresponsal[event.target.id], value:0}))
            }
            $.post("https://ZC-Character/changeValues", JSON.stringify({type: event.target.id, value:event.target.value}))
        });
    }

    function prev(id) {  
        let number = parseInt($('input[id='+id+']').val()) - 1

        if (number >= 0) {
            $('input[id='+id+']').text(number)
            $('input[id='+id+']').val(number)
            $.post("https://ZC-Character/changeValues", JSON.stringify({type: id, value:number}))

            if (corresponsal[id]) {
                $('input[id='+corresponsal[id]+']').val(0)
                $.post("https://ZC-Character/changeValues", JSON.stringify({type: corresponsal[id], value:0}))
            }
        }
    }

    // Functions
    function closeMenu() {
        $("#category-"+selectedcategory).removeClass("selectedcategory")
        $('.main-wrapper').fadeOut(200)
        $('.flex-identity').fadeIn(200)
        $('.'+categories[selectedcategory]).fadeOut(200)
        $('.camera-wrapper').hide()
        $('#hr1').show()
        $('#hr2').show()
        $('#hr3').show()
        $('.category2-button').show()
        $('.category1-button').show()
        $('.category3-button').show()
        $('#category-2').css('top', "19.5%")
        $('#category-3').css('top', "28%")
        $(".camera2-wrapper").hide().animate({
            left: "34%"
        }, 200)
        openCams = false
        selectedSex = ''
        selectedcategory = 1;

        if (shopType) {
            $.post("https://ZC-Character/closeMenuShop", JSON.stringify({type:shopType}))
            shopType = ''
        }
        $.post("https://ZC-Character/closeMenu")
    }

    function openMenu(type) {
        if (type === 'clothes') {
            shopType = 'clothes'
            selectedcategory = 3
            $('.category2-button').hide()
            $('.category1-button').hide()
            $('.flex-identity').hide()
            $('.flex-face').hide()
            $('#hr1').hide()
            $('#hr2').hide()
            $('#hr3').hide()
            $('#category-3').css('top', "10%")
            $('.flex-style').show()
        } else if (type === 'hair') {
            shopType = 'hair'
            selectedcategory = 2
            $('.category3-button').hide()
            $('.category1-button').hide()
            $('.flex-identity').hide()
            $('.flex-style').hide()
            $('#hr1').hide()
            $('#hr2').hide()
            $('#hr3').hide()
            $('#category-2').css('top', "10%")
            $('.flex-face').show()
        } 
        $("#category-"+selectedcategory).addClass("selectedcategory")
        $('.main-wrapper').fadeIn(200)
        $('.camera-wrapper').fadeIn(200)
    }

    function updateVals(values) {
        for (let i = 0; i < Object.keys(values).length; i++) {
            $('input[id='+values[i].type+']').val(values[i].value);
            $('output[name='+values[i].type+']').val(values[i].value);

            if (values[i].type == 'eye_color' && values[i].value > 0) {
                $('input[name=eyecolor][id='+color+']').prop('checked', false);
                $('.color[id='+color+']').removeClass("selectedColor")
                color = 'eye'+(values[i].value+1)
                $('input[name=eyecolor][id='+color+']').prop('checked', true);
                $('.color[id='+color+']').addClass("selectedColor")  
            }

            if (values[i].type == 'sex') {
                if (values[i].value == 'mp_m_freemode_01') {
                    selectedSex = 'male'
                    $('#male').addClass("selectedSex")
                    $('#sex_value').text("Hombre")
                } else {
                    selectedSex = 'female'
                    $('#female').addClass("selectedSex")
                    $('#sex_value').text("Mujer")
                }
            }
        }
    }

    function updateMax(max) {
        for (let i = 0; i < Object.keys(max).length; i++) {
            $('input[id='+max[i].type+']').attr({
                "max" : max[i].value
            });
        }
    }

    function changeCategory(type) {
        $('.'+categories[selectedcategory]).fadeOut(200)
        selectedcategory = type;
        $("#category-"+selectedcategory).addClass("selectedcategory")
        setTimeout(() => {
            $('.'+categories[selectedcategory]).fadeIn(200)
        }, 200);
    }
})