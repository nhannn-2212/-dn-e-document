$('.reply').one('click', function(e){
  let id =$(this).attr("data-commentID");
  $("#reply_comment"+id).show();
})
