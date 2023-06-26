require 'yaml'
require 'net/http'
require 'uri'
require 'json'

token = YAML.load_file('./env.yml')["token"]

# agent deets
url = "https://api.spacetraders.io/v2/my/agent"
# system deets
# url = "https://api.spacetraders.io/v2/systems/X1-YU85"
# waypoint deets
# url = "https://api.spacetraders.io/v2/systems/X1-YU85/waypoints/X1-YU85-99640B"
# contract deets
# url = "https://api.spacetraders.io/v2/my/contracts"
# list all waypoints in a system
# url = "https://api.spacetraders.io/v2/systems/X1-YU85/waypoints"
# list all ships in a shipyard
# url = 'https://api.spacetraders.io/v2/systems/X1-YU85/waypoints/X1-YU85-34607X/shipyard'
# buy ship
# url = "https://api.spacetraders.io/v2/my/ships"
uri = URI.parse(url)
request = Net::HTTP::Get.new(uri)
request["Authorization"] = "Bearer #{token}"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
pp JSON.parse(response.body)


