defmodule Types.Chromosome do
  alias Types.Chromosome
  use Agent

  @type t :: %__MODULE__{
          genes: Enum.t(),
          id: binary(),
          size: integer(),
          fitness: number(),
          age: integer()
        }

  @enforce_keys :genes
  defstruct [
    :genes,
    id: Base.encode16(:crypto.strong_rand_bytes(64)),
    size: 0,
    fitness: 0,
    age: 0
  ]

  def start_link(chromosome) do
    Agent.start_link(fn -> chromosome end)
  end

  def get_fitness(pid) do
    Agent.get(pid, & &1.fitness)
  end

  def eval(pid, fitness) do
    Agent.update(pid, fn c -> %Chromosome{c | fitness: fitness.(c)} end)
  end
end
