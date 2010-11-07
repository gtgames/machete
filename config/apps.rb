Padrino.mount("Frontend").to('/').host(/^(?!(admin|www\.admin)).*$/)

Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)