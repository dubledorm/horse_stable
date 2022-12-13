# frozen_string_literal: true

module HtmlHelper
  def single_comments
    content_tag(:div, class: 'single_comments') do
      image_tag('images/blog/avatar3.png', alt: '') +
        content_tag(:p, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do') +
        content_tag(:div, class: 'entry-meta small muted') do
          content_tag(:span, 'By') do
            link_to('Alex', '#')
          end +
            link_to('Creative', '#')
        end
    end
  end
end
