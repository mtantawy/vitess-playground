# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table(:products) do |t|
      t.string(:sku)
      t.string(:name)
      t.text(:description)
      t.integer(:quantity)

      t.timestamps
    end
    add_index(:products, :sku, unique: true)
  end
end
