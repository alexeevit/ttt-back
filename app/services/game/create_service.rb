class Game::CreateService < ApplicationService
  def call(params)
    player_1_id = params[:player_1_id].to_i

    game_id = SecureRandom.hex
    storage.hset("game:#{game_id}", :player_1_id, player_1_id)
    storage.rpush("awaiting_games", game_id)

    game_id
  end
end
