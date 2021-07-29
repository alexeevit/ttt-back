class GameChannel < ApplicationCable::Channel
  attr_reader :game_id, :user_id

  def subscribed
    @game_id = params[:id]
    @user_id = params[:user_id].to_s

    stream_from "game_#{game_id}_#{user_id}"

    if opponent_id
      ActionCable.server.broadcast("game_#{game_id}_#{user_id}", { type: "event", name: "game:started", turn: 1 })
      ActionCable.server.broadcast("game_#{game_id}_#{opponent_id}", { type: "event", name: "game:started", turn: 0 })
    end
  end

  def action(data)
    cell = data['cell'].to_i

    handler = Game::ActionsHandleService.new
    return unless handler.call({ game_id: game_id, player_id: user_id, cell: cell })

    win_checker = Game::WinCheckService.new
    win = win_checker.call({ game_id: game_id, cell: cell }).presence

    ActionCable.server.broadcast("game_#{game_id}_#{user_id}", { type: "action_confirmed", cell: cell })
    ActionCable.server.broadcast("game_#{game_id}_#{opponent_id}", { type: "action", cell: cell })

    if win
      ActionCable.server.broadcast("game_#{game_id}_#{user_id}", { type: "win", cell: cell })
      ActionCable.server.broadcast("game_#{game_id}_#{opponent_id}", { type: "lose", cell: cell })
    end
  end

  def unsubscribed
    Game::CloseService.new.call({ game_id: game_id })
  end

  def opponent_id
    @opponent_id ||=
      begin
        repository = Game::RepositoryService.new(game_id)
        repository.opponent_id(user_id)
      end
  end
end
