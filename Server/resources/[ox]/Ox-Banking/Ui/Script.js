$(function () {
    let inOptions = false;
    let deposit = false;
    let withdraw = false;
    let transfer = false;
    let account = {};
    let resourceData = null;
    let shopType = null;
    let shop = false;

    window.addEventListener("message", function (event) {  
        const open = event.data.open
        const openShop = event.data.openShop

        if (open) {
            account = {pin: open.pin, accounts: open.accounts, owner: open.owner, credit: open.credit}

            if (account.pin != 0 && account.pin != null && account.pin != undefined) {
                $(".enter-wrapper").slideDown(500)
                setTimeout(() => {
                    $('.enter-wrapper').show()
                }, 500);
            } else {
                $(".newAccount-wrapper").slideDown(500)
                setTimeout(() => {
                    $('.newAccount-wrapper').show()
                }, 500);
            }
        }

        if (openShop) {
            if (openShop.pin != 0 && openShop.pin != null && openShop.pin != undefined) {
                resourceData = event.data.resource
                shopType = event.data.shoptype
                account = {pin: openShop.pin, owner: openShop.owner}
                shop = true
                $(".enter-wrapper").slideDown(500)
                setTimeout(() => {
                    $('.enter-wrapper').show()
                }, 500);
            } else {
                $.post('https://Ox-Banking/notify', JSON.stringify({close: true, msg: "Debes crear tu PIN en un cajero"}));
            }
        }
    })

    $(".enter-button").on("click", function() {
        if (account.pin != 0 && account.pin != null && account.pin != undefined) {
            if (shop == false) {
                if($(".pin").val() == account.pin) {
                    $(".enter-wrapper").fadeOut(500)
                    $(".main-wrapper").fadeIn(500)
                    $(".credit-card").text(account.credit)
                    $(".money").text(account.accounts['bank']+'$')
                } else {
                    $(".enter-wrapper").effect( "shake", { times: 2}, 1000 );
                    $.post('https://Ox-Banking/notify', JSON.stringify({msg: "PIN ~r~incorrecto"}));
                }
            } else {
                if($(".pin").val() == account.pin) {
                    $(".enter-wrapper").fadeOut(500)
                    $.post('https://'+ resourceData +'/correctPin', JSON.stringify({ typeShop: shopType }));
                    $.post('https://'+ resourceData +'/correctPin2', JSON.stringify({ typeShop: shopType }));
                    $.post('https://'+ resourceData +'/correctPin3', JSON.stringify({ typeShop: shopType }));
                    $.post('https://'+ resourceData +'/correctPin4', JSON.stringify({ typeShop: shopType }));
                    $.post('https://'+ resourceData +'/correctPin5', JSON.stringify({ typeShop: shopType }));
                    close()
                } else {
                    $(".enter-wrapper").effect( "shake", { times: 2}, 1000 );
                    $.post('https://Ox-Banking/notify', JSON.stringify({msg: "PIN ~r~incorrecto"}));
                }
            }
        } else {
            let val = $(".createPin").val()
            if (val.toString().length == 4 && val.toString() !== 0000) {
                console.log(val)
                $.post('https://Ox-Banking/createPin', JSON.stringify({value: val}));
                $(".newAccount-wrapper").fadeOut(500)
                $(".main-wrapper").fadeIn(500)
                $(".credit-card").text(account.credit)
                $(".money").text(account.accounts['bank']+'$')
            } else {
                $(".newAccount-wrapper").effect( "shake", { times: 2}, 1000 );
                $.post('https://Ox-Banking/notify', JSON.stringify({msg: "El PIN debe contener ~r~4 números~w~ o debe ser distinto de 0000"}));
            }
        }
    })

    $(".options-button").on("click", function() {
        if (inOptions == false) {
            inOptions = true
            $(".main-wrapper").fadeOut(500)
            $(".options-wrapper").fadeIn(500)
        }
    })

    $(".home-button").on("click", function() {
        if (inOptions == true) {
            inOptions = false
            $(".options-wrapper").fadeOut(500)
            $(".main-wrapper").fadeIn(500)
        }
    })

    $(".deposit-button").on("click", function() {
        if (deposit == false) {
            deposit = true
            $(".deposit-button").fadeOut(500)
            $(".deposit-input").fadeIn(500)
            $(".deposit-send").fadeIn(500)
        }

        if (withdraw == true) {
            withdraw = false
            $(".withdraw-button").fadeIn(500)
            $(".withdraw-input").fadeOut(500)
            $(".withdraw-send").fadeOut(500)
        }

        if (transfer == true) {
            transfer = false
            $(".transfer-button").fadeIn(500)
            $(".transfer-input").fadeOut(500)
            $(".transfer-iban-input").fadeOut(500)
            $(".transfer-send").fadeOut(500)
        }
    })

    $(".withdraw-button").on("click", function() {
        if (withdraw == false) {
            withdraw = true
            $(".withdraw-button").fadeOut(500)
            $(".withdraw-input").fadeIn(500)
            $(".withdraw-send").fadeIn(500)
        }

        if (deposit == true) {
            deposit = false
            $(".deposit-button").fadeIn(500)
            $(".deposit-input").fadeOut(500)
            $(".deposit-send").fadeOut(500)
        }

        if (transfer == true) {
            transfer = false
            $(".transfer-button").fadeIn(500)
            $(".transfer-input").fadeOut(500)
            $(".transfer-iban-input").fadeOut(500)
            $(".transfer-send").fadeOut(500)
        }
    })

    $(".transfer-button").on("click", function() {
        if (transfer == false) {
            transfer = true
            $(".transfer-button").fadeOut(500)
            $(".transfer-input").fadeIn(500)
            $(".transfer-iban-input").fadeIn(500)
            $(".transfer-send").fadeIn(500)
        }

        if (deposit == true) {
            deposit = false
            $(".deposit-button").fadeIn(500)
            $(".deposit-input").fadeOut(500)
            $(".deposit-send").fadeOut(500)
        }

        if (withdraw == true) {
            withdraw = false
            $(".withdraw-button").fadeIn(500)
            $(".withdraw-input").fadeOut(500)
            $(".withdraw-send").fadeOut(500)
        }
    })

    $(".deposit-send").on("click", function() {
        let val = $(".deposit-input").val()
        if (val > 0 && val <= account.accounts['money']) {
            $.post('https://Ox-Banking/deposit', JSON.stringify({value: val}));
            close()
        } else {
            $(".main-wrapper").effect( "shake", { times: 2}, 1000 );
            $.post('https://Ox-Banking/notify', JSON.stringify({msg: "Cantidad ~r~inválida"}));
        }
    })

    $(".withdraw-send").on("click", function() {
        let val = $(".withdraw-input").val()
        if (val > 0 && val <= account.accounts['bank']) {
            $.post('https://Ox-Banking/withdraw', JSON.stringify({value: val}));
            close()
        } else {
            $(".main-wrapper").effect( "shake", { times: 2}, 1000 );
            $.post('https://Ox-Banking/notify', JSON.stringify({msg: "Cantidad ~r~inválida"}));
        }
    })

    $(".transfer-send").on("click", function() {
        let iban = $(".transfer-iban-input").val()
        let val = $(".transfer-input").val()
        if (val > 0 && val <= account.accounts['bank'] && iban != '') {
            $.post('https://Ox-Banking/transfer', JSON.stringify({iban:iban, value: val}));
        } else {
            $(".main-wrapper").effect( "shake", { times: 2}, 1000 );
            $.post('https://Ox-Banking/notify', JSON.stringify({msg: "Cantidad ~r~inválida"}));
        }
    })

    $(".changepin-button").on("click", function() {
        let val = $(".changepin").val()
        if (val != '') {
            $.post('https://Ox-Banking/changePin', JSON.stringify({value: val}));
            close()
        }
    })

    $(".newcredit-button").on("click", function() {
        $.post('https://Ox-Banking/newCredit', JSON.stringify({}));
        close()
    })

    window.addEventListener("keydown", function (data) {  
        if (data.which == 27) {
            if (shop) {
                $.post('https://'+ resourceData +'/closePin', JSON.stringify({}));
            }
            close()
        };
    });

    function close() {
        shop = false
        deposit = false
        $(".deposit-button").fadeIn(500)
        $(".deposit-input").fadeOut(500)
        $(".deposit-send").fadeOut(500)
        withdraw = false
        $(".withdraw-button").fadeIn(500)
        $(".withdraw-input").fadeOut(500)
        $(".withdraw-send").fadeOut(500)
        transfer = false
        $(".transfer-button").fadeIn(500)
        $(".transfer-input").fadeOut(500)
        $(".transfer-iban-input").fadeOut(500)
        $(".transfer-send").fadeOut(500)
        $(".main-wrapper").fadeOut(500)
        inOptions = false
        $(".options-wrapper").fadeOut(500)
        $(".enter-wrapper").fadeOut(500)
        $(".newAccount-wrapper").fadeOut(500)
        $(".createPin").val("")
        $(".pin").val("")
        $(".changepin").val("")
        $.post('https://Ox-Banking/close', JSON.stringify({}));
    }
})