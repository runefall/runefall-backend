require "rails_helper"
require "cgi"

# rubocop:disable Metrics/BlockLength
# rubocop:disable Style/StringConcatenation
RSpec.describe Api::V1::CardsController, type: :request do
  before :each do
    @card = create(:card, id: 1)
    @cards = (2..4).map do |num|
      create(:card, id: num, associated_card_refs: [@card.card_code])
    end
    @card.update(associated_card_refs: @cards.map(&:card_code))
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
        description_raw: "whirling axe"
      )
      card3 = create(:card, name: "Potato", description_raw: "whirling axe")
      create_list(:card, 3, name: "Draven")
      create_list(:card, 3, name: "Draven", description_raw: "axe")

      get "/api/v1/cards/search?query=" + CGI.escape("drav description_raw:axe")

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
        description_raw: "whirling axe"
      )

      get "/api/v1/cards/search?query=" + CGI.escape("drav whir")

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
        description_raw: "A description",
        regions: %w[Here There],
        formats: ["Format", "Other Format"],
        keywords: ["Keyword", "Other Keyword"],
        artist_name: "beelzebub artist",
        rarity: "notrare commonish",
        set: "set5 set6",
        flavor_text: "chocolate vanilla",
        card_type: "type notatype",
        attack: 2,
        cost: 3,
        health: 4
      )

      create(
        :card,
        name: "Draven's Whirling Death",
        description_raw: "whirling axe",
        regions: %w[Demacia Ionia],
        formats: ["Expedition"],
        keywords: ["Quick Attack"],
        artist_name: "Artist Name",
        rarity: "Champion",
        set: "Set Name",
        flavor_text: "Flavor Text",
        card_type: "Unit",
        attack: 6,
        cost: 6,
        health: 6
      )

      # Search by description

      get "/api/v1/cards/search?query=" + CGI.escape('d:"a desc"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('description:"a desc"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('description:"a" description:"desc"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by regions

      get "/api/v1/cards/search?query=" + CGI.escape('region:"here, there"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('reg:"here, there"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('region:"here" region:"there"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      # Search by formats

      get "/api/v1/cards/search?query=" + CGI.escape('format:"format"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('f:"format"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('format:"format" format:"other format"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by keywords

      get "/api/v1/cards/search?query=" + CGI.escape('keyword:"keyword"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('k:"keyword"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('keyword:"keyword" keyword:"other keyword"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by artist_name

      get "/api/v1/cards/search?query=" + CGI.escape('artist:"beelzebub"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('a:"beelzebub"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('artist:"beelzebub" artist:"artist"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by rarity

      get "/api/v1/cards/search?query=" + CGI.escape('rarity:"notrare"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('r:"notrare"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('rarity:"notrare" rarity:"commonish"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by set

      get "/api/v1/cards/search?query=" + CGI.escape('set:"set5"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('s:"set5"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('set:"set5" set:"set6"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by flavor_text

      get "/api/v1/cards/search?query=" + CGI.escape('flavor_text:"chocolate"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('ft:"chocolate"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('flavor_text:"chocolate" flavor_text:"vanilla"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by card_type

      get "/api/v1/cards/search?query=" + CGI.escape('type:"type"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('t:"type"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)
      expect(response.body).to include(card1.card_code)

      get "/api/v1/cards/search?query=" + CGI.escape('type:"type" type:"notatype"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(parsed_cards.count).to eq(1)

      # Search by multiple parameters

      url = "/api/v1/cards/search?query="

      query = 'description:"a desc" ' \
              'region:"here, there" ' \
              'format:"format" ' \
              'keyword:"keyword" ' \
              'artist:"beelzebub" ' \
              'rarity:"notrare" ' \
              'set:"set5" ' \
              'flavor_text:"chocolate" ' \
              'type:"type"'

      get url + CGI.escape(query)

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

      get "/api/v1/cards/search?query=" + CGI.escape('description:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with region that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('region:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with format that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('format:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with keyword that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('keyword:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with artist_name that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('artist:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with rarity that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('rarity:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with set that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('set:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with flavor_text that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('flavor_text:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with card_type that doesn't exist

      get "/api/v1/cards/search?query=" + CGI.escape('type:"non_existent"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for card with multiple parameters that don't exist

      url = "/api/v1/cards/search?query="
      query = 'description:"non_existent" ' \
              'region:"non_existent" ' \
              'format:"non_existent" ' \
              'keyword:"non_existent" ' \
              'artist:"non_existent" ' \
              'rarity:"non_existent" ' \
              'set:"non_existent" ' \
              'flavor_text:"non_existent" ' \
              'type:"non_existent" '

      get url + CGI.escape(query)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)
    end

    it "does not break when given unexpected characters" do
      query = "`~!@#$%^&*()_+-=[]{}|;':,.<>?\\\"/"

      get "/api/v1/cards/search?query=#{CGI.escape(query)}"

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it "returns an unsupported query error if an invalid filter is used" do
      get "/api/v1/cards/search?query=" + CGI.escape("drav invalid:axe")

      expect(response).to be_successful
      expect(response.status).to eq(200)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:error]).to eq(["invalid is an invalid search parameter"])
    end

    it "returns an unsupported query error if multiple invalid filters are used" do
      get "/api/v1/cards/search?query=" + CGI.escape("drav invalid:axe invalid2:axe")

      expect(response).to be_successful
      expect(response.status).to eq(200)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:error]).to eq([
        "invalid is an invalid search parameter",
        "invalid2 is an invalid search parameter"
      ])
    end

    it "returns an unsupported query error if an invalid filter is used with a valid filter" do
      get "/api/v1/cards/search?query=" + CGI.escape("drav invalid:axe description:axe")

      expect(response).to be_successful
      expect(response.status).to eq(200)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:error]).to eq(["invalid is an invalid search parameter"])
    end

    it "ignores 'mode', 'attribute', and 'direction' parameters" do
      get "/api/v1/cards/search?query=" + CGI.escape("#{@card.name} mode:image attribute:something direction:desc")

      expect(response).to be_successful
      expect(response.status).to eq(200)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:error]).to eq([])
      expect(body[:data].count > 0).to eq(true)
    end

    it "can search by attack, cost, and health" do
      create(:card, attack: 100, cost: 100, health: 100)

      # Search for cards by cost

      get "/api/v1/cards/search?query=" + CGI.escape("cost:=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("cost:>99")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("cost:<101")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(5)

      get "/api/v1/cards/search?query=" + CGI.escape("cost:<=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(5)

      get "/api/v1/cards/search?query=" + CGI.escape("cost:>=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("cost:=101")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for cards by attack

      get "/api/v1/cards/search?query=" + CGI.escape("attack:=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("attack:>99")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("attack:<101")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(5)

      get "/api/v1/cards/search?query=" + CGI.escape("attack:<=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(5)

      get "/api/v1/cards/search?query=" + CGI.escape("attack:>=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("attack:=101")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)

      # Search for cards by health

      get "/api/v1/cards/search?query=" + CGI.escape("health:=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      get "/api/v1/cards/search?query=" + CGI.escape("health:100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("health:>99")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("health:<101")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(5)

      get "/api/v1/cards/search?query=" + CGI.escape("health:<=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(5)

      get "/api/v1/cards/search?query=" + CGI.escape("health:>=100")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(1)

      get "/api/v1/cards/search?query=" + CGI.escape("health:=101")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(0)
    end

    it "does not break when given unexpected characters" do
      get "/api/v1/cards/search?query=" + CGI.escape("attack:a")

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards[:data]).to be_an(Array)
      expect(parsed_cards[:data].count).to eq(0)

      get "/api/v1/cards/search?query=" + CGI.escape('cost:="a"')

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_cards[:data]).to be_an(Array)
      expect(parsed_cards[:data].count).to eq(0)
    end

    it 'will split a query if there is an OR in the query and parse cards for each set of filters, combining the results' do
      impossible_card = create(:card, name: "Impossible Card")
      possible_card = create(:card, name: "Possible Card")

      get "/api/v1/cards/search?query=" + CGI.escape('name:"impossible card" OR name:"possible card"')

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(2)
      expect(response.body).to include(impossible_card.card_code)
      expect(response.body).to include(possible_card.card_code)
    end
  end

  describe "GET /api/v1/cards/random" do
    it "returns a random card" do
      get "/api/v1/cards/random"

      parsed_card = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_card[:type]).to eq("card")

      card_attributes = parsed_card[:attributes]

      expect(card_attributes).to have_key(:name)
      expect(card_attributes).to have_key(:card_code)
      expect(card_attributes).to have_key(:description)
    end

    it "accepts a query parameter of limit that lets you return multiple random cards up to the limit" do
      get "/api/v1/cards/random?limit=2"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards.count).to eq(2)

      parsed_cards.each do |card|
        expect(card[:type]).to eq("card")

        card_attributes = card[:attributes]

        expect(card_attributes).to have_key(:name)
        expect(card_attributes).to have_key(:card_code)
        expect(card_attributes).to have_key(:description)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Style/StringConcatenation
