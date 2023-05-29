
$(function() {
	var audioPlayer = null;

    window.addEventListener('message', function(event) {
    	
		if (event.data.type == "changeLvl"){
			$NivelText = "Nivel  " + event.data.level;
			$('#BarText').text($NivelText);
			$('#ExpText').text(event.data.points);
			$('#Interna').css('width',Math.round(event.data.percent).toString() + '%')
		}else if(event.data.type == "playSound"){
			if (audioPlayer != null) {
	            audioPlayer.pause();
	          }

	          audioPlayer = new Audio("./sound/" + event.data.mp3 + ".ogg");
	          audioPlayer.volume = 0.3;
	          audioPlayer.play();
		}else if(event.data.type == "off"){
			$('#main_list').css("display","none");
			$('.box').css("display","none");
		}else if(event.data.type == "on"){
			$('#main_list').css("display","block");
			$('.box').css("display","block");
		}
	});
});


