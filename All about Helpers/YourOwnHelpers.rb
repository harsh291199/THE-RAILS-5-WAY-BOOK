# ---------------- Writing your own view Helpers ------------------

# ------ Small Optimizations: The title Helper

def h1_title(name)
  content_for(:title) { name }
  content_tag('h1', name)
end

h1_title 'New user'

# ------- Encapsulating View Logic: The photo_for Helper %>

def photo_for(user, size = :thumb)
  src = if user.profile_photo
          user.profile_photo.public_filename(size)
        else
          'user_placeholder.png'
        end
  link_to(image_tag(src), user_path(user))
end

# ------- Smart View: The breadcrumbs Helper %>

def breadcrumbs
  return if controller.controller_name == 'home'

  html = [link_to('Home', root_path)]
  html << link_to(company.name, company) if respond_to? :company
  html << link_to(department.name, department) if respond_to? :department
  html << link_to(employee.name, employee) if respond_to? :employee
  html.join(' &gt; ').html_safe
end
