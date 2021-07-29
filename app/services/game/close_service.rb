class Game::CloseService < ApplicationService
  def call(params)
    game_id = params[:game_id].to_s
    storage.del("game:#{game_id}", "game:#{game_id}:state")
    storage.lrem("awaiting_games", 1, game_id)
  end
end
