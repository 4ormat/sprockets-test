if(location.pathname == '/jobs/online-portfolio-design'){
  $(function() {
  	// only support modern browsers and not on screens smaller than 855px (mobile targetted, this is done by hiding the #fluid element with a media query)
  	if (!($.browser.msie && parseInt($.browser.version, 10) < 9) || $('#fluid').css('display') == 'block') {

  		// setup fluid field and ascii display
  		var field = $('#fluid')[0],
  				ff = new FluidField(),
  				fdAscii = new FluidDisplayASCII(ff);

  		fdAscii.bindElement(field);

  		calcRes(ff, field); // initial resolution calc

  		ff.setIterations(5);
  		fdAscii.Config.density = 200;
  		fdAscii.Animation.start();

  		// recalculate resolution on window resize
  		$(window).resize(function() {
  			calcRes(ff, field);
  		});
  	}
  });

  // helper: calculate resolution
  function calcRes(ff, elem) {
  	var charSize = (function() {
  		var temp = $(elem).clone().text('M').hide().appendTo('body'),
  				dimensions = {
  			height: temp.css('line-height').replace('px', ''),
  			width: temp.width()
  		};

  		temp.remove();

  		return dimensions;
  	})();

  	ff.setResolution(Math.round($(window).height() / charSize.height), Math.round($(window).width() / charSize.width));
  };
}