module ApplicationHelper
  def active_for(name)
    "active" if controller.controller_name == name
  end
end
