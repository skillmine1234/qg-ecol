class EcolAppSearcher < Searcher
  attr_searchable :app_code, :customer_code
end