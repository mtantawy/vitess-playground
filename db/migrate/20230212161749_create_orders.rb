# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table(:orders) do |t|
      t.boolean(:paid)
      t.references(:customer, null: false, foreign_key: true)
      t.decimal(:total_amount)
      t.string(:status)
      t.references(:shipping_address, null: false, foreign_key: { to_table: :customer_addresses })
      t.references(:billing_address, null: false, foreign_key: { to_table: :customer_addresses })
      t.string(:payment_method)

      t.timestamps
    end
  end
end
