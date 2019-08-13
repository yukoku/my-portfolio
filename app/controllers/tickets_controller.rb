class TicketsController < ApplicationController
  before_action :project_member, except: %i[index]
  before_action :project_ticket, only: %i[edit show update destroy destroy_attached_file]

  PER = 5

  def new
    @project = Project.find(params[:project_id])
    @ticket = Ticket.new
  end

  def edit
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:id])
  end

  def index
    if current_user.admin?
      @tickets = Ticket.page(params[:page]).per(PER)
    else
      @tickets = Ticket.where(assignee_id: current_user.id).page(params[:page]).per(PER)
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @ticket = Ticket.new(ticket_params)
    @ticket.creator_id = current_user.id
    @ticket.project_id = @project.id
    if @ticket.save
      flash[:info] = I18n.t("ticket.crud.flash.created")
      redirect_to project_ticket_url(@project, @ticket)
    else
      render 'new'
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
    @comment = Comment.new
  end

  def update
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:id])
    if @ticket.update_attributes(ticket_params)
      flash[:success] = I18n.t("ticket.crud.flash.updated")
      redirect_to project_ticket_url(@project, @ticket)
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    ticket = Ticket.find(params[:id])
    ticket.destroy
    flash[:success] = I18n.t("ticket.crud.flash.deleted")
    redirect_to @project
  end

  def destroy_attached_file
    if @ticket.attached_files.attached?
      @attached_file = @ticket.attached_files.find_by(id: params[:attached_file_id])
      @attached_file&.purge_later
      redirect_to project_ticket_url(@project, @ticket)
    end
  end

private

  def ticket_params
    params.require(:ticket).permit(:title, :description, :due_on, :assignee_id,
                                   :ticket_attribute_id, :ticket_status_id, :ticket_priority_id,
                                   attached_files: [])
  end

  def project_member
    @project = Project.find(params[:project_id])
    redirect_to(root_url) unless @project&.users.include?(current_user) || current_user.admin?
  end

  def project_ticket
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:id])
    redirect_to(root_url) unless @project&.tickets.include?(@ticket)
  end
end
