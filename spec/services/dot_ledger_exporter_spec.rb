require 'rails_helper'

describe DotLedgerExporter do
  let!(:account_group_saving) do
    FactoryBot.create :account_group, name: 'Savings'
  end
  let!(:account_group_checking) do
    FactoryBot.create :account_group, name: 'Checking'
  end
  let!(:account) do
    FactoryBot.create :account, name: 'Eftpos', number: '1212341234567121', type: 'Cheque', account_group: account_group_checking
  end
  let!(:account_2) do
    FactoryBot.create :account, name: 'Savings', number: '1212341234567122', type: 'Savings', account_group: account_group_saving
  end
  let!(:category) do
    FactoryBot.create :category, name: 'Category 1', type: 'Essential'
  end
  let!(:goal) do
    category.goal.update(amount: 123.45)
  end
  let!(:sorting_rule) do
    FactoryBot.create :sorting_rule, name: 'Name 1', contains: 'Contains 1', category: category, tag_list: %w[foo bar], review: true
  end

  let(:data) do
    {
      'AccountGroups' => [
        {
          'name' => 'Savings'
        },
        {
          'name' => 'Checking'
        }
      ],
      'Accounts' => [
        {
          'name' => 'Eftpos',
          'number' => '1212341234567121',
          'type' => 'Cheque',
          'account_group_name' => 'Checking'
        },
        {
          'name' => 'Savings',
          'number' => '1212341234567122',
          'type' => 'Savings',
          'account_group_name' => 'Savings'
        }
      ],
      'Categories' => [
        {
          'name' => 'Category 1',
          'type' => 'Essential'
        }
      ],
      'Goals' => [
        {
          'category_name' => 'Category 1',
          'type' => 'Spend',
          'amount' => 123.45,
          'period' => 'Month'
        }
      ],
      'SortingRules' => [
        {
          'name' => 'Name 1',
          'contains' => 'Contains 1',
          'category_name' => 'Category 1',
          'tag_list' => %w[foo bar],
          'review' => true
        }
      ]
    }
  end

  subject { described_class.new }

  it 'builds the correct data format' do
    subject.export

    expect(subject.data).to eq(data)
  end
end
