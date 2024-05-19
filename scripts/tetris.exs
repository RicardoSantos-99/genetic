defmodule TetrisInterface do
  use Agent

  def start_link(path_to_tetris_rom) do
    int = Alex.new()

    game =
      int
      |> Alex.set_option(:display_screen, true)
      |> Alex.set_option(:sound, true)
      |> Alex.set_option(:random_seed, 123)
      |> Alex.load(path_to_tetris_rom)

    Agent.start_link(fn -> game end, name: __MODULE__)
  end
end

defmodule Tetris do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    game = Agent.get(TetrisInterface, fn game -> game end)

    gens = for _ <- 1..1000, do: Enum.random(game.legal_action())

    %Chromosome{genes: gens, size: 1000}
  end

  @impl true
  def fitness_function(chromosome) do
  end

  @impl true
  def terminate?(_population, generation), do: generation == 5
end
