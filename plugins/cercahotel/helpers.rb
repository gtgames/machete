CercaHotel.helpers do
end

Admin.helpers do
  def cerca_hotel_features_options
    [ ["Ristorante"             , "restaurant" ],
      ["Garage"                 , "garage"     ],
      ["Parcheggio"             , "park"       ],
      ["Strutture per disabili" , "disable"    ],
      ["Piscina"                , "pool"       ],
      ["Sauna"                  , "sauna"      ],
      ["Solarium"               , "solarium"   ],
      ["Beauty Farm"            , "beauty"     ],
      ["Cani ammessi"           , "dogs"       ],
      ["Giardino"               , "garden"     ],
      ["Suite"                  , "suite"      ],
      ["Balcone/Terrazzo"       , "terrace"    ],
      ["Tv - Sat"               , "tv"         ],
      ["Internet"               , "internet"   ],
      ["Cassaforte"             , "safe"       ] ]
  end
end