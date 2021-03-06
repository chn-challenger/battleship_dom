require 'sinatra/base'
require_relative '../game_setup'

class BattleshipsWeb < Sinatra::Base
  enable :sessions

  $board = Board.new(Cell)
  $board2 = Board.new(Cell)

  get '/' do
    erb :index
  end

  get '/new_game' do
    erb :new_game
  end

  get '/greetings' do
    @visitor = params[:name]
    $board = Board.new(Cell)
    erb :greetings
  end

  get '/game_board' do
    @destroyer = Ship.destroyer
    coordinates_1 = params[:coordinates_1].to_sym if params[:coordinates_1]
    orientation_1 = params[:orientation_1].to_sym if params[:orientation_1]
      if coordinates_1 && orientation_1
        $board.place(@destroyer, coordinates_1, orientation_1)
      end
    @battleship = Ship.battleship
    coordinates_2 = params[:coordinates_2].to_sym if params[:coordinates_2]
    orientation_2 = params[:orientation_2].to_sym if params[:orientation_2]
      if coordinates_2 && orientation_2
        $board.place(@battleship, coordinates_2, orientation_2)
      end
    @aircraft_carrier = Ship.aircraft_carrier
    coordinates_3 = params[:coordinates_3].to_sym if params[:coordinates_3]
    orientation_3 = params[:orientation_3].to_sym if params[:orientation_3]
      if coordinates_3 && orientation_3
        $board.place(@aircraft_carrier, coordinates_3, orientation_3)
      end
    @patrol_boat = Ship.patrol_boat
    coordinates_4 = params[:coordinates_4].to_sym if params[:coordinates_4]
    orientation_4 = params[:orientation_4].to_sym if params[:orientation_4]
      if coordinates_4 && orientation_4
        $board.place(@patrol_boat, coordinates_4, orientation_4)
      end
    @submarine = Ship.submarine
    coordinates_5 = params[:coordinates_5].to_sym if params[:coordinates_5]
    orientation_5 = params[:orientation_5].to_sym if params[:orientation_5]
      if coordinates_5 && orientation_5
        $board.place(@submarine, coordinates_5, orientation_5)
      end
    # @fire = params[:fire].to_sym if params[:fire]
    # $board.shoot_at(@fire) if @fire
    @printed_board = $board.print_board
    erb :game_board
  end

  get '/play_game' do
    if $board2.ships_count != 5
      @destroyer = Ship.destroyer
      @battleship = Ship.battleship
      @aircraft_carrier = Ship.aircraft_carrier
      @patrol_boat = Ship.patrol_boat
      @submarine = Ship.submarine
      $board2.rand_place(@destroyer)
      $board2.rand_place(@battleship)
      $board2.rand_place(@aircraft_carrier)
      $board2.rand_place(@patrol_boat)
      $board2.rand_place(@submarine)
    end
    @move = params[:coordinates]
    if @move
      $board2.shoot_at(@move.to_sym)
      if $board2.won?
        @printed_my_board = $board.print_board
        @printed_opp_board = $board2.print_board
        @message = "you win"
        return erb :winner
      end
      $board.shoot_at_random
      if $board.won?
        @printed_my_board = $board.print_board
        @printed_opp_board = $board2.print_board
        @message = "you lose"
        return erb :winner
      end
    end
    @printed_my_board = $board.print_board
    @printed_opp_board = $board2.print_opponent_board
    return erb :play_game
  end

  # post '/play_game' do
  #   # session[:cur_turn_coord]=params[:coordinates]
  #   puts 'We really posted this'
  #   $board2.shoot_at(params[:coordinates].to_sym)
  #   redirect('/play_game')
  # end

  get '/test_page' do
    @board = Board.new(Cell)
    @submarine = Ship.submarine
    @patrol_boat = Ship.patrol_boat
    @board.place(@submarine, :A1)
    @board.place(@patrol_boat, :B1)
    @board.shoot_at(:C1)
    @board.shoot_at(:A1)
    @board.shoot_at(:B2)
    @board.shoot_at(:F1)
    @board.shoot_at(:G10)
    @printed_board_my = @board.print_board
    @printed_board_opp = @board.print_opponent_board
    erb :test_page
  end

set :views, proc { File.join(root, '..', 'views') }

  # start the server if ruby file executed directly
  run! if app_file == $0
end
