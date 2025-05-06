require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Koff - iso 3', from: 'rating_beer_id')
    fill_in('rating_score', with: '15')
    save_and_open_page

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is shown on the ratings page" do
    create_beers_with_many_ratings({user: user}, 20, 20, 10)

    visit ratings_path
    expect(page).to have_content "#{user.username} 3 ratings"
  end

  it "is shown on the respective users page" do
    user2 = FactoryBot.create :user, username: "Pekka2"
    create_beers_with_many_ratings({user: user}, 20, 15, 10)
    create_beers_with_many_ratings({user: user2}, 16, 13, 14)

    visit user_path(user)
    expect(page).to have_content "Has made 3 ratings, average rating 15"
    expect(page).to have_content "anonymous 15"
    expect(page).to have_content "anonymous 20"
    expect(page).to have_content "anonymous 10"
    expect(page).not_to have_content "anonymous 13"
    expect(page).not_to have_content "anonymous 14"
    expect(page).not_to have_content "anonymous 16"
  end

  it "is deleted from the database when user deletes it" do
    create_beers_with_many_ratings({user: user}, 20, 15, 10)

    visit user_path(user)
    expect{click_link('Delete', match: :first)}.to change{Rating.count}.by(-1)
  end
end