window.addEventListener('message', function(event) {
    let data = event.data;

    if(data.type === "openUi") {
        $(".main-container").fadeIn(600)
    } else if(data.type === "hideUi") {
        $(".main-container").fadeOut(600)
    }

    if(data.type === "Available") {
        $(".timer").html("AVAILABLE")
    } else if(data.type === "Tomorrow") {
        $(".timer").html("Tomorrow")
    }

    if (data.which == 27) {
        $(".main-container").fadeOut(600)
        $.post('http://vd_dailyReward/exit', JSON.stringify({}));
        return
    }
})

function pressButton() {
    $.post('http://vd_dailyReward/givereward', JSON.stringify({}));
    $(".main-container").fadeOut(600)
}