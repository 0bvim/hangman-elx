defmodule B1Web.HangmanController do
  use B1Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def new(conn, _params) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    put_session(conn, :game, game)
    render(conn, :game, tally: tally)
  end
end
