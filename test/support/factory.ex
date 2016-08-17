defmodule JekyllInterface.Factory do
  use ExMachina.Ecto, repo: JekyllInterface.Repo

  def site_factory do
    %JekyllInterface.Site{
      fullpath: sequence(:fullpath, &"fullpath-#{&1}")
    }
  end

  def post_factory do
    %JekyllInterface.Post{
      filename: sequence(:filename, &"filename-#{&1}"),
      site: build(:site)
    }
  end
end
