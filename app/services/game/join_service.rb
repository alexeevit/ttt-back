class Game::JoinService < ApplicationService
  def call(params)
    game_id = params[:game_id]
    player_2_id = params[:player_2_id].to_i

    storage.hset("game:#{game_id}", :player_2_id, player_2_id)

    true
  end
end
