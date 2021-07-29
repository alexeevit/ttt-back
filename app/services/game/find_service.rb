class Game::FindService < ApplicationService
  def call
    storage.lpop("awaiting_games")
  end
end
