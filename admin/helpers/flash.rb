Admin.helpers do
  def flash_ui(*args)
    options = args.extract_options!
    args.map do |kind|
      flash_text = flash[kind]
      next if flash_text.blank?
      "ui['#{kind}']('#{flash_text}');"
    end.compact * "\n"
  end
end