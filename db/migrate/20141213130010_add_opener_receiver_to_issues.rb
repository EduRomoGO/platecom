class AddOpenerReceiverToIssues < ActiveRecord::Migration
  def change
    add_reference :issues, :opener, index: true
    add_reference :issues, :receiver, index: true
  end
end
