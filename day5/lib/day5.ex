defmodule Day5 do
  @letters "abcdefghijklmnopqrstuvwxyz"

  def react(string) when is_binary(string) do
    react({string, ""})
  end

  def react({a, a}) do
    a |> IO.inspect(printable_limit: :infinity)
  end

  def react({a, _b}) do
    b =
      Regex.replace(
        ~r/Aa|aA|Bb|bB|cC|Cc|dD|Dd|eE|Ee|fF|Ff|gG|Gg|hH|Hh|iI|Ii|jJ|Jj|kK|Kk|lL|Ll|mM|Mm|nN|Nn|oO|Oo|pP|Pp|qQ|Qq|rR|Rr|sS|Ss|tT|Tt|uU|Uu|vV|Vv|wW|Ww|xX|Xx|yY|Yy|zZ|Zz/,
        a,
        "",
        global: true
      )

    react({b, a})
  end

  def read_data() do
    File.stream!("polymer.txt")
    |> Enum.map(fn x ->
      String.trim(x, "\n")
    end)
    |> List.first()
  end

  def with_removal(data, letter) do
    {:ok, re} = Regex.compile(letter, "i")
    String.replace(data, re, "")
  end

  def best_reduction(data) do
    @letters
    |> String.split("")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn x ->
      {x, with_removal(data, x)}
    end)
    |> Enum.map(fn {x, d} -> {x, react(d)} end)
    |> Enum.map(fn {x, d} -> {x, String.length(d)} end)
  end
end
