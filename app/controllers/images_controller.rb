class ImagesController < ApplicationController
  def index
    @images = Image.all
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to images_path
    else
      render :new
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @image.update(image_params)
      sleep(3) # S3への画像反映のタイムラグを考慮して3秒待機
      redirect_to image_url(@image)
    else
      render :edit
    end
  end

  def show
    @image = Image.find(params[:id])
    # 参照先のS3オブジェクトURLを作成
   @image_url = "https://profile-img-resize.s3-ap-northeast-1.amazonaws.com/#{@image.image.key}-thumbnail.#{@image.image.content_type.split('/').pop}"
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    redirect_to images_path
  end

  private

  def image_params
    params.require(:image).permit(:name, :image)
  end
end
