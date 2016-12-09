module ApplicationHelper
  def user_nav_link
    if user_signed_in?
      link_to "Выйти (#{current_user.email if user_signed_in?})", destroy_user_session_path, method: :delete, class: 'nav-link'
    else
      link_to "Войти", new_user_session_path, class: 'nav-link'
    end
  end
 
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-error",
      alert: "alert-danger",
      notice: "alert-info"
    }[flash_type.to_sym] || flash_type.to_s
  end

  def bootstrap_glyphs_icon(flash_type)
    {
      success: "glyphicon-ok",
      error: "glyphicon-exclamation-sign",
      alert: "glyphicon-warning-sign",
      notice: "glyphicon-info-sign"
    }[flash_type.to_sym] || 'glyphicon-screenshot'
  end
end

class BreadcrumbsBootstrap4Builder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @elements.collect do |element|
      render_element(element)
    end.join(@options[:separator] || " &raquo; ")
  end

  def render_element(element)
    if element.path == nil
      content = compute_name(element)
    else
      content = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
    end
    tag_class = @options[:tag_class] || ''
    if @options[:tag]
      @context.content_tag(@options[:tag], content, class: tag_class)
    else
      ERB::Util.h(content)
    end
  end
end
