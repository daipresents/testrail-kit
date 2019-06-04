# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Plans' do
      it 'can get/create/delete test plan' do
        client = TestRail::Client.new(ENV['TESTRAIL_URL'])

        plan = client.add_plan('Clientでつくったやーつ', '説明もかけます')
        expect(plan).not_to be_nil

        plan_id = plan['id']
        plan = client.get_plan(plan_id)
        expect(plan['id']).to eq(plan_id)

        client.delete_plan(plan_id)
        expect { client.get_plan(plan_id) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :plan_id is not a valid test plan.")')
      end

      it 'can close test plan' do
        client = TestRail::Client.new(ENV['TESTRAIL_URL'])

        plan = client.add_plan('Clientでつくったやーつ', '説明もかけます')
        plan_id = plan['id']
        client.close_plan(plan_id)

        plan = client.get_plan(plan_id)
        expect(plan['is_completed']).to be true
      end
    end
  end
end