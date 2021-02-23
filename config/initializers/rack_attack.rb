class Rack::Attack
  blocklist("block access if not authenticated") do |req|
    req.env["HTTP_APIKEY"] != ENV["HTTP_APIKEY"]
  end

  safelist("allow access root path") do |req|
    req.path == "/" && req.get?
  end

  safelist("allow from localhost") do |req|
    "127.0.0.1" == req.ip || "::1" == req.ip
  end
end
