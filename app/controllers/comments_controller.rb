class CommentsController < ApplicationController
#  データを変える作業にはログイン必須
 before_action :authenticate_user!, only: :create
  
 
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      # @commentに結びついたprototypeのページを表示
      redirect_to prototype_path(@comment.prototype)
    else
      # もう一度show画面を作るための定義、インスタンスは作り直す必要あり
    @prototype = @comment.prototype
    @comments = @prototype.comments
    # 「なんらかの処理に失敗した」という汎用的なエラー指定
    render "prototypes/show", status: :unprocessable_entity
    end
    
  end

  private

  def comment_params
    # 
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
