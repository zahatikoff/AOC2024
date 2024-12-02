#!/bin/env elixir

defmodule Utils do
  def seq_kind(a, b) do
    cond do
      b > a -> :inc
      b == a -> :eq
      b < a -> :dec
    end
  end

  def distance_valid?(a, b) do
    if(abs(b - a) in 1..3) do
      true
    else
      false
    end
  end

  def check_array([a, b | t]) do
    with dir when dir in [:inc, :dec] <- seq_kind(a, b),
         true <- distance_valid?(a, b) do
      do_check([b | t], dir)
    else
      _ -> false
    end
  end

  # base case-ish
  defp do_check([a, b], dir) do
    if(distance_valid?(a, b) and seq_kind(a, b) == dir) do
      true
    else
      false
    end
  end

  # loopin'
  defp do_check([a, b | rest], dir) do
    if(distance_valid?(a, b) and seq_kind(a, b) == dir) do
      do_check([b | rest], dir)
    else
      false
    end
  end
end

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

arrays =
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(fn str ->
    String.split(str, ~r"\s+", trim: true) |> Enum.map(&String.to_integer/1)
  end)

safe_count =
  Enum.map(arrays, &Utils.check_array/1)
  |> Enum.count(&(&1 == true))

IO.puts("Safe: #{safe_count}")
