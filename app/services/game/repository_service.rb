class Game::RepositoryService < ApplicationService
  attr_reader :game_data, :game_id

  def initialize(game_id)
    @game_id = game_id
    @game_data = storage.hgetall("game:#{game_id}")
  end

  def opponent_id(player_id)
    ([game_data["player_1_id"], game_data["player_2_id"]] - [player_id]).shift
  end
end
