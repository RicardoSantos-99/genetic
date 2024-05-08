defmodule CodeBreaker do
  @behaviour Problem
  alias Types.Chromosome

  import Bitwise

  @size 64
  def genotype do
    genes = for _ <- 1..@size, do: Enum.random(0..1)

    %Chromosome{genes: genes, size: @size}
  end

  def fitness_function(chromosome) do
    target = ~c"ILoveGeneticAlgorithms"
    encrypted = ~c"LIjs`B`k`qlfDibjwlqmhv"
    cipher = fn word, key -> Enum.map(word, &rem(bxor(&1, key), 32768)) end

    key =
      chromosome.genes
      |> Enum.map(&Integer.to_string(&1))
      |> Enum.join("")
      |> String.to_integer(2)

    guess = List.to_string(cipher.(encrypted, key))
    String.jaro_distance(List.to_string(target), guess)
  end

  def terminate?(population, _generation) do
    Enum.max_by(population, &CodeBreaker.fitness_function/1).fitness == 1.0
  end
end

soln = Genetic.run(CodeBreaker, crossover_type: &Toolbox.Crossover.single_point/2)

{key, ""} =
  soln.genes
  |> Enum.map(&Integer.to_string(&1))
  |> Enum.join("")
  |> Integer.parse(2)

IO.write("\nThe Key is #{key}\n")
