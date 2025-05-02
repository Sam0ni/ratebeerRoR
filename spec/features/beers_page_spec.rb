require "rails_helper"

include Helpers

describe "beers page" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:user) { FactoryBot.create :user }
  let!(:style) { FactoryBot.create :style }
  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end
  it "should be able to add a beer with valid name" do
    visit new_beer_path
    fill_in("beer_name", with: "Testiolut")
    expect{click_button("Create Beer")}.to change{Beer.count}.by(1)
    
  end

  it "should not add non-valid named beer to the database" do
    visit new_beer_path
    expect{click_button("Create Beer")}.not_to change{Beer.count}
    expect(page).to have_content "Name can't be blank"
  end
end