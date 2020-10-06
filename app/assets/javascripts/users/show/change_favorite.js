jQuery.changeFavorite = function(){
  $(document).on('click','[id*="favorite-no-"]',function(){
    let starHtml = $(this).find("button");
    let starClass = starHtml.attr('class')
    if(starClass == undefined || !starClass.match(/favorited/)  ){
      starHtml.addClass('favorited')
    } else {
      starHtml.removeClass('favorited')
    }
  });
};
