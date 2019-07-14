module ApplicationHelper

  def embedded_svg(filename, options = {})
    file = File.read(Rails.root.join("app", "assets", "images", filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    if options[:class].present?
      svg["class"] = options[:class]
    end
    doc.to_html.html_safe
  end

  def conditional_wrap(tagname, options = {}, &block)
    if options.delete(:if)
      concat content_tag(tagname, capture(&block), options)
    else
      concat capture(&block)
    end
  end
end
