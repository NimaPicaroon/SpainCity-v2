console.log("App started - Wave 2022");
var audio = new Audio('https://cdn.discordapp.com/attachments/469421041928634368/962671288307056650/alarm.mp3');

$(document).ready(function(){
    document.getElementById("main").style.display = "none";
});

window.addEventListener('message', (event) => {
    if (event.data.type === 'show') {
        document.getElementById("main").style.display = "flex";
    }
    if (event.data.type === 'hide') {
        document.getElementById("main").style.display = "none";
    }
    if (event.data.type === 'alarm') {
        audio.play();
    }
    if (event.data.type === 'offalarm') {
        audio.pause();
    }
    if (event.data.ruido) {
        document.getElementById("bar").style.height = event.data.ruido + "%";
    }
});