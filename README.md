# Runefall

## Table of Contents
- [About](#about)
- [Development Setup](#development-setup)
- [External APIs and Services](#external-apis-and-services)
- [End Points](#end-points)
- [Contributors](#contributors)

## About
The Runefall backend service provides an advanced search to filter and query a list of cards available in the videogame Legends of Runeterra. 

You can find a live version of this service being utilized [here.](https://runefall.netlify.app/)

## Development Setup

This guide assumes you have installed [Rails 7.1.3](https://guides.rubyonrails.org/v7.1/getting_started.html) and [PostgreSQL >= 14](https://www.postgresql.org/download/)

First, clone the repository to your computer

```sh
git clone git@github.com:runefall/runefall-backend.git
```

Next, install all of the Gems

```sh
bundle install
```

Create, migrate, and seed the databases

```sh
rails db:{create,migrate,seed}
```

Finally, start the development server

```sh
rails s
```

The API will be served on `localhost:3000`.

Run the test suite to diagnose issues

```sh
bundle exec rspec
```

## External APIs and Services
#### Legends of Runeterra API
  - In our application, we utilize the Legends of Runeterra API as provided by Riot Games. For this, they provide raw JSON data about all of the previous and current cards available in Legends of Runeterra. We store this data in our database to allow for fast and advanced searching capabilities.

  - [Legends of Runeterra API Documentation](https://developer.riotgames.com/docs/lor#data-dragon_core-bundles)

## End Points
### Cards
<details>
<summary> Get One Card </summary>

Request:

```http
GET /api/v1/cards/:card_code
Content-Type: application/json
Accept: application/json
```

Response: `status: 200`

```json
{
    "data": {
        "id": "70",
        "type": "card",
        "attributes": {
            "name": "Draven",
            "card_code": "01NX020",
            "description": "When I'm summoned or <link=vocab.Strike><style=Vocab>strike</style></link>: Create a <link=card.create><style=AssociatedCard>Spinning Axe</style></link> in hand.",
            "description_raw": "When I'm summoned or strike: Create a Spinning Axe in hand.",
            "levelup_description": "I've <link=vocab.Strike><style=Vocab>struck</style></link> with 2+ total <link=card.create><style=AssociatedCard>Spinning Axes</style></link>.<style=Variable></style>",
            "levelup_description_raw": "I've struck with 2+ total Spinning Axes.",
            "flavor_text": "\"You want an autograph? Get in line, pal.\"",
            "artist_name": "SIXMOREVODKA",
            "attack": 3,
            "cost": 3,
            "health": 3,
            "spell_speed": "",
            "rarity": "Champion",
            "supertype": "Champion",
            "card_type": "Unit",
            "collectible": true,
            "set": "Set1",
            "associated_card_refs": [
                "01NX020T1",
                "01NX020T3",
                "01NX020T2"
            ],
            "regions": [
                "Noxus"
            ],
            "region_refs": [
                "Noxus"
            ],
            "keywords": [
                "Quick Attack"
            ],
            "keyword_refs": [
                "QuickStrike"
            ],
            "formats": [
                "Commons Only",
                "Eternal"
            ],
            "format_refs": [
                "client_Formats_CommonsOnly_name",
                "client_Formats_Eternal_name"
            ],
            "assets": [
                {
                    "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020.png",
                    "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020-full.png"
                }
            ],
            "associated_cards": [
                {
                    "id": 73,
                    "name": "Spinning Axe",
                    "card_code": "01NX020T1",
                    "description": "To play, discard 1.\r\nGive an ally +1|+0 this round.",
                    "description_raw": "To play, discard 1.\r\nGive an ally +1|+0 this round.",
                    "levelup_description": "",
                    "levelup_description_raw": "",
                    "flavor_text": "\"Yeah, his brother'd win one-on-one, but you see those axes spiraling... it's art, it is. Art.\" - Arena regular",
                    "artist_name": "SIXMOREVODKA",
                    "attack": 0,
                    "cost": 0,
                    "health": 0,
                    "spell_speed": "Burst",
                    "rarity": "None",
                    "supertype": "",
                    "card_type": "Spell",
                    "collectible": false,
                    "set": "Set1",
                    "associated_card_refs": [
                        "01NX020"
                    ],
                    "regions": [
                        "Noxus"
                    ],
                    "region_refs": [
                        "Noxus"
                    ],
                    "keywords": [
                        "Burst"
                    ],
                    "keyword_refs": [
                        "Burst"
                    ],
                    "formats": [
                        "Eternal",
                        "Standard"
                    ],
                    "format_refs": [
                        "client_Formats_Eternal_name",
                        "client_Formats_Standard_name"
                    ],
                    "assets": [
                        {
                            "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T1.png",
                            "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T1-full.png"
                        }
                    ],
                    "created_at": "2024-07-05T16:01:27.649Z",
                    "updated_at": "2024-07-05T16:01:27.649Z"
                },
                {
                    "id": 71,
                    "name": "Draven",
                    "card_code": "01NX020T3",
                    "description": "When I'm summoned or <link=vocab.Strike><style=Vocab>strike</style></link>: Create 2 <link=card.create><style=AssociatedCard>Spinning Axes</style></link> in hand.",
                    "description_raw": "When I'm summoned or strike: Create 2 Spinning Axes in hand.",
                    "levelup_description": "",
                    "levelup_description_raw": "",
                    "flavor_text": "\"WHAT'S MY NAME?\"",
                    "artist_name": "SIXMOREVODKA",
                    "attack": 4,
                    "cost": 3,
                    "health": 4,
                    "spell_speed": "",
                    "rarity": "None",
                    "supertype": "Champion",
                    "card_type": "Unit",
                    "collectible": false,
                    "set": "Set1",
                    "associated_card_refs": [
                        "01NX020T2",
                        "01NX020",
                        "01NX020T1"
                    ],
                    "regions": [
                        "Noxus"
                    ],
                    "region_refs": [
                        "Noxus"
                    ],
                    "keywords": [
                        "Quick Attack",
                        "Overwhelm"
                    ],
                    "keyword_refs": [
                        "QuickStrike",
                        "Overwhelm"
                    ],
                    "formats": [
                        "Eternal",
                        "Standard"
                    ],
                    "format_refs": [
                        "client_Formats_Eternal_name",
                        "client_Formats_Standard_name"
                    ],
                    "assets": [
                        {
                            "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T3.png",
                            "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T3-full.png"
                        }
                    ],
                    "created_at": "2024-07-05T16:01:27.641Z",
                    "updated_at": "2024-07-05T16:01:27.641Z"
                },
                {
                    "id": 72,
                    "name": "Draven's Whirling Death",
                    "card_code": "01NX020T2",
                    "description": "A battling ally <link=vocab.Strike><style=Vocab>strikes</style></link> a battling enemy.\r\nCreate a <link=card.level1><style=AssociatedCard>Draven</style></link> in your deck.",
                    "description_raw": "A battling ally strikes a battling enemy.\r\nCreate a Draven in your deck.",
                    "levelup_description": "",
                    "levelup_description_raw": "",
                    "flavor_text": "\"I have the best job.\" - Draven",
                    "artist_name": "Rafael Zanchetin",
                    "attack": 0,
                    "cost": 3,
                    "health": 0,
                    "spell_speed": "Fast",
                    "rarity": "None",
                    "supertype": "Champion",
                    "card_type": "Spell",
                    "collectible": false,
                    "set": "Set1",
                    "associated_card_refs": [
                        "01NX020T3",
                        "01NX020"
                    ],
                    "regions": [
                        "Noxus"
                    ],
                    "region_refs": [
                        "Noxus"
                    ],
                    "keywords": [
                        "Fast"
                    ],
                    "keyword_refs": [
                        "Fast"
                    ],
                    "formats": [
                        "Eternal",
                        "Standard"
                    ],
                    "format_refs": [
                        "client_Formats_Eternal_name",
                        "client_Formats_Standard_name"
                    ],
                    "assets": [
                        {
                            "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T2.png",
                            "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T2-full.png"
                        }
                    ],
                    "created_at": "2024-07-05T16:01:27.645Z",
                    "updated_at": "2024-07-05T16:01:27.645Z"
                }
            ]
        }
    }
}
```
</details>

<details>
<summary> Get All Cards </summary>

Request:

```http
GET /api/v1/cards
Content-Type: application/json
Accept: application/json
```

Response: `status: 200`

```json
{
    "data": [
        {
            "id": "1",
            "type": "multi_card",
            "attributes": {
                "name": "Twin Disciplines",
                "card_code": "01IO012",
                "description": "Give an ally +3|+0 or +0|+3 this round.",
                "description_raw": "Give an ally +3|+0 or +0|+3 this round.",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "\"Never fear change. It will question you, test your limits. It is our greatest teacher.\" - Karma",
                "artist_name": "SIXMOREVODKA",
                "attack": 0,
                "cost": 2,
                "health": 0,
                "spell_speed": "Burst",
                "rarity": "COMMON",
                "supertype": "",
                "card_type": "Spell",
                "collectible": true,
                "set": "Set1",
                "associated_card_refs": [],
                "regions": [
                    "Ionia"
                ],
                "region_refs": [
                    "Ionia"
                ],
                "keywords": [
                    "Burst"
                ],
                "keyword_refs": [
                    "Burst"
                ],
                "formats": [
                    "Commons Only",
                    "Eternal"
                ],
                "format_refs": [
                    "client_Formats_CommonsOnly_name",
                    "client_Formats_Eternal_name"
                ],
                "assets": [
                    {
                        "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01IO012.png",
                        "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01IO012-full.png"
                    }
                ]
            }
        },
        {
            "id": "2",
            "type": "multi_card",
            "attributes": {
                "name": "Discipline of Fortitude",
                "card_code": "01IO012T2",
                "description": "Give an ally +0|+3 this round.",
                "description_raw": "Give an ally +0|+3 this round.",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "",
                "artist_name": "SIXMOREVODKA",
                "attack": 0,
                "cost": 2,
                "health": 0,
                "spell_speed": "Burst",
                "rarity": "None",
                "supertype": "",
                "card_type": "Spell",
                "collectible": false,
                "set": "Set1",
                "associated_card_refs": [],
                "regions": [
                    "Ionia"
                ],
                "region_refs": [
                    "Ionia"
                ],
                "keywords": [
                    "Burst"
                ],
                "keyword_refs": [
                    "Burst"
                ],
                "formats": [
                    "Eternal",
                    "Standard"
                ],
                "format_refs": [
                    "client_Formats_Eternal_name",
                    "client_Formats_Standard_name"
                ],
                "assets": [
                    {
                        "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01IO012T2.png",
                        "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01IO012T2-full.png"
                    }
                ]
            }
        },
        ...,
        ...
    ]
}
```
</details>

<details>
<summary> Search All Cards </summary>

Request:

```http
GET /api/v1/cards/search?query={attribute:value}
Content-Type: application/json
Accept: application/json
```

Example Request:

```http
GET /api/v1/cards/search?query=drav%20description%3aaxe
```

Query Requirements:

- Different filters should be separated by spaces
- All filters (except name) should be formatted in the "attribute:value" syntax where the attribute and value are separated by a colon

Accepted Queries: 

- Name as "value" or "name:value"
- Description as "description:value"


Response: `status: 200`

```json
{
    "data": [
        {
            "id": "70",
            "type": "card",
            "attributes": {
                "name": "Draven",
                "card_code": "01NX020",
                "description": "When I'm summoned or <link=vocab.Strike><style=Vocab>strike</style></link>: Create a <link=card.create><style=AssociatedCard>Spinning Axe</style></link> in hand.",
                "description_raw": "When I'm summoned or strike: Create a Spinning Axe in hand.",
                "levelup_description": "I've <link=vocab.Strike><style=Vocab>struck</style></link> with 2+ total <link=card.create><style=AssociatedCard>Spinning Axes</style></link>.<style=Variable></style>",
                "levelup_description_raw": "I've struck with 2+ total Spinning Axes.",
                "flavor_text": "\"You want an autograph? Get in line, pal.\"",
                "artist_name": "SIXMOREVODKA",
                "attack": 3,
                "cost": 3,
                "health": 3,
                "spell_speed": "",
                "rarity": "Champion",
                "supertype": "Champion",
                "card_type": "Unit",
                "collectible": true,
                "set": "Set1",
                "associated_card_refs": [
                    "01NX020T1",
                    "01NX020T3",
                    "01NX020T2"
                ],
                "regions": [
                    "Noxus"
                ],
                "region_refs": [
                    "Noxus"
                ],
                "keywords": [
                    "Quick Attack"
                ],
                "keyword_refs": [
                    "QuickStrike"
                ],
                "formats": [
                    "Commons Only",
                    "Eternal"
                ],
                "format_refs": [
                    "client_Formats_CommonsOnly_name",
                    "client_Formats_Eternal_name"
                ],
                "assets": [
                    {
                        "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020.png",
                        "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020-full.png"
                    }
                ],
                "associated_cards": [
                    {
                        "id": 73,
                        "name": "Spinning Axe",
                        "card_code": "01NX020T1",
                        "description": "To play, discard 1.\r\nGive an ally +1|+0 this round.",
                        "description_raw": "To play, discard 1.\r\nGive an ally +1|+0 this round.",
                        "levelup_description": "",
                        "levelup_description_raw": "",
                        "flavor_text": "\"Yeah, his brother'd win one-on-one, but you see those axes spiraling... it's art, it is. Art.\" - Arena regular",
                        "artist_name": "SIXMOREVODKA",
                        "attack": 0,
                        "cost": 0,
                        "health": 0,
                        "spell_speed": "Burst",
                        "rarity": "None",
                        "supertype": "",
                        "card_type": "Spell",
                        "collectible": false,
                        "set": "Set1",
                        "associated_card_refs": [
                            "01NX020"
                        ],
                        "regions": [
                            "Noxus"
                        ],
                        "region_refs": [
                            "Noxus"
                        ],
                        "keywords": [
                            "Burst"
                        ],
                        "keyword_refs": [
                            "Burst"
                        ],
                        "formats": [
                            "Eternal",
                            "Standard"
                        ],
                        "format_refs": [
                            "client_Formats_Eternal_name",
                            "client_Formats_Standard_name"
                        ],
                        "assets": [
                            {
                                "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T1.png",
                                "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T1-full.png"
                            }
                        ],
                        "created_at": "2024-07-05T16:01:27.649Z",
                        "updated_at": "2024-07-05T16:01:27.649Z"
                    },
                    {
                        "id": 71,
                        "name": "Draven",
                        "card_code": "01NX020T3",
                        "description": "When I'm summoned or <link=vocab.Strike><style=Vocab>strike</style></link>: Create 2 <link=card.create><style=AssociatedCard>Spinning Axes</style></link> in hand.",
                        "description_raw": "When I'm summoned or strike: Create 2 Spinning Axes in hand.",
                        "levelup_description": "",
                        "levelup_description_raw": "",
                        "flavor_text": "\"WHAT'S MY NAME?\"",
                        "artist_name": "SIXMOREVODKA",
                        "attack": 4,
                        "cost": 3,
                        "health": 4,
                        "spell_speed": "",
                        "rarity": "None",
                        "supertype": "Champion",
                        "card_type": "Unit",
                        "collectible": false,
                        "set": "Set1",
                        "associated_card_refs": [
                            "01NX020T2",
                            "01NX020",
                            "01NX020T1"
                        ],
                        "regions": [
                            "Noxus"
                        ],
                        "region_refs": [
                            "Noxus"
                        ],
                        "keywords": [
                            "Quick Attack",
                            "Overwhelm"
                        ],
                        "keyword_refs": [
                            "QuickStrike",
                            "Overwhelm"
                        ],
                        "formats": [
                            "Eternal",
                            "Standard"
                        ],
                        "format_refs": [
                            "client_Formats_Eternal_name",
                            "client_Formats_Standard_name"
                        ],
                        "assets": [
                            {
                                "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T3.png",
                                "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T3-full.png"
                            }
                        ],
                        "created_at": "2024-07-05T16:01:27.641Z",
                        "updated_at": "2024-07-05T16:01:27.641Z"
                    },
                    {
                        "id": 72,
                        "name": "Draven's Whirling Death",
                        "card_code": "01NX020T2",
                        "description": "A battling ally <link=vocab.Strike><style=Vocab>strikes</style></link> a battling enemy.\r\nCreate a <link=card.level1><style=AssociatedCard>Draven</style></link> in your deck.",
                        "description_raw": "A battling ally strikes a battling enemy.\r\nCreate a Draven in your deck.",
                        "levelup_description": "",
                        "levelup_description_raw": "",
                        "flavor_text": "\"I have the best job.\" - Draven",
                        "artist_name": "Rafael Zanchetin",
                        "attack": 0,
                        "cost": 3,
                        "health": 0,
                        "spell_speed": "Fast",
                        "rarity": "None",
                        "supertype": "Champion",
                        "card_type": "Spell",
                        "collectible": false,
                        "set": "Set1",
                        "associated_card_refs": [
                            "01NX020T3",
                            "01NX020"
                        ],
                        "regions": [
                            "Noxus"
                        ],
                        "region_refs": [
                            "Noxus"
                        ],
                        "keywords": [
                            "Fast"
                        ],
                        "keyword_refs": [
                            "Fast"
                        ],
                        "formats": [
                            "Eternal",
                            "Standard"
                        ],
                        "format_refs": [
                            "client_Formats_Eternal_name",
                            "client_Formats_Standard_name"
                        ],
                        "assets": [
                            {
                                "gameAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T2.png",
                                "fullAbsolutePath": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01NX020T2-full.png"
                            }
                        ],
                        "created_at": "2024-07-05T16:01:27.645Z",
                        "updated_at": "2024-07-05T16:01:27.645Z"
                    }
                ]
            }
        },
    ...,
    ...
    ]
}
```
</details>

<details>
<summary> Get Random Cards</summary>

Request:

```http
GET /api/v1/cards/random
Content-Type: application/json
Accept: application/json
```

Response: `status: 200`

```json
{
    "data": {
        "id": "2158",
        "type": "card",
        "attributes": {
            "name": "The Swindler's Den",
            "card_code": "07BW035",
            "description": "Your cards in hand have <link=keyword.Fleeting><sprite name=Fleeting><style=Keyword>Fleeting</style></link>.\r\nWhen you play a card, draw 1.",
            "description_raw": "Your cards in hand have Fleeting.\r\nWhen you play a card, draw 1.",
            "levelup_description": "",
            "levelup_description_raw": "",
            "flavor_text": "\"I reckon you ought to know your hand and hold it close, or be prepared to lose it all.\" - Twisted Fate",
            "artist_name": "Envar Studio",
            "attack": 0,
            "cost": 6,
            "health": 0,
            "spell_speed": "",
            "rarity": "EPIC",
            "supertype": "",
            "card_type": "Landmark",
            "collectible": true,
            "set": "Set7b",
            "associated_card_refs": [],
            "regions": [
                "Bilgewater"
            ],
            "region_refs": [
                "Bilgewater"
            ],
            "keywords": [
                "Landmark"
            ],
            "keyword_refs": [
                "LandmarkVisualOnly"
            ],
            "formats": [
                "Eternal",
                "Standard"
            ],
            "format_refs": [
                "client_Formats_Eternal_name",
                "client_Formats_Standard_name"
            ],
            "assets": [
                {
                    "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set7b/en_us/img/cards/07BW035.png",
                    "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set7b/en_us/img/cards/07BW035-full.png"
                }
            ],
            "associated_cards": []
        }
    }
}
```

## Parameters
The `GET random cards` endpoint can also take in the query parameter of `limit` where it returns a number of random cards up to the limit or total number of cards.

### Example Request: 
```
GET /api/v1/cards/random?limit=5
Content-Type: application/json  
Accept: application/json  
```

### Response: ` status: 200 `  
```
{
    "data": [
        {
            "id": "287",
            "type": "card",
            "attributes": {
                "name": "Tryndamere's Battle Fury",
                "card_code": "01FR039T1",
                "description": "Grant an ally +8|+4.\r\nCreate a <link=card.level1><style=AssociatedCard>Tryndamere</style></link> in your deck.",
                "description_raw": "Grant an ally +8|+4.\r\nCreate a Tryndamere in your deck.",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "“I've been told I have a... temper.” - Tryndamere",
                "artist_name": "SIXMOREVODKA",
                "attack": 0,
                "cost": 8,
                "health": 0,
                "spell_speed": "Burst",
                "rarity": "None",
                "supertype": "Champion",
                "card_type": "Spell",
                "collectible": false,
                "set": "Set1",
                "associated_card_refs": [
                    "01FR039",
                    "01FR039T2"
                ],
                "regions": [
                    "Freljord"
                ],
                "region_refs": [
                    "Freljord"
                ],
                "keywords": [
                    "Burst"
                ],
                "keyword_refs": [
                    "Burst"
                ],
                "formats": [
                    "Eternal",
                    "Standard"
                ],
                "format_refs": [
                    "client_Formats_Eternal_name",
                    "client_Formats_Standard_name"
                ],
                "assets": [
                    {
                        "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01FR039T1.png",
                        "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01FR039T1-full.png"
                    }
                ],
                "associated_cards": [
                    {
                        "id": 286,
                        "name": "Tryndamere",
                        "card_code": "01FR039",
                        "description": "",
                        "description_raw": "",
                        "levelup_description": "If I would die, I Level Up instead.",
                        "levelup_description_raw": "If I would die, I Level Up instead.",
                        "flavor_text": "\"Do not die for your cause. Live for it...\"",
                        "artist_name": "SIXMOREVODKA",
                        "attack": 8,
                        "cost": 8,
                        "health": 6,
                        "spell_speed": "",
                        "rarity": "Champion",
                        "supertype": "Champion",
                        "card_type": "Unit",
                        "collectible": true,
                        "set": "Set1",
                        "associated_card_refs": [
                            "01FR039T2",
                            "01FR039T1"
                        ],
                        "regions": [
                            "Freljord"
                        ],
                        "region_refs": [
                            "Freljord"
                        ],
                        "keywords": [
                            "Overwhelm"
                        ],
                        "keyword_refs": [
                            "Overwhelm"
                        ],
                        "formats": [
                            "Commons Only",
                            "Eternal"
                        ],
                        "format_refs": [
                            "client_Formats_CommonsOnly_name",
                            "client_Formats_Eternal_name"
                        ],
                        "assets": [
                            {
                                "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01FR039.png",
                                "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01FR039-full.png"
                            }
                        ],
                        "created_at": "2024-07-07T17:38:18.760Z",
                        "updated_at": "2024-07-07T17:38:18.760Z",
                        "associated_cards": []
                    },
                    {
                        "id": 288,
                        "name": "Tryndamere",
                        "card_code": "01FR039T2",
                        "description": "",
                        "description_raw": "",
                        "levelup_description": "",
                        "levelup_description_raw": "",
                        "flavor_text": "\"...And make THEM die for it.\"",
                        "artist_name": "SIXMOREVODKA",
                        "attack": 9,
                        "cost": 8,
                        "health": 9,
                        "spell_speed": "",
                        "rarity": "None",
                        "supertype": "Champion",
                        "card_type": "Unit",
                        "collectible": false,
                        "set": "Set1",
                        "associated_card_refs": [
                            "01FR039",
                            "01FR039T1"
                        ],
                        "regions": [
                            "Freljord"
                        ],
                        "region_refs": [
                            "Freljord"
                        ],
                        "keywords": [
                            "Overwhelm",
                            "Fearsome",
                            "Tough"
                        ],
                        "keyword_refs": [
                            "Overwhelm",
                            "Fearsome",
                            "Tough"
                        ],
                        "formats": [
                            "Eternal",
                            "Standard"
                        ],
                        "format_refs": [
                            "client_Formats_Eternal_name",
                            "client_Formats_Standard_name"
                        ],
                        "assets": [
                            {
                                "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01FR039T2.png",
                                "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set1/en_us/img/cards/01FR039T2-full.png"
                            }
                        ],
                        "created_at": "2024-07-07T17:38:18.763Z",
                        "updated_at": "2024-07-07T17:38:18.763Z",
                        "associated_cards": []
                    }
                ]
            }
        },
        {
            "id": "1104",
            "type": "card",
            "attributes": {
                "name": "Frostguard Thrall",
                "card_code": "04FR001T1",
                "description": "",
                "description_raw": "",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "Freed from its icy tomb, the corrupted troll knew one thing, and one thing only - it must do as its dark mistress commanded.",
                "artist_name": "Kudos Productions",
                "attack": 8,
                "cost": 8,
                "health": 8,
                "spell_speed": "",
                "rarity": "None",
                "supertype": "",
                "card_type": "Unit",
                "collectible": false,
                "set": "Set4",
                "associated_card_refs": [],
                "regions": [
                    "Freljord"
                ],
                "region_refs": [
                    "Freljord"
                ],
                "keywords": [
                    "Overwhelm"
                ],
                "keyword_refs": [
                    "Overwhelm"
                ],
                "formats": [
                    "Eternal",
                    "Standard"
                ],
                "format_refs": [
                    "client_Formats_Eternal_name",
                    "client_Formats_Standard_name"
                ],
                "assets": [
                    {
                        "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set4/en_us/img/cards/04FR001T1.png",
                        "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set4/en_us/img/cards/04FR001T1-full.png"
                    }
                ],
                "associated_cards": []
            }
        },
        {
            "id": "1163",
            "type": "card",
            "attributes": {
                "name": "Symmetry In Stars",
                "card_code": "04SI012T1",
                "description": "Kill an ally to deal 3 to the enemy Nexus.",
                "description_raw": "Kill an ally to deal 3 to the enemy Nexus.",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "\"Now you'll truly shine!\" - Astral Fox",
                "artist_name": "Kudos Productions",
                "attack": 0,
                "cost": 0,
                "health": 0,
                "spell_speed": "",
                "rarity": "None",
                "supertype": "",
                "card_type": "Ability",
                "collectible": false,
                "set": "Set4",
                "associated_card_refs": [],
                "regions": [
                    "Shadow Isles"
                ],
                "region_refs": [
                    "ShadowIsles"
                ],
                "keywords": [
                    "Skill"
                ],
                "keyword_refs": [
                    "Skill"
                ],
                "formats": [
                    "Eternal",
                    "Standard"
                ],
                "format_refs": [
                    "client_Formats_Eternal_name",
                    "client_Formats_Standard_name"
                ],
                "assets": [
                    {
                        "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set4/en_us/img/cards/04SI012T1.png",
                        "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set4/en_us/img/cards/04SI012T1-full.png"
                    }
                ],
                "associated_cards": []
            }
        },
        {
            "id": "1405",
            "type": "card",
            "attributes": {
                "name": "Wrath of the Freljord",
                "card_code": "05FR014",
                "description": "<link=vocab.Play><style=Vocab>Play</style></link>:<link=keyword.Frostbite><sprite name=Frostbite><style=Keyword>Frostbite</style></link> an enemy.\r\nEnemies with 3 or less Power can't block.",
                "description_raw": "Play:Frostbite an enemy.\r\nEnemies with 3 or less Power can't block.",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "\"I was there, years ago... first came the cold, biting and unrelenting. Then a storm, angry and uncaring. Last came a roar, so sharp it cut me to the bone. I fell to my knees and prayed we hadn't made a grave mistake. To call upon a great spirit is to ask for its vengeance... and its mercy.\" - Hyara Allseer ",
                "artist_name": "Kudos Productions",
                "attack": 8,
                "cost": 8,
                "health": 8,
                "spell_speed": "",
                "rarity": "EPIC",
                "supertype": "",
                "card_type": "Unit",
                "collectible": true,
                "set": "Set5",
                "associated_card_refs": [],
                "regions": [
                    "Freljord"
                ],
                "region_refs": [
                    "Freljord"
                ],
                "keywords": [
                    "Overwhelm",
                    "Missing Translation"
                ],
                "keyword_refs": [
                    "Overwhelm",
                    "AuraVisualFakeKeyword"
                ],
                "formats": [
                    "Eternal",
                    "Standard"
                ],
                "format_refs": [
                    "client_Formats_Eternal_name",
                    "client_Formats_Standard_name"
                ],
                "assets": [
                    {
                        "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set5/en_us/img/cards/05FR014.png",
                        "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set5/en_us/img/cards/05FR014-full.png"
                    }
                ],
                "associated_cards": []
            }
        },
        {
            "id": "2308",
            "type": "card",
            "attributes": {
                "name": "Spitfire",
                "card_code": "08NX003T1",
                "description": "Deal 2 to an enemy and 2 to the enemy Nexus.",
                "description_raw": "Deal 2 to an enemy and 2 to the enemy Nexus.",
                "levelup_description": "",
                "levelup_description_raw": "",
                "flavor_text": "Wood, steel, flesh--all of it melts in proximity to the firespitter's caustic rage.",
                "artist_name": "Polar Engine",
                "attack": 0,
                "cost": 0,
                "health": 0,
                "spell_speed": "",
                "rarity": "None",
                "supertype": "",
                "card_type": "Ability",
                "collectible": false,
                "set": "Set8",
                "associated_card_refs": [
                    "08NX003"
                ],
                "regions": [
                    "Noxus"
                ],
                "region_refs": [
                    "Noxus"
                ],
                "keywords": [
                    "Elemental Skill"
                ],
                "keyword_refs": [
                    "ElementalSkill"
                ],
                "formats": [
                    "Eternal",
                    "Standard"
                ],
                "format_refs": [
                    "client_Formats_Eternal_name",
                    "client_Formats_Standard_name"
                ],
                "assets": [
                    {
                        "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set8/en_us/img/cards/08NX003T1.png",
                        "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set8/en_us/img/cards/08NX003T1-full.png"
                    }
                ],
                "associated_cards": [
                    {
                        "id": 2307,
                        "name": "Enraged Firespitter",
                        "card_code": "08NX003",
                        "description": "<link=keyword.Elemental Skill><sprite name=ElementalSkill><style=Keyword>Play</style></link>: Deal 2 to an enemy and 2 to the enemy Nexus.",
                        "description_raw": "Play: Deal 2 to an enemy and 2 to the enemy Nexus.",
                        "levelup_description": "",
                        "levelup_description_raw": "",
                        "flavor_text": "Noxian expansion has claimed many different peoples, settlements, and cultures. Frequently, wild creatures are also at the mercy of the war machine--but in the case of this dragon, each brutal step forward by Noxus is met with an equally brutal inferno of rage.",
                        "artist_name": "Envar Studio",
                        "attack": 5,
                        "cost": 6,
                        "health": 3,
                        "spell_speed": "",
                        "rarity": "EPIC",
                        "supertype": "",
                        "card_type": "Unit",
                        "collectible": true,
                        "set": "Set8",
                        "associated_card_refs": [
                            "08NX003T1"
                        ],
                        "regions": [
                            "Noxus"
                        ],
                        "region_refs": [
                            "Noxus"
                        ],
                        "keywords": [
                            "Challenger"
                        ],
                        "keyword_refs": [
                            "Challenger"
                        ],
                        "formats": [
                            "Eternal",
                            "Standard"
                        ],
                        "format_refs": [
                            "client_Formats_Eternal_name",
                            "client_Formats_Standard_name"
                        ],
                        "assets": [
                            {
                                "game_absolute_path": "http://dd.b.pvp.net/5_6_0/set8/en_us/img/cards/08NX003.png",
                                "full_absolute_path": "http://dd.b.pvp.net/5_6_0/set8/en_us/img/cards/08NX003-full.png"
                            }
                        ],
                        "created_at": "2024-07-07T17:38:22.863Z",
                        "updated_at": "2024-07-07T17:38:22.863Z",
                        "associated_cards": []
                    }
                ]
            }
        }
    ]
}
```


</details>

## Contributors

* Billy Wallace | [GitHub](https://github.com/wallacebilly1) | [LinkedIn](https://www.linkedin.com/in/wallacebilly1/)
* Jared Hobson | [GitHub](https://github.com/JaredMHobson) | [LinkedIn](https://www.linkedin.com/in/jaredhobson/)
* Neil Hendren | [GitHub](https://github.com/NeilTheSeal) | [LinkedIn](https://www.linkedin.com/in/neilhendren/)
* Charles Kwang | [GitHub](https://github.com/KojinKuro) | [LinkedIn](https://www.linkedin.com/in/charleskwangdevs/)
* Theotis McCray | [GitHub](https://github.com/Virulencies) | [LinkedIn](https://www.linkedin.com/in/theotis-mccray-849262207/)
* Laurel Bonal | [GitHub](https://github.com/laurelbonal) | [LinkedIn](https://www.linkedin.com/in/laurel-bonal-software-engineer/)
