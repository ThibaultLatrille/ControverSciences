class PreviewsController < ApplicationController
  def create
    render_options = {
        filter_html: true,
        hard_wrap: true,
        link_attributes: {rel: 'nofollow'},
        no_images: true,
        no_styles: true,
        safe_links_only: true
    }

    renderer = HTMLlinks.new(render_options)
    renderer.links = {}
    renderer.counter = 1

    if Rails.env.production?
      renderer.root_url = "controversciences.org"
    else
      renderer.root_url = "127.0.0.1:3000"
    end

    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        # will parse superscript after ^, you can wrap superscript in ()
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    markdown = redcarpet.render(params[:content])
    render json: markdown
  end
end
