$(document).ready(function() {
    function clamp(n, min, max) {
      return Math.max(min, Math.min(max, n));
    };

    $("body").hide()

    window.addEventListener("message", function(event) {
      if ( event.data.action == 'sound' ) {
        if ( event.data.putSound == true ) {
          audio = new Audio('https://cdn.discordapp.com/attachments/662091435226431508/842087478428041266/BMW_Chime_-_One_Ring_1.mp3');
          audio.volume = 0.05;
          audio.play(); 
        }
        if ( event.data.sound == 1 ) {
          audio = new Audio('https://cdn.discordapp.com/attachments/662091435226431508/842092286312841306/seatbelt-buckle.ogg');
          audio.volume = 0.05;
          audio.play(); 
        }
        else if ( event.data.sound == 0 ) {
          audio = new Audio('https://cdn.discordapp.com/attachments/662091435226431508/842092336158867496/seatbelt-unbuckle.ogg');
          audio.volume = 0.05;
          audio.play(); 
        }

        if (!event.data.seatbelt) {
          $(".seatbelt").css("opacity", "1.0");
          $(".seatbelt").attr("src", 'Assets/Cinturon.png');
          $(".seatbelt").css("animation", "blink 1000ms infinite");
        } else {
          $(".seatbelt").css("opacity", "0");
          $(".seatbelt").attr("src", '');
          $(".seatbelt").css("animation", "");
        }
      }

      if (event.data.action == 'vehicle') {
        let data = event.data.data;
        if (data.show) {
          $("body").fadeIn(200)
        } else {
          $("body").fadeOut(200)
        }

          drawProgress(data.rev)
            if (data.speed <= 9) {
                $(".main-text").text("00"+data.speed)
            } else if (data.speed <= 99) {
                $(".main-text").text("0"+data.speed)
            } else {
                $(".main-text").text(data.speed)
            }

            if (data.fuel > 70) {
              $(".fuel").attr("src", 'Assets/Gasolina.png')
            } else if (data.fuel > 15) {
              $(".fuel").attr("src", 'Assets/GasolinaNaranja.png')
            } else {
              $(".fuel").attr("src", 'Assets/GasolinaRoja.png')
            }
            if (data.gears) {
              $(".gears").text(data.gears)
            }
            if (data.engine > 70) {
              $(".motor").attr("src", 'Assets/MotorVerde.png')
            } else if (data.engine > 15) {
              $(".motor").attr("src", 'Assets/MotorNaranja.png')
            } else {
              $(".motor").attr("src", 'Assets/MotorRojo.png')
            }
      }
    })
  
    function drawProgress(percent) {
  
      if (isNaN(percent)) {
        return;
      }
  
      percent = clamp(parseFloat(percent), 0, 1);
  
      // 360 loops back to 0, so keep it within 0 to < 360
      var angle = clamp(percent * 360, 0, 359.99999);
      var paddedRadius = 49 + 1;
      var radians = (angle * Math.PI / 180);
      var x = Math.sin(radians) * paddedRadius;
      var y = Math.cos(radians) * -paddedRadius;
      var mid = (angle > 180) ? 1 : 0;
      var pathData = 'M 0 0 v -%@ A %@ %@ 1 '.replace(/%@/gi, paddedRadius) +
        mid + ' 1 ' +
        x + ' ' +
        y + ' z';
  
      var bar = document.getElementsByClassName('progress-radial-bar')[0];
      bar.setAttribute('d', pathData);
    };
  
  });