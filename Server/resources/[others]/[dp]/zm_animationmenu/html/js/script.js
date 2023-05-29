import { createPanels, fetchNUI } from "./modules/fetch.js";
import { setDisplay } from "./modules/functions.js";

window.addEventListener('load', (e) => {
    window.addEventListener('message', e => {
        switch (e.data.action) {
            case 'panelStatus':
                if (e.data.panelStatus) {
                    setDisplay('fadeIn');
                } else {
                    setDisplay('fadeOut');
                }
            break;

            case 'findEmote':
                const panels = document.getElementsByClassName('anim');
                for (let i = 0; i < panels.length; i++) {
                    let panelEmote = panels[i].childNodes[0].lastChild.textContent.split(" ")[1];
                    if (panelEmote.toLowerCase() == e.data.name.toLowerCase()) {
                        fetchNUI('beginAnimation', {dance: JSON.parse(panels[i].getAttribute('data-dances')), stance: JSON.parse(panels[i].getAttribute('data-stance')), scene: JSON.parse(panels[i].getAttribute('data-scenarios')), expression: JSON.parse(panels[i].getAttribute('data-expressions')), plus_eighteen: JSON.parse(panels[i].getAttribute('data-plus_eighteen')), walk: JSON.parse(panels[i].getAttribute('data-walks')), prop: JSON.parse(panels[i].getAttribute('data-props')), particle: JSON.parse(panels[i].getAttribute('data-particles')), shared: JSON.parse(panels[i].getAttribute('data-shared')), animals: JSON.parse(panels[i].getAttribute('data-animals')), disableMovement: JSON.parse(panels[i].getAttribute('data-disableMovement')), disableLoop: JSON.parse(panels[i].getAttribute('data-disableLoop'))}).then((resp) => {
                            if (resp.e == 'nearby') {
                                fetchNUI('sendNotification', {type: 'info', message: 'No hay nadie cerca...'})
                            } else {
                                (resp.e)
                                ? fetchNUI('sendNotification', {type: 'success', message: 'Animación iniciada!'})
                                : fetchNUI('sendNotification', {type: 'error', message: 'No se pudo cargar la anim.!'});
                            }
                            return;
                        })
                        return;
                    }
                }
                fetchNUI('sendNotification', {type: 'info', message: 'Animacion no encontrada...'})
            break;

            default:
                console.log('Something did not load properly when sending a message')
            break;
        }
    })

    //window.localStorage.clear() // Clear everyone's storage
    const favorites = JSON.parse(localStorage.getItem('favoriteAnims'))
    if (favorites == null) {
        //console.log("NEW")
        localStorage.setItem('favoriteAnims', JSON.stringify([]))
    }

    const animOpts = JSON.parse(localStorage.getItem('animOptions'))
    if (animOpts == null) {
        //console.log("NEW")
        localStorage.setItem('animOptions', JSON.stringify([]))
    } else {
        fetchNUI('fetchStorage', animOpts)
        for (let i = 0; i < animOpts.length; i++) {
            document.getElementById(animOpts[i]).style.backgroundColor = "#FBB040";
        }
    }

    const duration = localStorage.getItem('currentDuration')
    const cancel = localStorage.getItem('currentCancel')
    const emote = localStorage.getItem('currentEmote')
    const key = localStorage.getItem('currentKey')

    if (duration) {document.getElementById('set-duration').placeholder = duration};
    if (cancel) {document.getElementById('set-cancel').placeholder = cancel};
    if (emote) {document.getElementById('set-emote').placeholder = emote};
    if (key) {document.getElementById('set-key').placeholder = key};
    fetchNUI('changeCfg', {type: 'settings', duration: duration, cancel: cancel, emote: emote, key: key})

    fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => createPanels(data))
    .catch((e) => console.log('Fetching Error: ' + e))
});