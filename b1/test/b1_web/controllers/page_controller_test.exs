defmodule B1Web.PageControllerTest do
  use B1Web.ConnCase

  test "GET /hangman", %{conn: conn} do
    conn = get(conn, ~p"/hangman")
    assert html_response(conn, 200) =~ "Welcome"
  end
end
