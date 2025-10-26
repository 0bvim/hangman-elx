defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("bat")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["b", "a", "t"]
  end

  test "state doesn't change if a game is won" do
    for state <- [:won, :lost] do
      game = Game.new_game("bat")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicated letter is reported" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    { game, _tally } = Game.make_move(game, "y")
    { game, _tally } = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    { _game, tally } = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    { _game, tally } = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in ther word" do
    game = Game.new_game("wombat")
    { game, tally } = Game.make_move(game, "n")
    assert tally.game_state == :bad_guess
    { _game, tally } = Game.make_move(game, "e")
    assert tally.game_state == :bad_guess
  end

  test "decrease turns when wrong guess" do
    game = Game.new_game("wombat")
    { game, tally } = Game.make_move(game, "n")
    assert tally.turns_left == 6
    { _game, tally } = Game.make_move(game, "e")
    assert tally.turns_left == 5
  end

# hello
  test "can handle a sequence of moves" do
    [
      # guess | state | turns | letters | used
      ["a", :bad_guess, 6, [ "_", "_", "_","_","_" ], [ "a" ] ],
      ["a", :already_used, 6, [ "_", "_", "_","_","_" ], [ "a" ] ],
      ["e", :good_guess, 6, [ "_", "e", "_","_","_" ], [ "a", "e" ] ],
      ["x", :bad_guess, 5, [ "_", "e", "_","_","_" ], [ "a", "e", "x" ] ],
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a winning game" do
    [
      # guess | state | turns | letters | used
      ["a", :bad_guess,       6, [ "_", "_", "_","_","_" ], Enum.sort([ "a" ]) ],
      ["a", :already_used,    6, [ "_", "_", "_","_","_" ], Enum.sort([ "a" ]) ],
      ["e", :good_guess,      6, [ "_", "e", "_","_","_" ], Enum.sort([ "a", "e" ]) ],
      ["x", :bad_guess,       5, [ "_", "e", "_","_","_" ], Enum.sort([ "a", "e", "x" ]) ],
      ["x", :already_used,    5, [ "_", "e", "_","_","_" ], Enum.sort([ "a", "e", "x" ]) ],
      ["o", :good_guess,      5, [ "_", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o" ]) ],
      ["i", :bad_guess,       4, [ "_", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i" ]) ],
      ["j", :bad_guess,       3, [ "_", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j" ]) ],
      ["h", :good_guess,      3, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h" ]) ],
      ["h", :already_used,    3, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h" ]) ],
      ["k", :bad_guess,       2, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h", "k" ]) ],
      ["v", :bad_guess,       1, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h", "k", "v" ]) ],
      ["l", :won,             1, [ "h", "e", "l","l","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h", "k", "v", "l" ]) ],
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a losing game" do
    [
      # guess | state | turns | letters | used
      ["a", :bad_guess,       6, [ "_", "_", "_","_","_" ], Enum.sort([ "a" ]) ],
      ["a", :already_used,    6, [ "_", "_", "_","_","_" ], Enum.sort([ "a" ]) ],
      ["e", :good_guess,      6, [ "_", "e", "_","_","_" ], Enum.sort([ "a", "e" ]) ],
      ["x", :bad_guess,       5, [ "_", "e", "_","_","_" ], Enum.sort([ "a", "e", "x" ]) ],
      ["x", :already_used,    5, [ "_", "e", "_","_","_" ], Enum.sort([ "a", "e", "x" ]) ],
      ["o", :good_guess,      5, [ "_", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o" ]) ],
      ["i", :bad_guess,       4, [ "_", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i" ]) ],
      ["j", :bad_guess,       3, [ "_", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j" ]) ],
      ["h", :good_guess,      3, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h" ]) ],
      ["h", :already_used,    3, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h" ]) ],
      ["k", :bad_guess,       2, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h", "k" ]) ],
      ["v", :bad_guess,       1, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h", "k", "v" ]) ],
      ["m", :lost,            0, [ "h", "e", "_","_","o" ], Enum.sort([ "a", "e", "x", "o", "i", "j", "h", "k", "v", "m" ]) ],
    ]
    |> test_sequence_of_moves()
  end

  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([ guess, state, turns, letters, used], game) do
    { game, tally } = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end
end
