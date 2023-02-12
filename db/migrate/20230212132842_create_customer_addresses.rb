# frozen_string_literal: true

class CreateCustomerAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table(:customer_addresses) do |t|
      t.string(:kind, null: false)
      t.boolean(:default, default: false, null: false)
      t.string(:street)
      t.string(:postcode)
      t.string(:city)
      t.string(:country)
      t.references(:customer, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
