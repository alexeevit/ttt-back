class Game::ActionsHandleService < ApplicationService
  def call(params)
    game_id = params[:game_id].to_s
    player_id = params[:player_id].to_s
    cell = params[:cell].to_s

    turn = get_turn(game_id, player_id)
    state = get_state(game_id)

    validate_player_id(turn)
    validate_turn(state, turn)
    validate_cell(state, cell)

    use_cell(game_id, cell, turn)
    true
  end

  private

  attr_reader :game_id, :player_id, :cell

  def use_cell(game_id, cell, value)
    storage.hset("game:#{game_id}:state", cell, value)
  end

  def validate_player_id(turn)
    raise "Invalid player_id" unless turn
  end

  def validate_turn(state, turn)
    puts "turn: #{turn}"
    puts "state: #{state}"

    raise "Invalid turn" if state.values.compact.size % 2 != turn
  end

  def validate_cell(state, cell)
    raise "Invalid cell" if cell.to_i < 0 || cell.to_i > 8
    raise "Cell is used" if state[cell]
  end

  def get_turn(game_id, player_id)
    game_data ||= storage.hgetall("game:#{game_id}")
    player_ids = game_data.fetch_values("player_1_id", "player_2_id")
    player_ids.index(player_id)
  end

  def get_state(game_id)
    storage.hgetall("game:#{game_id}:state")
  end
end
