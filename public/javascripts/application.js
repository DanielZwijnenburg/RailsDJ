$(function(){
  var type_timer;
  $("#search_form").keyup(function(){
    var search = $(this).val();
    clearTimeout(type_timer);
    type_timer = setTimeout(function(){
      $.ajax({ url: "/search", dataType: "script", data: "q="+search });
    }, 500);
  });
});