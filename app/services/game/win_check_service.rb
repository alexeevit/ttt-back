class Game::WinCheckService < ApplicationService
  def call(params)
    game_id = params[:game_id].to_s
    cell = params[:cell].to_i

    state = game_state(game_id)
    check(state, cell)
  end

  private

  attr_reader :game_id, :cell

  def check(state, cell)
    x = cell % 3
    y = cell / 3
    value = state[cell]

    # check row
    return value if (0..2).reduce(true) { |acc, i| state[y * 3 + i] == value && acc }

    # check column
    return value if (0..2).reduce(true) { |acc, j| state[x + j * 3] == value && acc }

    # check diagonales
    if cell % 4 == 0
      return value if (0..2).reduce(true) { |acc, d| state[d + d * 3] == value && acc }
    end

    if cell / 2 > 0 && cell % 2 == 0 && cell < 8
      return value if (0..2).reduce(true) { |acc, d| state[d + (2 - d) * 3] == value && acc }
    end
  end

  def game_state(game_id)
    storage.hgetall("game:#{game_id}:state").transform_keys(&:to_i)
  end
end
