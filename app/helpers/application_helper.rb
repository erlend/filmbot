module ApplicationHelper

  ##
  # Bootstrap formated nav link. It adds the "active" class if url links to the
  # current page.
  #
  def nav_link_to(text, url, options={})
    is_active = current_page?(url)
    classes = %w[nav-item]

    if is_active
      classes << 'active'
      text = safe_join [text, content_tag(:span, '(current)', class: 'sr-only')]
    end

    content_tag :li, class: classes do
      link_to text, url, { class: 'nav-link' }.merge(options)
    end
  end

end
