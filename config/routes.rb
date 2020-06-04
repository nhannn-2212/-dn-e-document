Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
  end
end
