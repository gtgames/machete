CercaHotel.helpers do
end

Admin.helpers do
  def cerca_hotel_features_options
    [ ["restaurant",  "Ristorante"],
      ["garage",      "Garage"],
      ["park",        "Parcheggio"],
      ["disable",     "Strutture per disabili"],
      ["pool",        "Piscina"],
      ["sauna",       "Sauna"],
      ["solarium",    "Solarium"],
      ["beauty",      "Beauty Farm"],
      ["dogs",        "Cani ammessi"],
      ["garden",      "Giardino"],
      ["suite",       "Suite"],
      ["terrace",     "Balcone/Terrazzo"],
      ["tv",          "Tv - Sat"],
      ["internet",    "Internet"],
      ["safe",        "Cassaforte"] ]
  end
end