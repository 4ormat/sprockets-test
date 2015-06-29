sharing_blog_browser = $('.sharing .blog-browser > *')
editing_blog_browser = $('.editing .blog-browser > *')

$('li.writing').hover ->
  editing_blog_browser.not('.type_tools, .content_text').toggleClass('fade');
$('li.styling').hover ->
  editing_blog_browser.not('.type_tools').toggleClass('fade');
$('li.layout').hover ->
  editing_blog_browser.not('.images').toggleClass('fade');
$('li.import').hover ->
  editing_blog_browser.not('.add_media').toggleClass('fade');
$('li.include_message').hover ->
  sharing_blog_browser.not('.message_area').toggleClass('fade');
$('li.share_social').hover ->
  sharing_blog_browser.not('.networks').toggleClass('fade');