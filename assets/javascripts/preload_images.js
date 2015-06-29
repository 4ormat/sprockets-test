function preload_images(imgs) {
  $(imgs).each(function(index, value) {
     var image = new Image();
     image.src = this;
  });
}