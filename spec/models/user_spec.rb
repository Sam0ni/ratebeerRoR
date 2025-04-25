require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a too short password" do
    user = User.create username: "Pekka", password: "Haa"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a password with only small letters" do
    user = User.create username: "Pekka", password: "aaaaaaaaa"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:brewery)
      FactoryBot.create(:brewery)
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user }, 7 )
      best = create_beer_with_rating({ user: user }, 25 )
    
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "with no ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only beer rated if only one rated" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with the biggest avg score if several beers rated" do
      create_beers_with_many_ratings({ user: user, style: "Stout"}, 20, 15, 30)
      create_beers_with_many_ratings({ user: user, style: "Sour"}, 30, 40, 45)
      create_beers_with_many_ratings({ user: user}, 15, 10, 12)
      best_style = "Sour"

      expect(user.favorite_style).to eq(best_style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "with no ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only beer rated if only one rated" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end
    
    it "is the brewery with the biggest avg beer score if several beers rated" do
      brewery1 = FactoryBot.create(:brewery, name: "Koff")
      brewery2 = FactoryBot.create(:brewery, name: "Saimaan Panimo")
      create_beers_with_many_ratings({ user: user, brewery: brewery1}, 20, 15, 30)
      create_beers_with_many_ratings({ user: user, brewery: brewery2}, 30, 40, 45)
      create_beers_with_many_ratings({ user: user}, 15, 10, 12)
      
      expect(user.favorite_brewery).to eq(brewery2.name)
    end
  end

end

def create_beer_with_rating(object, score)
  
  if object[:brewery]
    brew = object[:brewery]
  else
    brew = FactoryBot.create(:brewery)
  end
  if object[:style]
    beer = FactoryBot.create(:beer, style: object[:style], brewery: brew)
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
