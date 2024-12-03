#! /bin/env elixir

# quick and dirty solution while im at work

input_file =
  try do
    [file_path | _] = System.argv()
    to_string(file_path)
  rescue
    MatchError ->
      IO.puts(:stderr, "No File Name given")
      System.halt(1)
  end

contents =
  with {:ok, contents} <- File.read(input_file) do
    contents
  else
    {:error, reason} ->
      IO.puts(:stderr, "Couldn't open #{input_file}. #{reason}")
      System.halt(2)
  end

stuff =
  Regex.scan(~r"(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))", contents)
  |> Enum.map(fn [match, _smth] -> match end)
  |> Enum.map(fn
    "do()" ->
      :go

    "don't()" ->
      :nogo

    str ->
      Regex.scan(~r"\d{1,3}", str)
      |> Enum.concat()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(1, fn x, acc -> x * acc end)
  end)

Enum.each(stuff, &IO.inspect/1)

simple =
  Enum.reduce(
    stuff,
    fn
      x, acc when is_atom(x) -> acc
      x, acc when is_number(x) -> acc + x
    end
  )

{_, dodont} =
  Enum.reduce(stuff, {:go, 0}, fn
    :go, {_, acc} -> {:go, acc}
    :nogo, {_, acc} -> {:nogo, acc}
    num, {:go, acc} -> {:go, acc + num}
    _num, {:nogo, acc} -> {:nogo, acc}
  end)

IO.puts("Simple multiply: #{simple}, do/don't: #{dodont}")
