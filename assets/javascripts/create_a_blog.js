// jquery mousewheel
;(function(e){if(typeof define==="function"&&define.amd){define(["jquery"],e)}else if(typeof exports==="object"){module.exports=e}else{e(jQuery)}})(function(e){function a(t){var n=t||window.event,o=r.call(arguments,1),u=0,a=0,c=0,h=0;t=e.event.fix(n);t.type="mousewheel";if("detail"in n){c=n.detail*-1}if("wheelDelta"in n){c=n.wheelDelta}if("wheelDeltaY"in n){c=n.wheelDeltaY}if("wheelDeltaX"in n){a=n.wheelDeltaX*-1}if("axis"in n&&n.axis===n.HORIZONTAL_AXIS){a=c*-1;c=0}u=c===0?a:c;if("deltaY"in n){c=n.deltaY*-1;u=c}if("deltaX"in n){a=n.deltaX;if(c===0){u=a*-1}}if(c===0&&a===0){return}if(n.deltaMode===1){var p=e.data(this,"mousewheel-line-height");u*=p;c*=p;a*=p}else if(n.deltaMode===2){var d=e.data(this,"mousewheel-page-height");u*=d;c*=d;a*=d}h=Math.max(Math.abs(c),Math.abs(a));if(!s||h<s){s=h;if(l(n,h)){s/=40}}if(l(n,h)){u/=40;a/=40;c/=40}u=Math[u>=1?"floor":"ceil"](u/s);a=Math[a>=1?"floor":"ceil"](a/s);c=Math[c>=1?"floor":"ceil"](c/s);t.deltaX=a;t.deltaY=c;t.deltaFactor=s;t.deltaMode=0;o.unshift(t,u,a,c);if(i){clearTimeout(i)}i=setTimeout(f,200);return(e.event.dispatch||e.event.handle).apply(this,o)}function f(){s=null}function l(e,t){return u.settings.adjustOldDeltas&&e.type==="mousewheel"&&t%120===0}var t=["wheel","mousewheel","DOMMouseScroll","MozMousePixelScroll"],n="onwheel"in document||document.documentMode>=9?["wheel"]:["mousewheel","DomMouseScroll","MozMousePixelScroll"],r=Array.prototype.slice,i,s;if(e.event.fixHooks){for(var o=t.length;o;){e.event.fixHooks[t[--o]]=e.event.mouseHooks}}var u=e.event.special.mousewheel={version:"3.1.9",setup:function(){if(this.addEventListener){for(var t=n.length;t;){this.addEventListener(n[--t],a,false)}}else{this.onmousewheel=a}e.data(this,"mousewheel-line-height",u.getLineHeight(this));e.data(this,"mousewheel-page-height",u.getPageHeight(this))},teardown:function(){if(this.removeEventListener){for(var e=n.length;e;){this.removeEventListener(n[--e],a,false)}}else{this.onmousewheel=null}},getLineHeight:function(t){return parseInt(e(t)["offsetParent"in e.fn?"offsetParent":"parent"]().css("fontSize"),10)},getPageHeight:function(t){return e(t).height()},settings:{adjustOldDeltas:true}};e.fn.extend({mousewheel:function(e){return e?this.bind("mousewheel",e):this.trigger("mousewheel")},unmousewheel:function(e){return this.unbind("mousewheel",e)}})});
// Date.now polyfill
Date.now = Date.now || function() { return +new Date; };

/*!
 * jQuery Scrollstop Plugin v1.1.0
 * https://github.com/ssorallen/jquery-scrollstop
 */
;(function(e){var t=e.event.dispatch||e.event.handle;var n=e.event.special,r="D"+ +(new Date),i="D"+(+(new Date)+1);n.scrollstart={setup:function(i){var s=e.extend({latency:n.scrollstop.latency},i);var o,u=function(e){var n=this,r=arguments;if(o){clearTimeout(o)}else{e.type="scrollstart";t.apply(n,r)}o=setTimeout(function(){o=null},s.latency)};e(this).bind("scroll",u).data(r,u)},teardown:function(){e(this).unbind("scroll",e(this).data(r))}};n.scrollstop={latency:500,setup:function(r){var s=e.extend({latency:n.scrollstop.latency},r);var o,u=function(e){var n=this,r=arguments;if(o){clearTimeout(o)}o=setTimeout(function(){o=null;e.type="scrollstop";t.apply(n,r)},s.latency)};e(this).bind("scroll",u).data(i,u)},teardown:function(){e(this).unbind("scroll",e(this).data(i))}}})(jQuery);

(function($) {

	// swap no-js out with js
	document.documentElement.className=document.documentElement.className.replace(/\bno-js\b/,'') + 'js';

	$(document).ready(function() {

		var $win = $(window),
			$nav = $('nav'),
			$sections = $('section,footer'),			// list of all sections
			$features = $('.features'),				// list of feature sections
			$videos = $features.find('video'),		// list of videos
			$lastVideo, $currVideo,					// cached vars for the scrolling function

			start = $sections.eq(1).offset().top,
			end = $sections.eq($sections.size() - 3).offset().top,

			astart = $sections.index($sections.filter('.blank').first()),
			aend = $sections.index($sections.filter('.blank').last()),

			isMobile = (/iPhone|iPod|iPad|Android|BlackBerry/).test(navigator.userAgent),

			active = -1,				// current index
			lastActive = -1,			// last index
			locked = false,			// whether or not we're currently locked
			triggered = false,		// whether or not the scroll transition has been triggered already (for disabling inertia scrolling)
			threshold = 4,			// threshold to scroll before slide change
			scrollTimer = null, // the settimeout timer
			minScrollDistance = 80,	// the amount that the user needs to scroll by to go to next item
			scrollDistance = 0, // the scroll amount within the scroll timeout
			duration = 600,			// transition duration
			scroll,id,pos,			// cached vars for the scrolling function
			top,bottom,				// cached vars for the scrolling function

			// support vars
			supportsSVG = !!document.createElementNS && !!document.createElementNS('http://www.w3.org/2000/svg', 'svg').createSVGRect,
			supportsVideo = !!document.createElement('video').canPlayType;




		if(!isMobile) $win.on('mousewheel', windowMouseWheel);
		$win.on('resize', throttle(resize,50));
		$win.on('scroll resize', throttle(windowScroll,50));

		$('body').on('keydown', keyboardPress);
		$nav.find('a').on('click', navClick);
		$('.js_learn_more').on('click', function() {
			if (isMobile) {
				$('html, body').animate({ scrollTop: $(window).height() })
				return false;
			}
			next();
			return false; // dont follow link
		});

		windowScroll(null);
		resize();

		// swap out svg for png if the browser doesn't support svg
		if(!supportsSVG) {
			var src = $('.logo img').attr('src');
			$('.logo img').attr('src', src.replace('.svg','.png'));
		}




		// event handlers

		// reacts to users trying to scroll
		function windowMouseWheel(e) {
			// if they're at the ends, allow scrolling
			// (this accomodates elastic scrolling on OS X)
			if(locked) return false;

			// if at top of page, dont try triggering any animations (theres nowhere to go)
			// but also make sure triggered is off, otherwise we block scrolling
			if ($(document).scrollTop() == 0 && e.deltaY > 0) {
				triggered = false;
				return true;
			}

			function resetScrollDistance() {
				// reset things:
				scrollDistance = 0;
				scrollTimer = null;
			}

			// reset the timeout on every scroll event.
			// Meaning, it only gets run once you stop scrolling for 600ms
			if(scrollTimer) clearTimeout(scrollTimer)
			scrollTimer = setTimeout(resetScrollDistance, 600);
			// only add for scrolls bigger than 1 in magnitude, and scroll isnt triggered by animation to next item
			if (Math.abs(e.deltaY) > 1 && !triggered) scrollDistance = scrollDistance + e.deltaY

			if(scrollDistance > minScrollDistance) {
				triggered = true;
				resetScrollDistance();
				return prev();
			} else if (scrollDistance < -minScrollDistance) {
				triggered = true;
				resetScrollDistance();
				return next();	
			}

			// if nothing else was triggered, return false
			return false;
		}

		// reacts to the document scrolling in any fashion
		function windowScroll(e) {

			scroll = $win.scrollTop();

			updateNavigation();

			if(!isMobile) $features.toggleClass('fixed', (scroll >= start && scroll <= end));
			if(!isMobile) $features.toggleClass('top', scroll < start);
		}
		
		function windowScrollEnd(e) {
			// if we've triggered the transition but we're now well below
			// the threshold, we can release things to be transitioned again
			if(triggered) triggered = false;
		}

		function resize() {
			start = $sections.eq(1).offset().top;
			end = $sections.eq($sections.size() - 3).offset().top;
		}

		function keyboardPress(e) {
			switch(e.keyCode) {
				case 38: // arrow up
				case 33: // page up
					e.preventDefault();
					prev();
					break;

				case 34: // page down
				case 40: // down arrow
					e.preventDefault();
					next();
					break;
			}
		}

		function navClick(e) {
			e.preventDefault();
			scrollTo($sections.filter('[data-id="'+$(this).attr('data-anchor')+'"]').first().offset().top, true);
		}





		// helper functions

		function next() {
			if(active < $sections.size() - 2) {
				active++;
				scrollTo($sections.eq(active).offset().top);
			} else if(($('footer').offset().top + $('footer').outerHeight()) > (scroll + $win.height())) {
				// next on the last section?
				// if the footer isn't all the way in, allow scroll to it
				active++;
				scrollTo($(document).height()-$win.height());
			} else {
				// otherwise, at bottom so allow scrolling
				triggered = false;
			}
		}

		function prev() {
			if(active > 0) {
				active--;
				scrollTo($sections.eq(active).offset().top);
			}
		}

		function scrollTo(dist) {
			// if we're already locked, don't let them trigger again
			// tell other functions that we're hijacking the scroll
			if(locked) return false;
			locked = true;

			$("html,body").stop(true, true).animate({scrollTop:dist}, duration, "easeOutExpo");
			// release scroll after scroll end
			$(window).on('scrollstop', windowScrollEnd);
			// releasing scroll is separated to allow for us to release it 100ms
			// before completion, which feels more responsive
			setTimeout(function() {
				// release scroll control
				locked = false;
			}, duration - 100)
		}

		function updateNavigation() {

			lastActive = active;
			top = scroll - ($win.height()/2);
			bottom = scroll + ($win.height()/2);

			$sections.each(function(index) {
				id = $(this).attr('data-id');
				pos = $(this).offset().top;

				// if the slide is in view
				if(pos > top && pos < bottom) {

					// If we haven't changed sections, don't bother running what's below
					if(index == lastActive) return false;

					// update the navigation
					$nav.find('.active').removeClass('active');
					$nav.find('[data-anchor="' + id + '"]').addClass('active');

					// set the active section (unless it's the footer)
					if(active !== $sections.size() - 1) active = index;

					// update the features section
					if(!isMobile) updateFeatures();

					return false;
				}
			});	
		}

		function updateFeatures() {
			if(active >= astart && active <= aend) {
				// pause and reset the video that we're moving away from
				$lastVideo = $videos.filter('[data-link="' + $features.attr('data-active') + '"]');
				$currVideo = $videos.filter('[data-link="' + id + '"]');
				if(supportsVideo && $lastVideo.length && $currVideo.length) {
					if($lastVideo[0].readyState == 4) {
						$lastVideo[0].pause();
						$lastVideo[0].currentTime = 0;
					}
					$currVideo[0].play();
				}
				// set the new active attribute
				$features.attr('data-active',id);
			}
		}

		// Taken from http://documentcloud.github.io/underscore/docs/underscore.html
		function throttle(func, wait, options) {
			var context, args, result;
			var timeout = null;
			var previous = 0;
			options || (options = {});
			var later = function() {
				previous = options.leading === false ? 0 : Date.now();
				timeout = null;
				result = func.apply(context, args);
				context = args = null;
			};
			return function() {
				var now = Date.now();
				if (!previous && options.leading === false) previous = now;
				var remaining = wait - (now - previous);
				context = this;
				args = arguments;
				if (remaining <= 0) {
					clearTimeout(timeout);
					timeout = null;
					previous = now;
					result = func.apply(context, args);
					context = args = null;
				} else if (!timeout && options.trailing !== false) {
					timeout = setTimeout(later, remaining);
				}
				return result;
			};
		}

	});

	$.easing['jswing'] = $.easing['swing'];

	$.extend($.easing,
	{
		def: 'easeOutQuad',
		swing: function (x, t, b, c, d) {
			return $.easing[$.easing.def](x, t, b, c, d);
		},
		easeInQuad: function (x, t, b, c, d) {
			return c*(t/=d)*t + b;
		},
		easeOutQuad: function (x, t, b, c, d) {
			return -c *(t/=d)*(t-2) + b;
		},
		easeOutQuint: function (x, t, b, c, d) {
			return c*((t=t/d-1)*t*t*t*t + 1) + b;
		},
		easeInExpo: function (x, t, b, c, d) {
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
		},
		easeOutExpo: function (x, t, b, c, d) {
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		},
		easeInOutExpo: function (x, t, b, c, d) {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
			return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
	});

})(jQuery);