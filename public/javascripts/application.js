var refresh_timer;
function refresh() {
	$.ajax({ url: "/refresh", dataType: "script" });
	refresh_timer = setTimeout(refresh, 10000);
}

$(function(){
  var type_timer;
  $("#search_form").keyup(function(){
    var search = $(this).val();
    clearTimeout(type_timer);
    type_timer = setTimeout(function(){
      $.ajax({ url: "/search", dataType: "script", data: "q="+search });
    }, 500);
  });
	
	refresh_timer = setTimeout(refresh, 10000);
});