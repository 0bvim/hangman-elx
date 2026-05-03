defmodule B1Web.HangmanController do
  use B1Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
