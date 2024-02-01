defmodule Slackernews do
  @moduledoc """
  Slackernews keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  defmodule UnauthorizedError do
    defexception [:message, plug_status: 404]
  end
end
