require 'rails_helper'

describe 'create payment on successful charge', :vcr do
  let(:event_data) do
    {
      "id" => "evt_19OpF2FgeUvs3GmuTKs8XDa6",
      "object" => "event",
      "api_version" => "2016-07-06",
      "created" => 1481293252,
      "data" => {
        "object" => {
          "id" => "ch_19OpF2FgeUvs3GmuNyOE1GYW",
          "object" => "charge",
          "amount" => 299,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_19OpF2FgeUvs3GmuBYaEnU7l",
          "captured" => true,
          "created" => 1481293252,
          "currency" => "usd",
          "customer" => "cus_9hyoKDuVTerKrV",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => "in_19OpF2FgeUvs3GmuxoIwbO7o",
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_19OpF2FgeUvs3GmuNyOE1GYW/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_19OpETFgeUvs3Gmu08IO6qGC",
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
            "customer" => "cus_9hyoKDuVTerKrV",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2021,
            "fingerprint" => "BKTw6Ixt61DE2nPW",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "my trello plus monthly",
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_9iFky9h3wZR0zr",
      "type" => "charge.succeeded"
    }
  end

  let!(:user) { Fabricate :user, stripe_customer_id: 'cus_9hyoKDuVTerKrV' }
  let(:action) { post '/stripe_events', event_data }

  it 'creates a payment with the webhook info' do
    expect{ action }.to change(Payment, :count).by(1)
  end

  it 'associates the payment with the user' do
    action
    expect(Payment.last.user).to eq(user)
  end

  it 'adds the amount to the payment' do
    action
    expect(Payment.last.amount).to eq(299)
  end

  it 'adds a reference id to the payment' do
    action
    expect(Payment.last.reference_id).to eq('ch_19OpF2FgeUvs3GmuNyOE1GYW')
  end
end
