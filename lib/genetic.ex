defmodule Genetic do
  alias Types.Chromosome

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0, opts)

    evolve(population, problem, 0, opts)
  end

  def evolve(population, problem, generation, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)
    best = hd(population)

    IO.write("\r Current Best #{best.fitness}")

    if problem.terminate?(population, generation) do
      best
    else
      {parents, leftover} = select(population, opts)

      children = crossover(parents, opts)

      (children ++ leftover)
      |> mutation(opts)
      |> evolve(problem, generation + 1, opts)
    end
  end

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function, _opts \\ []) do
    population
    |> Enum.map(&%Chromosome{&1 | fitness: fitness_function.(&1), age: &1.age + 1})
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  def select(population, opts \\ []) do
    select_fn = Keyword.get(opts, :selection_type, &Toolbox.Selection.elite/2)

    selection_rate = Keyword.get(opts, :selection_rate, 0.8)
    n = round(length(population) * selection_rate)
    n = if rem(n, 2) == 0, do: n, else: n + 1

    parents = apply(select_fn, [population, n])

    leftover =
      population
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(parents))

    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
    |> then(&{&1, MapSet.to_list(leftover)})
  end

  def crossover(population, _opts \\ []) do
    Enum.reduce(population, [], fn {p1, p2}, acc ->
      cx_point =
        p1.genes
        |> length()
        |> :rand.uniform()

      {{h1, t1}, {h2, t2}} =
        {Enum.split(p1.genes, cx_point), Enum.split(p2.genes, cx_point)}

      {c1, c2} = {%Chromosome{p1 | genes: h1 ++ t2}, %Chromosome{p2 | genes: h2 ++ t1}}

      [c1, c2 | acc]
    end)
  end

  def mutation(population, _opts \\ []) do
    Enum.map(population, fn chromosome ->
      if :rand.uniform() < 0.05 do
        %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
      else
        chromosome
      end
    end)
  end
end
