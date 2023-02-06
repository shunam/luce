# == Schema Information
#
# Table name: invoices
#
#  id             :integer          not null, primary key
#  status         :string
#  payment_status :string
#  amount         :float
#  paid_amount    :float
#  issue_date     :date
#  due_date       :date
#  client_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Invoice < ApplicationRecord
  STATUSES = %w[NEW CONFIRMED CANCELLED].freeze
  PAYMENT_STATUSES = %w[PAID UNPAID UNDERPAID].freeze

  belongs_to :client
  has_many :transactions, dependent: :destroy

  validates :status, presence: true, inclusion: STATUSES
  validates :payment_status, presence: true, inclusion: PAYMENT_STATUSES

  scope :by_client_id, ->(client_id) { where(client_id: client_id) }

  after_update :update_xero

  after_create :create_xero

  def update_xero
    XeroClient.new.update_invoice(self)
  end

  def create_xero
    XeroClient.new.post_invoice(self)
  end

  def cancel
    update_attributes(status: 'CANCELLED')
  end

  def confirm
    update_attributes(status: 'CONFIRMED')
  end

  def update_amount
    update_attributes(amount: compute_amount)
  end

  def compute_amount
    transactions.sum(&:amount)
  end
end
