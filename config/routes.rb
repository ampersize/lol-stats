Rails.application.routes.draw do
	resources :summoners

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get 'summoners/:id/summary' => 'summoners#summary', as: :summoner_summary
	get 'summoners/:id/games' => 'summoners#games', as: :summoner_games

	# app root
	root 'summoners#index'	
end
