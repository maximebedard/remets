module ApplicationHelper
  def active_for(input)
    "active" if controller.controller_name == input
  end
end
