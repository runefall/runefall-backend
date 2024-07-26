require "rails_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe Api::V1::CardsController, type: :request do
  before :each do
    @card = create(:card)
    @cards = create_list(:card, 3, associated_card_refs: [@card.card_code])
    @card.update(associated_card_refs: @cards.map do |card|
      card.card_code
    end)
  end

  describe "GET /api/v1/cards/:card_code" do
    it "returns the card with the specified card_code" do
      get "/api/v1/cards/#{@card.card_code}"

      parsed_card = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_card[:id]).to eq(@card.id.to_s)
      expect(parsed_card[:type]).to eq("card")

      card_attributes = parsed_card[:attributes]

      expect(card_attributes[:name]).to eq(@card.name)
      expect(card_attributes[:card_code]).to eq(@card.card_code)
      expect(card_attributes[:description]).to eq(@card.description)
      expect(card_attributes[:description_raw]).to eq(@card.description_raw)
      expect(card_attributes[:levelup_description]).to eq(@card.levelup_description)
      expect(card_attributes[:levelup_description_raw]).to eq(@card.levelup_description_raw)
      expect(card_attributes[:flavor_text]).to eq(@card.flavor_text)
      expect(card_attributes[:artist_name]).to eq(@card.artist_name)
      expect(card_attributes[:attack]).to eq(@card.attack)
      expect(card_attributes[:cost]).to eq(@card.cost)
      expect(card_attributes[:health]).to eq(@card.health)
      expect(card_attributes[:spell_speed]).to eq(@card.spell_speed)
      expect(card_attributes[:rarity]).to eq(@card.rarity)
      expect(card_attributes[:supertype]).to eq(@card.supertype)
      expect(card_attributes[:card_type]).to eq(@card.card_type)
      expect(card_attributes[:collectible]).to eq(@card.collectible)
      expect(card_attributes[:set]).to eq(@card.set)
      expect(card_attributes[:associated_card_refs]).to eq(@card.associated_card_refs)
      expect(card_attributes[:regions]).to eq(@card.regions)
      expect(card_attributes[:region_refs]).to eq(@card.region_refs)
      expect(card_attributes[:keywords]).to eq(@card.keywords)
      expect(card_attributes[:keyword_refs]).to eq(@card.keyword_refs)
      expect(card_attributes[:formats]).to eq(@card.formats)
      expect(card_attributes[:format_refs]).to eq(@card.format_refs)
      expect(card_attributes[:assets].first[:game_absolute_path]).to eq(@card.assets.first["game_absolute_path"])
      expect(card_attributes[:assets].first[:full_absolute_path]).to eq(@card.assets.first["full_absolute_path"])
      expect(card_attributes[:associated_cards].count).to eq(3)
      expect(card_attributes[:associated_cards].first[:card_code]).to eq(@cards.first.card_code)
      expect(card_attributes[:associated_cards].second[:card_code]).to eq(@cards.second.card_code)
      expect(card_attributes[:associated_cards].third[:card_code]).to eq(@cards.third.card_code)
    end

    it "returns a not found error if the card with the specified card_code does not exist" do
      get "/api/v1/cards/non_existent_card_code"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.body).to include("Card not found")
    end
  end

  describe "GET /api/v1/cards" do
    it "returns all cards" do
      get "/api/v1/cards"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(response.body).to include(@cards.first.card_code)
      expect(response.body).to include(@cards.second.card_code)
      expect(response.body).to include(@cards.third.card_code)
      expect(response.body).to include(@card.card_code)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards.count).to eq(4)
      expect(parsed_cards).to be_an(Array)
    end
  end

  describe "GET /api/v1/cards/search" do
    it "returns any card that has an partial name match all of the search queries" do
      card1 = create(:card, name: "Draven")
      card2 = create(
        :card,
        name: "Draven's Whirling Death",
        description: "whirling axe"
      )
      card3 = create(:card, name: "Potato", description: "whirling axe")
      create_list(:card, 3, name: "Draven")
      create_list(:card, 3, name: "Draven", description: "axe")

      get "/api/v1/cards/search?query=drav%20description%3aaxe"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(4)
      expect(response.body).to include(card2.card_code)
      expect(response.body).to_not include(@card.card_code)
      expect(response.body).to_not include(card1.card_code)
      expect(response.body).to_not include(card3.card_code)
    end

    it "searches by name when parameters are separated by a space" do
      card1 = create(:card, name: "Draven")
      card2 = create(
        :card,
        name: "Draven's Whirling Death",
        description: "whirling axe"
      )

      get "/api/v1/cards/search?query=drav%20whir"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card2.card_code)
      expect(response.body).to_not include(card1.card_code)
    end

    it "searches by all parameters and shortcuts" do
      card1 = create(
        :card,
        name: "Billy",
        description: "A description",
        regions: %w[Here There],
        formats: ["Format"],
        keywords: ["Keyword"],
        artist_name: "beelzebub",
        rarity: "notrare",
        set: "set5",
        flavor_text: "chocolate",
        card_type: "type",
        attack: 2,
        cost: 3,
        health: 4
      )

      card2 = create(
        :card,
        name: "Draven's Whirling Death",
        description: "whirling axe",
        regions: %w[Demacia Ionia],
        formats: ["Expedition"],
        keywords: ["Quick Attack"],
        artist_name: "Artist Name",
        rarity: "Champion",
        set: "Set Name",
        flavor_text: "Flavor Text",
        card_type: "Unit",
        attack: 1,
        cost: 2,
        health: 3
      )

      # Search by description

      get "/api/v1/cards/search?query=d%3A%22a%20desc%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=description%3A%22a%20desc%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by regions

      get "/api/v1/cards/search?query=region%3A%22here%2C+there%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=reg%3A%22here%2C+there%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by formats

      get "/api/v1/cards/search?query=format%3A%22format%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=f%3A%22format%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by keywords

      get "/api/v1/cards/search?query=keyword%3A%22keyword%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=k%3A%22keyword%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by artist_name

      get "/api/v1/cards/search?query=artist%3A%22beelzebub%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=a%3A%22beelzebub%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by rarity

      get "/api/v1/cards/search?query=rarity%3A%22notrare%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=r%3A%22notrare%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by set

      get "/api/v1/cards/search?query=set%3A%22set5%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=s%3A%22set5%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by flavor_text

      get "/api/v1/cards/search?query=flavor_text%3A%22chocolate%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=ft%3A%22chocolate%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by card_type

      get "/api/v1/cards/search?query=type%3A%22type%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=t%3A%22type%22"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by multiple parameters

      query = "/api/v1/cards/search?query=" \
              "description%3A%22a%20desc%22%20" \
              "region%3A%22here%2C+there%22%" \
              "20format%3A%22format%22" \
              "%20keyword%3A%22keyword%22" \
              "%20artist%3A%22beelzebub%22" \
              "%20rarity%3A%22notrare%22" \
              "%20set%3A%22set5%22" \
              "%20flavor_text%3A%22chocolate%22" \
              "%20type%3A%22type%22"

      get query

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(response.body).to include(card1.card_code)
      expect(parsed_cards.count).to eq(1)

      # Search for card with name that doesn't exist

      get "/api/v1/cards/search?query=non_existent"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with description that doesn't exist

      get "/api/v1/cards/search?query=description%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with region that doesn't exist

      get "/api/v1/cards/search?query=region%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with format that doesn't exist

      get "/api/v1/cards/search?query=format%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with keyword that doesn't exist

      get "/api/v1/cards/search?query=keyword%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with artist_name that doesn't exist

      get "/api/v1/cards/search?query=artist%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with rarity that doesn't exist

      get "/api/v1/cards/search?query=rarity%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with set that doesn't exist

      get "/api/v1/cards/search?query=set%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with flavor_text that doesn't exist

      get "/api/v1/cards/search?query=flavor_text%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with card_type that doesn't exist

      get "/api/v1/cards/search?query=type%3A%22non_existent%22"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with multiple parameters that don't exist

      query = "/api/v1/cards/search?query=" \
              "description%3A%22non_existent%22%20" \
              "region%3A%22non_existent%22%" \
              "20format%3A%22non_existent%22" \
              "%20keyword%3A%22non_existent%22" \
              "%20artist%3A%22non_existent%22" \
              "%20rarity%3A%22non_existent%22" \
              "%20set%3A%22non_existent%22" \
              "%20flavor_text%3A%22non_existent%22" \
              "%20type%3A%22non_existent%22"

      get query

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)
    end

    it "returns an unsupported query error if an invalid filter is used" do
      get "/api/v1/cards/search?query=drav%20invalid%3aaxe"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to include("invalid is an invalid search query")
    end

    it "returns an unsupported query error if multiple invalid filters are used" do
      get "/api/v1/cards/search?query=drav%20invalid%3aaxe%20invalid2%3aaxe"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to include(
        "[invalid, invalid2] are invalid search queries"
      )
    end

    it "returns an unsupported query error if an invalid filter is used with a valid filter" do
      get "/api/v1/cards/search?query=drav%20invalid%3aaxe%20description%3aaxe"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to include("invalid is an invalid search query")
    end
  end
end
# rubocop:enable Metrics/BlockLength
