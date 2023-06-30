require "tty-prompt"
require 'yaml'
require 'net/http'
require 'uri'
require 'json'

class Controller

	attr_reader :prompt, :token

	def initialize
		@prompt = TTY::Prompt.new(interrupt: :exit)
		@token = YAML.load_file('./env.yml')["token"]
	end

	def home
		puts '----* Agent Details'
		agent.each {|k, v| puts "#{k}: #{v}" }

		answer = prompt.select("----* Select Option", %w(Ships Systems Contracts))

		eval(answer.downcase)
	end

	def agent
		response = make_request("https://api.spacetraders.io/v2/my/agent")['data'].transform_keys(&:to_sym)

		{
			Name: response[:symbol],
			Credits: response[:credits]
		}
	end

	def ships
		response = make_request("https://api.spacetraders.io/v2/my/ships")

		pp response
	end

	def make_request(url)
		uri = URI.parse(url)
		request = Net::HTTP::Get.new(uri)
		request["Authorization"] = "Bearer #{token}"

		req_options = {
		  use_ssl: uri.scheme == "https",
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end

		JSON.parse(response.body)
	end
end