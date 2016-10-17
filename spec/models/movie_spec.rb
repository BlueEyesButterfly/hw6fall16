describe Movie do

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
      it 'should call Moive.get_rating method and return movies whose title include search_terms' do
        search_terms = "Lethal Weapon"
        allow(Tmdb::Movie).to receive(:find).with(search_terms)
        Movie.find_in_tmdb(search_terms).each do |m|
          expect(m[:title]).to include(search_terms)
          expect(Movie).to receive(:get_rating).with(m[:id])
        end
      end
    end    
 
  end
  describe 'creating movies from Tmdb ID' do
    tmdb_id = 942
    context 'with valid key' do
      it 'should call Tmdb with Tmdb ID' do
        allow(Tmdb::Movie).to receive(:detail).with(tmdb_id).and_return({original_title: "test title", overview: "test overview", release_date: "1900-01-01"})
        allow(Movie).to receive(:get_rating).with(tmdb_id)
        expect(Movie).to receive(:create!)
        Movie.create_from_tmdb(tmdb_id)
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:detail).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.create_from_tmdb(tmdb_id) }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe 'getting the rating given tmdb_id' do
    tmdb_id = 941
    context 'with valid key' do
      it 'should return rating' do
        fake1={"countries" => [{"iso_3166_1" => "US", "certification" => "R"}]}
        allow(Tmdb::Movie).to receive(:releases).with(tmdb_id).and_return(fake1)
        expect(Movie.get_rating(tmdb_id)).to eq("R")
        Movie.get_rating(tmdb_id)
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:releases).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.get_rating(tmdb_id) }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe 'all ratings' do
    context 'checking ratings' do
      it 'should have G, PG, PG-13, NC-17, R and UNKNOWN' do
        expect(Movie.all_ratings).to eq(['G', 'PG', 'PG-13', 'NC-17', 'R','UNKNOWN'])
      end
    end 
  end
end
