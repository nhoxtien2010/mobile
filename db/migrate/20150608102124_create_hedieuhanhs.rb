class CreateHedieuhanhs < ActiveRecord::Migration
  def change
    create_table :hedieuhanhs do |t|
      t.string :ten

      t.timestamps
    end
  end
end
