module FormHelper
  def modal(**options, &block)
    render(
      layout: "shared/info_modal",
      locals: options,
      &block
    )
  end

  def user_picker_field(name, **options)
    render(
      partial: "shared/user_picker",
      locals: { name: name, **options },
    )
  end
end
