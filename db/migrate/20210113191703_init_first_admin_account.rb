class InitFirstAdminAccount < ActiveRecord::Migration[6.0]
  def change
    reversible do |change|
      change.up do
        User.create! do |u|
          u.email       = 'super1@super.com'
          u.name        = 'superadmin1'
          u.password    = 'password'
          u.admin_role  = true
          u.client_role = false
        end
      end
    end
  end
end
