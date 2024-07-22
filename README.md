# Runefall

## About
The Runefall backend service provides an advanced search to filter and query a list of cards available in the videogame Legends of Runeterra. 

You can find a live version of this service being utilized [here.](https://runefall.netlify.app/)

## Development setup

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

## Contributors

* Billy Wallace | [GitHub](https://github.com/wallacebilly1) | [LinkedIn](https://www.linkedin.com/in/wallacebilly1/)
* Jared Hobson | [GitHub](https://github.com/JaredMHobson) | [LinkedIn](https://www.linkedin.com/in/jaredhobson/)
* Neil Hendren | [GitHub](https://github.com/NeilTheSeal) | [LinkedIn](https://www.linkedin.com/in/neilhendren/)
* Charles Kwang | [GitHub](https://github.com/KojinKuro) | [LinkedIn](https://www.linkedin.com/in/charleskwangdevs/)
* Theotis McCray | [GitHub](https://github.com/Virulencies) | [LinkedIn](https://www.linkedin.com/in/theotis-mccray-849262207/)
