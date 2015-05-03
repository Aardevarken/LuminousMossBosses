function retrain_bag_of_words() {
    $.post('_retrain_bag_of_words', {
    },function(data){flash = data.flash}, 'json');
}
function retrain_general() {
    $.post('_retrain_bag_of_words', {
    },function(data){flash = data.flash}, 'json');
}
