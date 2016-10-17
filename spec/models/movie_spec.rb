describe Movie do

  describe 'geting the rating from tmdb' do
    context 'with valid id and ' do 
      fake_results = {"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
      allow(Tmdb::Movie).to receive(:release).and_return(fake_results)
      expect(Movie).to receive(get_rating).and_raise("R")
      Movie.get_rating('id')
    end
  end

  describe 'searching Tmdb by search_terms' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect(Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect{Movie.find_in_tmdb('Inception')}.to raise_error(Movie::InvalidKeyError)
      end
    end
    context 'with no matches' do
      it 'should return []' do
        allow(Tmdb::Movie).to receive(:find).with('asdf123asdfasdf').and_return (nil)
        expect(Movie.find_in_tmdb('asdf123asdfasdf')).to eq([])
      end
    end  
    context 'with matches' do
      it 'should call Moive::get_rating method and return fake_results' do
        fake_results = [double('Movie1'),double('Movie2')]
        fake_results.each do |f|
          allow(f).to receive(:id).and_return("id")
          allow(f).to receive(:title).and_return("title")
          allow(f).to receive(:release_date).and_return("release_date")
          allow(Movie).to receive(:get_rating).with("id").and_return("rating")
        end
        expect(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
        Movie.find_in_tmdb('Inception')
      end
    end    
  #   context 'with matches and no US iso information' do
  #     it 'should return movie with rating ""' do
  #       m = double('Movie')
  #       fake_results = [m]
  #       allow(m).to receive(:id).and_return("id")
  #       allow(m).to receive(:title).and_return("title")
  #       allow(m).to receive(:release_date).and_return("release")
  #       fake_results2 = {"countries" => []}
  #       allow(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
  #       allow(Tmdb::Movie).to receive(:releases).and_return(fake_results2)
  #       expect(Movie.find_in_tmdb('Inception')[0][:rating]).to eq("")
  #     end
  #   end  
  #   context 'with matches and US iso information is ""' do
  #     it 'should return movie with rating ""' do
  #       m = double('Movie')
  #       fake_results = [m]
  #       allow(m).to receive(:id).and_return("id")
  #       allow(m).to receive(:title).and_return("title")
  #       allow(m).to receive(:release_date).and_return("release")
  #       fake_results2 = {"countries" => [{"iso_3166_1" => "US", "certification" => ""}]}
  #       allow(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
  #       allow(Tmdb::Movie).to receive(:releases).and_return(fake_results2)
  #       expect(Movie.find_in_tmdb('Inception')[0][:rating]).to eq("")
  #     end
  #   end  
  #   context 'with matches and US iso information not equal to ""' do
  #     it 'should return movie with rating' do
  #       m = double('Movie')
  #       fake_results = [m]
  #       allow(m).to receive(:id).and_return("id")
  #       allow(m).to receive(:title).and_return("title")
  #       allow(m).to receive(:release_date).and_return("release")
  #       fake_results2 = {"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
  #       allow(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
  #       allow(Tmdb::Movie).to receive(:releases).and_return(fake_results2)
  #       expect(Movie.find_in_tmdb('Inception')[0][:rating]).to eq("R")
  #     end
  #   end  
  #   context 'with matches and valid title information' do
  #     it 'should return movie with title' do
  #       m = double('Movie')
  #       fake_results = [m]
  #       allow(m).to receive(:id).and_return("id")
  #       allow(m).to receive(:title).and_return("title")
  #       allow(m).to receive(:release_date).and_return("release")
  #       fake_results2 = {"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
  #       allow(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
  #       allow(Tmdb::Movie).to receive(:releases).and_return(fake_results2)
  #       expect(Movie.find_in_tmdb('Inception')[0][:title]).to eq("title")
  #     end
  #   end  
  #   context 'with matches and valid release information' do
  #     it 'should return movie with release' do
  #       m = double('Movie')
  #       fake_results = [m]
  #       allow(m).to receive(:id).and_return("id")
  #       allow(m).to receive(:title).and_return("title")
  #       allow(m).to receive(:release_date).and_return("release")
  #       fake_results2 = {"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
  #       allow(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
  #       allow(Tmdb::Movie).to receive(:releases).and_return(fake_results2)
  #       expect(Movie.find_in_tmdb('Inception')[0][:release_date]).to eq("release")
  #     end
  #   end  
  #   context 'with matches and valid id information' do
  #     it 'should return movie with id' do
  #       m = double('Movie')
  #       fake_results = [m]
  #       allow(m).to receive(:id).and_return("id")
  #       allow(m).to receive(:title).and_return("title")
  #       allow(m).to receive(:release_date).and_return("release")
  #       fake_results2 = {"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
  #       allow(Tmdb::Movie).to receive(:find).with('Inception').and_return(fake_results)
  #       allow(Tmdb::Movie).to receive(:releases).and_return(fake_results2)
  #       expect(Movie.find_in_tmdb('Inception')[0][:tmdb_id]).to eq("id")
  #     end
  #   end  
  
end
  describe 'creating Tmdb movie' do
    context 'with valid key' do
      it 'should call Tmdb detail' do
        fake_results = {"countries" => []}
        expect(Tmdb::Movie).to receive(:detail).with(1).and_return({})
        allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
        Movie.create_from_tmdb(1)
      end
    end
    # context 'with valid key' do
    #   it 'should call Tmdb releases' do
    #     fake_results = {"countries" => []}
    #     expect(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return({})
    #     Movie.create_from_tmdb(1)
    #   end
    # end
    # context 'with valid information' do
    #   it 'should call Movie create' do
    #     fake_results = {"countries" => []}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return({})
    #     expect(Movie).to receive(:create!)
    #     Movie.create_from_tmdb(1)
    #   end
    # end
    # context 'with invalid key' do
    #   it 'should raise InvalidKeyError for Tmdb detail if key is missing or invalid' do
    #     allow(Tmdb::Movie).to receive(:detail).and_raise(Tmdb::InvalidApiKeyError)
    #     expect{Movie.create_from_tmdb(1)}.to raise_error(Movie::InvalidKeyError)
    #   end
    # end
    # context 'with invalid key' do
    #   it 'should raise InvalidKeyError for Tmdb releases if key is missing or invalid' do
    #     allow(Tmdb::Movie).to receive(:releases).and_raise(Tmdb::InvalidApiKeyError)
    #     expect{Movie.create_from_tmdb(1)}.to raise_error(Movie::InvalidKeyError)
    #   end
    # end
    # context 'with no ratings' do
    #   it 'should set rating to nothing' do
    #     fake_results = {"countries" => []}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return({})
    #     expect(Movie.create_from_tmdb(1)[:rating]).to eq("")
    #   end
    # end
    # context 'with no US iso_3166_1' do
    #   it 'should set rating to nothing' do
    #     fake_results = {"countries" => [{"iso_3166_1" => "C", "certification" => "R"}]}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return({})
    #     expect(Movie.create_from_tmdb(1)[:rating]).to eq("")
    #   end
    # end
    # context 'with US iso_3166_1 equal to ""' do
    #   it 'should set rating to nothing' do
    #     fake_results = {"countries" => [{"iso_3166_1" => "US", "certification" => ""}]}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return({})
    #     expect(Movie.create_from_tmdb(1)[:rating]).to eq("")
    #   end
    # end
    # context 'with US iso_3166_1 not equal to ""' do
    #   it 'should set rating to iso_3166_1' do
    #     fake_results = {"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return({})
    #     expect(Movie.create_from_tmdb(1)[:rating]).to eq("R")
    #   end
    # end
    # context 'with a valid movie' do
    #   it 'should set title appropriately' do
    #     fake_results = {"countries" => [{"iso_3166_1" => "US", "certification" => "PG"}]}
    #     fake_results2 = {"title" => "Title", "release_date" => "Release", "overview" => "Overview"}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return(fake_results2)
    #     expect(Movie.create_from_tmdb(1)[:title]).to eq("Title")
    #   end
    # end
    # context 'with a valid movie' do
    #   it 'should set release appropriately' do
    #     fake_results = {"countries" => [{"iso_3166_1" => "US", "certification" => "PG"}]}
    #     fake_results2 = {"title" => "Title", "release_date" => "1979-05-25", "overview" => "Overview"}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return(fake_results2)
    #     expect(Movie.create_from_tmdb(1)[:release_date]).to eq("1979-05-25")
    #   end
    # end
    # context 'with a valid movie' do
    #   it 'should set description appropriately' do
    #     fake_results = {"countries" => [{"iso_3166_1" => "US", "certification" => "PG"}]}
    #     fake_results2 = {"title" => "Title", "release_date" => "Release", "overview" => "Overview"}
    #     allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
    #     allow(Tmdb::Movie).to receive(:detail).with(1).and_return(fake_results2)
    #     expect(Movie.create_from_tmdb(1)[:description]).to eq("Overview")
    #   end
    # end
  end
  describe 'all ratings' do
    context 'checking ratings' do
      it 'should have G, PG, PG-13, NC-17, R and UNKNOWN' do
        expect(Movie.all_ratings).to eq(['G', 'PG', 'PG-13', 'NC-17', 'R','UNKNOWN'])
      end
    end 
  end
end
