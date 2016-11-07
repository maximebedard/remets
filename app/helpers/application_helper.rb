module ApplicationHelper
  def active_link?(name)
    "active" if controller.controller_name == name
  end
end
