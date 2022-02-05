class BookCommentsController < ApplicationController
  def create
    @book_comment = BookComment.new
    @book = Book.find(params[:book_id])
    # 3つの情報が必要（book_commentテーブル内のcomment,user_id,book_idカラムが必要)
    comment = BookComment.new(book_comment_params)
    comment.user_id = current_user.id
    # comment = current_user.book_comments.new(book_comment_params) これは上の二行を一文にまとめた内容。
    # 上の行でcommentとuser_idの2つの情報を取得
    comment.book_id = @book.id
    # 上の行でbook_idを取得した。favoriteと違って2行になってるのは文を短くするために分けた。
    comment.save
    # redirect_to request.referer
  end

  def destroy
    book_comment = BookComment.find(params[:id])
    @book = book_comment.book
    book_comment.destroy
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
