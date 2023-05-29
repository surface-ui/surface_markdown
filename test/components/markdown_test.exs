defmodule Surface.Components.MarkdownTest do
  use SurfaceMarkdown.ConnCase, async: true

  alias Surface.Components.Markdown

  test "translate markdown into HTML" do
    html =
      render_surface do
        ~F"""
        <#Markdown>
          # Head 1
          Bold: **bold**
          Code: `code`
        </#Markdown>
        """
      end

    assert html =~ """
           <div class="">\
           <h1>
           Head 1</h1>
           <p>
           Bold: <strong>bold</strong>
           Code: <code class="inline">code</code></p>
           </div>
           """
  end

  test "setting the class" do
    html =
      render_surface do
        ~F"""
        <#Markdown class="markdown">
          # Head 1
        </#Markdown>
        """
      end

    assert html =~ """
           <div class="markdown">\
           <h1>
           Head 1</h1>
           </div>
           """
  end

  test "setting multiple classes" do
    html =
      render_surface do
        ~F"""
        <#Markdown class="markdown small">
          # Head 1
        </#Markdown>
        """
      end

    assert html =~ """
           <div class="markdown small">\
           <h1>
           Head 1</h1>
           </div>
           """
  end

  test "setting unwrap removes the wrapping <div>" do
    html =
      render_surface do
        ~F"""
        <#Markdown unwrap>
          # Head 1
        </#Markdown>
        """
      end

    assert html == """
           <h1>
           Head 1</h1>
           """
  end

  test "translates escaped three double-quotes" do
    html =
      render_surface do
        ~F"""
        <#Markdown>
        ```elixir
        def render(assigns) do
          ~F"\""
          Hello
          "\""
        end
        ```
        </#Markdown>
        """
      end

    assert html =~ """
             ~F&quot;&quot;&quot;
             Hello
             &quot;&quot;&quot;
           """
  end

  test "setting opts forward options to Earmark" do
    html =
      render_surface do
        ~F"""
        <#Markdown opts={code_class_prefix: "language-"}>
          ```elixir
          code
          ```
        </#Markdown>
        """
      end

    assert html =~ """
           <pre><code class="elixir language-elixir">code</code></pre>
           """
  end
end

defmodule Surface.Components.MarkdownSyncTest do
  use SurfaceMarkdown.ConnCase

  import ExUnit.CaptureIO
  alias Surface.Components.Markdown

  describe "config" do
    test ":default_class config", %{conn: conn} do
      using_config Markdown, default_class: "content" do
        code =
          quote do
            ~F"""
            <#Markdown>
              # Head 1
            </#Markdown>
            """
          end

        view = compile_surface(code)
        {:ok, _view, html} = live_isolated(conn, view)

        assert html =~ """
               <div class="content"><h1>
               Head 1</h1></div>\
               """
      end
    end

    test "override the :default_class config", %{conn: conn} do
      using_config Markdown, default_class: "content" do
        code =
          quote do
            ~F"""
            <#Markdown class="markdown">
              # Head 1
            </#Markdown>
            """
          end

        view = compile_surface(code)
        {:ok, _view, html} = live_isolated(conn, view)

        assert html =~ """
               <div class="markdown"><h1>
               Head 1</h1></div>\
               """
      end
    end

    test ":default_opts config", %{conn: conn} do
      using_config Markdown, default_opts: [code_class_prefix: "language-"] do
        code =
          quote do
            ~F"""
            <#Markdown>
              ```elixir
              var = 1
              ```
            </#Markdown>
            """
          end

        view = compile_surface(code)
        {:ok, _view, html} = live_isolated(conn, view)

        assert html =~ """
               <div class=\"\"><pre><code class="elixir language-elixir">var = 1</code></pre></div>\
               """
      end
    end

    test "property opts gets merged with global config :opts (overriding existing keys)", %{
      conn: conn
    } do
      using_config Markdown, default_opts: [code_class_prefix: "language-", smartypants: false] do
        code =
          quote do
            ~F"""
            <#Markdown>
              "Elixir"
            </#Markdown>
            """
          end

        view = compile_surface(code)
        {:ok, _view, html} = live_isolated(conn, view)

        assert html =~ """
               <div class=\"\"><p>
               &quot;Elixir&quot;</p></div>\
               """

        code =
          quote do
            ~F"""
            <#Markdown opts={smartypants: true}>
              "Elixir"

              ```elixir
              code
              ```
            </#Markdown>
            """
          end

        view = compile_surface(code)
        {:ok, _view, html} = live_isolated(conn, view)

        assert html =~
                 """
                 <div class=\"\"><p>
                 “Elixir”</p><pre><code class="elixir language-elixir">code</code></pre></div>\
                 """
      end
    end
  end

  describe "error + warnings" do
    test "show parsing errors + warnings at the right line" do
      code =
        quote do
          ~F"""
          <div>
            <#Markdown>
              A
              B
              =
              C
            </#Markdown>
          </div>
          """
        end

      output =
        capture_io(:standard_error, fn ->
          compile_surface(code, %{class: "markdown"})
        end)

      assert output =~ ~r"""
             Unexpected line =
               code:5:\
             """
    end
  end
end
