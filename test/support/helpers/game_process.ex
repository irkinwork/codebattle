defmodule Helpers.GameProcess do
  @moduledoc """
  Test helpers for GameProcess context
  """

  import CodebattleWeb.Factory

  alias Codebattle.GameProcess.{Supervisor, Fsm}

  def setup_game(state, data) do
    game = insert(:game)
    data = Map.put(data, :game_id, game.id)
    fsm = Fsm.set_data(state, data)
    Supervisor.start_game(game.id, fsm)
    game
  end

  def start_game_recorder(game_id, task_id, user_id) do
    Codebattle.Bot.RecorderServer.start(game_id, task_id, user_id)
  end

  def setup_lang(slug) do
    spec_filepath = Path.join(File.cwd!, "priv/repo/seeds/langs.yml")
    %{langs: langs} = YamlElixir.read_from_file spec_filepath, atoms: true
    lang = langs |> Enum.find(fn(lang) -> lang.slug == to_string(slug) end)
    insert(:language, lang)
  end

end
