module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def create_beer_with_rating(object, score)
  
    if object[:brewery]
      brew = object[:brewery]
    else
      brew = FactoryBot.create(:brewery)
    end
    if object[:style]
      beer = FactoryBot.create(:beer, style: FactoryBot.create(:style, name: object[:style]), brewery: brew)
    else
      beer = FactoryBot.create(:beer, brewery: brew)
    end
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end
  
  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end
end