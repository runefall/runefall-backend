require "rails_helper"

RSpec.describe Card, type: :model do
  describe "Search" do
    before(:each) do
      @card1 = create(:card, name: "Draven")

      @card2 = create(
        :card,
        name: "Draven's Whirling Death",
        description_raw: "whirling axe"
      )

      @card3 = create(:card, name: "Potato", description_raw: "whirling axe")

      create_list(:card, 3, name: "Draven")
      create_list(:card, 3, name: "Draven", description_raw: "axe")
    end

    it "returns all cards with fuzzy name matches when a basic search is used" do
      search_array = [{ name: ["drav"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(8)
      expect(cards).to include(@card1)
      expect(cards).to_not include(@card3)
    end

    it "returns all cards with fuzzy description matches when the 'description_raw:text' syntax is used" do
      search_array = [{ description_raw: ["axe"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(5)
      expect(cards).to include(@card2)
      expect(cards).to_not include(@card1)
    end

    it "returns all cards that satisfy ALL search parameters when multiple search syntaxes are used" do
      search_array = [{ name: ["drav"], description_raw: ["axe"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(4)
      expect(cards).to include(@card2)
      expect(cards).to_not include(@card1)
    end

    it "returns all cards that satisfy ALL search parameters when multiple of the same search stynax is used and not just the last of that syntax" do
      temp_card = create(
        :card,
        name: "Darius's Whirling Death",
        description_raw: "whirling axe"
      )

      search_array = [{ name: %w[dar whir] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card2)
    end

    it "returns a card based on the rarity, artist_name, set, flavor_text, and card_type with partial case-insensitive matches" do
      temp_card = create(
        :card,
        rarity: "Champion",
        artist_name: "SIXMOREVODKA",
        set: "Set1",
        flavor_text: "flavor text",
        card_type: "Unit22",
        regions: ["Regionland"],
        formats: ["Nonstandard"],
        keywords: ["Slow Attack"]
      )

      search_array = [{ rarity: ["champio"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ artist_name: ["sixmorevodk"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ set: ["set1"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ flavor_text: ["flavor tex"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ card_type: ["unit2"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ regions: %w[regionland Other] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ formats: %w[nonstandard Other] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      search_array = [{ keywords: ["slow attack", "Other"] }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)

      search_array = [{
        rarity: ["champio"],
        artist_name: ["sixmorevodk"],
        set: ["set1"],
        flavor_text: ["flavor tex"],
        card_type: ["unit2"],
        regions: %w[regionland Other],
        formats: %w[nonstandard Other],
        keywords: ["slow attack", "Other"]
      }]

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)

      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(1)
      expect(cards).to include(temp_card)
      expect(cards).to_not include(@card1)
    end

    it "can accept two different sets of filters and combine the results" do
      search_array = [
        { name: ["potato"] },
        { name: ["draven's whirling death"] }
      ]
      cards = Card.search(search_array)

      expect(cards).to be_an(ActiveRecord::Relation)
      expect(cards.count).to eq(2)
      expect(cards).to include(@card2)
      expect(cards).to include(@card3)
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
    end

    it "can return multiple random cards" do
      cards = Card.random_cards(5)

      expect(cards.count).to eq(5)
      expect(cards).to all be_a Card
      expect(cards.uniq.count).to eq(5)
    end
  end
end
