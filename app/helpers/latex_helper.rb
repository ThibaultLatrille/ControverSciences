module LatexHelper

  class LaTeXRender < Redcarpet::Render::Base

    def normal_text(text)
      if text.length == 0
        ''
      else
        text
      end
    end

    def link(link, title, content)
      if link !~ /\D/ && !link.blank? && link != "0"
        ref = "\\textcolor{blue}{<sup>[\\ref{ref-#{link}}, p. \\pageref{ref-#{link}}]<endsub>}"
        if content[0] == "*"
          ref
        else
          content + ref
        end
      elsif link.blank?
        content
      elsif (link[0..6] == "http://") || (link[0..7] == "https://")
        "#{content}\\footnote{#{link}}"
      else
        content
      end
    end

    def codespan(code)
      "\\begin{verbatim} \r #{normal_text(code)} \r \\end{verbatim}"
    end

    def header(title, heading)
      "\\large #{title}"  + "\\normalsize \\\\\n"
    end

    def superscript(text)
      if text[0] == "_"
        "<sub>#{text[1..-1]}<endsub>"
      else
        "<sup>#{text}<endsub>"
      end
    end

    def paragraph(text)
      text + " \\\\ \n\n"
    end

    def double_emphasis(text)
      "\\textbf{#{text}}"
    end

    def emphasis(text)
      "\\textit{#{text}}"
    end

    def list(content, list_type)
      head = "\\vspace{-.5em}"
      itemsep = " \\setlength\\itemsep{0em} \n"
      case list_type
        when :ordered
          head + "\\begin{enumerate}#{itemsep}#{content}\\end{enumerate} \n\n"
        when :unordered
          head + "\\begin{itemize}#{itemsep}#{content}\\end{itemize} \n\n"
      end
    end

    def list_item(content, list_type)
      "\\item #{content.strip} \n"
    end
  end

  def escap_char(text)
    escape_re = /([_$&%#^])/
    text.gsub(escape_re) {|m| "\\#{m}"}
  end

  def lesc(text, section=false)
    renderer = LaTeXRender.new
    extensions = {
        lax_spacing: true,
        strikethrough: true,
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    latexstr = redcarpet.render(text)

    latexstr = escap_char(latexstr)
    latexstr.gsub!("~", "$\\sim$")
    latexstr.gsub!("<sub>", "$_{\\textrm{\\footnotesize{")
    latexstr.gsub!("<sup>", "$^{\\textrm{\\footnotesize{")
    latexstr.gsub!("<endsub>", "}}}$")
    if section
      latexstr[0..-6].html_safe
    else
      latexstr.html_safe
    end
  end

  def render_to_pdf(model, text, list)
    @text = text
    unless @text.strip.blank?
      begin
        render_to_string(:template => 'assistant/partial_tex.pdf.erb', :layout => true)
      rescue Exception => exp
        file = exp.to_s[('rails-latex failed: See '.length)..-(' for details'.length+1)]
        log = File.open(file).read[24020..-1]
        list.append([model, log, text])
      end
    end
  end

  def render_tim_pdf(model, list)
    @timeline = model
    @frame = Frame.find_by(timeline_id: model.id, best: true)
    if @frame
      summary_best = SummaryBest.find_by(timeline_id: model.id)
      if summary_best
        @summary = Summary.find(summary_best.summary_id)
      else
        @summary = nil
      end
      @references = Reference.order(year: :desc).where(timeline_id: @timeline.id)
      begin
        render_to_string(:template => 'timelines/download_pdf.pdf.erb', layout: true)
      rescue Exception => exp
        file = exp.to_s[('rails-latex failed: See '.length)..-(' for details'.length+1)]
        log = File.open(file).read[24020..-1]
        list.append([model, log])
      end
    end
  end
end
