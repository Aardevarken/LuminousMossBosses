
function retrain_bag_of_words() {
    document.getElementById("bag_of_words").disabled = true
    document.getElementById("test_status").innerHTML = "Test is currently running"
    $.post('_retrain_bag_of_words', {
    },function(data){flash = data.flash}, 'json');
}
