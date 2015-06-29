(function(){
  var $ = this.jQuery,
      that =  null;

  this.ModalMessage = function(options) {

    // Options can take just a string or an object of values

    // Object accepts following values:
    // {
    //   target_el : $('body'),
    //   title : "My Title",
    //   html : "<p>String of html.</p>",
    //   text : "String of text.",
    //   modal_class : 'small/medium/large',
    //   prevent_close : true,
    //   enter_button : 'button',
    //   buttons : {
    //     'button' : {
    //       text : 'My Button',
    //       classes : 'class1 class2 class3',
    //       icon : 'check',
    //       action : function() {
    //         alert('callback');
    //       }
    //     },
    //     'close' : { text : 'Close' }
    //   },
    //   on_create_callback : function() {} // called after modal is appended to DOM
    //   before_close_callback : function(modal) {} // called before modal is closed (via 'X' button or modal.close_modal)
    //   after_close_callback : function(modal) {} // called after modal is closed (via 'X' button or modal.close_modal)
    // }

    // Instantiation syntax:
    // var modal = new ModalMessage({ options });

    // Notes:

    // - Accepts an object passed to target to append the modal.
    // - If html and text is passed as args the text will not show.
    // - Creating a button 'close' automatically gets the close event bound.
    // - If no buttons are created a close button will be added, if at least one
    //   button is created then close will not automatically be added.
    // - Button icons pull from ss-icon library.
    // - Buttons can be assigned functions through the action option callback.
    // - Specify 'prevent_close' as true if user shouldn't be able to close the modal.
    // - enter_button determines which button gets a click invoked when users presses enter button


    var html = '',
        modal_class = 'small',
        target_el = $('body');

    that = this;

    this.anim_speed = 300;
    this.options = options;

    if(options.modal_class) { modal_class = options.modal_class; }

    if (typeof(options) === 'string') { options = {text: options}; }

    if (options.buttons === undefined && options.prevent_close !== true) {
      options.buttons = {
        close: {
          text: 'Close',
          classes: 'btn_default'
        }
      };
    }

    // Wrapper and Overlay for popup

    html += '<div class="_4ORMAT_overlay"></div><div class="ModalMessage generated ' + modal_class + '">';

    // Body content gets inserted here. If html isn't provided we assume that
    // title and/or text is provided and populate the popup with this instead.

    if(options.title) {
      html += '<div id="modalMessage_header">';

      if(options.prevent_close !== true) {
        html += '<a href="javascript:void(0)" class="ss-icon close">close</a>';
      }

      html += '<div id="modalMessage_header_title">' + options.title + '</div>';
      html += '</div>';
    } else {
      if(options.prevent_close !== true) {
        html += '<a href="javascript:void(0)" class="ss-icon close">close</a>';
      }
    }

    html += '<div class="msg">';

    if(options.html) {
      html += options.html;
    } else if(options.text) {
      html += '<p>' + options.text + '</p>';
    }

    html += '</div>';

    // Construct buttons

    if(options.buttons) {
      html += '<p class="center">';

      // for each button add it with the classes and names

      $.each(options.buttons, function(i, v) {
        var text = '',
            classes = '';

        if(v.text) { text = v.text; }
        if(v.classes) { classes = ' ' + v.classes; }

        html += '<a href="javascript:void(0)" class="' + i + classes +'">';

        if(v.icon) {
          html += '<span class="ss-icon">' + v.icon + '</span> ';
        }

        html += text + '</a>';
      });

      html += '</p>';
    }

    html += '</div>';

    // Append html to dom.

    if(typeof(options.target_el) === 'object') {
      target_el = options.target_el;
    }

    target_el.append(html);

    if(typeof(options.on_create_callback) === 'function') {
      options.on_create_callback();
    }

    // Animate after appended.

    setTimeout(function() {
      $('.ModalMessage').addClass('show');
      $('._4ORMAT_overlay').addClass('show');
    }, 1);

    // Bind button actions

    if(options.buttons) {
      $.each(options.buttons, function(i, v) {
        if(typeof(v.action) === 'function') {
          $('.ModalMessage').delegate('.' + i, 'click.modal', v.action);
        }
      });
    }

    $(document).unbind('keydown.modal').bind('keydown.modal', function(e) {
      if(e.which == 13) {
        if(! options.enter_button) { options.enter_button = 'close'; }
        $('.ModalMessage .' + options.enter_button).trigger('click');
      }
    });

    // Bind close event

    if(options.prevent_close !== true) {
      $('html').delegate('.ModalMessage .close, ._4ORMAT_overlay', 'click.modal_close', this.close_modal);
    }
  };

  // helper functions

  this.ModalMessage.prototype.close_modal = function() {
    if (typeof(that.options.before_close_callback) === 'function') {
      that.options.before_close_callback(that);
    }

    $('.ModalMessage').removeClass('show');
    $('._4ORMAT_overlay').removeClass('show');

    if(that.options.prevent_close !== true) {
      $('html').undelegate('.ModalMessage .close, ._4ORMAT_overlay', 'click.modal_close');
    }

    if(that.options.buttons) {
      $.each(that.options.buttons, function(i, v) {
        if(typeof(v.action) === 'function') {
          $('.ModalMessage').undelegate('.' + i, 'click.modal');
        }
      });
    }

    $(document).unbind('keydown.modal');

    setTimeout(function() {
      $('.ModalMessage.generated').remove();
      $('._4ORMAT_overlay').remove();    
      if (typeof(that.options.after_close_callback) === 'function') {
        that.options.after_close_callback(that);
      }
    }, that.anim_speed);
  };
}).call(typeof(_4ORMAT) === 'object' ? _4ORMAT : window);