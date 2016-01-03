class SharedCell < Cell::Rails
  helper ApplicationHelper
  # helper PagesHelper
  append_view_path "app/views"

  cache :foo, :expires_in => 4.hours do |cell, args|
    get_formats(args).first.to_s 
  end

  def foo(args={})
    render_it(args)
  end
  
  private
    def get_formats args={}
      formats = request.formats.map() {|f| f.symbol || :html}
      if args && args[:formats]
        formats = args[:formats]
      elsif args && args[:mobile]
        formats = [:mobile, :html]
      end
      formats || [:html]
    end

    def render_it(args={})
      args[:formats] = get_formats(args)
      render args
    end
end