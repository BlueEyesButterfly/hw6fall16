require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb) {[double('movie1'), double('movie2')]}
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    it 'should redirect to the Index page with invalid search terms' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => '  '}
      expect(response).to redirect_to(movies_path)
    end
    it 'should redirect to the Index page if no matching movies' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => '123wdixiskdkd'}
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe 'adding movies from TMDb' do
    it 'should not call Movie.create_from_tmdb if no checkbox is checked' do
      expect(Movie).not_to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies => nil}
    end
    it 'should call  Movie.create_from_tmdb if any checkbox is checked' do
      expect(Movie).to receive(:create_from_tmdb).with("278")
      post :add_tmdb, {:tmdb_movies => {"278": "1"}}
    end
  end
  
  describe 'showing a movie' do
    it 'should call Movie.find' do
      fake_id="1"
      expect(Movie).to receive(:find).with(fake_id)
      get :show, {:id => "1"}
    end
    it 'should select the show template for rendering' do
      allow(Movie).to receive(:find)
      get :show, {:id => "1"}
      expect(response).to render_template('show')
    end
  end
  
  describe 'editing a movie' do
    it 'should call Movie.find' do
      fake_id="1"
      expect(Movie).to receive(:find).with(fake_id)
      get :edit, {:id => "1"}
    end
    it 'should select the edit template for rendering' do
      allow(Movie).to receive(:find)
      get :edit, {:id => "1"}
      expect(response).to render_template('edit')
    end
  end
  
  describe 'rendering index page of movies' do
    it 'should select the index template for rendering' do
      allow(Movie).to receive(:all_ratings).and_return(%w(G PG PG-13 NC-17 R UNKNOWN))
      allow(Movie).to receive(:where).with(rating:["G", "PG", "PG-13", "NC-17", "R","UNKNOWN"]).and_return(Movie.all)
      allow(Movie).to receive(:order)
      get :index
      expect(response).to render_template('index')
    end
  end
  
  fake_movie = {:title => "title", :rating => "rating", :description => "description", :release_date => "2000-01-01"}
  
  describe 'creating a new movie' do
    it "should createa a new movie" do
      expect { post :create, :movie => fake_movie }.to change(Movie, :count).by(1)
    end
    it "should redirect to home page after movie being created" do
      post :create, {:movie => fake_movie}
      expect(response).to redirect_to(movies_path)
    end
  end
  
  before(:each) do
      @movie = Movie.create! fake_movie
  end
  
  describe "updating a movie" do
    fake_param = {:title => "new test title"}
    it "should update the chosen movie" do
      Movie.any_instance.should_receive(:update_attributes!).with(fake_param)
      put :update, :id => @movie.id, :movie => fake_param
    end
    it "should redirect to the home page after successful updating" do
      allow(Movie).to receive(:update).with(fake_param)
      put :update, :id => @movie.id, :movie => fake_param
      expect(response).to redirect_to(movie_path(@movie))
    end
  end
    
  describe "deleting a movie" do
    it "should delete the chosen movie" do
      expect { delete :destroy, :id => @movie.id}.to change(Movie, :count).by(-1)
    end
    it "should redirect to the home page after deleting" do
      delete :destroy, :id => @movie.id
      expect(response).to redirect_to(movies_path)
    end
  end
end
