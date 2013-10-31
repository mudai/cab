class CreateOnetimeTokens < ActiveRecord::Migration
  def change
    create_table :onetime_tokens do |t|

      t.timestamps
    end
  end
end
