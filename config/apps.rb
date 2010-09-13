if PADRINO_ENV == 'development'
  Padrino.mount("Frontend").to('/').host(/^(?:www\.)?frenz\.fr/)
  Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\.frenz\.fr/)
else
  Padrino.mount("Frontend").to('/').host(/^(?:www\.)?#{Regex.escape(DOMAIN_NAME)}/)
  Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\.#{Regex.escape(DOMAIN_NAME)}/)
end

Padrino.mount("Imagination").to("/imagination")
