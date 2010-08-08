# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|  
  # Specify a custom renderer if needed. 
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call. 
  # navigation.renderer = Your::Custom::Renderer
  
  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'
    
  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false
  
  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)

    if @course and @course.id and @menu_actions and @menu_actions.size > 0

      @menu_actions.sort { |m1,m2| m1.order <=> m2.order }.each do |m|
        path =
          case m.action
          when 'home' then course_path( @course )
          when 'lectures' then course_lectures_path( @course )
          when 'lecture_notes' then course_lecture_notes_path( @course )
          when 'handouts' then course_handouts_path( @course )
          else course_path( @course ) + '/' + m.action.parameterize
          end
        primary.item m.action, m.tag, path
      end
      
      # Add an item which has a sub navigation (same params, but with block)
      #primary.item :key_2, 'name', 'url2', options do |sub_nav|
        # Add an item to the sub navigation (same params again)
        #sub_nav.item :key_2_1, 'name', 'url2-1'
      #end
      
    elsif @course and @course.id
      
      primary.item :home, 'Home', course_path( @course )
      primary.item :lectures, 'Syllabus', course_lectures_path( @course )
      primary.item :lecture_notes, 'Lecture notes', 'lecture_notes'
      primary.item :handouts, 'Handouts', 'handouts'
      primary.item :assignments, 'Assignments', 'assignments'
      primary.item :exams, 'Exams', 'exams'
      primary.item :readings, 'Readings', 'readings'
      primary.item :resources, 'Resources', 'resource_groups'
      
    end

    primary.item :course_list, 'Course list', courses_path, { :class => 'courselist' }
    
    if !logged_in?
      primary.item :login, 'Login', login_path, { :class => 'user' }
      #primary.item :register, 'Register', signup_path, { :class => 'user' }
    end
    
    if authorized?( :new, CoursesController )
      primary.item :new_course, 'New course', new_course_path, { :class => 'edit' }
    end
      
    if @course and @course.id and authorized?( :edit, @course )
      primary.item :edit_course, 'Edit course info', edit_course_path( @course ), :class => 'edit'
    end

    if logged_in?
      primary.item :logout, 'Logout', logout_path, { :class => 'user' }
    end
    
    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    #primary.item :key_3, 'Admin', 'url3', :class => 'special', :if => Proc.new { current_user.admin? }
    #primary.item :key_4, 'Account', 'url4', :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'
    
    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false
  
  end
  
end
