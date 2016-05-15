module FormHelper
  def modal(**options, &block)
    render(
      layout: "shared/info_modal",
      locals: options,
      &block
    )
  end

  def direct_file_uploader
  end

  def user_picker_field(name, values, option_tags = nil, options = {})
    render(
      partial: "shared/user_picker",
      locals: { name: name, values: values, option_tags: option_tags, options: options },
    )
  end

  def errors_summary(record)
    render(
      partial: "shared/errors_summary",
      locals: { record: record },
    )
  end
end
