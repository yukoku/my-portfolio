class CommentsController < ApplicationController
  before_action :project_member
  before_action :project_ticket
  before_action :ticket_comment, only: :destroy

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.ticket_id = @ticket.id
    if @comment.save
      flash[:success] = I18n.t("comment.crud.flash.created")
      redirect_to project_ticket_url(@project, @ticket)
    else
      render 'tickets/show'
    end

  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:success] = I18n.t("comment.crud.flash.deleted")
    redirect_to project_ticket_url(@project, @ticket)
  end

private
  def comment_params
    params.require(:comment).permit(:content)
  end

  def project_member
    @project = Project.find(params[:project_id])
    redirect_to(root_url) unless @project&.users.include?(current_user) || current_user.admin?
  end

  def project_ticket
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:ticket_id])
    redirect_to(root_url) unless @project&.tickets.include?(@ticket)
  end

  def ticket_comment
    @ticket = Ticket.find(params[:ticket_id])
    @comment = Comment.find(params[:id])
    redirect_to(root_url) unless @ticket&.comments.include?(@comment)
  end
end
