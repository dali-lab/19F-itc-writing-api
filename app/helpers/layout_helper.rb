module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def nav_tabs
    return "" unless logged_in? && current_user
    main_tab_active = false
    thing_tab_active = false

    case controller.controller_name
    when 'application'
        main_tab_active = true
    when 'things'
        if controller.action_name == 'new'
          main_tab_active = true
        else
          thing_tab_active = true
        end
    end

    tabs = Array.new
    tabs << content_tag(:li, link_to("Home", root_path, class: 'nav-link'), :class => (main_tab_active == true ? 'nav-item active' : 'nav-item'))
    tabs << content_tag(:li, link_to("Thing X", show_path, class: 'nav-link'), :class => (thing_tab_active == true ? 'nav-item active' : 'nav-item'))
    tabs << content_tag(:li, link_to("Thing Y", root_path, class: 'nav-link'), class: 'nav-item')
    tabs.join('').html_safe
  end
end
