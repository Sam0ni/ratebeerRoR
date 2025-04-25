require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "can be created with parameters defined" do
    brewery = Brewery.create name: "Saimaan Panimo", year: 1983
    beer = Beer.create name: "Sour", brewery_id: brewery.id, style: "Sour"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "can't be created without name" do
    brewery = Brewery.create name: "Saimaan Panimo", year: 1983
    beer = Beer.create brewery_id: brewery.id, style: "Sour"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "can't be created without style" do
    brewery = Brewery.create name: "Saimaan Panimo", year: 1983
    beer = Beer.create name: "sour", brewery_id: brewery.id

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
