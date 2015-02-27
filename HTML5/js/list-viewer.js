update_list = function(data, page, displayCount) {
  data.forEach(function(observation) {
    add_observation(observation);
  });
};

add_observation = function(data) {
  var webpage="/webapp/observer.html?imageid="+data.ImageID;
  var verified = data.IsSilene;
  var options = addSelection(verified); 
  var maxLength = 40
  var filename = data.FileName.length > maxLength? "..."+data.FileName.slice(data.FileName.length - maxLength) : data.FileName;
  var observation = '<tr><td>'+data.ImageID+'</td><td><img src="/thumbs/'+ data.FileName +'"/></td><td><a href="'+webpage+'" target="_blank" >'+filename+'</a></td><td>'+data.Date+'</td><td><select id="id_'+data.ImageID+'" onclick="updateVerification('+data.ImageID+')">'+options+'</select></td></tr>';
  $('#observationholder').append(observation);
};


/**
 * Init function
 */
$(function () {
    page = getUrlVars()['pageNumber'];  
    page = page == null ? 0 : page;
    filter = getUrlVars()['filter'];
    filter = filter == null ? '' : filter;
    amount = 25;
    console.log("started");
    getPageNavigation(page,filter);
    $.get("/cgi-bin/observations.py?rangeid="+(0+page*amount)+","+amount+"&isplant="+filter, update_list, "json");
});

function RemoveParameterFromUrl(parameter) {
      return window.location.href 
          .replace(new RegExp('[?&]' + parameter + '=[^&#]*(#.*)?$'), '$1')
              .replace(new RegExp('([?&])' + parameter + '=[^&]*&'), '$1');
}
function changeUrlByFilter(newfilter) {
    location.href = window.location.href.split('?')[0]+'?filter='+newfilter
}

function changeUrlByPage(num, filter) {
    return window.location.href.split('?')[0]+'?pageNumber='+num+'&filter='+filter
}

function getPageNavigation(page, filter) {
    num = parseInt(page);
    previous = page < 1 ? '' : '<b><a href="'+changeUrlByPage(num-1,filter)+'">previous</a></b> '
    next = '<b><a href="'+changeUrlByPage(num+1,filter)+'">next</a></b>'
    html = previous + next
    $('#pages').append(html);
}
