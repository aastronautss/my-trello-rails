class TweetsController < ActivatedRemoteController
  def create
    @tweet = TweetForm.new tweet_form_params
    if @tweet.valid?
      tweet_info = twitter_api_client.create_tweet
    end
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
