let played_sound = false

window.addEventListener('message', function(event) {
	var sound = new Audio('sound.mp3');
	sound.volume = 0.08;

	if (event.data.action == 'open') {
		id = event.data.id
		message = event.data.message;

		$('.main-flex').css('left', '');
		$('.main-flex').css('right', '1%');
		$(".main-flex").append(`
			<div class="main showright" id="${id}">
				<span id="message">${message}</span>
			</div>
		`)
  
		if (played_sound == false) {
			sound.play();
			played_sound = true;
		}

	} else if (event.data.action == 'close') {
		if ($('#'+event.data.id)) {
			$('#'+event.data.id).removeClass('showright');
			$('#'+event.data.id).addClass('hideright');
			$('#'+event.data.id).remove();
		}
	}

	played_sound = false;
})