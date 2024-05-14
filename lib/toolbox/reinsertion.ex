defmodule Toolbox.Reinsertion do
  def pure(_parents, offspring, _leftovers), do: offspring

  def elitist(parents, offspring, leftovers, survival_rate) do
    parents = Enum.flat_map(parents, &[elem(&1, 0), elem(&1, 1)])
    old = parents ++ leftovers
    n = floor(length(old) * survival_rate)

    survivors =
      old
      |> Enum.sort_by(& &1.fitness, &>=/2)
      |> Enum.take(n)

    offspring ++ survivors
  end

  def uniform(parents, offspring, leftover, survival_rate) do
    parents = Enum.flat_map(parents, &[elem(&1, 0), elem(&1, 1)])
    old = parents ++ leftover
    n = floor(length(old) * survival_rate)

    survivors =
      old
      |> Enum.take_random(n)

    offspring ++ survivors
  end
end
