module ApplicationHelper
  def active_on_controller(input)
    "active" if controller.controller_name == input
  end

  def white_background
    "white-bg" if %w(home authentications).include?(controller.controller_name)
  end
end
