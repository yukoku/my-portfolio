class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_project_member, except: [:index, :new, :create]

  def index
    @projects = fetch_projects.includes(:tickets, :project_members).order(:due_on).page(params[:page]).per(Constants::PER)
    @tickets_count = @projects.to_h { |p| [p.id, p.tickets.size] }
    @project_members = ProjectMember.where(user_id: current_user.id, project_id: @projects.pluck(:id)).index_by(&:project_id)
  end

  def show
    @project_owners = @project.project_members.where(owner: true)
    @search = @project.tickets.order(:due_on).ransack(params[:q])
    @tickets = @search.result.page(params[:page]).per(Constants::PER)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      current_user.project_members.create!(project_id: @project.id, accepted_project_invitation: true, owner: true)
      flash[:info] = I18n.t("#{Constants::PROJECT_CRUD_FLASH}.created")
      redirect_to projects_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:success] = I18n.t("#{Constants::PROJECT_CRUD_FLASH}.updated")
      redirect_to @project
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    flash[:success] = I18n.t("#{Constants::PROJECT_CRUD_FLASH}.deleted")
    redirect_to projects_path
  end

  private

  def set_project
    @project = Project.find_by!(id: params[:id])
  end

  def authenticate_project_member
    unless @project.users.exists?(id: current_user.id) || current_user.admin?
      redirect_to projects_path
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :due_on)
  end

  def fetch_projects
    current_user.admin? ? Project.all : current_user.projects
  end
end
