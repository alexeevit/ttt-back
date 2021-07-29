class GamesController < ApplicationController
  def find
    game_id = Game::FindService.new.call

    if game_id
      Game::JoinService.new.call({ game_id: game_id, player_2_id: params[:user_id] })
    else
      game_id = Game::CreateService.new.call({ player_1_id: params[:user_id] })
    end

    render json: { id: game_id }
  end
end
