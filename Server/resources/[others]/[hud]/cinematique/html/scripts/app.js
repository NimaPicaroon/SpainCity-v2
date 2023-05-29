$(document).ready(function(){ 
	window.addEventListener('message', function(event){
	  	var item = event.data;

	  	if (item.openCinema === true) {
			$('html').delay(100).fadeIn( 300 );
		} else if (item.openCinema === false) {
			$('html').fadeOut( 300 );
		}
	});
});