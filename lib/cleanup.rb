def html_cleanup h
  Sanitize.clean(h, {
      :elements => [
        'a', 'b', 'blockquote', 'caption', 'cite', 'code', 'col',
        'colgroup', 'dd', 'dl', 'dt', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
        'i', 'img', 'li', 'ol', 'p', 'pre', 'q', 'small', 'strike', 'strong',
        'sub', 'sup', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'tr', 'u',
        'ul', 'iframe'],
      :attributes => {
        :all          => ['class','href'],
        'img'         => ['alt', 'src', 'title', 'style'],
        'a'           => ['href', 'title', 'rel'],
        'blockquote'  => ['cite'],
        'col'         => ['span', 'width'],
        'colgroup'    => ['span', 'width'],
        'img'         => ['align', 'alt', 'height', 'src', 'title', 'width'],
        'ol'          => ['start', 'type'],
        'q'           => ['cite'],
        'table'       => ['summary', 'width'],
        'td'          => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
        'th'          => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
        'ul'          => ['type'],
        'iframe'      => ['src', "width", "height", "frameborder", "scrolling", "marginheight", "marginwidth"]
      },
      :protocols => {
        'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
        'blockquote' => {'cite' => ['http', 'https', :relative]},
        'img'        => {'src'  => ['http', 'https', :relative]},
        'q'          => {'cite' => ['http', 'https', :relative]}
      },
      :add_attributes => {
        'a' => {'rel' => 'nofollow'}
      },
      :trandsformers => [
        lambda do |env|
          node      = env[:node]
          node_name = env[:node_name]

          # Don't continue if this node is already whitelisted or is not an element.
          return if env[:is_whitelisted] || !node.element?

          parent = node.parent

          # Since the transformer receives the deepest nodes first, we look for a
          # <param> element or an <embed> element whose parent is an <object>.
          return unless (node_name == 'param' || node_name == 'embed') &&
              parent.name.to_s.downcase == 'object'

          if node_name == 'param'
            # Quick XPath search to find the <param> node that contains the video URL.
            return unless movie_node = parent.search('param[@name="movie"]')[0]
            url = movie_node['value']
          else
            # Since this is an <embed>, the video URL is in the "src" attribute. No
            # extra work needed.
            url = node['src']
          end

          # Verify that the video URL is actually a valid YouTube video URL.
          return unless url =~ /^http:\/\/(?:www\.)?youtube\.com\/v\//

          # We're now certain that this is a YouTube embed, but we still need to run
          # it through a special Sanitize step to ensure that no unwanted elements or
          # attributes that don't belong in a YouTube embed can sneak in.
          Sanitize.clean_node!(parent, {
            :elements => %w[embed object param],

            :attributes => {
              'embed'  => %w[allowfullscreen allowscriptaccess height src type width],
              'object' => %w[height width],
              'param'  => %w[name value]
            }
          })

          # Now that we're sure that this is a valid YouTube embed and that there are
          # no unwanted elements or attributes hidden inside it, we can tell Sanitize
          # to whitelist the current node (<param> or <embed>) and its parent
          # (<object>).
          {:node_whitelist => [node, parent]}
        end,
        lambda do |env|
          node = env[:node]
          return unless node.elem?

          unless node.children.any?{|c| c.text? && c.content.strip.length > 0 || !c.text? || not (c.text =~ /\s*\&nbsp;\s*/).nil? }
            node.unlink
          end
        end
      ]
    })
end
