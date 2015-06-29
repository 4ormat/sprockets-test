function css_browser_selector(u){var ua = u.toLowerCase(),is=function(t){return ua.indexOf(t)>-1;},g='gecko',w='webkit',s='safari',o='opera',h=document.getElementsByTagName('html')[0],b=[(!(/opera|webtv/i.test(ua))&&/msie\s(\d)/.test(ua))?('ie ie'+RegExp.$1):is('firefox/2')?g+' ff2':is('firefox/3.5')?g+' ff3 ff3_5':is('firefox/3')?g+' ff3':is('gecko/')?g:is('opera')?o+(/version\/(\d+)/.test(ua)?' '+o+RegExp.$1:(/opera(\s|\/)(\d+)/.test(ua)?' '+o+RegExp.$2:'')):is('konqueror')?'konqueror':is('chrome')?w+' chrome':is('iron')?w+' iron':is('applewebkit/')?w+' '+s+(/version\/(\d+)/.test(ua)?' '+s+RegExp.$1:''):is('mozilla/')?g:'',is('j2me')?'mobile':is('iphone')?'iphone':is('ipod')?'ipod':is('mac')?'mac':is('darwin')?'mac':is('webtv')?'webtv':is('win')?'win':is('freebsd')?'freebsd':(is('x11')||is('linux'))?'linux':'','js']; c = b.join(' '); h.className += ' '+c; return c;}; css_browser_selector(navigator.userAgent);

var generate_uuid = function(){
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
    return v.toString(16);
  }).toUpperCase();
};

var Signup = {

	nextPage: function(e) {
		$self = $(this);
		$tab = $self.parents('.tab');
		if (typeof e !== 'undefined') e.preventDefault();

		// check if user has selected an item first...
		if($tab.find('button.disabled').length !== 0){
			return false
		}

		// update skin and gallery images
		if($tab.attr('id') == 'theme_name'){
			var theme_name = $tab.find('.browser.active').data('theme_name');
			$('.browser[data-theme_name="'+theme_name+'"]').show();
		}

		// change main nav
		$('.mainnav li').not('.closed')
			.addClass('closed')
			.next('li').removeClass('closed');

		$tab.addClass('hidden');

		window.setTimeout(function() {
			$tab.next('.tab').removeClass('hidden')
		}, 300);

		$.proxy(Signup.pageActions($tab.next().attr('rel')), this);
	},

	pageActions: function(page) {
		switch (page) {
			case 'page-done':
				var target = document.getElementById('spinner-holder');
				var spinner = new Spinner({
					lines: 13, // The number of lines to draw
					length: 5, // The length of each line
					width: 2, // The line thickness
					radius: 10, // The radius of the inner circle
					corners: 0.4, // Corner roundness (0..1)
					rotate: 0, // The rotation offset
					color: '#ccc', // #rgb or #rrggbb
					speed: 1, // Rounds per second
					trail: 60, // Afterglow percentage
					shadow: false, // Whether to render a shadow
					hwaccel: true, // Whether to use hardware acceleration
				}).spin(target);

        window.setTimeout(function() {
          Signup.post();
        }, 300);
				break;
		}
		return true;
	},

  post : function(e){
    // prevent double submit
    $('#signup_form').find('button').addClass("disabled");
    $('#setup_theme_name').val($('#theme_name .active').data('theme_name'));
    $('#setup_skin_name').val($('#theme_name .active').data('skin_name'));
    var uuid = generate_uuid();
    $('#email').val(uuid + "@example.com");
    $('#password').val(uuid);
    $('#signup_form').data('setup', true);
    $('#signup_form').submit();
  },

	selectItem: function(e) {
		e.preventDefault();
		$(this).addClass('active').siblings('a.active').removeClass('active');
		$(this).parents('.tab').find('button.disabled').removeClass('disabled').trigger('click');
	}
};

(function() {
  _kmq.push(['record', 'Viewed Signup Page', {'Signup Page':'Try', 'SignupWorkflow':'2_step_original'}]);

	// events
	$('.next_page').on('click', Signup.nextPage);
	$('#signup_form').on('submit', function(e) {
    // prevent this form from being submit by anything but post()
    if ($(this).data('setup') !== true) {
      e.preventDefault();
    }
  });

	$('.thumbnail_select').on('click', '.browser', Signup.selectItem);

  // fade in images on load
  $(".tab_container .browser img").one('load', function() {
    $(this).addClass('is_loaded');
  }).each(function() {
    // fix for if image is in browser cache, then force image load event.
    if(this.complete) $(this).load();
  });
})();
