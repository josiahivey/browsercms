# Load up data that was created in load seed data migration
User.current = User.first(:conditions => {:login => 'cmsadmin'})
root_section = Section.root.first
home_page = Page.first(:conditions => {:name => "Home"})

# Now create the additional initial data
create_section(:products, :name => "Products", :parent => root_section, :path => "/products")
create_section(:browsercms, :name => "BrowserCMS", :parent => sections(:products), :path => "/browsercms")
create_section(:browserams, :name => "BrowserAMS", :parent => sections(:products), :path => "/browserams")
create_section(:about, :name => "About", :parent => root_section, :path => "/about")
create_section(:people, :name => "People", :parent => sections(:about), :path => "/people")
create_section(:careers, :name => "Careers", :parent => sections(:about), :path => "/careers")

Group.all.each{|g| g.sections = Section.all }

create_page(:about, :name => "About Us", :path => "/about", :section => sections(:about), :template => "Main")
create_page(:kerry, :name => "Kerry Gunther", :path => "/people/kerry", :section => sections(:people), :template => "Main")
create_page(:pat, :name => "Patrick Peak", :path => "/people/pat", :section => sections(:people), :template => "Main")
create_page(:paul, :name => "Paul Barry", :path => "/people/paul", :section => sections(:people), :template => "Main")

create_page(:test, :name => "Test", :path => "/test", :section => sections(:root), :template => "Main")
create_html_block(:test, :name => "Test", :connect_to_page_id => pages(:test).id, :connect_to_container => "main")
pages(:test).publish!

create_html_block(:sidebar, :name => "Sidebar", :content => "<ul><li><a href=\"/\">Home</a></li><li><a href=\"/about\">About Us</a></li></ul>", :publish_on_save => true)
create_html_block(:about_us, :name => "About Us", :content => "We are super fantastic", :publish_on_save => true)

home_page.publish!

pages(:about).create_connector(html_blocks(:about_us), "main")
pages(:about).publish!

create_dynamic_portlet(:recently_updated_pages,
  :name => 'Recently Updated Pages',  
  :code => "@pages = Page.all(:order => 'updated_at desc', :limit => 3)",
  :template => <<-TEMPLATE
<h2>Recent Updates</h2>
<ul>
  <% @pages.each do |page| %><li>
    <%= page.name %>
  </li><% end %>
</ul>
TEMPLATE
)
