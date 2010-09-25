# encoding:utf-8
Admin.helpers do
  def language_select
    langs = Language.all.map {|l| ["#{l.name}", "#{l.code}"] }
    select_tag(:language, :options => langs, :selected => langs.first)
  end
  
  def languages
    Language.all
  end
end