defmodule Tandladventures.Repo do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    posts = Tandladventures.Crawler.crawl()

    fake_posts =
      for n <- 1..30 do
        %Tandladventures.Post{
          slug: "test-post-#{n}",
          title: "test-post-#{n}",
          date: Timex.today(),
          intro: "Hello welcome to the #{n}th post",
          content: "<p>#{n} post</p>\n",
          title_image: "https://picsum.photos/320/200?random=#{n}"
        }
      end

    posts = List.flatten([fake_posts | posts])
    {:ok, posts}
  end

  def get_by_slug(slug) do
    GenServer.call(__MODULE__, {:get_by_slug, slug})
  end

  def list() do
    GenServer.call(__MODULE__, {:list})
  end

  def handle_call({:get_by_slug, slug}, _from, posts) do
    case Enum.find(posts, fn x -> x.slug == slug end) do
      nil -> {:reply, :not_found, posts}
      post -> {:reply, {:ok, post}, posts}
    end
  end

  def handle_call({:list}, _from, posts) do
    {:reply, {:ok, posts}, posts}
  end
end
