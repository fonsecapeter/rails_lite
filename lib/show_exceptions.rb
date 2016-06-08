require 'erb'
require 'ruby_cowsay'

class ShowExceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue Exception => e
    render_exception(e)
  end

  private

  def render_exception(e)
    current_path = File.dirname(__FILE__)
    template = File.read("#{current_path}/templates/rescue.html.erb")
    message = message(e)
    backtrace = backtrace(e)
    code_preview = code_preview(e)
    body = [ERB.new(template).result(binding)]

    # body = ["<pre><code>#{cow}</code></p>"]

    ['500', {'Content-type' => 'text/html'}, body]
  end

  def message(e)
    Cow.new.say("error: #{e.to_s}")[2..-1]
  end

  def backtrace(e)
    e.backtrace
  end

  def code_preview(e)
    line_num = backtrace(e)[0].split(':')[1].to_i
    file_name = backtrace(e)[0].split(':')[0]

    line = 0
    line_preview = ""
    File.open(file_name, 'r') do |f|
      while line <= line_num
        line_preview = f.gets
        line += 1
      end
    end
    "> #{line_preview.strip}"
  end

end
