module ApplicationHelper
  def active_on_controller(input)
    "active" if controller.controller_name == input
  end
end
