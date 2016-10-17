class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R UNKNOWN)
  end
  
  class Movie::InvalidKeyError < StandardError ; end
  
  def self.api_key
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
  end
  
  def self.find_in_tmdb(string)
    begin
      self.api_key
      match_movies=[]
      if Tmdb::Movie.find(string)!=nil
        Tmdb::Movie.find(string).each do |movie|
          match_movies << {:tmdb_id =>movie.id, :title => movie.title, :rating => self.get_rating(movie.id), :release_date => movie.release_date}
        end
      end
      return match_movies
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end

  def self.create_from_tmdb(tmdb_id)
    begin 
      self.api_key
      detail= Tmdb::Movie.detail(tmdb_id)
      movie_params={:title=>detail["original_title"],:rating=>self.get_rating(tmdb_id),:release_date =>detail["release_date"], :description=>detail["overview"]}
      Movie.create!(movie_params)
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end  
  end
  
  def self.get_rating(tmdb_id)
    begin
      self.api_key
      rating = 'UNKNOWN'
      Tmdb::Movie.releases(tmdb_id)["countries"].each do |e|
        if e["iso_3166_1"] == "US" and e["certification"]!=""
          rating = e["certification"]
          break
        else
    
        end
      end
      return rating
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end

end

