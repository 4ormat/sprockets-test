blog_post_text_block = {}

blog_post_text_block.className = 'blog_post_text_block'

blog_post_text_block.editor_wrapper = """
  <div class='blog_post_content_block #{blog_post_text_block.className}'></div>
"""

blog_post_text_block.render_block = (blockHTML) ->
  $(blog_post_text_block.editor_wrapper).html(blockHTML)

blog_post_text_block.is_of_type = ($block) ->
  $block.hasClass(blog_post_text_block.className)

window.blog_post_text_block = blog_post_text_block
