defmodule Athenas do
  alias Req
  alias ReqAthena

  defp opt do
    {:ok, access_key_id} = System.fetch_env("access_key_id")
    {:ok, secret_access_key} = System.fetch_env("secret_access_key")
    {:ok, region} = System.fetch_env("region")
    {:ok, database} = System.fetch_env("database")
    {:ok, output_location} = System.fetch_env("output_location")

    list = [
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      region: region,
      database: database,
      output_location: output_location
    ]

    list
  end

  defp sql_queries_list do
    [
      "select dol.id from deimos_organizations_legado dol",
      "select id from deimos_organizations",
      "select dol.id from deimos_organizations_legado dol",
      "select dol.id from deimos_organizations_legado dol",
      "select id from deimos_organizations",
      "select dol.id from deimos_organizations_legado dol"
    ]
  end

  defp athena(query) do
    IO.puts("Processed #{query} ...")
    req = Req.new() |> ReqAthena.attach(opt())
    map = Req.post!(req, athena: query).body

    out =
      Enum.map(map.rows, fn [h | _t] ->
        Map.put(%{}, :id, h)
      end)

    out
  end

  def process do
    sql_queries_list()
    |> Enum.map(fn query ->
      Task.async(fn -> athena(query) end)
    end)
    |> Enum.map(&Task.await/1)
  end
end
