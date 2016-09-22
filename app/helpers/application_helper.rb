module ApplicationHelper
  def format_body(body_text)
    body_text.split(/\n\n/).map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join('').html_safe
  end
end
