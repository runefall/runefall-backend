require "rails_helper"

RSpec.describe Card, type: :model do
  describe "Search" do
    before(:each) do
      @card1 = create(:card, name: "Draven")
      @card2 = create(:card, name: "Draven's Whirling Death",
                             description: "whirling axe")
      @card3 = create(:card, name: "Potato", description: "whirling axe")
      create_list(:card, 3, name: "Draven")
      create_list(:card, 3, name: "Draven", description: "axe")
    end

    it "returns all cards with fuzzy name matches when a basic search is used" do
      search_array = [{ name: "drav" }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(8)
      expect(cards).to include(@card1)
      expect(cards).to_not include(@card3)
    end

    it "returns all cards with fuzzy description matches when the 'description:text' syntax is used" do
      search_array = [{ description: "axe" }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(5)
      expect(cards).to include(@card2)
      expect(cards).to_not include(@card1)
    end

    it "returns all cards that satisfy ALL search parameters when multiple search syntaxes are used" do
      search_array = [{ name: "drav" }, { description: "axe" }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(4)
      expect(cards).to include(@card2)
      expect(cards).to_not include(@card1)
    end

    it "returns all cards that satisfy ALL search parameters when multiple of the same search stynax is used and not just the last of that syntax" do
      temp_card = create(:card, name: "Darius's Whirling Death",
                                description: "whirling axe")
      search_array = [{ name: "dar" }, { name: "whirl" }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card2)
    end
  end

  describe "#random_cards" do
    before(:each) do
      (1..10).each do |num|
        create(:card, id: num)
      end
    end

    it "can return a single random card" do
      card = Card.random_cards(1)

      expect(card).to be_a Card

      different_card = Card.random_cards(1)

      expect(card).to_not eq(different_card)
    end

    it 'can return multiple random cards' do
      cards = Card.random_cards(5)

      expect(cards.count).to eq(5)
      expect(cards).to all be_a Card
    end
  end
end
