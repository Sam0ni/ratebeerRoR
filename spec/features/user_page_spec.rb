require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  describe "who has rated beers" do
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
    let!(:brewery2) { FactoryBot.create :brewery, name: "Saimaan panimo"}
    let!(:user) { FactoryBot.create :user, username: "Reittimies"}
    before do
      create_beers_with_many_ratings({user: user, brewery: brewery, style: "IPA"}, 10, 30, 20)
      create_beers_with_many_ratings({user: user, brewery: brewery2, style: "Lager"}, 40, 20, 30)
    end

    it "has favourite beer style" do
      visit user_path(user)

      expect(page).to have_content "Favourite beer style: Lager"
    end

    it "has favourite brewery" do
      visit user_path(user)

      expect(page).to have_content "Favourite brewery: Saimaan panimo"
    end
  end
end