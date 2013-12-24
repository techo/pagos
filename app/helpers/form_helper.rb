module FormHelper
  def form_error_messages(form_resource = nil)
    resource_with_errors = form_resource ? form_resource : resource
    return '' if resource_with_errors.errors.empty?

    messages = resource_with_errors.errors.messages.map { |field, msg| content_tag(:li, msg.join(', ')) }.join

    html = <<-HTML
    <div class="alert alert-error alert-block">
    <button type="button" class="close" data-dismiss="alert">x</button>
    #{messages}
    </div>
    HTML

    html.html_safe
  end

  def encode_utf_8(text)
    e = text.encode("cp1252", invalid: :replace, undef: :replace).force_encoding("UTF-8")
    e.valid_encoding? ? e : text
  end
end
