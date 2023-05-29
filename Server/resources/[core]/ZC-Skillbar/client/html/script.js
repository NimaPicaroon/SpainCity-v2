const background = document.querySelector('#skillbar')
const check = document.querySelector('#check')
const bar = document.querySelector('#bar')

let canCheck = false
let currentId = 0
let sound = new Howl({
    src: ['./sound.ogg'],
    volume: 0.2
});
let soundError = new Howl({
    src: ['./error.ogg'],
    volume: 0.2
});
let soundCorrect = new Howl({
    src: ['./correct.ogg'],
    volume: 0.2
});

window.addEventListener('message', (e) => {
    let msg = e.data
    if (msg.type == 'open') {
        let skillPos = ((Math.random() * (90 - 15)) - msg.size)
        skillPos = skillPos < 0 ? 0 : skillPos
        check.style.width   = msg.size + '%'
        check.style.marginRight = skillPos + '%'     
        StartSkillbar(skillPos, msg.time, msg.size)
    } else if (msg.type == 'close') {
        StopSkillbar()
    } else if (msg.type == 'sound') {
        soundCorrect.play();
    }
})

window.addEventListener('keydown', (e) => {
    if (e.key.toLowerCase() === 'e') {
        if (canCheck) {
            $.post('https://ZC-Skillbar/ZC-Skillbar:checkButton', JSON.stringify({ success: true }));
        } else {
            $.post('https://ZC-Skillbar/ZC-Skillbar:checkButton', JSON.stringify({ success: false }));
            soundError.play();
        }
        StopSkillbar()
    }
})


function StartSkillbar(skillPos, time, size) {
    if (currentId !== 0) {
        return
    }
    sound.play();
    background.style.opacity = 100 + '%'
    
    let barWidth = 0;
    currentId = setInterval(() => {
       if ( barWidth >= 100) {
            $.post('https://ZC-Skillbar/ZC-Skillbar:checkFailed');
            soundError.play();
            StopSkillbar()
            return
        } else {
            if (barWidth >= 100 - (skillPos + size) && barWidth <= 100 - (skillPos)){
                canCheck = true
            } else {
                if (canCheck) {
                    canCheck = false;
                }
            }
            barWidth++;
            bar.style.width = barWidth + '%';
        }
    }, (time / 100))
}


function StopSkillbar() {
    if (currentId !== 0) {
        clearInterval(currentId);
        currentId = 0;
        canCheck = false;
        bar.style.width = '0%';
        background.style.opacity = 0 + '%';
        $.post('https://ZC-Skillbar/ZC-Skillbar:closeSkillbar');
        return
    }
}