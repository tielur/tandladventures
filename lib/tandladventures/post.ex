defmodule Tandladventures.Post do
  defstruct slug: "", title: "", date: "", intro: "", content: "", title_image: ""

  def compile(file) do
    post = %Tandladventures.Post{
      slug: file_to_slug(file)
    }

    Path.join(["priv/posts", file])
    |> File.read!()
    |> split
    |> extract(post)
  end

  defp file_to_slug(file) do
    String.replace(file, ~r/\.md$/, "")
  end

  """
  It uses String.split/3 to split the file data string in two parts (note the parts: 2, which limits to only splitting once = two parts). The regex ~r/\n-{3,}\n/ looks for the first line that consists of min. 3 dashes and has a newline before and after it. We then pattern match to get the frontmatter and the markdown into two separate variables. We parse both using parse_yaml/1 and Earmark.as_html/1 respectively and return a tuple with the two elements.
  """

  defp split(data) do
    regex = ~r/\n-{3,}\n/
    [frontmatter, markdown] = String.split(data, regex, parts: 2)
    {parse_yaml(frontmatter), Earmark.as_html!(markdown)}
  end

  # parse_yaml/1 is a little helper function. Yamerl’s :yamerl_constr.string/1 returns a list, where we’re only interested in the first element
  defp parse_yaml(yaml) do
    [parsed] = :yamerl_constr.string(yaml)
    parsed
  end

  """
  Note that the result from :yamerl_constr.string/1 we got earlier, props, is an Erlang property list, which are a little awkward to work with in Elixir. So we define the function get_prop/2 that helps us
  """

  defp extract({props, content}, post) do
    %{
      post
      | title: get_prop(props, "title"),
        date: Timex.parse!(get_prop(props, "date"), "{ISOdate}"),
        intro: get_prop(props, "intro"),
        title_image: get_prop(props, "title_image"),
        content: content
    }
  end

  defp get_prop(props, key) do
    case :proplists.get_value(String.to_charlist(key), props) do
      :undefined -> nil
      x -> to_string(x)
    end
  end
end
