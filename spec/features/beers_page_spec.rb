require "rails_helper"

describe "beers page" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
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