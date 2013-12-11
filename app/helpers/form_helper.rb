module FormHelper
  def form_error_messages
    return '' if resource.errors.empty?

    messages = resource.errors.messages.map { |field, msg| content_tag(:li, msg.join(', ')) }.join

    html = <<-HTML
    <div class="alert alert-error alert-block">
    <button type="button" class="close" data-dismiss="alert">x</button>
    #{messages}
    </div>
    HTML

    html.html_safe
  end
end
