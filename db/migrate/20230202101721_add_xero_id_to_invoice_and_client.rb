class AddXeroIdToInvoiceAndClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :xero_contact_id, :string
    add_column :invoices, :xero_invoice_id, :string
  end
end
