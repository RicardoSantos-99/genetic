defmodule OneMaxInteractive do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..6, do: Enum.random(0..1)

    %Chromosome{genes: genes, size: 6}
  end

  @impl true
  def fitness_function(chromosome) do
    fit = IO.gets("Enter fitness: ") |> String.replace("\n", "")

    String.to_integer(fit)
  end

  @impl true
  def terminate?([best | _], _generation), do: best.fitness == 6
end

soln = Genetic.run(OneMaxInteractive, population_size: 6)
IO.write("\n")
IO.inspect(soln)
