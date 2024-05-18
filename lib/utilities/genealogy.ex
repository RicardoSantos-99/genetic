defmodule Utilities.Genealogy do
  use GenServer

  # Client

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_chromosomes(chromosomes) do
    GenServer.cast(__MODULE__, {:add_chromosomes, chromosomes})
  end

  def add_chromosomes(parent, child) do
    GenServer.cast(__MODULE__, {:add_chromosomes, parent, child})
  end

  def add_chromosomes(parent_a, parent_b, child) do
    GenServer.cast(__MODULE__, {:add_chromosomes, parent_a, parent_b, child})
  end

  def get_tree do
    GenServer.call(__MODULE__, :get_tree)
  end

  # Server

  def init(_opts) do
    {:ok, Graph.new()}
  end

  def handle_cast({:add_chromosomes, chromosomes}, genealogy) do
    {:noreply, Graph.add_vertices(genealogy, chromosomes)}
  end

  def handle_cast({:add_chromosomes, parent, child}, genealogy) do
    new_genealogy = Graph.add_edge(genealogy, parent, child)

    {:noreply, new_genealogy}
  end

  def handle_cast({:add_chromosomes, parent_a, parent_b, child}, genealogy) do
    new_genealogy =
      genealogy
      |> Graph.add_edge(parent_a, child)
      |> Graph.add_edge(parent_b, child)

    {:noreply, new_genealogy}
  end

  def handle_call(:get_tree, _, genealogy) do
    {:reply, genealogy, genealogy}
  end
end
