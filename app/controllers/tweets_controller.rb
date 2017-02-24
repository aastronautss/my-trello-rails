class TweetsController < ActivatedRemoteController
  def create
    @tweet_form = TweetForm.new tweet_form_params

    if @tweet_form.valid?
      tweet_info = twitter_api_client.create_tweet status: @tweet_form.status
      render '{}', status: :created
    else
      render json: @tweet_form.errors.full_messages,
        status: :unprocessable_entity
    end

  rescue TwitterAPI::TweetCreationFailure => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def tweet_form_params
    params.require(:tweet).permit :status
  end

  def twitter_api_client
    service = current_user.services.where(provider: 'twitter').first
    @twitter_api_client ||= TwitterAPI::Client.new(service.token, service.secret)
  end
end
