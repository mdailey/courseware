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

    default_menu_actions = []
    menu_actions = []
    
    # Options for course views
        
    if @course and @course.id
      
      menu_actions = @course.menu_actions
      
      default_menu_actions = [
        ( MenuAction.new :order => 1, :tag => 'Home', :action => 'home' ),
        ( MenuAction.new :order => 2, :tag => 'Syllabus', :action => 'syllabus' ),
        ( MenuAction.new :order => 3, :tag => 'Lecture notes', :action => 'lecture_notes' ),
        ( MenuAction.new :order => 4, :tag => 'Handouts', :action => 'handouts' ),
        ( MenuAction.new :order => 5, :tag => 'Assignments', :action => 'assignments' ),
        ( MenuAction.new :order => 6, :tag => 'Exams', :action => 'exams' ),
        ( MenuAction.new :order => 7, :tag => 'Readings', :action => 'readings' ),
        ( MenuAction.new :order => 8, :tag => 'Resources', :action => 'resources' )
      ]
      
      if menu_actions.nil? or menu_actions.size == 0
        menu_actions = default_menu_actions
      end
    
      menu_actions.sort { |m1,m2| m1.order <=> m2.order }.each do |m|
        path =
          case m.action
          when 'home' then course_path( @course )
          else course_path( @course ) + '/' + m.action.parameterize
          end
        primary.item m.action, m.tag, path
      end
      
    end

    primary.item :course_list, 'Course list', courses_path, { :class => 'courselist' }
    
    if !logged_in?
      primary.item :login, 'Login', login_path, { :class => 'user' }
      #primary.item :register, 'Register', signup_path, { :class => 'user' }
    end
    
    if authorized?( :new, CoursesController )
      primary.item :new_course, 'New course', new_course_path, { :class => 'edit' }
    end

    # Options for editing course views
     
    if @course and @course.id and authorized?( :edit, @course )
      menu_actions.sort { |m1,m2| m1.order <=> m2.order }.each do |m|
        if default_menu_actions.select { |dm| dm.action == m.action }.size > 0
          action = "edit_#{m.action}"
          tag = h("Edit #{m.tag.downcase}")
          path = course_path( @course ) + ( m.action == 'home' ? '' : ('/' + m.action.parameterize)) + '/edit'
          primary.item action, tag, path, :class => 'edit'
        end
      end
    end

    if logged_in?
      primary.item :logout, 'Logout', logout_path, { :class => 'user' }
    end
    
    # Add an item which has a sub navigation (same params, but with block)
    #primary.item :key_2, 'name', 'url2', options do |sub_nav|
      # Add an item to the sub navigation (same params again)
      #sub_nav.item :key_2_1, 'name', 'url2-1'
    #end
      
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
