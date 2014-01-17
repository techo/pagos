# Create initial admin user-- guille
if (User.all.empty?)
  u = User.new(first_name: "Guillermo", last_name: "Lincango", email:"guillermo.lincango@techo.org", password: ENV["ADMIN_DEFAULT_PASSWORD"], role:"administrador")
  u.save(validation: false)
end
