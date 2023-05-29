PEDS = {}

$('body').hide('slow')

window.addEventListener('message', (event) => {
	let data = event.data
    if (data.action == 'showPeds') {
        data.peds.map(e => {
            !PEDS[e.ped] ? new Ped({ped: e.ped, type : e.type, name : e.label}) : console.log('ped exist')
        })   
        $('body').show('slow')     
    }
})

$('#Home').on('click', () => {
    $('body').hide('slow')
    $.post('https://K-Peds/close',JSON.stringify({}))
})

$('#default_ped').on('click', () => {
    $('body').hide('slow')
    $.post('https://K-Peds/default_ped',JSON.stringify({}))
})