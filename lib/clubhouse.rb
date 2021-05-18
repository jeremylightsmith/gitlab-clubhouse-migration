require 'faraday'
require 'dotenv/load'
require 'yajl'

class Clubhouse
  def initialize(verbose: false)
    @verbose = verbose
    @client = Faraday.new(
      url: 'https://api.clubhouse.io/api/v3',
      headers: { 'Clubhouse-Token' => ENV['CLUBHOUSE_API_TOKEN'] }
    )
  end

  def get(path, params = {})
    puts "GET #{path} : #{params}" if @verbose
    response = @client.get(path, params)
    if response.status == 200
      Yajl::Parser.new.parse(response.body)
    else
      puts response.body
      raise response.body
    end
  end

  def post(path, hash)
    puts "POST #{path} - #{hash}" if @verbose
    response = @client.post(path, Yajl::Encoder.encode(hash), 'Content-Type' => 'application/json')
    if response.status <= 201
      response
    else
      puts "status = #{response.status}"
      puts response.body
      raise response.body
    end
  end

  def delete(path)
    puts "DELETE #{path}" if @verbose
    response = @client.delete(path)
    if response.status <= 204
      response
    else
      puts "status = #{response.status}"
      puts response.body
      raise response.body
    end
  end
end
