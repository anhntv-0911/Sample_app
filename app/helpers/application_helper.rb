module ApplicationHelper
  def full_title page_title = ""
    base_title = t("static_pages.home.sampleapp")
      if base_title.empty?
        page_title
      else
        page_title + " | " + base_title
      end
  end
end
