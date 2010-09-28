domain_regex = Regexp.escape(DOMAIN_NAME)

Padrino.mount("Frontend").to('/').host(/^(?:www\.)?#{domain_regex}/)

Padrino.mount("Imagination").to("/imagination")


Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\.#{domain_regex}/)
