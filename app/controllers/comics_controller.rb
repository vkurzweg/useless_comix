class ComicsController < ApplicationController
  before_action :admit_admin!, except: [:index, :show]

  def index
    @comics = Comic.all
  end

  def show
    @comic  = Comic.find(params[:id] || Comic.last.id)
    @comics = Comic.limit(7).order("RANDOM()")
    @first_comic = Comic.first
    @last_comic = Comic.last
    @next_comic = nil
    @prev_comic = nil

    if @comic != @last_comic
      @next_comic = Comic.where( "created_at > ?", @comic.created_at )
                         .order( "created_at" )
                         .first
    end

    if @comic != @first_comic
      @prev_comic = Comic.where( "created_at < ?", @comic.created_at )
                         .order( "created_at DESC" )
                         .first
    end
  end

  def new
    @comic = Comic.new
  end

  def edit
    @comic = Comic.find(params[:id])
  end

  def create
    @comic = Comic.new(comic_params)
    if @comic.save
      redirect_to root_path, notice: "Comic added!"
    else
      render 'new', alert: "Could not add comic."
    end
  end

  def update
    @comic = Comic.find(params[:id])
    if @comic.update_attributes(comic_params)
      redirect_to comic_path, notice: 'Comic updated!'
    else
      render 'edit', alert: "Could not update comic."
    end
  end

  def destroy
    @comic = Comic.find(params[:id])
    @comic.destroy
    redirect_to comics_path, notice: "Comic deleted."
  end

  private

  def comic_params
    params.require(:comic).permit(:name, :uri, :image)
  end
end
