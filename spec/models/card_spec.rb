require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'Search' do
    before(:each) do
      @card1 = create(:card, name: "Draven")
      @card2 = create(:card, name: "Draven's Whirling Death", description: "whirling axe")
      @card3 = create(:card, name: "Potato", description: "whirling axe")
      create_list(:card, 3, name: "Draven")
      create_list(:card, 3, name: "Draven", description: "axe")
    end

    it 'returns all cards with fuzzy name matches when a basic search is used' do
      search_hash = {name: "drav"}

      cards = Card.search(search_hash)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(8)
      expect(cards).to include(@card1)
      expect(cards).to_not include(@card3)
    end

    it "returns all cards with fuzzy description matches when the 'description:text' syntax is used" do
      search_hash = {description: "axe"}

      cards = Card.search(search_hash)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(5)
      expect(cards).to include(@card2)
      expect(cards).to_not include(@card1)
    end

    it "returns all cards that satisfy ALL search parameters when multiple search syntaxes are used" do
      search_hash = {name: "drav", description: "axe"}

      cards = Card.search(search_hash)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(4)
      expect(cards).to include(@card2)
      expect(cards).to_not include(@card1)
    end
  end
end