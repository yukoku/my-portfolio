class TicketsController < ApplicationController
  before_action :project_member, except: %i[index]
  before_action :project_ticket, only: %i[edit show update destroy destroy_attached_file]

  def new
    @project = Project.find(params[:project_id])
    @ticket = Ticket.new
    @metadata = TicketMetadata.where(project_id: params[:project_id])
    @metadata.each do |m|
      @ticket.ticket_metadata_values.build(ticket_metadata_id: m.id)
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @ticket = Ticket.includes(:ticket_metadata_values).find(params[:id])
    @metadata = TicketMetadata.where(project_id: params[:project_id])
    existing_metadata_ids = @ticket.ticket_metadata_values.pluck(:ticket_metadata_id)
    @metadata.where.not(id: existing_metadata_ids).each do |m|
      @ticket.ticket_metadata_values.build(ticket_metadata_id: m.id)
    end
  end

  def index
    if current_user.admin?
      @search = Ticket.includes(:project).order(:due_on).ransack(params[:q])
      @tickets = @search.result.page(params[:page]).per(Constants::PER)
    else
      @search = Ticket.includes(:project).where(assignee_id: current_user.id).order(:due_on).ransack(params[:q])
      @tickets = @search.result.page(params[:page]).per(Constants::PER)
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @ticket = Ticket.new(ticket_params)
    @ticket.creator_id = current_user.id
    @ticket.project_id = @project.id
    if @ticket.save
      flash[:info] = I18n.t("#{Constants::TICKET_CRUD_FLASH}.created")
      redirect_to project_ticket_url(@project, @ticket)
    else
      render 'new'
    end
  end

  def show
    @comment = Comment.new
    @metadata = TicketMetadata.where(project_id: params[:project_id])
    @metadata_values = TicketMetadataValue.where(ticket_id: @ticket.id).to_h do |mv|
      [mv.ticket_metadata_id, mv]
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      flash[:success] = I18n.t("#{Constants::TICKET_CRUD_FLASH}.updated")
      redirect_to project_ticket_url(@project, @ticket)
    else
      @metadata = TicketMetadata.where(project_id: params[:project_id])
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    ticket = Ticket.find(params[:id])
    ticket.destroy
    flash[:success] = I18n.t("#{Constants::TICKET_CRUD_FLASH}.deleted")
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
                                   attached_files: [],
                                   ticket_metadata_values_attributes: [:id, :ticket_metadata_id, :value])
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
