module FormHelper
  def modal(**options, &block)
    render(
      layout: "shared/info_modal",
      locals: options,
      &block
    )
  end

  def user_picker_field(name, option_tags = nil, options = {})
    render(
      partial: "shared/user_picker",
      locals: { name: name, option_tags: option_tags, options: options },
    )
  end
end
