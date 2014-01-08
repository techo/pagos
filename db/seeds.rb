# Create initial admin user
if (User.all.empty?)
  u = User.new(first_name: "Michelle", last_name: "Arevalo-Carpenter", email:"michelle.arevalo@techo.org", password: ENV["ADMIN_DEFAULT_PASSWORD"])
  u.save(validation: false)
end
