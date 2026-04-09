class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :move_to_index, only: [:edit, :update, :destroy]
  # ログインの有無のみならず、プロトタイプの投稿者かどうか判別する
  def move_to_index
  redirect_to root_path unless current_user == @prototype.user
  end

  def index
    # データとしては配列
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    # フォームに入力したデータの格納先
    @prototype = Prototype.new(prototype_params)
      if @prototype.save
         redirect_to root_path
      else
        # renderの参照先はnew.html.erb
        render :new, status: :unprocessable_entity  
      end
  end

  def show
    # 送信されたID値で、Prototypeモデルの特定のオブジェクトを取得しそれを@prototypeに代入する
    @prototype = Prototype.find(params[:id])
    # commentも表示させる必要があるので追記
    # 上がformに送る空のデータ、下が一覧で繰り返し表示するプロトタイプに付属する全てのコメントデータ
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    # すでに存在しているレコードを選択して中身を書き換える。renderするなら@使え
    @prototype = Prototype.find(params[:id])
    # updateメソッドにはsaveが含まれている。既に画像はレコードにあるのでpresence :falseでも通る
    if @prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end

  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  
end
