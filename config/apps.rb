domain_regex = Regexp.escape(DOMAIN_NAME)

Padrino.mount("Frontend").to('/').host(/^(?!(admin|www\.admin)).*$/)

Padrino.mount("Imagination").to("/imagination")

Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)