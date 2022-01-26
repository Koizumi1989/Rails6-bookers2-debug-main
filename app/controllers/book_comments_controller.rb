class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    # 3つの情報が必要（book_commentテーブル内のcomment,user_id,book_idカラムが必要)
    comment = current_user.book_comments.new(book_comment_params)
    # 上の行でcommentとuser_idの2つの情報を取得
    comment.book_id = book.id
    # 上の行でbook_idを取得した。favoriteと違って2行になってるのは文を短くするために分けた。
    comment.save
    redirect_to request.referer
  end

  def destroy
    BookComment.find(params[:id]).destroy
    redirect_to request.referer
  end


  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
