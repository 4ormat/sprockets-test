class @RedactorOverrides
  @overrideCleanParagraphy: ->
    $.Redactor::cleanParagraphy = (html) ->
      R = (str, mod, r) ->
        html.replace new RegExp(str, mod), r

      html = $.trim(html)
      return html  if @opts.linebreaks is true
      return @opts.emptyHtml  if html is "" or html is "<p></p>"
      html = html + "\n"
      return html  if @opts.removeEmptyTags is false
      safes = []
      matches = html.match(/<(table|div|pre|object)(.*?)>([\w\W]*?)<\/(table|div|pre|object)>/g)
      matches = []  unless matches
      commentsMatches = html.match(/<!--([\w\W]*?)-->/g)
      matches = $.merge(matches, commentsMatches)  if commentsMatches
      if @opts.phpTags
        phpMatches = html.match(/<section(.*?)rel="redactor-php-tag">([\w\W]*?)<\/section>/g)
        matches = $.merge(matches, phpMatches)  if phpMatches
      if matches
        $.each matches, (i, s) ->
          safes[i] = s
          html = html.replace(s, "{replace" + i + "}\n")
          return

      blocks = "(comment|html|body|head|title|meta|style|script|link|iframe|table|thead|tfoot|caption|col|colgroup|tbody|tr|td|th|div|dl|dd|dt|ul|ol|li|pre|select|option|form|map|area|blockquote|address|math|style|p|h[1-6]|hr|fieldset|legend|section|article|aside|hgroup|header|footer|nav|figure|figcaption|details|menu|summary)"
      html = R("(<" + blocks + "[^>]*>)", "gi", "\n$1")
      html = R("(</" + blocks + ">)", "gi", "$1\n\n")
      html = R("\r\n", "g", "\n")
      html = R("\r", "g", "\n")
      html = R("/\n\n+/", "g", "\n\n")

      html = R("<p><p>", "gi", "<p>")
      html = R("</p></p>", "gi", "</p>")
      html = R("<p>s?</p>", "gi", "")
      html = R("<p>([^<]+)</(div|address|form)>", "gi", "<p>$1</p></$2>")
      html = R("<p>(</?" + blocks + "[^>]*>)</p>", "gi", "$1")
      html = R("<p>(<li.+?)</p>", "gi", "$1")
      html = R("<p>s?(</?" + blocks + "[^>]*>)", "gi", "$1")
      html = R("(</?" + blocks + "[^>]*>)s?</p>", "gi", "$1")
      html = R("(</?" + blocks + "[^>]*>)s?<br />", "gi", "$1")
      html = R("<br />(s*</?(?:p|li|div|dl|dd|dt|th|pre|td|ul|ol)[^>]*>)", "gi", "$1")
      html = R("\n</p>", "gi", "</p>")
      html = R("<li><p>", "gi", "<li>")
      html = R("</p></li>", "gi", "</li>")
      html = R("</li><p>", "gi", "</li>")

      html = R("<p>\t?\n?<p>", "gi", "<p>")
      html = R("</dt><p>", "gi", "</dt>")
      html = R("</dd><p>", "gi", "</dd>")
      html = R("<br></p></blockquote>", "gi", "</blockquote>")
      html = R("<p>\t*</p>", "gi", "")

      # restore safes
      $.each safes, (i, s) ->
        html = html.replace("{replace" + i + "}", s)
        return

      $.trim html

  @overrideSetSpansVerified: ->
    $.Redactor::setSpansVerified = ->
      # do nothing! We don't want span -> inline

  @overrideSyncClean: ->
    $.Redactor::syncClean = (html) ->
      html = @cleanStripTags(html)  unless @opts.fullpage

      # trim
      html = $.trim(html)

      # removeplaceholder
      html = @placeholderRemoveFromCode(html)

      # remove space
      html = html.replace(/&#x200b;/g, "")
      html = html.replace(/&#8203;/g, "")
      html = html.replace(/<\/a>&nbsp;/g, "</a> ")
      html = html.replace(/\u200B/g, "")
      #html = ""  if html is "<p></p>" or html is "<p> </p>" or html is "<p>&nbsp;</p>"

      # link nofollow
      if @opts.linkNofollow
        html = html.replace(/<a(.*?)rel="nofollow"(.*?)>/g, "<a$1$2>")
        html = html.replace(/<a(.*?)>/g, "<a$1 rel=\"nofollow\">")

      # php code fix
      html = html.replace("<!--?php", "<?php")
      html = html.replace("?-->", "?>")

      # revert no editable
      html = html.replace(/<(.*?)class="noeditable"(.*?) contenteditable="false"(.*?)>/g, "<$1class=\"noeditable\"$2$3>")
      html = html.replace(RegExp(" data-tagblock=\"\"", "g"), "")
      html = html.replace(/<br\s?\/?>\n?<\/(P|H[1-6]|LI|ADDRESS|SECTION|HEADER|FOOTER|ASIDE|ARTICLE)>/g, "</$1>")

      # remove image resize
      html = html.replace(/<span(.*?)id="redactor-image-box"(.*?)>([\w\W]*?)<img(.*?)><\/span>/g, "$3<img$4>")
      html = html.replace(/<span(.*?)id="redactor-image-resizer"(.*?)>(.*?)<\/span>/g, "")
      html = html.replace(/<span(.*?)id="redactor-image-editter"(.*?)>(.*?)<\/span>/g, "")

      # remove empty lists
      html = html.replace(/<(ul|ol)>\s*\t*\n*<\/(ul|ol)>/g, "")

      # remove font
      html = html.replace(/<font(.*?)>([\w\W]*?)<\/font>/g, "$2")  if @opts.cleanFontTag

      # remove spans
      # html = html.replace(/<span(.*?)>([\w\W]*?)<\/span>/g, "$2")
      html = html.replace(/<inline>/g, "<span>")
      html = html.replace(/<inline /g, "<span ")
      html = html.replace(/<\/inline>/g, "</span>")
      html = html.replace(/<span(.*?)class="redactor_placeholder"(.*?)>([\w\W]*?)<\/span>/g, "")
      html = html.replace(/<span>([\w\W]*?)<\/span>/g, "$1")

      # special characters
      html = html.replace(/&amp;/g, "&")
      html = html.replace(/™/g, "&trade;")
      html = html.replace(/©/g, "&copy;")
      html = html.replace(/…/g, "&hellip;")
      html = html.replace(/—/g, "&mdash;")
      html = html.replace(/‐/g, "&dash;")
      html = @cleanReConvertProtected(html)

      html
