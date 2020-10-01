jQuery.highlightStars = function(starNumber){
  for(let n = 1; n <= starNumber ; n++){
     $('#star-' + n.toString()).html('<i class="fa fa-star"></i>')
  }
  for(let n = starNumber + 1; n <= 5 ; n++){
     $('#star-' + n.toString()).html('<i class="far fa-star"></i>')
  }
};
