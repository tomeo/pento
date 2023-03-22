defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  defp randomize_answer() do
    :rand.uniform(10) |> to_string
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:", answer: randomize_answer())}
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
        answer: result.answer
      )
    }
  end



  def render(assigns) do
    ~H"""
      <h1>Your score: <%= @score %></h1>
      <h2><%= @message %></h2>
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </.link>
        <% end %>
      </h2>
    """
  end
end
