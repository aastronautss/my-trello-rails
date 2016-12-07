module StripeWrapper
  class Charge
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @message = options[:message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
        )

        new(response: response)
      rescue Stripe::CardError => e
        new(message: e.message)
      end
    end

    def successful?
      @response.present?
    end
  end

  class Customer
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @message = options[:message]
    end

    def self.create(options = {})
      begin
        response = options[:user].stripe_customer_id.present? ? retrieve_customer(options) : create_customer(options)

        new(response: response)
      rescue Stripe::CardError => e
        new(message: e.message)
      end
    end

    def successful?
      @response.present?
    end

    def id
      @response[:id]
    end

    private

    def self.create_customer(options = {})
      Stripe::Customer.create(
        source: options[:card],
        email: options[:user].email
      )
    end

    def self.retrieve_customer(options = {})
      Stripe::Customer.retrieve(options[:user].stripe_customer_id)
    end
  end

  class Subscription
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @response = options[:message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Subscription.create(
          customer: options[:user].stripe_customer_id,
          plan: options[:plan].stripe_plan_id
        )

        new response: response
      rescue Stripe::CardError => e
        new message: e.message
      end
    end

    def successful?
      @response.present?
    end
  end
end
