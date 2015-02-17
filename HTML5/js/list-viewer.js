update_list = function(data) {
  data.forEach(function(observation) {
    add_observation(observation);
  });
};

add_observation = function(data) {
  var webpage="/webapp/observer.html?imageid="+data.ImageID;
  var verified = data.IsSilene;
  var options = addSelectOption("N/A", "null", verified == null ? "selected" : "");
  options += addSelectOption("Not Silene", "false", verified == false ? "selected" : "");
  options += addSelectOption("Silene", "true", verified == true ? "selected" : "");
  var observation = '<tr><td>'+data.ImageID+'</td><td><img src="/thumbs/'+ data.FileName +'"/></td><td><a href="'+webpage+'" target="_blank" >'+data.FileName+'</a></td><td>'+data.Date+'</td><td><select id="id_'+data.ImageID+'" onclick="update('+data.ImageID+')">'+options+'</select></td></tr>';
  $('#observationholder').append(observation);
};

function addSelectOption(option, value, selected) {
    return '<option value="'+value+'" '+selected+' >'+option+'</option>'
}

/**
 * Init function
 */
$(function () {
  console.log("started");
  $.get("/cgi-bin/observations.py", update_list, "json");
});

function update(id) {
    console.log(id);
    var results = $("#id_"+id+" :selected").val()
    console.log(results);
    $.post("/cgi-bin/sponsor_verify.py?issilene="+results+"&obsid="+id);
}
