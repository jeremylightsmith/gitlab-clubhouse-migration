require 'faraday'
require 'dotenv/load'
require 'yajl'

class Gitlab
  def initialize(verbose: false)
    @verbose = verbose
    @client = Faraday.new(
      url: 'https://gitlab.com/api/v4',
      headers: { Authorization: "Bearer #{ENV['GITLAB_ACCESS_TOKEN']}" }
    )
  end

  def get_each(path, params = {})
    limit = params.delete(:limit)
    count = 0
    page = 1
    while page > 0
      response = get_response(path, params.merge(page: page, per_page: 500))
      parse_json(response.body).each do |item|
        return links if limit && (count += 1) > limit

        yield item
      end
      page = response.headers['x-next-page'].to_i
    end
  end

  def get(path, params = {})
    parse_json(get_response(path, params).body)
  end

  private

  def parse_json(json)
    Yajl::Parser.new.parse(json)
  rescue StandardError
    raise "Couldn't parse json: #{json[0..1000]}"
  end

  def get_response(path, params = {})
    puts "GET #{path} : #{params}" if @verbose
    response = @client.get(path, params)
    if response.status == 200
      response
    else
      puts response.body
      raise response.body
    end
  end
end
