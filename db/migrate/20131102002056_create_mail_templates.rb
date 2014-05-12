class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.string :code # どのタイミングのテンプレートか？
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
