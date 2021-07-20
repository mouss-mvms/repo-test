class Rack::Attack
  blocklist("block access if not authenticated") do |req|
    req.env["HTTP_X_APIKEY"] != ENV["HTTP_APIKEY"]
  end

  safelist("allow access root path") do |req|
    req.get? && "/"  == req.path
  end

  safelist("allow from localhost") do |req|
    "127.0.0.1" == req.ip || "::1" == req.ip
  end

  safelist("allow access swagger path") do |req|
    req.get? && req.path.start_with?("/api-docs")
  end
end
