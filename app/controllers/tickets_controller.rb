class TicketsController < ApplicationController
  before_action :project_member, except: %i[index]
  before_action :project_ticket, only: %i[edit show update destroy]
  def new
    @project = Project.find(params[:project_id])
    @ticket = Ticket.new
  end

  def edit
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:id])
  end

  def index
    @tickets = Ticket.where(assignee_id: current_user.id)
  end

  def create
    @project = Project.find(params[:project_id])
    @ticket = Ticket.new(ticket_params)
    @ticket.creator_id = current_user.id
    @ticket.project_id = @project.id
    if @ticket.save
      flash[:info] = I18n.t("ticket.crud.flash.created")
      redirect_to @project
    else
      render 'new'
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
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

private

  def ticket_params
    params.require(:ticket).permit(:title, :description, :due_on, :assignee_id,
                                   :ticket_attribute_id, :ticket_status_id, :ticket_priority_id, attached_files: [])
  end

  def project_member
    @project = Project.find(params[:project_id])
    redirect_to(root_url) unless @project&.users.include?(current_user)
  end

  def project_ticket
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:id])
    redirect_to(root_url) unless @project&.tickets.include?(@ticket)
  end
end
