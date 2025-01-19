require 'rails_helper'

RSpec.describe Debt, type: :model do
  describe 'validations' do
    subject { create(:debt) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:government_id) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:debt_id) }
    it { should validate_uniqueness_of(:debt_id) }
  end

  describe 'associations' do
    it { should have_one(:bill) }
    it { should belong_to(:file_processing) }
  end
end
