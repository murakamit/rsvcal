Rsvcal::Application.routes.draw do
  root 'top#index'

  get "/today" => "top#today"
  get "/:year-:month-:day" => "top#year_month_day", constraints: { year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/ }, as: :ymd_top

  resource :session, only: [:new, :create, :destroy]
  get "session" => "sessions#index"

  resources :groups, only: [:index, :show]

  resources :items, only: [:index, :show]

  resources :items do
    member do
      get "prop"
      get "today"
    end
  end

  h = { id: /\d+/, year: /\d{4}/, month: /\d{1,2}/ }
  get "/items/:id/:year-:month" => "items#year_month", constraints: h, as: :ym_item

  h = { id: /\d+/, year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/ }
  get "/items/:id/:year-:month-:day" => "items#year_month_day", constraints: h, as: :ymd_item

  resources :weeklies

  resources :weeklyrevokes, only: [:show, :new, :create, :destroy]

  resources :reservations

  namespace :admin do
    root "top#index"
    resources :groups, only: [:new, :create, :edit, :update, :destroy]
    resources :items,  only: [:new, :create, :edit, :update, :destroy]
  end
end
