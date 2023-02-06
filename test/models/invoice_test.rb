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
require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
