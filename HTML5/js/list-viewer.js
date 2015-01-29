update_list = function(data) {
  data.forEach(function(observation) {
    add_observation(observation);
  });
};

add_observation = function(data) {
  var observation = '<div class="col-md-2"><img src="/images/'+ data.FileName +'" /></div>';
  $('#observationholder').append(observation);
};

/**
 * Init function
 */
$(function () {
  console.log("started");
  $.get("http://localhost:5000/observations", update_list, "json");
});
