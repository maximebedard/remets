class Scraper
  include ActionView::Helpers::SanitizeHelper

  def text(content)
    sanitize(content).downcase
  end
end
