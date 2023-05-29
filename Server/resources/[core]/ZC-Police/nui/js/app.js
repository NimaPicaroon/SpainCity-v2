$(function() {
    window.addEventListener("message", function (event) {         
        if (event.data.action === 'show') {
            $("#container").fadeIn(500)
        } else if (event.data.action === 'hide') {
            $("#container").fadeOut(500)
        } else if (event.data.action === 'update') {
            let plate = event.data.info.plate
            let model = event.data.info.model
            let speed = event.data.info.speed

            $("#plate-text").html(`<span style='color: rgb(0, 234, 255)'>Matrícula:</span> ${plate}`)
            $("#model-text").html(`<span style='color: rgb(0, 234, 255)'>Modelo:</span> ${model}`)
            $("#speed-text").html(`<span style='color: rgb(0, 234, 255)'>Velocidad:</span> ${speed}km/h`)
        }
    })
})