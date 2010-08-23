ActionController::Routing::Routes.draw do |map|

  map.edit_course_lectures 'courses/:course_id/lectures/edit', :controller => 'lectures', :action => 'edit', :conditions => { :method => :get }
  map.update_course_lectures 'courses/:course_id/lectures/update', :controller => 'lectures', :action => 'update', :conditions => { :method => :post }
  
  map.edit_handouts 'courses/:course_id/handouts/edit', :controller => 'handouts', :action => 'edit', :conditions => { :method => :get }
  map.edit_lecture_notes 'courses/:course_id/lecture_notes/edit', :controller => 'lecture_notes', :action => 'edit', :conditions => { :method => :get }
  map.connect 'courses/:course_id/handouts', :controller => 'handouts', :action => 'update', :conditions => { :method => :put }
  map.connect 'courses/:course_id/lecture_notes', :controller => 'lecture_notes', :action => 'update', :conditions => { :method => :put }

  map.edit_course_readings 'courses/:course_id/readings/edit', :controller => 'readings', :action => 'edit', :conditions => { :method => :get }
  map.connect 'courses/:course_id/readings', :controller => 'readings', :action => 'update', :conditions => { :method => :put }
  
  map.resources :courses, :has_many => [ :menu_actions, :lectures, :lecture_notes, :handouts, :exams, :readings, :resource_groups, :assignments ]

  map.connect 'courses/:id/:static_action', :controller => 'courses', :action => 'static'
  
  # For restful-authentication plugin
    
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }

  map.resource :session
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "courses"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
