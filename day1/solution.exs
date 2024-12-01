#!/bin/env elixir
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

{list1, list2} =
  contents
  |> String.split(~r"\s+", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.chunk_every(2)
  |> Enum.map(&List.to_tuple/1)
  |> Enum.unzip()

lists = [Enum.sort(list1), Enum.sort(list2)]

distance =
  lists
  |> List.zip()
  |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  |> IO.inspect()
