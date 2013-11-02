class CreateProvisionalUsers < ActiveRecord::Migration
  def change
    create_table :provisional_users do |t|

      t.timestamps
    end
  end
end
