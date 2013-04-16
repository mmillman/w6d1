require_relative 'cookies'

class ControllerBase
  def initialize(req, res)
    @req = req
    @res = res
    @session = Session.new(@req)
  end

  def render_content(content_type, body)
    @res.content_type = content_type
    @res.body = body
    @response_built = true
    @session.store_session(@res)
    puts "render_content's @res.cookies: #{@res.cookies}"
  end

  def redirect_to(url)
    @res.status = 302
    @res["Location"] = url
    @response_built = true
    @session.store_session(@res)
  end

  def session
    @session ||= Session.new(@req)
  end
end
