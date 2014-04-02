class CommentsController < ApplicationController

  def destroy
    @comment = Comment.find(params[:id]).destroy
    flash[:success] = "comment destroyed"
    redirect_to @comment.auction_item
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end

