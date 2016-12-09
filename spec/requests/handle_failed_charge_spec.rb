require 'rails_helper'

describe 'handle failed charge', :vcr do
  let(:event_data) do
    {
      "id" => "evt_19OpmbFgeUvs3GmuhFrwq1mc",
      "object" => "event",
      "api_version" => "2016-07-06",
      "created" => 1481295333,
      "data" => {
        "object" => {
          "id" => "ch_19OpmbFgeUvs3GmuE4X3Dbnt",
          "object" => "charge",
          "amount" => 299,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1481295333,
          "currency" => "usd",
          "customer" => "cus_9hylQXbEozYBLk",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_19OpmbFgeUvs3GmuE4X3Dbnt/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_19OpmPFgeUvs3Gmu6qClTMff",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_9hylQXbEozYBLk",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2020,
            "fingerprint" => "JdFb5cdIk9LqsEmo",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "my trello plus monthly",
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_9iGJlOgPJc0Txw",
      "type" => "charge.failed"
    }
  end

  let!(:user) { Fabricate :user, stripe_customer_id: 'cus_9hylQXbEozYBLk' }
  let(:action) { post '/stripe_events', event_data }

  after { ActionMailer::Base.deliveries.clear }

  it 'does not create a payment' do
    expect{ action }.to change(Payment, :count).by(0)
  end

  it 'changes the plan to basic' do
    action
    expect(user.reload.plan).to eq('basic')
  end
end
