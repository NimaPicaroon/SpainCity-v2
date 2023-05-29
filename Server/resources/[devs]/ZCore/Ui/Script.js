$(function() {
    var selected;
    var spawn = false;
    
    window.addEventListener("message", function (event) {  
      const show = event.data.show
      const close = event.data.close
      const withSpawn = event.data.spawn
  
      if (show) {
        $("body").fadeIn(200)
        spawn = withSpawn;

        setTimeout(function() {
            if (!spawn) {
                $.post("https://ZCore/closeHud", JSON.stringify({}))
            } else {
                setTimeout(function() {
                    $(".Spawners").fadeIn(800)
                    loadImage().then(() => {
                        createSmokeObject();
                        smokeSwitch();
                        smokeEater();
                    });

                    setTimeout(function() {
                        $(".Spawners").fadeIn(800)
                    }, 600 );
                }, 200);
            }
            setTimeout(function() {
                $( "#button" ).removeClass( "validate" );
            }, 250 );
        }, 1000 );
      }

      if (close) {
        $("body").fadeOut(200)
        $(".Spawners").fadeOut(200)
      }
    });

    $( "#button2" ).click(function() {
        setTimeout(function() {
            $.post("https://ZCore/closeHud", JSON.stringify({spawn: selected}))
        }, 250 );
    });

    $("#paleto").on("click", function() {
        $("#paleto").css('border', "0.2vw solid white")
        if (selected) {
            $("#"+selected).css('border', "0.2vw solid #13b2e2")
        } else {
            $(".container2").fadeIn(600);
        }
        selected = 'paleto'
    })

    $("#aeropuerto").on("click", function() {
        $("#aeropuerto").css('border', "0.2vw solid white")
        if (selected) {
            $("#"+selected).css('border', "0.2vw solid #13b2e2")
        } else {
            $(".container2").fadeIn(600);
        }
        selected = 'aeropuerto'
    })

    $("#sandy").on("click", function() {
        $("#sandy").css('border', "0.2vw solid white")
        if (selected) {
            $("#"+selected).css('border', "0.2vw solid #13b2e2")
        } else {
            $(".container2").fadeIn(600);
        }
        selected = 'sandy'
    })

    $("#ayuntamiento").on("click", function() {
        $("#ayuntamiento").css('border', "0.2vw solid white")
        if (selected) {
            $("#"+selected).css('border', "0.2vw solid #13b2e2")
        } else {
            $(".container2").fadeIn(600);
        }
        selected = 'ayuntamiento'
    })

    let smokeDensity = 25;
    const imageUrl = "https://cdn.discordapp.com/attachments/662091435226431508/955933287514243072/smoke-2.png";
    const playground = document.getElementsByClassName("ag-smoke-block");
    let smokeObject;
    let smokes = [];
    const smokeLife = 10000;

    function loadImage() {
        return new Promise((resolve, reject) => {
        let Img = new Image();
        Img.src = imageUrl;
        Img.onload = resolve;
        Img.onerror = reject;
        });
    }

    function createSmokeObject() {
        smokeObject = document.createElement("div");
        smokeObject.className = "smoke";
    }

    function removeSmoke(smokeElement, delay) {
        setTimeout(function() {
        smokeElement.remove();
        }, delay + smokeLife);
    }

    /**
     * Start Stop Smoke Generator
     */
    function smokeSwitch() {
        smokeGenerator(getRandomInt(5, smokeDensity));
        smokeGeneratorTimer = setInterval(() => {
        smokeGenerator(getRandomInt(5, smokeDensity));
        }, smokeLife);
    }

    function smokeGenerator(smokeDensity) {
        let smokeClone, delay;
        for (let i = 0; i < smokeDensity; i++) {
        smokeClone = smokeObject.cloneNode();
        smokeClone.style.left = getRandomInt(-20, 100) + '%';
        delay = getRandomInt(0, smokeLife);
        smokeClone.style.animationDelay = delay + 'ms';
        smokeClone.style.animationDuration = smokeLife + 'ms';
        smokeClone.id = i;
        playground[0].appendChild(smokeClone);
        smokes.push(smokeClone)
        removeSmoke(smokeClone, delay);
        }
    }

    function smokeEater() {
        for (var index = 0; index < smokes.length; index++) {
        if(smokes[index].offsetTop < -20) {
            $(".smoke [id="+index+"]").fadeOut(500)
            setTimeout(function() {
                $(".smoke [id="+index+"]").remove();
                smokes.splice(index, 0);
            }, 500)
        }  
        }
        window.requestAnimationFrame(smokeEater);
    }

    // window.onload = () => {
    //     console.info('Page Loaded');
    //     loadImage().then(() => {
    //         console.info('Image Loaded');
    //         createSmokeObject();
    //         smokeSwitch();
    //         smokeEater();
    //     });
    // };

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
});
