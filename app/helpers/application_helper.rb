module ApplicationHelper
  def active_on_controller(input)
    "active" if controller.controller_name == input
  end

  def white_bg?
    "white-bg" if controller.controller_name == "home"
  end
end
