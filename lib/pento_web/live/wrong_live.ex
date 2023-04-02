defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts

  defp randomize_answer() do
    :rand.uniform(10) |> to_string
  end

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess:",
        answer: randomize_answer(),
        time: time(),
        session_id: session["live_socket_id"],
        current_user: user
      )
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    answer = socket.assigns.answer
    result = case guess do
      ^answer -> %{
        message: "Your guess was correct!",
        score: socket.assigns.score + 1,
        answer: randomize_answer()
      }
      _ -> %{
        message: "Your guess: #{guess}. Wrong. Guess again.",
        score: socket.assigns.score - 1,
        answer: answer
      }
    end

    {
      :noreply,
      assign(
        socket,
        message: result.message,
        score: result.score,
        answer: result.answer,
        time: time()
      )
    }
  end



  def render(assigns) do
    ~H"""
      <h1>Your score: <%= @score %></h1>
      <h2><%= @message %></h2>
      It's <%= @time %>
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </.link>
        <% end %>
        <pre>
          <%= @current_user.email %>
          <%= @session_id %>
        </pre>
      </h2>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end
end
