require 'xero-ruby'

class XeroClient
  XERO_STATUS = {
    'NEW' => XeroRuby::Accounting::Invoice::DRAFT,
    'CONFIRMED' => XeroRuby::Accounting::Invoice::AUTHORISED,
    'CANCELLED' => XeroRuby::Accounting::Invoice::VOIDED
  }.freeze

  def initialize
    creds = {
      # client_id: ENV['CLIENT_ID'],
      # client_secret: ENV['CLIENT_SECRET'],
      client_id: '4CC584B1D45A4FC085505037C14B370A',
      client_secret: '7sLCgEeyuU2GFflyX6Rr5UJO1yvoPufe6zXnwcO3WmPHP14y',
      grant_type: 'client_credentials'
    }
    @xero_client ||= XeroRuby::ApiClient.new(credentials: creds)
    @xero_client.get_client_credentials_token
    @xero_tenant_id = @xero_client.last_connection['tenantId']
  end

  def update_invoice(invoice)
    invoices = {  
      invoices: [{ 
        status: XERO_STATUS[invoice.status.to_s]
      }]
    } 

    begin
      response = @xero_client.accounting_api.update_invoice(@xero_tenant_id, invoice.xero_invoice_id, invoices)
      return response
    rescue XeroRuby::ApiError => e
      puts "Exception when calling update_invoice: #{e}"
    end
  end

  def post_invoice(invoice)
    # List type on Xero
    # ACCPAY ||= "ACCPAY".freeze
    # ACCPAYCREDIT ||= "ACCPAYCREDIT".freeze
    # APOVERPAYMENT ||= "APOVERPAYMENT".freeze
    # APPREPAYMENT ||= "APPREPAYMENT".freeze
    # ACCREC ||= "ACCREC".freeze
    # ACCRECCREDIT ||= "ACCRECCREDIT".freeze
    # AROVERPAYMENT ||= "AROVERPAYMENT".freeze
    # ARPREPAYMENT ||= "ARPREPAYMENT".freeze

    # List status on Xero
    # DRAFT ||= "DRAFT".freeze
    # SUBMITTED ||= "SUBMITTED".freeze
    # DELETED ||= "DELETED".freeze
    # AUTHORISED ||= "AUTHORISED".freeze
    # PAID ||= "PAID".freeze
    # VOIDED ||= "VOIDED".freeze

    invoices =  [{
      type:  XeroRuby::Accounting::Invoice::ACCREC, #Using ACCREC, following from the SDK sample on Xero
      contact: contacts(invoice.client),
      date:  invoice.issue_date,
      due_date:  invoice.due_date,
      line_items:  map_line_item(transactions: invoice.transactions),
      currency_code: "SGD",
      status: XERO_STATUS[invoice.status.to_s]
    }]

    begin
      response = @xero_client.accounting_api.update_or_create_invoices(@xero_tenant_id, { invoices: invoices })
      invoice.update_column(:xero_invoice_id, response.invoices.first.invoice_id)
    rescue XeroRuby::ApiError => e
      puts "Exception when calling update_or_create_invoices: #{e}"
    end

  end

  def contacts(client)
    if client.xero_contact_id.blank?
      find_contact(client)
    end

    if client.xero_contact_id.blank?
      create_contact(client)
    end

    return {
      contact_id: client.xero_contact_id
    }
  end

  def find_contact(client)
    opts = {
      where: {
        email_address: ['==', client.email]
      }
    }

    begin
      response = @xero_client.accounting_api.get_contacts(@xero_tenant_id, opts)
      client.update_column(:xero_contact_id, response.contacts.first.contact_id)
    rescue
      return ''
    end
  end

  def create_contact(client)
    contact = { 
      name: client.name,
      email_address: client.email,
    }  

    contacts = {  
      contacts: [contact]
    } 

    begin
      response = @xero_client.accounting_api.create_contacts(@xero_tenant_id, contacts)
      client.update_column(:xero_contact_id, response.contacts.first.contact_id)
    rescue XeroRuby::ApiError => e
      puts "Exception when calling create_contacts: #{e}"
    end
  end

  def map_line_item(transactions: [])
    line_items = []

    transactions.each do |transaction|
      line_items << { 
        description: transaction.description,
        quantity: transaction.quantity,
        unit_amount: transaction.unit_amount,
        account_code: "200"
      }
    end

    return line_items
  end
end